import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_worker/core/money/money.dart';
import 'package:wervexa_worker/domain/entities/enums.dart';
import 'package:wervexa_worker/domain/entities/verification.dart';

/// The old application showed five hardcoded VERIFIED rows regardless of the
/// truth, and let a worker award themselves the badge. These tests pin down the
/// replacement: the default is not-submitted, expiry revokes validity, and the
/// type system offers no way to construct an approval.
void main() {
  group('Default state', () {
    test('a case that was never started is NOT_SUBMITTED, not approved', () {
      const verification =
          VerificationCase.notSubmitted(VerificationType.identityKyc);

      expect(verification.status, VerificationStatus.notSubmitted);
      expect(verification.isCurrentlyValid, isFalse);
      expect(verification.statusLabel, 'Not started');
    });

    test('every verification type has a not-submitted default available', () {
      for (final type in VerificationType.values) {
        final verification = VerificationCase.notSubmitted(type);
        expect(verification.status, VerificationStatus.notSubmitted);
        expect(verification.isCurrentlyValid, isFalse);
      }
    });
  });

  group('Approval and expiry', () {
    test('an approved, in-date case is valid', () {
      final verification = VerificationCase(
        type: VerificationType.identityKyc,
        status: VerificationStatus.approved,
        expiresAt: DateTime.now().add(const Duration(days: 365)),
      );

      expect(verification.isCurrentlyValid, isTrue);
      expect(verification.statusLabel, 'Verified');
    });

    test('an approved case past its expiry is NOT valid', () {
      // A certificate that lapsed is not verification, and the worker is told
      // so rather than continuing to show a badge they no longer hold.
      final verification = VerificationCase(
        type: VerificationType.itiCertificate,
        status: VerificationStatus.approved,
        expiresAt: DateTime.now().subtract(const Duration(days: 1)),
      );

      expect(verification.isCurrentlyValid, isFalse);
      expect(verification.statusLabel, 'Expired');
    });

    test('an approved case with no expiry stays valid', () {
      const verification = VerificationCase(
        type: VerificationType.identityKyc,
        status: VerificationStatus.approved,
      );

      expect(verification.isCurrentlyValid, isTrue);
    });
  });

  group('What needs the worker\'s attention', () {
    test('rejected, expired and more-info need action', () {
      for (final status in [
        VerificationStatus.notSubmitted,
        VerificationStatus.moreInfoRequired,
        VerificationStatus.rejected,
        VerificationStatus.expired,
      ]) {
        expect(status.needsWorkerAction, isTrue, reason: '$status');
      }
    });

    test('anything with the platform does not', () {
      for (final status in [
        VerificationStatus.pending,
        VerificationStatus.underReview,
        VerificationStatus.approved,
      ]) {
        expect(status.needsWorkerAction, isFalse, reason: '$status');
      }
    });

    test('the background check is not the worker\'s to submit', () {
      // The platform runs it. Offering an upload would be asking for paperwork
      // that has nowhere to go.
      expect(VerificationType.backgroundCheck.isWorkerSubmitted, isFalse);
      expect(VerificationType.identityKyc.isWorkerSubmitted, isTrue);
    });
  });

  group('Qualification validation', () {
    Qualification qualification({
      String? institution = 'Government ITI, Coimbatore',
      String? name = 'Electrician',
      int? year = 2015,
    }) =>
        Qualification(
          type: VerificationType.itiCertificate,
          status: VerificationStatus.notSubmitted,
          institution: institution,
          qualificationName: name,
          yearOfPassing: year,
        );

    test('accepts a complete qualification', () {
      expect(qualification().validate(), isEmpty);
    });

    test('requires an institution', () {
      expect(qualification(institution: '').validate(), contains('institution'));
    });

    test('requires a qualification name', () {
      expect(qualification(name: '').validate(), contains('qualification'));
    });

    test('rejects a year in the future', () {
      final next = DateTime.now().year + 1;
      expect(qualification(year: next).validate(), contains('year'));
    });

    test('rejects an implausibly old year', () {
      expect(qualification(year: 1900).validate(), contains('year'));
    });

    test('builds only the fields that were filled in', () {
      final details = qualification().toDetails();
      expect(details['institution'], 'Government ITI, Coimbatore');
      expect(details['year_of_passing'], 2015);
      // Nothing is invented to fill the blob out.
      expect(details.containsKey('specialisation'), isFalse);
    });
  });

  group('Insurance', () {
    test('an active, in-date policy is covering', () {
      final policy = InsurancePolicy(
        id: 'p1',
        providerName: 'Example General',
        policyNumber: 'POL123456789',
        coverageAmount: const Money(10000000),
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now().add(const Duration(days: 335)),
        status: InsuranceStatus.active,
      );

      expect(policy.isCovering, isTrue);
    });

    test('a policy past its end date is not covering, whatever its status', () {
      final policy = InsurancePolicy(
        id: 'p1',
        providerName: 'Example General',
        policyNumber: 'POL123456789',
        coverageAmount: const Money(10000000),
        startDate: DateTime.now().subtract(const Duration(days: 400)),
        endDate: DateTime.now().subtract(const Duration(days: 1)),
        status: InsuranceStatus.active,
      );

      expect(policy.isCovering, isFalse);
    });

    test('the policy number is masked for display', () {
      final policy = InsurancePolicy(
        id: 'p1',
        providerName: 'Example General',
        policyNumber: 'POL123456789',
        coverageAmount: const Money(10000000),
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 365)),
        status: InsuranceStatus.active,
      );

      expect(policy.maskedPolicyNumber, endsWith('6789'));
      expect(policy.maskedPolicyNumber, isNot(contains('POL123')));
    });
  });
}
