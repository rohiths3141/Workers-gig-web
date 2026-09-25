import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/errors/result.dart';
import '../../../core/localization/l10n.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/verification.dart';
import '../../../shared/widgets/common_widgets.dart';
import 'verification_controller.dart';

/// Identity verification.
///
/// The worker completes a government DigiLocker consent journey; MessageCentral
/// confirms the Aadhaar details and this app polls for the outcome. There is
/// no control on this screen, or anywhere in this app, that marks a case
/// verified — the decision is made server-side from what DigiLocker actually
/// returned, exactly like the admin-reviewed types.
class KycScreen extends ConsumerStatefulWidget {
  const KycScreen({super.key});

  @override
  ConsumerState<KycScreen> createState() => _KycScreenState();
}

enum _Stage { idle, awaitingConsent, checking, approved, rejected }

class _KycScreenState extends ConsumerState<KycScreen>
    with WidgetsBindingObserver {
  _Stage _stage = _Stage.idle;
  String? _error;
  Timer? _pollTimer;
  int _pollAttempts = 0;

  /// How long to wait before each check.
  ///
  /// The first is zero on purpose. MessageCentral usually has the answer by
  /// the time the worker is back in the app — the consent journey finished
  /// before their browser redirected — so a flat six-second timer meant
  /// staring at "Checking with DigiLocker…" for six seconds with the result
  /// already sitting on the server. The gaps then widen, because a check that
  /// has not resolved in half a minute is waiting on DigiLocker rather than on
  /// us, and hammering the provider does not make it answer sooner.
  static const _pollSchedule = <Duration>[
    Duration.zero,
    Duration(seconds: 2),
    Duration(seconds: 3),
    Duration(seconds: 4),
    Duration(seconds: 5),
  ];
  static const _pollTailInterval = Duration(seconds: 6);

  static const _maxPollAttempts = 24; // ~2.5 minutes

  Duration _delayBeforeAttempt(int attempt) => attempt < _pollSchedule.length
      ? _pollSchedule[attempt]
      : _pollTailInterval;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pollTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // The worker just came back from the DigiLocker consent screen in their
    // browser. Start checking rather than waiting for them to tap anything.
    if (state == AppLifecycleState.resumed && _stage == _Stage.awaitingConsent) {
      _startChecking();
    }
  }

  Future<void> _startVerification() async {
    setState(() {
      _stage = _Stage.idle;
      _error = null;
    });

    final result =
        await ref.read(verificationControllerProvider.notifier).startDigilockerKyc();

    if (!mounted) return;

    switch (result) {
      case Ok(value: final url):
        if (url == null) {
          setState(() => _stage = _Stage.approved);
          return;
        }
        setState(() => _stage = _Stage.awaitingConsent);
        await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView);
      case Err(:final failure):
        setState(() {
          _stage = _Stage.idle;
          _error = failure.message;
        });
    }
  }

  void _startChecking() {
    setState(() {
      _stage = _Stage.checking;
      _pollAttempts = 0;
    });
    _poll();
  }

  void _poll() {
    _pollTimer?.cancel();

    final delay = _delayBeforeAttempt(_pollAttempts);
    if (delay == Duration.zero) {
      unawaited(_runCheck());
      return;
    }
    _pollTimer = Timer(delay, () => unawaited(_runCheck()));
  }

  Future<void> _runCheck() async {
    if (!mounted) return;

    final result = await ref
        .read(verificationControllerProvider.notifier)
        .checkDigilockerStatus();

    if (!mounted || _stage == _Stage.approved || _stage == _Stage.rejected) {
      // Realtime may have delivered the decision while this was in flight.
      return;
    }

    switch (result) {
      case Ok(value: final status):
        switch (status.outcome) {
          case DigilockerOutcome.approved:
          case DigilockerOutcome.alreadyVerified:
            _settle(_Stage.approved);
          case DigilockerOutcome.rejected:
            _settle(_Stage.rejected, status.reason);
          case DigilockerOutcome.pending:
            _pollAttempts++;
            if (_pollAttempts >= _maxPollAttempts) {
              setState(() {
                _stage = _Stage.idle;
                _error = context.l10n.kycStillWaiting;
              });
            } else {
              _poll();
            }
        }
      case Err(:final failure):
        setState(() {
          _stage = _Stage.idle;
          _error = failure.message;
        });
    }
  }

  /// Lands a final outcome and stops any further checking.
  ///
  /// Both the poll and the Realtime subscription can deliver the same decision
  /// — whichever arrives first wins and the other becomes a no-op.
  void _settle(_Stage stage, [String? reason]) {
    if (!mounted) return;
    _pollTimer?.cancel();
    _pollTimer = null;
    setState(() {
      _stage = stage;
      _error = reason;
    });
  }

  @override
  Widget build(BuildContext context) {
    // The server is the only thing that decides this case, and it writes the
    // decision to worker_verifications — which is in the supabase_realtime
    // publication already. Listening to it means an outcome reaches this
    // screen the moment it is written, rather than on the next poll tick:
    // the poll exists to make the server *ask* MessageCentral, and this
    // catches everything else, including a decision that lands after the poll
    // window closed and an administrator overturning a rejection while the
    // worker is sitting here.
    ref.listen<AsyncValue<List<VerificationCase>>>(verificationsProvider,
        (_, next) {
      final identity = next.valueOrNull
          ?.where((c) => c.type == VerificationType.identityKyc)
          .firstOrNull;
      if (identity == null) return;

      switch (identity.status) {
        case VerificationStatus.approved:
          _settle(_Stage.approved);
        case VerificationStatus.rejected:
          _settle(_Stage.rejected, identity.rejectionReason);
        default:
          break;
      }
    });

    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.kycTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          Text(l10n.kycHeadline,
              style: AppTypography.headlineMedium.copyWith(color: context.ink)),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.kycIntro,
            style: AppTypography.bodyLarge.copyWith(color: context.inkSecondary),
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildStageCard(),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              backgroundColor: AppColors.dangerSurface,
              child: Text(_error!, style: const TextStyle(color: AppColors.danger)),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            backgroundColor: context.surfaceMuted,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lock_outline_rounded, size: 20, color: context.inkSecondary),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    l10n.kycPrivacy,
                    style: AppTypography.bodySmall.copyWith(color: context.inkSecondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageCard() {
    final l10n = context.l10n;
    switch (_stage) {
      case _Stage.approved:
        return AppCard(
          backgroundColor: AppColors.successSurface,
          child: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.success),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text(l10n.kycVerified)),
            ],
          ),
        );

      case _Stage.awaitingConsent:
      case _Stage.checking:
        return AppCard(
          child: Row(
            children: [
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  _stage == _Stage.awaitingConsent
                      ? l10n.kycAwaitingConsent
                      : l10n.kycChecking,
                ),
              ),
            ],
          ),
        );

      case _Stage.idle:
      case _Stage.rejected:
        return SizedBox(
          height: AppSpacing.primaryActionHeight,
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _startVerification,
            icon: const Icon(Icons.verified_user_outlined),
            label: Text(
              _stage == _Stage.rejected ? l10n.commonTryAgain : l10n.kycStart,
            ),
          ),
        );
    }
  }
}
