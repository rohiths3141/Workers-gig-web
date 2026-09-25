import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../core/auth/token_claims.dart';
import '../../core/errors/app_failure.dart';
import '../../core/errors/result.dart';
import '../../core/firebase/firebase_initializer.dart';
import '../../core/logging/app_logger.dart';
import '../../core/supabase/supabase_client_provider.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/worker.dart';
import '../../domain/repositories/repositories.dart';
import 'providers.dart';
import 'push_registration_provider.dart';
import '../../core/localization/app_locale.dart';

/// Where the app should send the worker.
///
/// Derived from real state — Firebase says whether there is an account, the
/// server says whether a worker profile exists and how far onboarding has got.
/// Nothing here is a local boolean that could survive a reinstall or be set by
/// the client to skip a step.
sealed class Session {
  const Session();
}

/// Still resolving. The splash stays up.
class SessionLoading extends Session {
  const SessionLoading();
}

class SessionSignedOut extends Session {
  const SessionSignedOut();
}

/// Firebase account exists, but no worker profile does yet.
class SessionNeedsRegistration extends Session {
  const SessionNeedsRegistration({required this.firebaseUid, this.phoneNumber});
  final String firebaseUid;
  final String? phoneNumber;
}

/// Profile exists but onboarding is incomplete.
class SessionOnboarding extends Session {
  const SessionOnboarding({required this.worker, required this.progress});
  final Worker worker;
  final OnboardingProgress progress;
}

class SessionReady extends Session {
  const SessionReady({required this.worker});
  final Worker worker;
}

/// The profile could not be loaded. Distinct from signed-out: the worker is
/// authenticated, something went wrong, and a retry is the right offer. This is
/// the case the old application handled by inventing a profile.
class SessionError extends Session {
  const SessionError(this.failure);
  final AppFailure failure;
}

/// Onboarding progress, computed from the worker row rather than a counter.
///
/// A reinstall resumes exactly where the worker left off, because the answer
/// lives on the server.
class OnboardingProgress {
  const OnboardingProgress({
    required this.hasBasicProfile,
    required this.hasTrade,
    required this.hasSkills,
    required this.hasServiceArea,
    required this.hasSubmittedKyc,
  });

  final bool hasBasicProfile;
  final bool hasTrade;
  final bool hasSkills;
  final bool hasServiceArea;
  final bool hasSubmittedKyc;

  /// Onboarding finishes when the worker has done everything asked of them.
  /// Verification *approval* is not a step: a worker who has submitted their
  /// documents is done, and then waits. Blocking the app on someone else's
  /// review queue would be both wrong and infuriating.
  bool get isComplete =>
      hasBasicProfile &&
      hasTrade &&
      hasSkills &&
      hasServiceArea &&
      hasSubmittedKyc;

  int get completedSteps => [
        hasBasicProfile,
        hasTrade,
        hasSkills,
        hasServiceArea,
        hasSubmittedKyc,
      ].where((step) => step).length;

  static const totalSteps = 5;

  double get fraction => completedSteps / totalSteps;

  /// The step to resume on.
  OnboardingStep get nextStep {
    if (!hasBasicProfile) return OnboardingStep.basicProfile;
    if (!hasTrade) return OnboardingStep.trade;
    if (!hasSkills) return OnboardingStep.skills;
    if (!hasServiceArea) return OnboardingStep.serviceArea;
    if (!hasSubmittedKyc) return OnboardingStep.kyc;
    return OnboardingStep.review;
  }
}

enum OnboardingStep {
  basicProfile,
  trade,
  skills,
  serviceArea,
  kyc,
  review;

  /// In the language on screen.
  String get label {
    final l10n = AppStrings.current;
    return switch (this) {
      OnboardingStep.basicProfile => l10n.onboardingStepDetails,
      OnboardingStep.trade => l10n.onboardingStepTrade,
      OnboardingStep.skills => l10n.onboardingStepSkills,
      OnboardingStep.serviceArea => l10n.onboardingStepArea,
      OnboardingStep.kyc => l10n.onboardingStepKyc,
      OnboardingStep.review => l10n.onboardingStepReady,
    };
  }
}

/// Resolves and holds the session.
class SessionController extends AsyncNotifier<Session> {
  static const _log = AppLogger('Session');

  /// Firebase UIDs already confirmed to carry the Supabase role claim this
  /// app run, so a routine token refresh doesn't re-hit the web tier.
  static final Set<String> _roleClaimVerified = {};

  Future<void> _ensureSupabaseRole(String firebaseUid) async {
    if (_roleClaimVerified.contains(firebaseUid)) return;

    final apiBaseUrl = ref.read(appConfigProvider).apiBaseUrl;
    if (apiBaseUrl.isEmpty) return;

    final tokenResult = await ref.read(authRepositoryProvider).idToken();
    final token = tokenResult.valueOrNull;
    if (token == null) return;

    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/auth/claims'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['ok'] != true) {
        _log.warning('Supabase role claim rejected: ${json['error']}');
        return;
      }

      final refreshRequired =
          (json['data'] as Map<String, dynamic>?)?['refreshRequired'] == true;
      if (refreshRequired && !await _awaitRoleClaimInToken()) {
        // Do not mark this UID verified: the next attempt should ask again
        // rather than assume a claim that never showed up.
        _log.warning('Supabase role claim not visible in the ID token yet');
        return;
      }
      _roleClaimVerified.add(firebaseUid);
    } catch (e) {
      _log.warning('Could not ensure Supabase role claim: $e');
    }
  }

  /// Whether [failure] is PostgREST refusing a request that reached it as
  /// `anon` rather than a genuine "you may not see this row".
  ///
  /// supabase-dart puts the HTTP status in `PostgrestException.code`, so the
  /// Postgres `42501` only appears inside the message body — which is why this
  /// matches on the text rather than the code.
  static bool _looksLikeAnonDenial(AppFailure? failure) {
    if (failure == null) return false;
    final detail = failure.debugDetail ?? '';
    return detail.contains('42501') || detail.contains('permission denied');
  }

  /// Refreshes the ID token until it actually carries `role: authenticated`.
  ///
  /// `setCustomUserClaims` and Firebase's token service settle independently,
  /// so a forced refresh immediately afterwards can still mint a token without
  /// the claim. That token is then cached for an hour and every Supabase
  /// request runs as `anon` — which is what "permission denied for table
  /// workers" was on a brand-new account: sign-in had succeeded, the profile
  /// read had not.
  Future<bool> _awaitRoleClaimInToken() async {
    const delays = [
      Duration.zero,
      Duration(milliseconds: 800),
      Duration(milliseconds: 1600),
      Duration(seconds: 3),
    ];

    for (final delay in delays) {
      if (delay > Duration.zero) await Future<void>.delayed(delay);

      final token = (await ref
              .read(authRepositoryProvider)
              .idToken(forceRefresh: true))
          .valueOrNull;
      if (hasSupabaseRole(token)) return true;
    }
    return false;
  }

  @override
  Future<Session> build() async {
    // Rebuilds whenever Firebase reports a change, so a disabled account or an
    // expired token takes effect immediately rather than at the next restart.
    final auth = ref.watch(authStateProvider);

    return auth.when(
      loading: () => const SessionLoading(),
      error: (error, _) => SessionError(
        error is AppFailure ? error : const UnexpectedFailure(),
      ),
      data: (authState) async {
        switch (authState) {
          case AuthSignedOut():
          case AuthUnknown():
            await FirebaseInitializer.setUser(null);
            return const SessionSignedOut();

          case AuthAwaitingOtp():
            return const SessionSignedOut();

          case AuthSignedIn(:final firebaseUid, :final phoneNumber):
            await FirebaseInitializer.setUser(firebaseUid);
            // Firebase ID tokens don't carry `role: authenticated` by
            // default; Supabase's third-party-auth mapping relies on that
            // claim to run the request as `authenticated` rather than
            // `anon`. Until the web tier stamps it onto this user (once,
            // server-side) and we pick up a token minted after that, every
            // RLS policy scoped to `authenticated` denies us even though
            // sign-in itself succeeded.
            await _ensureSupabaseRole(firebaseUid);
            if (SupabaseClientProvider.isInitialized) {
              final tokenResult = await ref.read(authRepositoryProvider).idToken();
              await SupabaseClientProvider.instance.syncRealtimeAuth(tokenResult.valueOrNull);
            }
            return _resolveWorker(firebaseUid, phoneNumber);
        }
      },
    );
  }

  Future<Session> _resolveWorker(String firebaseUid, String? phoneNumber) async {
    var result = await _getWorkerWithClockSkewRetry();

    // A denial here means the token went out as `anon` — the role claim was
    // not on it after all. Ask the web tier again and retry once before
    // showing an error the worker can do nothing about.
    if (_looksLikeAnonDenial(result.failureOrNull)) {
      _log.warning('Profile read denied; re-provisioning the role claim');
      _roleClaimVerified.remove(firebaseUid);
      await _ensureSupabaseRole(firebaseUid);
      if (SupabaseClientProvider.isInitialized) {
        final token = await ref.read(authRepositoryProvider).idToken();
        await SupabaseClientProvider.instance
            .syncRealtimeAuth(token.valueOrNull);
      }
      result = await _getWorkerWithClockSkewRetry();
    }

    return result.fold(
      (worker) async {
        var resolved = worker;

        if (resolved == null) {
          // No row for this UID. Before concluding that registration never
          // happened, ask whether this caller's OTP-verified number already
          // owns an account. Firebase issues a *new* UID when a user record is
          // deleted and the same number signs in again, and a worker in that
          // position was being sent to the Register screen and then refused
          // there, because the old row still held their number — no way back
          // into their own account. Nothing is claimed unless the server can
          // match the verified number on the token, so the app sends none.
          final claimed =
              await ref.read(workerRepositoryProvider).claimExistingAccount();

          resolved = claimed.valueOrNull;
          if (resolved != null) {
            _log.info('Re-bound an existing account to a new Firebase UID');
          }
        }

        if (resolved == null) {
          // Authenticated, but registration never finished.
          return SessionNeedsRegistration(
            firebaseUid: firebaseUid,
            phoneNumber: phoneNumber,
          );
        }

        final progress = await _progressFor(resolved);

        return progress.isComplete
            ? SessionReady(worker: resolved)
            : SessionOnboarding(worker: resolved, progress: progress);
      },
      (failure) {
        // Not signed out, and emphatically not a fabricated profile. The UI
        // shows the error and a retry.
        _log.warning('Could not resolve worker profile');
        if (failure is AuthFailure && failure.requiresReauthentication) {
          return const SessionSignedOut();
        }
        return SessionError(failure);
      },
    );
  }

  /// Loads the profile, retrying while PostgREST rejects the Firebase token
  /// as "issued at future".
  ///
  /// A phone whose clock runs a couple of seconds fast mints tokens Supabase
  /// will not accept yet; the request succeeds once real time catches up, so
  /// wait it out rather than showing the session error screen on launch.
  Future<Result<Worker?>> _getWorkerWithClockSkewRetry() async {
    const backoff = [
      Duration(milliseconds: 900),
      Duration(milliseconds: 1800),
      Duration(milliseconds: 2700),
    ];

    final repo = ref.read(workerRepositoryProvider);
    var result = await repo.getCurrentWorker();

    for (final delay in backoff) {
      if (result.failureOrNull is! ClockSkewFailure) break;

      _log.warning('Token rejected as clock-skewed; retrying in '
          '${delay.inMilliseconds}ms');
      await Future<void>.delayed(delay);

      final refreshed =
          await ref.read(authRepositoryProvider).idToken(forceRefresh: true);
      if (SupabaseClientProvider.isInitialized) {
        await SupabaseClientProvider.instance
            .syncRealtimeAuth(refreshed.valueOrNull);
      }
      result = await repo.getCurrentWorker();
    }

    return result;
  }

  Future<OnboardingProgress> _progressFor(Worker worker) async {
    final skills = await ref.read(workerRepositoryProvider).getSkills();
    final verifications =
        await ref.read(verificationRepositoryProvider).getVerifications();

    final hasSubmittedKyc = verifications.fold(
      (cases) => cases.any((c) =>
          c.type == VerificationType.identityKyc &&
          c.status != VerificationStatus.notSubmitted),
      // If the check itself failed, do not claim the step is done. Treating an
      // unknown as complete is how a worker ends up stuck later with no
      // explanation.
      (_) => false,
    );

    return OnboardingProgress(
      hasBasicProfile: worker.fullName.trim().isNotEmpty &&
          (worker.city ?? '').isNotEmpty &&
          (worker.pincode ?? '').isNotEmpty &&
          (worker.gender ?? '').isNotEmpty,
      hasTrade: worker.primaryServiceId != null,
      hasSkills: skills.fold((s) => s.isNotEmpty, (_) => false),
      hasServiceArea: worker.hasServiceArea,
      hasSubmittedKyc: hasSubmittedKyc,
    );
  }

  /// Re-reads the session after an action that could change it.
  ///
  /// Keeps the previous value attached via `copyWithPrevious` rather than
  /// wiping it with a bare `AsyncLoading()` — the router reads
  /// `session.valueOrNull`, and a refresh with no prior value looked
  /// identical to a cold-start bootstrap, bouncing the worker to the splash
  /// screen for the split second the refresh took.
  Future<void> refresh() async {
    state = const AsyncLoading<Session>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final authState = ref.read(authRepositoryProvider).currentState;
      if (authState is! AuthSignedIn) return const SessionSignedOut();
      return _resolveWorker(authState.firebaseUid, authState.phoneNumber);
    });
  }

  Future<Result<void>> signOut() async {
    final firebaseUid = switch (ref.read(authRepositoryProvider).currentState) {
      AuthSignedIn(:final firebaseUid) => firebaseUid,
      _ => null,
    };

    // Everything below happens *before* Firebase drops the session, because
    // each step is authorized by the token that is about to go away.

    // Stop this device receiving the departing worker's job alerts. Best
    // effort — a push row that will not update must not block a sign-out.
    //
    // The token is read from `registeredPushTokenProvider` rather than from
    // `pushRegistrationProvider`, which depends on this provider: reading that
    // one back from here is a genuine cycle, and Riverpod throws
    // CircularDependencyError for it in debug — on the sign-out button.
    await _deactivatePushToken();

    // Drop every Realtime subscription. Without this the channels opened for
    // the departing worker stayed joined on the socket, so a signed-out phone
    // went on receiving their offers and booking changes, and the next worker
    // to sign in on it inherited them.
    if (SupabaseClientProvider.isInitialized) {
      try {
        await SupabaseClientProvider.instance.disposeChannels();
      } catch (e) {
        _log.warning('Could not drop Realtime channels on sign-out: $e');
      }
    }

    final result = await ref.read(authRepositoryProvider).signOut();

    // The role claim has to be re-established for whoever signs in next; this
    // is per-process state, so leaving the departing UID in it would skip the
    // check if they came back on a fresh Firebase UID.
    if (firebaseUid != null) _roleClaimVerified.remove(firebaseUid);

    // Everything derived from the session is invalidated, so no screen can keep
    // showing a signed-out worker's data.
    _invalidateSessionScopedProviders();
    ref.invalidateSelf();
    return result;
  }

  /// Switches this device's push token off for the worker signing out.
  ///
  /// Runs before Firebase drops the session, because the update is authorized
  /// by the caller's own ID token: migration 0009 grants
  /// `update (is_active, ...)` on `push_tokens` scoped to
  /// `firebase_uid = public.firebase_uid()`.
  Future<void> _deactivatePushToken() async {
    final registered = ref.read(registeredPushTokenProvider);
    final token = registered.token;
    registered.clear();
    if (token == null) return;

    final result = await ref
        .read(notificationRepositoryProvider)
        .deactivatePushToken(token);
    result.fold(
      (_) {},
      (failure) => _log
          .warning('Could not deactivate the push token: ${failure.message}'),
    );
  }

  /// Rebuilds every repository, so nothing one worker's session resolved —
  /// most importantly the cached `workers.id` in [SupabaseRepositoryBase] —
  /// can be read by the next worker on this device.
  void _invalidateSessionScopedProviders() {
    ref
      ..invalidate(workerRepositoryProvider)
      ..invalidate(availabilityRepositoryProvider)
      ..invalidate(catalogueRepositoryProvider)
      ..invalidate(jobRepositoryProvider)
      ..invalidate(materialRepositoryProvider)
      ..invalidate(gigRepositoryProvider)
      ..invalidate(walletRepositoryProvider)
      ..invalidate(payoutRepositoryProvider)
      ..invalidate(verificationRepositoryProvider)
      ..invalidate(supportRepositoryProvider)
      ..invalidate(notificationRepositoryProvider)
      ..invalidate(mediaRepositoryProvider)
      ..invalidate(customerRequestDiscoveryProvider)
      ..invalidate(workerOfferRepositoryProvider);
  }
}

final sessionProvider =
    AsyncNotifierProvider<SessionController, Session>(SessionController.new);

/// The signed-in worker, when there is one.
final currentWorkerProvider = Provider<Worker?>((ref) {
  final session = ref.watch(sessionProvider).valueOrNull;
  return switch (session) {
    SessionReady(:final worker) => worker,
    SessionOnboarding(:final worker) => worker,
    _ => null,
  };
});
