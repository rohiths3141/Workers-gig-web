import '../../core/errors/result.dart';
import '../../domain/entities/worker_offer.dart';
import '../../domain/repositories/repositories.dart';
import 'supabase_repository_base.dart';

final class SupabaseWorkerOfferRepository extends SupabaseRepositoryBase
    implements WorkerOfferRepository {
  SupabaseWorkerOfferRepository(
    super.db, {
    required super.currentFirebaseUid,
  });

  @override
  Future<Result<WorkerOffer>> submitOffer({
    required String serviceRequestId,
    required int quotedAmountMinor,
    String? estimatedDuration,
    String? message,
    String? gigId,
  }) =>
      guard(
        () async {
          final row = await db
              .rpc('worker_submit_offer', params: {
                'p_service_request_id': serviceRequestId,
                'p_quoted_amount_minor': quotedAmountMinor,
                if (estimatedDuration != null)
                  'p_estimated_duration': estimatedDuration,
                if (message != null) 'p_message': message,
                if (gigId != null) 'p_gig_id': gigId,
              })
              .single();
          return WorkerOffer.fromJson(Map<String, dynamic>.from(row as Map));
        },
        operation: 'submitOffer',
      );

  @override
  Future<Result<List<WorkerOffer>>> getMyOffers() => guard(
        () async {
          final workerId = await resolveWorkerId();
          final rows = await db
              .from('service_request_offers')
              .select('''
                *,
                customer_service_requests!service_request_offers_service_request_id_fkey!inner(title, request_code)
              ''')
              .eq('worker_id', workerId)
              .order('created_at', ascending: false);

          return (rows as List).map((r) {
            final map = Map<String, dynamic>.from(r as Map);
            if (map['customer_service_requests'] is Map) {
              final req = map['customer_service_requests'] as Map;
              map['request_title'] = req['title'];
              map['request_code'] = req['request_code'];
            }
            return WorkerOffer.fromJson(map);
          }).toList();
        },
        operation: 'getMyOffers',
      );

  @override
  Future<Result<List<WorkerOffer>>> getOffersForRequest(String requestId) =>
      guard(
        () async {
          final workerId = await resolveWorkerId();
          final rows = await db
              .from('service_request_offers')
              .select()
              .eq('service_request_id', requestId)
              .eq('worker_id', workerId)
              .order('created_at', ascending: false);

          return (rows as List)
              .map((r) =>
                  WorkerOffer.fromJson(Map<String, dynamic>.from(r as Map)))
              .toList();
        },
        operation: 'getOffersForRequest',
      );

  @override
  Future<Result<void>> withdrawOffer(String offerId) => guard(
        () async {
          await db.rpc('worker_withdraw_offer', params: {
            'p_offer_id': offerId,
          });
        },
        operation: 'withdrawOffer',
      );
}
