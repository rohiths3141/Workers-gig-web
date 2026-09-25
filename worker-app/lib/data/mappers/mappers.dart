import '../../core/money/money.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/gig.dart';
import '../../domain/entities/job.dart';
import '../../domain/entities/media.dart';
import '../../domain/entities/support.dart';
import '../../domain/entities/verification.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/entities/worker.dart';
import '../../core/localization/app_locale.dart';

/// Row-to-entity conversion.
///
/// One place that knows the column names, so a schema change is a single edit
/// rather than a search across the app. Nothing here invents a value: a missing
/// required column throws, because rendering a booking with a silently
/// defaulted status is worse than failing visibly.
typedef Row = Map<String, dynamic>;

// ---------------------------------------------------------------------------
// Primitives
// ---------------------------------------------------------------------------

String _requireString(Row row, String key) {
  final value = row[key];
  if (value is String && value.isNotEmpty) return value;
  throw FormatException('Missing "$key" in row');
}

DateTime _requireDate(Row row, String key) {
  final parsed = parseDate(row[key]);
  if (parsed == null) throw FormatException('Missing "$key" in row');
  return parsed;
}

DateTime? parseDate(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return value.toLocal();
  if (value is String) return DateTime.tryParse(value)?.toLocal();
  return null;
}

/// Postgres `bigint` arrives as int, but a large value can come back as a
/// string from PostgREST. Both are handled; a double never is, because a money
/// column that arrived as a double means something upstream is wrong.
int? parseMinor(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

Money? parseMoney(Object? value, {String currency = 'INR'}) {
  final minor = parseMinor(value);
  return minor == null ? null : Money(minor, currency: currency);
}

Money parseMoneyOrZero(Object? value, {String currency = 'INR'}) =>
    parseMoney(value, currency: currency) ?? Money.zero(currency: currency);

double? parseDouble(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int parseIntOr(Object? value, int fallback) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

Map<String, dynamic> parseJsonMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return const {};
}

/// A joined row. PostgREST returns an embedded resource as a map, or as a
/// single-element list depending on the relationship.
Row? embedded(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  if (value is List && value.isNotEmpty) {
    final first = value.first;
    if (first is Map) return Map<String, dynamic>.from(first);
  }
  return null;
}

// ---------------------------------------------------------------------------
// Worker
// ---------------------------------------------------------------------------

abstract final class WorkerMapper {
  static Worker fromRow(Row row, {String? profilePhotoUrl}) => Worker(
        id: _requireString(row, 'id'),
        firebaseUid: _requireString(row, 'firebase_uid'),
        workerCode: _requireString(row, 'worker_code'),
        fullName: _requireString(row, 'full_name'),
        phone: _requireString(row, 'phone'),
        email: row['email'] as String?,
        status: WorkerStatus.parse(row['status'] as String?),
        availability: WorkerAvailability.parse(row['availability'] as String?),
        primaryServiceId: row['primary_service_id'] as String?,
        experienceYears: parseIntOr(row['experience_years'], 0),
        bio: row['bio'] as String?,
        city: row['city'] as String?,
        state: row['state'] as String?,
        pincode: row['pincode'] as String?,
        gender: row['gender'] as String?,
        addressLine: row['address_line'] as String?,
        latitude: parseDouble(row['latitude']),
        longitude: parseDouble(row['longitude']),
        serviceRadiusKm: parseDouble(row['service_radius_km']) ?? 10,
        ratingAvg: parseDouble(row['rating_avg']),
        ratingCount: parseIntOr(row['rating_count'], 0),
        jobsCompleted: parseIntOr(row['jobs_completed'], 0),
        jobsCancelled: parseIntOr(row['jobs_cancelled'], 0),
        // Server-derived. Absent is false, never true: a missing flag must
        // never read as verified.
        isKycVerified: row['is_kyc_verified'] == true,
        isQualificationVerified: row['is_qualification_verified'] == true,
        isSkillVerified: row['is_skill_verified'] == true,
        isBackgroundVerified: row['is_background_verified'] == true,
        isInsured: row['is_insured'] == true,
        verifiedAt: parseDate(row['verified_at']),
        restrictionReason: row['restriction_reason'] as String?,
        profilePhotoUrl: profilePhotoUrl,
      );

  /// From the `worker_eligibility` RPC payload.
  static WorkerEligibility eligibilityFromJson(Row json) => WorkerEligibility(
        isEligible: json['eligible'] == true,
        accountStatus: WorkerStatus.parse(json['account_status'] as String?),
        availability: WorkerAvailability.parse(json['availability'] as String?),
        activeGigCount: parseIntOr(json['active_gig_count'], 0),
        reasons: (json['reasons'] as List? ?? const [])
            .whereType<Map>()
            .map((r) => EligibilityBlocker(
                  code: r['code'] as String? ?? 'UNKNOWN',
                  message:
                      r['message'] as String? ??
                          AppStrings.current.eligibilityStepIncomplete,
                  action: r['action'] as String?,
                ))
            .toList(growable: false),
      );

  static WorkerSkill skillFromRow(Row row) {
    final service = embedded(row['services']);
    return WorkerSkill(
      serviceId: _requireString(row, 'service_id'),
      serviceName: service?['name'] as String? ?? 'Service',
      serviceSlug: service?['slug'] as String? ?? '',
      isApproved: row['is_approved'] == true,
      approvedAt: parseDate(row['approved_at']),
    );
  }
}

// ---------------------------------------------------------------------------
// Catalogue
// ---------------------------------------------------------------------------

abstract final class ServiceMapper {
  static ServiceCategory fromRow(Row row) => ServiceCategory(
        id: _requireString(row, 'id'),
        name: _requireString(row, 'name'),
        slug: _requireString(row, 'slug'),
        shortDescription: row['short_description'] as String? ?? '',
        iconKey: row['icon_key'] as String? ?? 'wrench',
        requiredVerifications: (row['required_verifications'] as List? ?? const [])
            .whereType<String>()
            .map(VerificationType.parse)
            .toList(growable: false),
        baseVisitFee: parseMoney(row['base_visit_fee_minor']),
      );
}

// ---------------------------------------------------------------------------
// Jobs
// ---------------------------------------------------------------------------

abstract final class JobMapper {
  static Job fromRow(Row row, {double? distanceKm, DateTime? offerExpiresAt}) {
    final currency = row['currency'] as String? ?? 'INR';
    final service = embedded(row['services']);
    final customer = embedded(row['customers']);
    final gig = embedded(row['worker_gigs']);

    return Job(
      id: _requireString(row, 'id'),
      bookingCode: _requireString(row, 'booking_code'),
      status: BookingStatus.parse(row['status'] as String?),
      serviceId: _requireString(row, 'service_id'),
      serviceName: service?['name'] as String? ?? 'Service',
      gigId: row['gig_id'] as String?,
      gigTitle: gig?['title'] as String?,
      problemDescription: row['problem_description'] as String? ?? '',
      scheduledAt: parseDate(row['scheduled_at']),
      addressLine: row['address_line'] as String? ?? '',
      city: row['city'] as String?,
      pincode: row['pincode'] as String?,
      latitude: parseDouble(row['latitude']),
      longitude: parseDouble(row['longitude']),
      distanceKm: distanceKm,
      quotedAmount: parseMoney(row['quoted_amount_minor'], currency: currency),
      workerAmount: parseMoney(row['worker_amount_minor'], currency: currency),
      finalAmount: parseMoney(row['final_amount_minor'], currency: currency),
      platformFee: parseMoney(row['platform_fee_minor'], currency: currency),
      materialAmount:
          parseMoneyOrZero(row['material_amount_minor'], currency: currency),
      // Present only once the platform has released them to this worker.
      customerName: customer?['full_name'] as String?,
      customerPhone: customer?['phone'] as String?,
      arrivalVerifiedAt: parseDate(row['arrival_verified_at']),
      acceptedAt: parseDate(row['accepted_at']),
      travelStartedAt: parseDate(row['travel_started_at']),
      arrivedAt: parseDate(row['arrived_at']),
      workStartedAt: parseDate(row['work_started_at']),
      completedAt: parseDate(row['completed_at']),
      paidAt: parseDate(row['paid_at']),
      createdAt: _requireDate(row, 'created_at'),
      cancellationReason: row['cancellation_reason'] as String?,
      offerExpiresAt: offerExpiresAt,
    );
  }

  /// From a `booking_match_candidates` row with the booking embedded.
  static JobOffer offerFromRow(Row row, {required Duration responseWindow}) {
    final bookingRow = embedded(row['bookings']);
    if (bookingRow == null) {
      throw const FormatException('Offer row has no booking attached');
    }

    final offeredAt = parseDate(row['offered_at']) ?? DateTime.now();
    final expiresAt = offeredAt.add(responseWindow);
    final distanceKm = parseDouble(row['distance_km']) ?? 0;

    final job = fromRow(bookingRow,
        distanceKm: distanceKm, offerExpiresAt: expiresAt);

    return JobOffer(
      job: job,
      rank: parseIntOr(row['rank'], 0),
      distanceKm: distanceKm,
      offeredAt: offeredAt,
      expiresAt: expiresAt,
      // What the worker would be credited, when the booking already carries it.
      // Null renders as "amount confirmed after the visit", never as a guess.
      estimatedEarning: job.earnings,
    );
  }

  static JobEvent eventFromRow(Row row) => JobEvent(
        id: parseIntOr(row['id'], 0),
        eventType: _requireString(row, 'event_type'),
        fromStatus: row['from_status'] == null
            ? null
            : BookingStatus.parse(row['from_status'] as String?),
        toStatus: row['to_status'] == null
            ? null
            : BookingStatus.parse(row['to_status'] as String?),
        note: row['note'] as String?,
        createdAt: _requireDate(row, 'created_at'),
      );

  static MaterialRequest materialFromRow(Row row) {
    final currency = row['currency'] as String? ?? 'INR';
    return MaterialRequest(
      id: _requireString(row, 'id'),
      bookingId: _requireString(row, 'booking_id'),
      name: _requireString(row, 'name'),
      description: row['description'] as String?,
      quantity: parseDouble(row['quantity']) ?? 1,
      unit: row['unit'] as String? ?? 'unit',
      estimatedCost:
          parseMoneyOrZero(row['estimated_cost_minor'], currency: currency),
      actualCost: parseMoney(row['actual_cost_minor'], currency: currency),
      status: MaterialStatus.parse(row['status'] as String?),
      customerRejectionReason: row['customer_rejection_reason'] as String?,
      createdAt: _requireDate(row, 'created_at'),
    );
  }
}

// ---------------------------------------------------------------------------
// Gigs
// ---------------------------------------------------------------------------

abstract final class GigMapper {
  static Gig fromRow(Row row) {
    final currency = row['currency'] as String? ?? 'INR';
    final service = embedded(row['services']);
    return Gig(
      id: _requireString(row, 'id'),
      workerId: _requireString(row, 'worker_id'),
      serviceId: _requireString(row, 'service_id'),
      serviceName: service?['name'] as String? ?? 'Service',
      title: _requireString(row, 'title'),
      description: row['description'] as String?,
      status: GigStatus.parse(row['status'] as String?),
      price: parseMoneyOrZero(row['price_minor'], currency: currency),
      pricingUnit: PricingUnit.parse(row['pricing_unit'] as String?),
      estimatedDurationMinutes:
          parseIntOr(row['estimated_duration_minutes'], 60),
      serviceRadiusKm: parseDouble(row['service_radius_km']),
      rejectionReason: row['rejection_reason'] as String?,
      submittedAt: parseDate(row['submitted_at']),
      reviewedAt: parseDate(row['reviewed_at']),
      jobsCompleted: parseIntOr(row['jobs_completed'], 0),
      createdAt: _requireDate(row, 'created_at'),
      updatedAt: _requireDate(row, 'updated_at'),
    );
  }
}

// ---------------------------------------------------------------------------
// Money
// ---------------------------------------------------------------------------

abstract final class WalletMapper {
  static Wallet fromRow(Row row, {Money? pendingEarnings}) {
    final currency = row['currency'] as String? ?? 'INR';
    return Wallet(
      id: _requireString(row, 'id'),
      workerId: _requireString(row, 'worker_id'),
      balance: parseMoneyOrZero(row['balance_minor'], currency: currency),
      pendingEarnings: pendingEarnings ?? Money.zero(currency: currency),
      totalCredited:
          parseMoneyOrZero(row['total_credited_minor'], currency: currency),
      totalDebited:
          parseMoneyOrZero(row['total_debited_minor'], currency: currency),
      isFrozen: row['is_frozen'] == true,
      frozenReason: row['frozen_reason'] as String?,
      lastTransactionAt: parseDate(row['last_transaction_at']),
    );
  }

  static WalletTransaction transactionFromRow(Row row) {
    final currency = row['currency'] as String? ?? 'INR';
    final booking = embedded(row['bookings']);
    final service = booking == null ? null : embedded(booking['services']);

    return WalletTransaction(
      id: _requireString(row, 'id'),
      type: WalletTransactionType.parse(row['type'] as String?),
      amount: parseMoneyOrZero(row['amount_minor'], currency: currency),
      balanceAfter:
          parseMoneyOrZero(row['balance_after_minor'], currency: currency),
      description: row['description'] as String? ?? '',
      referenceType: row['reference_type'] as String?,
      referenceId: row['reference_id'] as String?,
      bookingCode: booking?['booking_code'] as String?,
      serviceName: service?['name'] as String?,
      createdAt: _requireDate(row, 'created_at'),
    );
  }

  static Payout payoutFromRow(Row row) {
    final currency = row['currency'] as String? ?? 'INR';
    return Payout(
      id: _requireString(row, 'id'),
      payoutCode: _requireString(row, 'payout_code'),
      amount: parseMoneyOrZero(row['amount_minor'], currency: currency),
      status: PayoutStatus.parse(row['status'] as String?),
      method: row['method'] as String? ?? 'BANK_TRANSFER',
      accountLast4: row['account_last4'] as String?,
      bankName: row['bank_name'] as String?,
      requestedAt: _requireDate(row, 'requested_at'),
      completedAt: parseDate(row['completed_at']),
      failureReason: row['failure_reason'] as String?,
      decisionReason: row['decision_reason'] as String?,
    );
  }
}

// ---------------------------------------------------------------------------
// Verification
// ---------------------------------------------------------------------------

abstract final class VerificationMapper {
  static VerificationCase fromRow(Row row) => VerificationCase(
        id: row['id'] as String?,
        type: VerificationType.parse(row['type'] as String?),
        status: VerificationStatus.parse(row['status'] as String?),
        submittedAt: parseDate(row['submitted_at']),
        reviewedAt: parseDate(row['reviewed_at']),
        rejectionReason: row['rejection_reason'] as String?,
        infoRequested: row['info_requested'] as String?,
        expiresAt: parseDate(row['expires_at']),
        details: parseJsonMap(row['details']),
      );

  static InsurancePolicy policyFromRow(Row row) {
    final currency = row['currency'] as String? ?? 'INR';
    return InsurancePolicy(
      id: _requireString(row, 'id'),
      providerName: _requireString(row, 'provider_name'),
      policyNumber: _requireString(row, 'policy_number'),
      coverageAmount:
          parseMoneyOrZero(row['coverage_amount_minor'], currency: currency),
      premiumAmount:
          parseMoney(row['premium_amount_minor'], currency: currency),
      startDate: _requireDate(row, 'start_date'),
      endDate: _requireDate(row, 'end_date'),
      status: InsuranceStatus.parse(row['status'] as String?),
    );
  }

  static Claim claimFromRow(Row row) {
    final currency = row['currency'] as String? ?? 'INR';
    final booking = embedded(row['bookings']);
    return Claim(
      id: _requireString(row, 'id'),
      claimCode: _requireString(row, 'claim_code'),
      type: row['type'] as String? ?? 'OTHER',
      status: ClaimStatus.parse(row['status'] as String?),
      description: row['description'] as String? ?? '',
      amountClaimed:
          parseMoneyOrZero(row['amount_claimed_minor'], currency: currency),
      amountApproved:
          parseMoney(row['amount_approved_minor'], currency: currency),
      bookingCode: booking?['booking_code'] as String?,
      infoRequested: row['info_requested'] as String?,
      decisionNote: row['decision_note'] as String?,
      rejectionReason: row['rejection_reason'] as String?,
      incidentAt: _requireDate(row, 'incident_at'),
      createdAt: _requireDate(row, 'created_at'),
    );
  }
}

// ---------------------------------------------------------------------------
// Support, notifications, ratings, media
// ---------------------------------------------------------------------------

abstract final class SupportMapper {
  static SupportTicket ticketFromRow(Row row) {
    final booking = embedded(row['bookings']);
    return SupportTicket(
      id: _requireString(row, 'id'),
      ticketCode: _requireString(row, 'ticket_code'),
      subject: _requireString(row, 'subject'),
      category: SupportCategory.parse(row['category'] as String?),
      status: SupportStatus.parse(row['status'] as String?),
      bookingCode: booking?['booking_code'] as String?,
      resolutionNote: row['resolution_note'] as String?,
      createdAt: _requireDate(row, 'created_at'),
      lastMessageAt: parseDate(row['last_message_at']) ??
          _requireDate(row, 'created_at'),
    );
  }

  static SupportMessage messageFromRow(Row row) => SupportMessage(
        id: _requireString(row, 'id'),
        ticketId: _requireString(row, 'ticket_id'),
        body: row['body'] as String? ?? '',
        isFromWorker: row['author_type'] == 'WORKER',
        createdAt: _requireDate(row, 'created_at'),
      );
}

abstract final class NotificationMapper {
  static AppNotification fromRow(Row row) => AppNotification(
        id: _requireString(row, 'id'),
        title: row['title'] as String? ?? '',
        body: row['body'] as String? ?? '',
        templateKey: row['template_key'] as String? ?? 'system',
        payload: parseJsonMap(row['payload']),
        createdAt: _requireDate(row, 'created_at'),
        readAt: parseDate(row['read_at']),
      );
}

abstract final class RatingMapper {
  static Rating fromRow(Row row) {
    final booking = embedded(row['bookings']);
    final service = booking == null ? null : embedded(booking['services']);
    return Rating(
      id: _requireString(row, 'id'),
      bookingId: _requireString(row, 'booking_id'),
      rating: parseIntOr(row['rating'], 0),
      comment: row['comment'] as String?,
      isFromCustomer: row['rater_type'] == 'CUSTOMER',
      serviceName: service?['name'] as String?,
      createdAt: _requireDate(row, 'created_at'),
    );
  }
}

abstract final class MediaMapper {
  static MediaAsset fromRow(Row row) => MediaAsset(
        id: _requireString(row, 'id'),
        purpose: MediaPurpose.parse(row['purpose'] as String?),
        uploadStatus: MediaUploadStatus.parse(row['upload_status'] as String?),
        mimeType: row['mime_type'] as String? ?? 'application/octet-stream',
        fileSizeBytes: parseIntOr(row['file_size_bytes'], 0),
        originalFileName: row['original_file_name'] as String? ?? 'file',
        bookingId: row['booking_id'] as String?,
        workerId: row['worker_id'] as String?,
        materialId: row['material_id'] as String?,
        capturedAt: parseDate(row['captured_at']),
        createdAt: _requireDate(row, 'created_at'),
        width: parseMinor(row['width']),
        height: parseMinor(row['height']),
        durationSeconds: parseDouble(row['duration_seconds']),
      );
}
