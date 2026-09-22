import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show SupabaseClient;

import '../../core/errors/result.dart';
import '../../core/nlu/keyword_service_matcher.dart';
import '../../core/supabase/supabase_client_provider.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import '../../data/repositories/http_payment_repository.dart';
import '../../data/repositories/supabase_address_repository.dart';
import '../../data/repositories/supabase_booking_repository.dart';
import '../../data/repositories/supabase_catalogue_repository.dart';
import '../../data/repositories/supabase_customer_repository.dart';
import '../../data/repositories/supabase_gig_discovery_repository.dart';
import '../../data/repositories/supabase_location_repository.dart';
import '../../data/repositories/supabase_material_repository.dart';
import '../../data/repositories/supabase_notification_repository.dart';
import '../../data/repositories/supabase_review_repository.dart';
import '../../data/repositories/supabase_service_request_offer_repository.dart';
import '../../data/repositories/supabase_service_request_repository.dart';
import '../../data/repositories/supabase_support_repository.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/customer_address.dart';
import '../../domain/entities/gig_card.dart';
import '../../domain/entities/material_request.dart';
import '../../domain/entities/payment.dart';
import '../../domain/entities/service_category.dart';
import '../../domain/entities/service_problem.dart';
import '../../domain/entities/service_request.dart';
import '../../domain/entities/service_request_offer.dart';
import '../../domain/entities/support_ticket.dart';
import '../../domain/entities/worker_location.dart';
import '../../domain/matching/service_matcher.dart';
import '../../domain/repositories/repositories.dart';
import '../config/app_config.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('appConfigProvider must be overridden at startup');
});

final supabaseClientProvider = Provider<SupabaseClient?>((ref) {
  if (!SupabaseClientProvider.isInitialized) return null;
  return SupabaseClientProvider.instance.client;
});

// ---------------------------------------------------------------------------
// Identity
// ---------------------------------------------------------------------------

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FirebaseAuthRepository(),
);

final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

final firebaseUidProvider = Provider<String?>((ref) {
  final state = ref.watch(authStateProvider).valueOrNull;
  return state is AuthSignedIn ? state.firebaseUid : null;
});

String? Function() _uidReader(Ref ref) =>
    () => ref.read(authRepositoryProvider).currentState is AuthSignedIn
        ? (ref.read(authRepositoryProvider).currentState as AuthSignedIn)
            .firebaseUid
        : null;

// ---------------------------------------------------------------------------
// Data Repositories
// ---------------------------------------------------------------------------

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseCustomerRepository(
    client ?? SupabaseClient('http://localhost', 'placeholder'),
    currentFirebaseUid: _uidReader(ref),
  );
});

final catalogueRepositoryProvider = Provider<CatalogueRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseCatalogueRepository(
    client ?? SupabaseClient('http://localhost', 'placeholder'),
    currentFirebaseUid: _uidReader(ref),
  );
});

final gigDiscoveryRepositoryProvider = Provider<GigDiscoveryRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseGigDiscoveryRepository(
    client ?? SupabaseClient('http://localhost', 'placeholder'),
    currentFirebaseUid: _uidReader(ref),
  );
});

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseBookingRepository(
    client ?? SupabaseClient('http://localhost', 'placeholder'),
    currentFirebaseUid: _uidReader(ref),
  );
});

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseAddressRepository(
    client ?? SupabaseClient('http://localhost', 'placeholder'),
    currentFirebaseUid: _uidReader(ref),
  );
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseLocationRepository(
    client ?? SupabaseClient('http://localhost', 'placeholder'),
    currentFirebaseUid: _uidReader(ref),
  );
});

final materialRepositoryProvider = Provider<MaterialRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseMaterialRepository(
    client ?? SupabaseClient('http://localhost', 'placeholder'),
    currentFirebaseUid: _uidReader(ref),
  );
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseNotificationRepository(
    client ?? SupabaseClient('http://localhost', 'placeholder'),
    currentFirebaseUid: _uidReader(ref),
  );
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseReviewRepository(
    client ?? SupabaseClient('http://localhost', 'placeholder'),
    currentFirebaseUid: _uidReader(ref),
  );
});

final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseSupportRepository(
    client ?? SupabaseClient('http://localhost', 'placeholder'),
    currentFirebaseUid: _uidReader(ref),
  );
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final config = ref.watch(appConfigProvider);
  return HttpPaymentRepository(
    client ?? SupabaseClient('http://localhost', 'placeholder'),
    ref.watch(authRepositoryProvider),
    apiBaseUrl: config.apiBaseUrl,
  );
});

// ---------------------------------------------------------------------------
// Convenience Stream / Future Providers
// ---------------------------------------------------------------------------

/// The value, or the failure thrown so Riverpod reports it as AsyncError.
///
/// These providers used to answer a failure with an empty list, which reads to
/// the customer as "you have nothing" — no bookings, no saved addresses, no
/// categories — and offers no retry. A network drop looked exactly like an
/// empty account. Every screen below already has an `error:` branch with a real
/// message and a Try again; nothing was reaching it.
///
/// [AppFailure] is an Exception, so it survives the throw with its type and
/// message intact and the UI can say what actually went wrong.
T _orThrow<T>(Result<T> result) =>
    result.fold((value) => value, (failure) => throw failure);

final serviceCategoriesProvider = FutureProvider<List<ServiceCategory>>((ref) async {
  return _orThrow(await ref.watch(catalogueRepositoryProvider).getServices());
});

final serviceProblemsProvider = FutureProvider.family<List<ServiceProblem>, String>((ref, serviceId) async {
  return _orThrow(
    await ref.watch(catalogueRepositoryProvider).getServiceProblems(serviceId),
  );
});

/// Every problem across the whole catalogue — the assistant's vocabulary.
final allServiceProblemsProvider = FutureProvider<List<ServiceProblem>>((ref) async {
  return _orThrow(
    await ref.watch(catalogueRepositoryProvider).getAllServiceProblems(),
  );
});

/// The engine that turns "water is leaking under my sink" into Plumbing.
///
/// Kept alive for the session: it builds an index over the catalogue on
/// first use and reuses it for every later message, so the second question
/// in a conversation answers faster than the first.
final serviceMatcherProvider = Provider<ServiceMatcher>((ref) {
  return KeywordServiceMatcher();
});

final customerBookingsProvider = FutureProvider.family<List<Booking>, String>((ref, customerId) async {
  return _orThrow(await ref.watch(bookingRepositoryProvider).getMyBookings());
});

/// Live single-booking stream, seeded from the current row then kept live
/// via Realtime — so a status change updates any screen watching it.
final bookingStreamProvider = StreamProvider.family<Booking, String>((ref, bookingId) {
  return ref.watch(bookingRepositoryProvider).watchBooking(bookingId);
});

final activeBookingsProvider = FutureProvider<List<Booking>>((ref) async {
  final bookings =
      _orThrow(await ref.watch(bookingRepositoryProvider).getMyBookings());
  return bookings.where((b) => b.status.isActive).toList();
});

final gigDiscoveryProvider = FutureProvider.family<List<GigCard>, ({String serviceId, double lat, double lng, double radiusKm})>((ref, arg) async {
  final res = await ref.watch(gigDiscoveryRepositoryProvider).findGigs(
        serviceId: arg.serviceId,
        latitude: arg.lat,
        longitude: arg.lng,
        radiusKm: arg.radiusKm,
      );
  // Wrapping this in a bare Exception lost the AppFailure's type and message,
  // so the UI could only print the toString of a wrapper.
  return _orThrow(res);
});

final customerAddressesProvider = FutureProvider.family<List<CustomerAddress>, String>((ref, customerId) async {
  return _orThrow(await ref.watch(addressRepositoryProvider).getAddresses());
});

final bookingMaterialsProvider = StreamProvider.family<List<MaterialRequest>, String>((ref, bookingId) {
  return ref.watch(materialRepositoryProvider).watchMaterials(bookingId);
});

final workerLocationProvider = StreamProvider.family<WorkerLocation?, String>((ref, bookingId) {
  return ref.watch(locationRepositoryProvider).watchWorkerLocation(bookingId);
});

final notificationsProvider = StreamProvider<List<AppNotification>>((ref) {
  return ref.watch(notificationRepositoryProvider).watchNotifications();
});

/// The payment on a booking, or null when there genuinely is not one yet.
///
/// The distinction matters more here than anywhere else in the app. A failure
/// used to come back as null, which is the same answer as "not paid yet" — so
/// a lookup that failed put the customer back on the Pay button for a booking
/// they may already have paid for. Null now means only what it says.
final paymentForBookingProvider = FutureProvider.family<Payment?, String>((ref, bookingId) async {
  return _orThrow(
    await ref.watch(paymentRepositoryProvider).getPaymentForBooking(bookingId),
  );
});

/// Bookings with a captured payment. Refreshed when the bookings list is.
///
/// This must never answer a failure with an empty set: the screens read it as
/// "not paid yet" and offer to take the money again.
final paidBookingIdsProvider = FutureProvider<Set<String>>((ref) async {
  return _orThrow(await ref.watch(paymentRepositoryProvider).getPaidBookingIds());
});

final myTicketsProvider = FutureProvider<List<SupportTicket>>((ref) async {
  return _orThrow(await ref.watch(supportRepositoryProvider).getMyTickets());
});

final supportMessagesProvider = StreamProvider.family<List<SupportMessage>, String>((ref, ticketId) {
  return ref.watch(supportRepositoryProvider).watchMessages(ticketId);
});

/// The real, server-issued arrival code for a booking. Only resolves
/// successfully once the booking has reached ARRIVED — the RPC enforces
/// this server-side and errors otherwise.
final arrivalCodeProvider = FutureProvider.family<String?, String>((ref, bookingId) async {
  final res = await ref.watch(bookingRepositoryProvider).getArrivalCode(bookingId);
  return res.fold((code) => code, (_) => null);
});

// ---------------------------------------------------------------------------
// Service Requests (Model B)
// ---------------------------------------------------------------------------

final serviceRequestRepositoryProvider = Provider<ServiceRequestRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseServiceRequestRepository(
    client ?? SupabaseClient('http://localhost', 'placeholder'),
    currentFirebaseUid: _uidReader(ref),
  );
});

final serviceRequestOfferRepositoryProvider =
    Provider<ServiceRequestOfferRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseServiceRequestOfferRepository(
    client ?? SupabaseClient('http://localhost', 'placeholder'),
    currentFirebaseUid: _uidReader(ref),
  );
});

/// All service requests for the current customer.
final myServiceRequestsProvider = FutureProvider<List<ServiceRequest>>((ref) async {
  return _orThrow(
    await ref.watch(serviceRequestRepositoryProvider).getMyServiceRequests(),
  );
});

/// Live stream of the customer's service requests.
final myServiceRequestsStreamProvider =
    StreamProvider<List<ServiceRequest>>((ref) {
  return ref.watch(serviceRequestRepositoryProvider).watchMyServiceRequests();
});

/// Live stream of a single service request.
final serviceRequestStreamProvider =
    StreamProvider.family<ServiceRequest, String>((ref, requestId) {
  return ref.watch(serviceRequestRepositoryProvider).watchServiceRequest(requestId);
});

/// Offers received for a specific service request.
final offersForRequestProvider =
    FutureProvider.family<List<ServiceRequestOffer>, String>((ref, requestId) async {
  return _orThrow(
    await ref
        .watch(serviceRequestOfferRepositoryProvider)
        .getOffersForRequest(requestId),
  );
});

/// Live stream of offers for a service request.
final offersForRequestStreamProvider =
    StreamProvider.family<List<ServiceRequestOffer>, String>((ref, requestId) {
  return ref
      .watch(serviceRequestOfferRepositoryProvider)
      .watchOffersForRequest(requestId);
});

