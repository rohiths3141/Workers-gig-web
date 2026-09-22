import '../../core/money/money.dart';
import 'enums.dart';

/// The signed-in worker.
///
/// Mirrors `public.workers`. The `is*Verified` fields are derived server-side
/// by trigger from `worker_verifications` and are read-only here — there is no
/// setter, no copyWith entry, and no code path in this app that can produce a
/// Worker with a verification flag the server did not send. That is the direct
/// answer to the old application's hardcoded VERIFIED rows.
class Worker {
  const Worker({
    required this.id,
    required this.firebaseUid,
    required this.workerCode,
    required this.fullName,
    required this.phone,
    required this.status,
    required this.availability,
    required this.experienceYears,
    required this.serviceRadiusKm,
    required this.ratingCount,
    required this.jobsCompleted,
    required this.jobsCancelled,
    required this.isKycVerified,
    required this.isQualificationVerified,
    required this.isSkillVerified,
    required this.isBackgroundVerified,
    required this.isInsured,
    this.email,
    this.primaryServiceId,
    this.bio,
    this.city,
    this.state,
    this.pincode,
    this.gender,
    this.addressLine,
    this.latitude,
    this.longitude,
    this.ratingAvg,
    this.verifiedAt,
    this.restrictionReason,
    this.profilePhotoUrl,
  });

  final String id;
  final String firebaseUid;

  /// Human-readable identifier, e.g. `WKR-25-A1B2C3`. Shown to the worker
  /// because it is what support will ask for.
  final String workerCode;

  final String fullName;
  final String phone;
  final String? email;

  final WorkerStatus status;
  final WorkerAvailability availability;

  final String? primaryServiceId;
  final int experienceYears;
  final String? bio;

  final String? city;
  final String? state;
  final String? pincode;
  final String? gender;
  final String? addressLine;
  final double? latitude;
  final double? longitude;
  final double serviceRadiusKm;

  final double? ratingAvg;
  final int ratingCount;
  final int jobsCompleted;
  final int jobsCancelled;

  // Server-derived. Never written by this app.
  final bool isKycVerified;
  final bool isQualificationVerified;
  final bool isSkillVerified;
  final bool isBackgroundVerified;
  final bool isInsured;
  final DateTime? verifiedAt;

  /// Set by trust and safety alongside a status change. Shown verbatim so a
  /// restricted worker knows what happened rather than finding features missing.
  final String? restrictionReason;

  /// Resolved from a signed URL, not stored on the row.
  final String? profilePhotoUrl;

  bool get hasServiceArea => latitude != null && longitude != null;

  /// First name, for greeting. Falls back to the whole name.
  String get shortName {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? fullName : parts.first;
  }

  /// Fraction of the profile that is filled in, 0..1.
  ///
  /// Deliberately counts only what the worker controls. Verification approval
  /// is not in here: a worker who has done everything asked of them should see
  /// 100%, and then wait for review, rather than being shown an incomplete bar
  /// for something that is not theirs to finish.
  double get profileCompletion {
    final checks = <bool>[
      fullName.trim().isNotEmpty,
      phone.isNotEmpty,
      primaryServiceId != null,
      experienceYears >= 0,
      hasServiceArea,
      (city ?? '').isNotEmpty,
      (pincode ?? '').isNotEmpty,
      (bio ?? '').trim().isNotEmpty,
      profilePhotoUrl != null,
    ];
    final done = checks.where((c) => c).length;
    return done / checks.length;
  }

  Worker copyWith({
    String? fullName,
    String? email,
    WorkerAvailability? availability,
    String? primaryServiceId,
    int? experienceYears,
    String? bio,
    String? city,
    String? state,
    String? pincode,
    String? addressLine,
    double? latitude,
    double? longitude,
    double? serviceRadiusKm,
    String? profilePhotoUrl,
  }) {
    // Note the absence of status and every is*Verified flag. Those change only
    // by re-reading the server.
    return Worker(
      id: id,
      firebaseUid: firebaseUid,
      workerCode: workerCode,
      fullName: fullName ?? this.fullName,
      phone: phone,
      email: email ?? this.email,
      status: status,
      availability: availability ?? this.availability,
      primaryServiceId: primaryServiceId ?? this.primaryServiceId,
      experienceYears: experienceYears ?? this.experienceYears,
      bio: bio ?? this.bio,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      addressLine: addressLine ?? this.addressLine,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      serviceRadiusKm: serviceRadiusKm ?? this.serviceRadiusKm,
      ratingAvg: ratingAvg,
      ratingCount: ratingCount,
      jobsCompleted: jobsCompleted,
      jobsCancelled: jobsCancelled,
      isKycVerified: isKycVerified,
      isQualificationVerified: isQualificationVerified,
      isSkillVerified: isSkillVerified,
      isBackgroundVerified: isBackgroundVerified,
      isInsured: isInsured,
      verifiedAt: verifiedAt,
      restrictionReason: restrictionReason,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
    );
  }
}

/// The answer to "can I receive jobs, and if not, why not", from
/// `public.worker_eligibility`.
class WorkerEligibility {
  const WorkerEligibility({
    required this.isEligible,
    required this.accountStatus,
    required this.availability,
    required this.activeGigCount,
    required this.reasons,
  });

  final bool isEligible;
  final WorkerStatus accountStatus;
  final WorkerAvailability availability;
  final int activeGigCount;

  /// Empty when eligible. Otherwise every blocker, each with a destination.
  final List<EligibilityBlocker> reasons;
}

class EligibilityBlocker {
  const EligibilityBlocker({
    required this.code,
    required this.message,
    this.action,
  });

  final String code;
  final String message;

  /// Route fragment to send the worker to, e.g. `verification/kyc`.
  final String? action;
}

/// A trade the worker may work in. `isApproved` is set by operations; an
/// unapproved skill cannot carry a gig.
class WorkerSkill {
  const WorkerSkill({
    required this.serviceId,
    required this.serviceName,
    required this.serviceSlug,
    required this.isApproved,
    this.approvedAt,
  });

  final String serviceId;
  final String serviceName;
  final String serviceSlug;
  final bool isApproved;
  final DateTime? approvedAt;
}

/// Aggregated earnings, all derived server-side from the ledger.
class EarningsSummary {
  const EarningsSummary({
    required this.today,
    required this.thisWeek,
    required this.thisMonth,
    required this.lifetime,
  });

  final Money today;
  final Money thisWeek;
  final Money thisMonth;
  final Money lifetime;
}
