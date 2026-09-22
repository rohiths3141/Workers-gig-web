import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/supabase/supabase_client_provider.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import '../../data/repositories/supabase_media_repository.dart';
import '../../data/repositories/supabase_gig_repository.dart';
import '../../data/repositories/supabase_job_repository.dart';
import '../../data/repositories/supabase_customer_request_repository.dart';
import '../../data/repositories/supabase_trust_repositories.dart';
import '../../data/repositories/supabase_wallet_repository.dart';
import '../../data/repositories/supabase_worker_offer_repository.dart';
import '../../data/repositories/supabase_worker_repository.dart';
import '../../domain/repositories/repositories.dart';
import '../config/app_config.dart';

/// Dependency wiring.
///
/// Every provider here exposes a repository *interface*. Controllers and
/// widgets depend on these, so a test substitutes a fake by overriding one
/// provider, and no screen has a reason to reach for Supabase or Firebase.

final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('appConfigProvider must be overridden at startup');
});

final supabaseClientProvider = Provider((ref) => SupabaseClientProvider.instance.client);

// ---------------------------------------------------------------------------
// Identity
// ---------------------------------------------------------------------------

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository();
});

/// The current auth state, as a stream the router listens to.
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

/// The signed-in Firebase UID, or null.
final firebaseUidProvider = Provider<String?>((ref) {
  final state = ref.watch(authStateProvider).valueOrNull;
  return state is AuthSignedIn ? state.firebaseUid : null;
});

/// Reads the current Firebase UID at call time.
///
/// Repositories take this rather than asking the Supabase client, because that
/// client is configured for third-party auth: it holds no session and `db.auth`
/// throws when touched. Identity lives in Firebase, and this is the one way a
/// repository reaches it.
///
/// It is a callback rather than a captured value so a repository built while
/// signed out picks up the UID as soon as one exists, instead of holding a
/// stale null for its lifetime.
String? Function() _uidReader(Ref ref) =>
    () => ref.read(authRepositoryProvider).currentState is AuthSignedIn
        ? (ref.read(authRepositoryProvider).currentState as AuthSignedIn)
            .firebaseUid
        : null;

// ---------------------------------------------------------------------------
// Data
// ---------------------------------------------------------------------------

final mediaRepositoryProvider = Provider<MediaRepository>((ref) {
  final auth = ref.watch(authRepositoryProvider);
  return SupabaseMediaRepository(
    db: ref.watch(supabaseClientProvider),
    apiBaseUrl: ref.watch(appConfigProvider).apiBaseUrl,
    idTokenProvider: () async {
      final result = await auth.idToken();
      return result.valueOrNull;
    },
  );
});

final workerRepositoryProvider = Provider<WorkerRepository>((ref) {
  return SupabaseWorkerRepository(
    ref.watch(supabaseClientProvider),
    currentFirebaseUid: _uidReader(ref),
    media: ref.watch(mediaRepositoryProvider),
  );
});

final availabilityRepositoryProvider = Provider<AvailabilityRepository>((ref) {
  return SupabaseAvailabilityRepository(
    ref.watch(supabaseClientProvider),
    currentFirebaseUid: _uidReader(ref),
  );
});

final catalogueRepositoryProvider = Provider<CatalogueRepository>((ref) {
  return SupabaseCatalogueRepository(
    ref.watch(supabaseClientProvider),
    currentFirebaseUid: _uidReader(ref),
  );
});

final jobRepositoryProvider = Provider<JobRepository>((ref) {
  return SupabaseJobRepository(
    ref.watch(supabaseClientProvider),
    currentFirebaseUid: _uidReader(ref),
  );
});

final materialRepositoryProvider = Provider<MaterialRepository>((ref) {
  return SupabaseMaterialRepository(
    ref.watch(supabaseClientProvider),
    currentFirebaseUid: _uidReader(ref),
  );
});

final gigRepositoryProvider = Provider<GigRepository>((ref) {
  return SupabaseGigRepository(
    ref.watch(supabaseClientProvider),
    currentFirebaseUid: _uidReader(ref),
    media: ref.watch(mediaRepositoryProvider),
  );
});

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return SupabaseWalletRepository(
    ref.watch(supabaseClientProvider),
    currentFirebaseUid: _uidReader(ref),
  );
});

final payoutRepositoryProvider = Provider<PayoutRepository>((ref) {
  return SupabasePayoutRepository(
    ref.watch(supabaseClientProvider),
    currentFirebaseUid: _uidReader(ref),
  );
});

final verificationRepositoryProvider = Provider<VerificationRepository>((ref) {
  return SupabaseVerificationRepository(
    ref.watch(supabaseClientProvider),
    currentFirebaseUid: _uidReader(ref),
  );
});

final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  return SupabaseSupportRepository(
    ref.watch(supabaseClientProvider),
    currentFirebaseUid: _uidReader(ref),
  );
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return SupabaseNotificationRepository(
    ref.watch(supabaseClientProvider),
    currentFirebaseUid: _uidReader(ref),
  );
});

// ---------------------------------------------------------------------------
// Customer Service Requests — worker side (Model B)
// ---------------------------------------------------------------------------

final customerRequestDiscoveryProvider =
    Provider<CustomerRequestDiscoveryRepository>((ref) {
  return SupabaseCustomerRequestDiscoveryRepository(
    ref.watch(supabaseClientProvider),
    currentFirebaseUid: _uidReader(ref),
  );
});

final workerOfferRepositoryProvider = Provider<WorkerOfferRepository>((ref) {
  return SupabaseWorkerOfferRepository(
    ref.watch(supabaseClientProvider),
    currentFirebaseUid: _uidReader(ref),
  );
});

