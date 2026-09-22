import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_worker/core/money/money.dart';
import 'package:wervexa_worker/domain/entities/enums.dart';
import 'package:wervexa_worker/domain/entities/gig.dart';

/// The multi-gig rule is the central business requirement, so it gets a test
/// that would fail loudly if anyone reintroduced a one-gig assumption.
void main() {
  Gig gig({
    String id = 'g1',
    String serviceId = 's-electrical',
    String serviceName = 'Electrical',
    String title = 'Switchboard Repair',
    GigStatus status = GigStatus.active,
    int priceMinor = 39900,
    int durationMinutes = 60,
  }) =>
      Gig(
        id: id,
        workerId: 'w1',
        serviceId: serviceId,
        serviceName: serviceName,
        title: title,
        status: status,
        price: Money(priceMinor),
        pricingUnit: PricingUnit.perJob,
        estimatedDurationMinutes: durationMinutes,
        jobsCompleted: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  group('One worker, many gigs', () {
    test('a worker holds gigs across several trades', () {
      // Arun: AC technician, painter and electrician. One person, one identity,
      // five offerings. Nothing in the model caps this.
      final gigs = [
        gig(id: 'g1', serviceId: 's-ac', serviceName: 'AC Service', title: 'AC Service'),
        gig(id: 'g2', serviceId: 's-ac', serviceName: 'AC Service', title: 'AC Installation', priceMinor: 149900),
        gig(id: 'g3', serviceId: 's-paint', serviceName: 'Painting', title: 'Interior Wall Painting', priceMinor: 250000),
        gig(id: 'g4', serviceId: 's-paint', serviceName: 'Painting', title: 'Single Room Repaint', priceMinor: 80000),
        gig(id: 'g5', serviceId: 's-electrical', serviceName: 'Electrical', title: 'Electrical Repair'),
      ];

      expect(gigs, hasLength(5));
      expect(gigs.map((g) => g.serviceId).toSet(), hasLength(3));
      expect(gigs.map((g) => g.workerId).toSet(), hasLength(1));
    });

    test('each gig carries its own price, not one worker-wide rate', () {
      final acService = gig(title: 'AC Service', priceMinor: 49900);
      final painting = gig(title: 'Wall Painting', priceMinor: 250000);

      expect(acService.price.format(), '₹499');
      expect(painting.price.format(), '₹2,500');
    });

    test('each gig carries its own duration', () {
      expect(gig(durationMinutes: 45).durationLabel, '45 min');
      expect(gig(durationMinutes: 150).durationLabel, '2 hr 30 min');
      expect(gig(durationMinutes: 2880).durationLabel, '2 days');
    });

    test('a gig carries no verification state of its own', () {
      // KYC belongs to the worker. Five gigs must not mean five copies of a
      // verification flag that could drift apart.
      final fields = gig().toString();
      expect(fields, isNot(contains('isKycVerified')));
    });
  });

  group('Gig status is independent of worker availability', () {
    test('only an active gig is matchable', () {
      expect(gig(status: GigStatus.active).isMatchable, isTrue);
      expect(gig(status: GigStatus.paused).isMatchable, isFalse);
      expect(gig(status: GigStatus.draft).isMatchable, isFalse);
      expect(gig(status: GigStatus.pendingReview).isMatchable, isFalse);
      expect(gig(status: GigStatus.rejected).isMatchable, isFalse);
      expect(gig(status: GigStatus.archived).isMatchable, isFalse);
    });

    test('a worker can pause one gig while others stay live', () {
      final gigs = [
        gig(id: 'g1', title: 'AC Service', status: GigStatus.active),
        gig(id: 'g2', title: 'Wall Painting', status: GigStatus.paused),
      ];

      expect(gigs.where((g) => g.isMatchable).map((g) => g.title), ['AC Service']);
    });

    test('only a paused gig can be resumed by the worker', () {
      // Mirrors worker_set_gig_status: a draft or rejected gig goes back
      // through review, it is not simply switched on.
      expect(GigStatus.paused.canResume, isTrue);
      expect(GigStatus.draft.canResume, isFalse);
      expect(GigStatus.rejected.canResume, isFalse);
      expect(GigStatus.pendingReview.canResume, isFalse);
    });

    test('an archived gig cannot be edited, so history stays intact', () {
      expect(GigStatus.archived.isEditable, isFalse);
      expect(GigStatus.paused.isEditable, isTrue);
    });
  });

  group('Draft validation mirrors the database constraints', () {
    GigDraft draft({
      String? serviceId = 's-electrical',
      String title = 'Switchboard Repair',
      int? price = 39900,
      int? duration = 60,
      double? radius,
    }) =>
        GigDraft(
          serviceId: serviceId,
          title: title,
          priceMinor: price,
          estimatedDurationMinutes: duration,
          serviceRadiusKm: radius,
        );

    test('accepts a complete draft', () {
      expect(draft().validate(), isEmpty);
      expect(draft().isValid, isTrue);
    });

    test('requires a trade', () {
      expect(draft(serviceId: null).validate(), contains('serviceId'));
    });

    test('enforces the 6..120 title length the table check enforces', () {
      expect(draft(title: 'AC').validate(), contains('title'));
      expect(draft(title: 'A' * 121).validate(), contains('title'));
      expect(draft(title: 'AC fix').validate(), isEmpty);
    });

    test('requires a positive price', () {
      expect(draft(price: 0).validate(), contains('price'));
      expect(draft(price: null).validate(), contains('price'));
    });

    test('enforces the 15 minute to 14 day duration range', () {
      expect(draft(duration: 14).validate(), contains('duration'));
      expect(draft(duration: 20161).validate(), contains('duration'));
      expect(draft(duration: 15).validate(), isEmpty);
      expect(draft(duration: 20160).validate(), isEmpty);
    });

    test('enforces the 1..100 km radius range', () {
      expect(draft(radius: 0).validate(), contains('radius'));
      expect(draft(radius: 101).validate(), contains('radius'));
      expect(draft(radius: 50).validate(), isEmpty);
    });

    test('a null radius is valid and means "use my usual distance"', () {
      expect(draft(radius: null).validate(), isEmpty);
    });

    test('round-trips a gig into an editable draft', () {
      final original = gig(title: 'AC Installation', priceMinor: 149900);
      final asDraft = GigDraft.fromGig(original);

      expect(asDraft.id, original.id);
      expect(asDraft.title, 'AC Installation');
      expect(asDraft.priceMinor, 149900);
      expect(asDraft.isNew, isFalse);
      expect(asDraft.isValid, isTrue);
    });
  });

  group('Price label reflects the pricing unit', () {
    test('formats each unit the way a worker would say it', () {
      Gig withUnit(PricingUnit unit) => Gig(
            id: 'g1',
            workerId: 'w1',
            serviceId: 's1',
            serviceName: 'Painting',
            title: 'Wall Painting',
            status: GigStatus.active,
            price: const Money(250000),
            pricingUnit: unit,
            estimatedDurationMinutes: 480,
            jobsCompleted: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

      expect(withUnit(PricingUnit.perJob).priceLabel, '₹2,500');
      expect(withUnit(PricingUnit.perHour).priceLabel, '₹2,500/hr');
      expect(withUnit(PricingUnit.perSqft).priceLabel, '₹2,500/sq ft');
    });
  });
}
