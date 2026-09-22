import 'dart:io';

import '../../core/errors/result.dart';
import '../../core/money/money.dart';
import '../entities/customer_service_request.dart';
import '../entities/enums.dart';
import '../entities/gig.dart';
import '../entities/job.dart';
import '../entities/media.dart';
import '../entities/support.dart';
import '../entities/verification.dart';
import '../entities/wallet.dart';
import '../entities/worker.dart';
import '../entities/worker_offer.dart';

/// The contracts the presentation layer depends on.
///
/// Every method returns [Result], never throws, and never returns a fabricated
/// value on failure. There is deliberately no `getJobsOrEmpty()` and no
/// `getWalletOrZero()`: an empty list means the server said there is nothing,
/// and a zero balance means the server said zero.
///
/// Implementations live in `lib/data/repositories/`. No widget and no
/// controller imports Supabase or Firebase directly.

// ---------------------------------------------------------------------------
// Identity
// ---------------------------------------------------------------------------

/// Where the worker is in the sign-in flow.
sealed class AuthState {
  const AuthState();
}

class AuthUnknown extends AuthState {
  const AuthUnknown();
}

class AuthSignedOut extends AuthState {
  const AuthSignedOut();
}

class AuthSignedIn extends AuthState {
  const AuthSignedIn({required this.firebaseUid, required this.phoneNumber});
  final String firebaseUid;
  final String? phoneNumber;
}

/// An OTP has been sent and is awaiting the code.
class AuthAwaitingOtp extends AuthState {
  const AuthAwaitingOtp({
    required this.verificationId,
    required this.phoneNumber,
    this.resendToken,
  });
  final String verificationId;
  final String phoneNumber;
  final int? resendToken;
}

abstract interface class AuthRepository {
  /// Emits on every Firebase auth change, including token refresh failure and
  /// account disablement. The session layer watches this and clears local state
  /// the moment it reports signed out — there is no local flag that can keep a
  /// worker "signed in" after Firebase says otherwise.
  Stream<AuthState> authStateChanges();

  AuthState get currentState;

  /// Sends a phone OTP. Phone is the only credential on this platform: there is
  /// no password to guess, leak or reset.
  Future<Result<AuthAwaitingOtp>> requestOtp(String phoneNumber);

  Future<Result<AuthSignedIn>> verifyOtp({
    required String verificationId,
    required String smsCode,
  });

  Future<Result<AuthAwaitingOtp>> resendOtp({
    required String phoneNumber,
    int? resendToken,
  });

  /// The current Firebase ID token, refreshed when needed. This is what
  /// Supabase RLS and the trusted web tier both authenticate against.
  Future<Result<String>> idToken({bool forceRefresh = false});

  Future<Result<void>> signOut();

  /// Starts the platform's account deletion workflow. Does not merely clear
  /// local data — a request the worker cannot verify happened is not deletion.
  Future<Result<void>> requestAccountDeletion({required String reason});
}

// ---------------------------------------------------------------------------
// Worker profile
// ---------------------------------------------------------------------------

abstract interface class WorkerRepository {
  /// The signed-in worker, or null when no profile exists yet — which is the
  /// normal state between creating a Firebase account and finishing
  /// registration, and is distinct from a failure to load.
  Future<Result<Worker?>> getCurrentWorker();

  /// Live updates to the worker's own row.
  Stream<Worker> watchCurrentWorker();

  /// Re-binds an account whose Firebase UID has changed, or null.
  ///
  /// Firebase mints a new UID when a user record is deleted and the same
  /// number signs in again, and the worker then matched no row: the app sent
  /// them to register, and registering was refused because the old row still
  /// held their number. The server re-binds the account when the OTP-verified
  /// number on the token matches the one on it, so the only thing that can
  /// trigger this is the worker proving control of their own number.
  ///
  /// Null is the ordinary answer for someone who has genuinely not registered.
  Future<Result<Worker?>> claimExistingAccount();

  /// Creates the platform-side worker record for an already-authenticated
  /// Firebase user.
  Future<Result<Worker>> createProfile({
    required String fullName,
    required String phone,
    String? email,
  });

  /// Only the fields a worker is permitted to change. Status, verification
  /// flags, rating and wallet are not parameters here because they are not
  /// grantable to the client at all.
  Future<Result<Worker>> updateProfile({
    String? bio,
    int? experienceYears,
    String? addressLine,
    String? city,
    String? state,
    String? pincode,
    String? gender,
  });

  Future<Result<Worker>> updateServiceArea({
    required double latitude,
    required double longitude,
    required double radiusKm,
    String? city,
    String? pincode,
  });

  Future<Result<Worker>> setPrimaryService(String serviceId);

  /// Uploads and attaches a profile photo. Returns the updated worker.
  Future<Result<Worker>> updateProfilePhoto(File image);

  /// Trades the worker has asked for, with approval state.
  Future<Result<List<WorkerSkill>>> getSkills();

  /// Requests a trade. Arrives unapproved: selecting a regulated trade is a
  /// request, not a grant.
  Future<Result<WorkerSkill>> requestSkill(String serviceId);

  Future<Result<EarningsSummary>> getEarningsSummary();

  Future<Result<RatingSummary>> getRatingSummary();

  Future<Result<List<Rating>>> getRatings({int limit = 20, int offset = 0});
}

abstract interface class AvailabilityRepository {
  /// Whether the worker may receive jobs, and every reason they may not.
  Future<Result<WorkerEligibility>> getEligibility();

  /// Asks the server to change availability.
  ///
  /// Returns [PermissionFailure] carrying the eligibility reasons when the
  /// worker is not allowed to go available, so the UI can show a task list
  /// rather than a dead toggle. Going offline always succeeds — a worker must
  /// never be trapped in a state they cannot leave.
  Future<Result<WorkerEligibility>> setAvailability(WorkerAvailability value);
}

// ---------------------------------------------------------------------------
// Work
// ---------------------------------------------------------------------------

enum JobListFilter { offers, upcoming, active, completed, cancelled }

class PagedResult<T> {
  const PagedResult({required this.items, required this.hasMore});
  final List<T> items;
  final bool hasMore;
}

abstract interface class JobRepository {
  Future<Result<PagedResult<Job>>> getJobs({
    required JobListFilter filter,
    int limit = 20,
    int offset = 0,
  });

  Future<Result<Job>> getJob(String bookingId);

  Future<Result<List<JobEvent>>> getJobTimeline(String bookingId);

  /// Open offers. Only rows the matching engine actually offered to this
  /// worker; there is no path that invents one.
  Future<Result<List<JobOffer>>> getOffers();

  Stream<List<JobOffer>> watchOffers();

  Stream<Job> watchJob(String bookingId);

  /// The worker's current job, when one is in flight.
  Future<Result<Job?>> getActiveJob();

  /// Accepts an offer. This is a race the worker can lose: a
  /// [ConflictFailure] means another worker got there first, and the UI says
  /// exactly that.
  Future<Result<Job>> acceptOffer(String bookingId);

  Future<Result<void>> declineOffer(String bookingId, {String? reason});

  /// Moves the job forward. The server validates both the transition and the
  /// mover; this never assumes success.
  Future<Result<Job>> advance(
    String bookingId,
    BookingStatus toStatus, {
    String? reason,
  });

  /// Submits the customer's arrival code.
  ///
  /// The result is whatever the server decided. There is no client-side
  /// comparison, because the worker's app never holds the correct code — which
  /// is what makes the old application's "return success anyway" bug
  /// unreproducible here.
  Future<Result<ArrivalVerification>> verifyArrival(
    String bookingId,
    String code,
  );

  Future<Result<CompletionReadiness>> getCompletionReadiness(String bookingId);

  Future<Result<void>> rateCustomer({
    required String bookingId,
    required int rating,
    String? comment,
  });

  /// Records one point of this worker's live position against [bookingId].
  ///
  /// The server refuses this outside TRAVELING/ARRIVED/IN_PROGRESS and for a
  /// booking that is not this worker's, so a stray call after a job ends is
  /// harmless rather than a leak of a customer's whereabouts.
  Future<Result<void>> updateLocation({
    required String bookingId,
    required double latitude,
    required double longitude,
    double? accuracy,
    double? heading,
    double? speed,
  });

  /// A driving route from [originLat]/[originLng] to [destLat]/[destLng], via
  /// the server-side Routes API call. Never called on every GPS tick — the
  /// caller decides when a recompute is actually warranted.
  Future<Result<RouteInfo>> computeRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  });
}

/// A computed route: distance, duration and the points to draw it with.
class RouteInfo {
  const RouteInfo({
    required this.distanceMeters,
    required this.durationSeconds,
    required this.points,
  });

  final int? distanceMeters;
  final int? durationSeconds;
  final List<(double, double)> points;
}

class ArrivalVerification {
  const ArrivalVerification({
    required this.isVerified,
    this.alreadyVerified = false,
    this.attemptsRemaining,
  });

  final bool isVerified;
  final bool alreadyVerified;

  /// Null when verification succeeded. Otherwise how many tries are left before
  /// the worker has to call support.
  final int? attemptsRemaining;
}

abstract interface class MaterialRepository {
  Future<Result<List<MaterialRequest>>> getMaterials(String bookingId);

  Stream<List<MaterialRequest>> watchMaterials(String bookingId);

  Future<Result<MaterialRequest>> requestMaterial({
    required String bookingId,
    required String name,
    required double quantity,
    required String unit,
    required Money estimatedCost,
    String? description,
  });

  /// Records what the material actually cost. Requires an uploaded receipt —
  /// the server refuses without one, because an unevidenced cost is an
  /// unrecoverable cost.
  Future<Result<MaterialRequest>> recordActualCost({
    required String materialId,
    required Money actualCost,
  });
}

// ---------------------------------------------------------------------------
// Gigs
// ---------------------------------------------------------------------------

abstract interface class GigRepository {
  /// Every gig this worker has, in every state. There is no limit and no
  /// "already has one" check: a worker holds as many gigs as their approved
  /// trades allow.
  Future<Result<List<Gig>>> getMyGigs();

  Stream<List<Gig>> watchMyGigs();

  Future<Result<Gig>> getGig(String gigId);

  /// The trades this worker may publish a gig under. Derived from approved
  /// skills, so the picker cannot offer something the server will refuse.
  Future<Result<List<ServiceCategory>>> getAvailableCategories();

  Future<Result<Gig>> saveDraft(GigDraft draft);

  Future<Result<Gig>> publish(GigDraft draft);

  Future<Result<Gig>> pause(String gigId);

  Future<Result<Gig>> resume(String gigId);

  /// Archives rather than destroys: past bookings keep pointing at the gig they
  /// were sold from.
  Future<Result<Gig>> archive(String gigId);

  Future<Result<Gig>> addPhoto(String gigId, File image);
}

// ---------------------------------------------------------------------------
// Money
// ---------------------------------------------------------------------------

abstract interface class WalletRepository {
  Future<Result<Wallet>> getWallet();

  Stream<Wallet> watchWallet();

  Future<Result<PagedResult<WalletTransaction>>> getTransactions({
    int limit = 20,
    int offset = 0,
  });

  /// Ledger entries grouped per job, so the worker sees gross, fee and net
  /// together. The fee is read from the debit rows that exist — never computed
  /// on the client from a hardcoded percentage.
  Future<Result<List<EarningBreakdown>>> getEarningBreakdowns({
    int limit = 20,
    int offset = 0,
  });
}

abstract interface class PayoutRepository {
  Future<Result<List<Payout>>> getPayouts({int limit = 20, int offset = 0});

  /// Requests a withdrawal. [idempotencyKey] makes a double tap safe.
  Future<Result<Payout>> requestPayout({
    required Money amount,
    required String idempotencyKey,
  });

  /// The smallest amount the platform will process, from platform settings.
  Future<Result<Money>> getMinimumPayout();
}

// ---------------------------------------------------------------------------
// Trust
// ---------------------------------------------------------------------------

abstract interface class VerificationRepository {
  /// Every verification type with its real state. A type the worker has never
  /// started comes back as NOT_SUBMITTED, not absent and never approved.
  Future<Result<List<VerificationCase>>> getVerifications();

  Stream<List<VerificationCase>> watchVerifications();

  /// Submits a case for review. Reaches PENDING and nothing further: approval
  /// is not a client operation.
  Future<Result<VerificationCase>> submit({
    required VerificationType type,
    Map<String, dynamic> details = const {},
  });

  Future<Result<VerificationCase>> submitQualification(Qualification qualification);

  /// Sends payout bank details for admin verification. Reaches PENDING.
  Future<Result<VerificationCase>> submitBankAccount({
    required String accountHolderName,
    required String accountNumber,
    required String ifsc,
    String? bankName,
  });

  /// Starts the real DigiLocker identity-verification consent flow via the
  /// MessageCentral e-KYC integration. Returns the consent URL to open, or
  /// `null` if the worker is already verified.
  Future<Result<String?>> startDigilockerKyc();

  /// Polls whether the DigiLocker consent the worker completed has been
  /// decided yet. The decision itself is made server-side from what
  /// MessageCentral's DigiLocker journey returned — never by this app.
  Future<Result<DigilockerStatus>> checkDigilockerStatus();

  /// Policies on file. An empty list means no cover, and the UI says so
  /// rather than implying protection that does not exist.
  Future<Result<List<InsurancePolicy>>> getInsurancePolicies();

  Future<Result<List<Claim>>> getClaims();

  Future<Result<void>> respondToClaim({
    required String claimId,
    required String response,
  });
}

// ---------------------------------------------------------------------------
// Communication
// ---------------------------------------------------------------------------

abstract interface class SupportRepository {
  Future<Result<List<SupportTicket>>> getTickets();

  Future<Result<List<SupportMessage>>> getMessages(String ticketId);

  Stream<List<SupportMessage>> watchMessages(String ticketId);

  Future<Result<SupportTicket>> createTicket({
    required String subject,
    required SupportCategory category,
    required String message,
    String? bookingId,
  });

  Future<Result<SupportMessage>> postMessage({
    required String ticketId,
    required String body,
  });
}

abstract interface class NotificationRepository {
  Future<Result<PagedResult<AppNotification>>> getNotifications({
    int limit = 20,
    int offset = 0,
  });

  Stream<List<AppNotification>> watchNotifications();

  Future<Result<int>> getUnreadCount();

  Future<Result<void>> markRead(String notificationId);

  Future<Result<void>> markAllRead();

  /// Registers this device for push. The profile is resolved server-side, so a
  /// device cannot register a token against someone else's account.
  Future<Result<void>> registerPushToken({
    required String token,
    required String platform,
    String? deviceLabel,
  });

  /// Marks this device's push token inactive, so a worker who has signed out
  /// stops receiving their job alerts on a phone they may have handed back.
  Future<Result<void>> deactivatePushToken(String token);
}

// ---------------------------------------------------------------------------
// Media
// ---------------------------------------------------------------------------

abstract interface class MediaRepository {
  /// Uploads a file for a purpose.
  ///
  /// The full sequence — validate, compress, ask the server to authorize and
  /// allocate a path, PUT the bytes, confirm — lives behind this one call.
  /// The client never chooses a storage path.
  Stream<UploadTask> upload({
    required File file,
    required MediaPurpose purpose,
    String? bookingId,
    String? materialId,
    String? gigId,
    String? ticketId,
    DateTime? capturedAt,
  });

  Future<Result<UploadTask>> retry(String localId);

  Future<Result<void>> cancel(String localId);

  /// A short-lived signed URL. Sensitive files never have a public URL, so this
  /// is the only way to view one and every call is authorized server-side.
  Future<Result<String>> signedUrl(String mediaId);

  Future<Result<List<MediaAsset>>> getAssets({
    String? bookingId,
    String? workerId,
    MediaPurpose? purpose,
  });

  Future<Result<void>> delete(String mediaId);

  /// Uploads that were interrupted — by a dead connection, or by the app being
  /// killed — and can be resumed.
  Future<Result<List<UploadTask>>> getPendingUploads();
}

// ---------------------------------------------------------------------------
// Catalogue
// ---------------------------------------------------------------------------

abstract interface class CatalogueRepository {
  Future<Result<List<ServiceCategory>>> getServices();

  Future<Result<ServiceCategory>> getService(String serviceId);
}

// ---------------------------------------------------------------------------
// Customer Service Requests — worker side (Model B)
// ---------------------------------------------------------------------------

abstract interface class CustomerRequestDiscoveryRepository {
  /// Finds open customer service requests near the worker, filtered by the
  /// worker's registered services and radius.
  Future<Result<List<CustomerServiceRequest>>> findEligibleRequests({
    required double latitude,
    required double longitude,
    double radiusKm = 15,
  });

  /// Returns a single request by ID (for the detail screen).
  Future<Result<CustomerServiceRequest>> getRequest(String requestId);
}

abstract interface class WorkerOfferRepository {
  /// Submits an offer on a customer service request.
  Future<Result<WorkerOffer>> submitOffer({
    required String serviceRequestId,
    required int quotedAmountMinor,
    String? estimatedDuration,
    String? message,
    String? gigId,
  });

  /// All offers the current worker has submitted across all requests.
  Future<Result<List<WorkerOffer>>> getMyOffers();

  /// Offers for a specific request from this worker (usually 0 or 1).
  Future<Result<List<WorkerOffer>>> getOffersForRequest(String requestId);

  /// Withdraws a pending offer.
  Future<Result<void>> withdrawOffer(String offerId);
}

