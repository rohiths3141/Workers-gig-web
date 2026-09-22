import '../../core/money/money.dart';
import 'enums.dart';

/// One verification case, from `public.worker_verifications`.
///
/// `status` is written only by `decide_verification()`, which refuses
/// self-review. Nothing in this app can construct an approved case, and the
/// default when no row exists is [VerificationStatus.notSubmitted] — not
/// approved, which is what the old application displayed regardless of truth.
class VerificationCase {
  const VerificationCase({
    required this.type,
    required this.status,
    this.id,
    this.submittedAt,
    this.reviewedAt,
    this.rejectionReason,
    this.infoRequested,
    this.expiresAt,
    this.details = const {},
    this.documentMediaIds = const [],
  });

  /// A case the worker has never started. Used instead of null so the UI always
  /// has something concrete to render.
  const VerificationCase.notSubmitted(this.type)
      : id = null,
        status = VerificationStatus.notSubmitted,
        submittedAt = null,
        reviewedAt = null,
        rejectionReason = null,
        infoRequested = null,
        expiresAt = null,
        details = const {},
        documentMediaIds = const [];

  final String? id;
  final VerificationType type;
  final VerificationStatus status;
  final DateTime? submittedAt;
  final DateTime? reviewedAt;

  /// Why it was refused. Shown verbatim: a worker cannot fix a rejection they
  /// are not told the reason for.
  final String? rejectionReason;

  /// What else the reviewer needs.
  final String? infoRequested;

  /// Certificates and background checks go stale.
  final DateTime? expiresAt;

  final Map<String, dynamic> details;
  final List<String> documentMediaIds;

  bool get isExpired =>
      expiresAt != null && expiresAt!.isBefore(DateTime.now());

  /// Approved *and* still in date. An expired approval is not verification.
  bool get isCurrentlyValid => status.isApproved && !isExpired;

  /// The one line shown next to the badge.
  String get statusLabel => switch (status) {
        VerificationStatus.notSubmitted => 'Not started',
        VerificationStatus.pending => 'Submitted',
        VerificationStatus.underReview => 'Being reviewed',
        VerificationStatus.moreInfoRequired => 'More information needed',
        VerificationStatus.approved => isExpired ? 'Expired' : 'Verified',
        VerificationStatus.rejected => 'Not approved',
        VerificationStatus.expired => 'Expired',
        VerificationStatus.notApplicable => 'Not required',
      };
}

/// The outcome of polling the DigiLocker consent flow.
///
/// [reason] is only ever set by the server (from what MessageCentral actually
/// returned or a name mismatch it detected) — this app has no way to produce
/// [approved] itself.
enum DigilockerOutcome { pending, approved, rejected, alreadyVerified }

class DigilockerStatus {
  const DigilockerStatus(this.outcome, {this.reason});

  final DigilockerOutcome outcome;
  final String? reason;
}

/// A qualification the worker holds — ITI, diploma, or similar.
class Qualification {
  const Qualification({
    required this.type,
    required this.status,
    this.institution,
    this.qualificationName,
    this.specialisation,
    this.yearOfPassing,
    this.certificateNumber,
    this.documentMediaIds = const [],
  });

  final VerificationType type;
  final VerificationStatus status;
  final String? institution;
  final String? qualificationName;
  final String? specialisation;
  final int? yearOfPassing;
  final String? certificateNumber;
  final List<String> documentMediaIds;

  /// The details blob the `worker_submit_verification` contract expects.
  Map<String, dynamic> toDetails() => {
        if (institution != null) 'institution': institution,
        if (qualificationName != null) 'qualification': qualificationName,
        if (specialisation != null) 'specialisation': specialisation,
        if (yearOfPassing != null) 'year_of_passing': yearOfPassing,
        if (certificateNumber != null) 'certificate_number': certificateNumber,
      };

  Map<String, String> validate() {
    final errors = <String, String>{};
    if ((institution ?? '').trim().length < 2) {
      errors['institution'] = 'Which institute issued this?';
    }
    if ((qualificationName ?? '').trim().isEmpty) {
      errors['qualification'] = 'What is the qualification called?';
    }
    final year = yearOfPassing;
    final thisYear = DateTime.now().year;
    if (year == null) {
      errors['year'] = 'Which year did you complete it?';
    } else if (year < 1950 || year > thisYear) {
      errors['year'] = 'Enter a year between 1950 and $thisYear';
    }
    return errors;
  }
}

/// An insurance policy, from `public.insurance_policies`.
///
/// The platform is not the insurer. There is no constructor that invents a
/// policy, and the absence of a row means "no cover", never "cover assumed".
class InsurancePolicy {
  const InsurancePolicy({
    required this.id,
    required this.providerName,
    required this.policyNumber,
    required this.coverageAmount,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.premiumAmount,
  });

  final String id;
  final String providerName;
  final String policyNumber;
  final Money coverageAmount;
  final Money? premiumAmount;
  final DateTime startDate;
  final DateTime endDate;
  final InsuranceStatus status;

  bool get isCovering => status.isCovering && endDate.isAfter(DateTime.now());

  int get daysUntilExpiry => endDate.difference(DateTime.now()).inDays;

  /// Masked for display. The full number is on the policy document.
  String get maskedPolicyNumber {
    if (policyNumber.length <= 4) return policyNumber;
    return '${'•' * (policyNumber.length - 4)}${policyNumber.substring(policyNumber.length - 4)}';
  }
}

/// A damage or incident claim the worker is a party to.
class Claim {
  const Claim({
    required this.id,
    required this.claimCode,
    required this.type,
    required this.status,
    required this.description,
    required this.amountClaimed,
    required this.incidentAt,
    required this.createdAt,
    this.bookingCode,
    this.amountApproved,
    this.infoRequested,
    this.decisionNote,
    this.rejectionReason,
  });

  final String id;
  final String claimCode;
  final String type;
  final ClaimStatus status;
  final String description;
  final Money amountClaimed;
  final Money? amountApproved;
  final String? bookingCode;
  final String? infoRequested;
  final String? decisionNote;
  final String? rejectionReason;
  final DateTime incidentAt;
  final DateTime createdAt;

  bool get needsResponse => status.needsWorkerResponse;
}
