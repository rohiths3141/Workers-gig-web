import 'dart:async';

import '../../core/errors/result.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/service_request_offer.dart';
import '../../domain/repositories/repositories.dart';
import 'supabase_repository_base.dart';

final class SupabaseServiceRequestOfferRepository
    extends SupabaseRepositoryBase
    implements ServiceRequestOfferRepository {
  SupabaseServiceRequestOfferRepository(
    super.db, {
    required super.currentFirebaseUid,
  });

  static const _log = AppLogger('OfferRepo');
  static const _table = 'service_request_offers';

  @override
  Future<Result<List<ServiceRequestOffer>>> getOffersForRequest(
      String requestId) =>
      guard(() async {
        // Join worker public fields for the offer card.
        final rows = await db
            .from(_table)
            .select('''
              *,
              workers!inner(
                id, full_name, rating_avg, rating_count,
                jobs_completed, experience_years, city,
                is_kyc_verified, is_background_verified, is_insured
              ),
              worker_gigs(title)
            ''')
            .eq('service_request_id', requestId)
            .order('created_at', ascending: false);

        return (rows as List).map((r) => _parseRow(r)).toList();
      });

  @override
  Stream<List<ServiceRequestOffer>> watchOffersForRequest(String requestId) {
    final controller = StreamController<List<ServiceRequestOffer>>();

    // Seed with current data.
    getOffersForRequest(requestId).then((result) {
      result.fold(
        (offers) {
          if (!controller.isClosed) controller.add(offers);
        },
        (_) {},
      );
    });

    final subscription = db
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('service_request_id', requestId)
        .order('created_at', ascending: false)
        .listen(
          (rows) {
            try {
              final offers =
                  (rows as List).map((r) => _parseRow(r)).toList();
              if (!controller.isClosed) controller.add(offers);
            } catch (e) {
              _log.warning('watchOffers parse error',
                  {'error': e.toString()});
            }
          },
          onError: (error) {
            _log.error('watchOffers stream error', error: error);
          },
        );

    controller.onCancel = () => subscription.cancel();
    return controller.stream;
  }

  @override
  Future<Result<Booking>> acceptOffer(String offerId) =>
      guard(() async {
        final row = await db
            .rpc('customer_accept_offer', params: {
              'p_offer_id': offerId,
            })
            .single();
        final map = Map<String, dynamic>.from(row as Map);
        map.putIfAbsent('service_name', () => '');
        return Booking.fromJson(map);
      });

  @override
  Future<Result<void>> rejectOffer(String offerId) =>
      guard(() async {
        await db.rpc('customer_reject_offer', params: {
          'p_offer_id': offerId,
        });
      });

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  ServiceRequestOffer _parseRow(dynamic raw) {
    final map = Map<String, dynamic>.from(raw as Map);
    // Flatten joined worker fields.
    if (map['workers'] is Map) {
      final w = map['workers'] as Map;
      map['worker_name'] = w['full_name'];
      map['worker_rating'] = w['rating_avg'];
      map['worker_rating_count'] = w['rating_count'];
      map['worker_jobs_completed'] = w['jobs_completed'];
      map['worker_experience_years'] = w['experience_years'];
      map['worker_city'] = w['city'];
      map['is_kyc_verified'] = w['is_kyc_verified'];
      map['is_background_verified'] = w['is_background_verified'];
      map['is_insured'] = w['is_insured'];
    }
    // Flatten gig title.
    if (map['worker_gigs'] is Map) {
      map['gig_title'] = (map['worker_gigs'] as Map)['title'];
    }
    return ServiceRequestOffer.fromJson(map);
  }
}
