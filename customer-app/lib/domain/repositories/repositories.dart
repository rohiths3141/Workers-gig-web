import '../../core/errors/result.dart';
import '../entities/app_notification.dart';
import '../entities/booking.dart';
import '../entities/customer.dart';
import '../entities/customer_address.dart';
import '../entities/enums.dart';
import '../entities/gig_card.dart';
import '../entities/material_request.dart';
import '../entities/payment.dart';
import '../entities/service_category.dart';
import '../entities/service_problem.dart';
import '../entities/service_request.dart';
import '../entities/service_request_offer.dart';
import '../entities/support_ticket.dart';
import '../entities/worker_location.dart';

import 'auth_state.dart';

export 'auth_state.dart';

// ---------------------------------------------------------------------------
// Auth
// ---------------------------------------------------------------------------

abstract interface class AuthRepository {
  Stream<AuthState> authStateChanges();
  AuthState get currentState;
  Future<Result<AuthAwaitingOtp>> requestOtp(String phoneNumber);
  Future<Result<AuthSignedIn>> verifyOtp({
    required String verificationId,
    required String smsCode,
  });
  Future<Result<AuthAwaitingOtp>> resendOtp({
    required String phoneNumber,
    int? resendToken,
  });
  Future<Result<String>> idToken({bool forceRefresh = false});
  Future<Result<void>> signOut();
}

// ---------------------------------------------------------------------------
// Customer profile
// ---------------------------------------------------------------------------

abstract interface class CustomerRepository {
  Future<Result<Customer?>> getCurrentCustomer();

  /// Re-binds an account whose Firebase UID has changed, or null.
  ///
  /// Firebase mints a new UID when a user record is deleted and the same
  /// number signs in again, and the customer then matched no row: the app sent
  /// them to register, and registering was refused because the old row still
  /// held their number. The server re-binds the account only when the
  /// OTP-verified number on the token matches the one on it, so the app sends
  /// no phone number of its own.
  ///
  /// Null is the ordinary answer for someone who has genuinely not registered.
  Future<Result<Customer?>> claimExistingAccount();

  Future<Result<Customer>> createProfile({
    required String fullName,
    required String phone,
    String? email,
  });

  /// Direct RLS-scoped update — the server grants UPDATE on exactly these
  /// customer-editable columns, nothing else.
  Future<Result<Customer>> updateProfile({
    required String fullName,
    String? email,
  });

  /// Sets the customer's current search anchor — not a saved address, and
  /// distinct from [AddressRepository.upsertAddress]'s permanent Home/Work/
  /// Other entries. This is "where am I searching from right now".
  Future<Result<Customer>> updateLocation({
    required double latitude,
    required double longitude,
    String? city,
    String? state,
    String? pincode,
  });
}

// ---------------------------------------------------------------------------
// Service catalogue
// ---------------------------------------------------------------------------

abstract interface class CatalogueRepository {
  Future<Result<List<ServiceCategory>>> getServices();
  Future<Result<List<ServiceProblem>>> getServiceProblems(String serviceId);

  /// Every problem across every active service, in one call.
  ///
  /// The assistant scores a customer's description against the whole
  /// catalogue at once — it cannot ask for one service's problems, because
  /// which service it is is exactly the question. Fetching per service would
  /// be eight round trips to answer one sentence.
  Future<Result<List<ServiceProblem>>> getAllServiceProblems();
}

// ---------------------------------------------------------------------------
// Gig discovery
// ---------------------------------------------------------------------------

abstract interface class GigDiscoveryRepository {
  Future<Result<List<GigCard>>> findGigs({
    required String serviceId,
    required double latitude,
    required double longitude,
    double radiusKm = 25,
  });
}

// ---------------------------------------------------------------------------
// Addresses
// ---------------------------------------------------------------------------

abstract interface class AddressRepository {
  Future<Result<List<CustomerAddress>>> getAddresses();
  Future<Result<CustomerAddress>> upsertAddress({
    String? addressId,
    required String label,
    required String addressLine,
    String? city,
    String? state,
    String? pincode,
    double? latitude,
    double? longitude,
    bool isDefault = false,
  });
  Future<Result<void>> deleteAddress(String addressId);
}

// ---------------------------------------------------------------------------
// Bookings
// ---------------------------------------------------------------------------

abstract interface class BookingRepository {
  Future<Result<Booking>> createBooking({
    required String gigId,
    required String problemDescription,
    required String addressLine,
    required String city,
    String? state,
    String? pincode,
    double? latitude,
    double? longitude,
    DateTime? scheduledAt,
    String? notes,
  });

  Future<Result<List<Booking>>> getMyBookings();

  Future<Result<Booking>> getBooking(String bookingId);

  Stream<Booking> watchBooking(String bookingId);

  Stream<List<BookingEvent>> watchBookingEvents(String bookingId);

  Future<Result<Booking>> approveCompletion(String bookingId);

  Future<Result<Booking>> cancelBooking(String bookingId, {String? reason});

  Future<Result<String>> getArrivalCode(String bookingId);
}

// ---------------------------------------------------------------------------
// Materials
// ---------------------------------------------------------------------------

abstract interface class MaterialRepository {
  Future<Result<List<MaterialRequest>>> getMaterialsForBooking(
      String bookingId);
  Stream<List<MaterialRequest>> watchMaterials(String bookingId);
  Future<Result<MaterialRequest>> approveMaterial(String materialId);
  Future<Result<MaterialRequest>> rejectMaterial(String materialId,
      {String? reason});
}

// ---------------------------------------------------------------------------
// Live tracking
// ---------------------------------------------------------------------------

abstract interface class LocationRepository {
  /// Streams the latest worker location for an active booking.
  Stream<WorkerLocation?> watchWorkerLocation(String bookingId);

  /// Fetches the most recent known location for the given booking.
  Future<Result<WorkerLocation?>> getLatestWorkerLocation(String bookingId);
}

// ---------------------------------------------------------------------------
// Notifications
// ---------------------------------------------------------------------------

abstract interface class NotificationRepository {
  Future<void> registerPushToken(String token, String platform);

  /// Live stream of the customer's own in-app notifications (RLS-scoped).
  Stream<List<AppNotification>> watchNotifications();

  Future<void> markRead(String notificationId);
}

// ---------------------------------------------------------------------------
// Reviews
// ---------------------------------------------------------------------------

abstract interface class SupportRepository {
  Future<Result<List<SupportTicket>>> getMyTickets();

  Future<Result<SupportTicket>> createTicket({
    required String subject,
    required SupportCategory category,
    required String message,
    String? bookingId,
  });

  Stream<List<SupportMessage>> watchMessages(String ticketId);

  Future<Result<void>> postMessage(String ticketId, String body);
}

// ---------------------------------------------------------------------------
// Payments
// ---------------------------------------------------------------------------

abstract interface class PaymentRepository {
  /// Asks the trusted backend to start (or resume) payment for a booking.
  /// The backend computes the real amount server-side — this never sends one.
  Future<Result<PaymentOrder>> createOrder(String bookingId);

  /// Sends the gateway's own signed result to the backend for verification.
  /// A client-side "it succeeded" is never trusted on its own.
  Future<Result<void>> verifyPayment({
    required String paymentId,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  });

  /// Reads the current payment row for a booking, if one exists. A captured
  /// payment is preferred over later abandoned checkout attempts.
  Future<Result<Payment?>> getPaymentForBooking(String bookingId);

  /// Ids of this customer's bookings that have a captured payment. Bookings
  /// are paid upfront, so an unpaid REQUESTED booking still needs checkout.
  Future<Result<Set<String>>> getPaidBookingIds();
}

abstract interface class ReviewRepository {
  /// Rates the worker for a completed booking. The server enforces that the
  /// booking belongs to the caller, is in a rateable state, and has not
  /// already been rated.
  Future<Result<void>> rateWorker({
    required String bookingId,
    required int rating,
    String? comment,
  });
}

// ---------------------------------------------------------------------------
// Service requests (Model B — customer posts, workers offer)
// ---------------------------------------------------------------------------

abstract interface class ServiceRequestRepository {
  /// Creates a new service request and publishes it for worker discovery.
  Future<Result<ServiceRequest>> createServiceRequest({
    required String categoryId,
    required String title,
    required String description,
    required BudgetType budgetType,
    int? budgetMinMinor,
    int? budgetMaxMinor,
    required ScheduleType scheduleType,
    DateTime? scheduledDate,
    String? timeWindowStart,
    String? timeWindowEnd,
    required String addressLine,
    String? city,
    String? state,
    String? pincode,
    double? latitude,
    double? longitude,
    String? additionalNotes,
  });

  /// All service requests for the current customer.
  Future<Result<List<ServiceRequest>>> getMyServiceRequests();

  /// Live updates to the customer's service requests.
  Stream<List<ServiceRequest>> watchMyServiceRequests();

  /// A single service request.
  Future<Result<ServiceRequest>> getServiceRequest(String requestId);

  /// Live updates to a single service request (for offer count, status).
  Stream<ServiceRequest> watchServiceRequest(String requestId);

  /// Cancels a service request that is still open or receiving offers.
  Future<Result<ServiceRequest>> cancelServiceRequest(String requestId);
}

abstract interface class ServiceRequestOfferRepository {
  /// All offers received for a specific service request.
  Future<Result<List<ServiceRequestOffer>>> getOffersForRequest(
      String requestId);

  /// Live stream of offers for a request (new offers appear in realtime).
  Stream<List<ServiceRequestOffer>> watchOffersForRequest(String requestId);

  /// Accept an offer — atomically creates a booking, closes other offers.
  Future<Result<Booking>> acceptOffer(String offerId);

  /// Reject a single offer.
  Future<Result<void>> rejectOffer(String offerId);
}

