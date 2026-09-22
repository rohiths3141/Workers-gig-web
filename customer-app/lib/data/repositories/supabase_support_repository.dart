import '../../core/errors/result.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/support_ticket.dart';
import '../../domain/repositories/repositories.dart';
import 'supabase_repository_base.dart';

final class SupabaseSupportRepository extends SupabaseRepositoryBase
    implements SupportRepository {
  SupabaseSupportRepository(
    super.db, {
    required super.currentFirebaseUid,
  });

  @override
  Future<Result<List<SupportTicket>>> getMyTickets() =>
      guard(() async {
        final rows = await db
            .from('support_tickets')
            .select('id, ticket_code, subject, category, status, created_at, booking_id')
            .order('created_at', ascending: false);

        return (rows as List)
            .map((r) => SupportTicket.fromJson(r as Map<String, dynamic>))
            .toList();
      });

  @override
  Future<Result<SupportTicket>> createTicket({
    required String subject,
    required SupportCategory category,
    required String message,
    String? bookingId,
  }) =>
      guard(() async {
        final row = await db.rpc('customer_create_support_ticket', params: {
          'p_subject': subject,
          'p_category': category.wire,
          'p_message': message,
          if (bookingId != null) 'p_booking_id': bookingId,
        }).single();
        return SupportTicket.fromJson(row as Map<String, dynamic>);
      });

  @override
  Stream<List<SupportMessage>> watchMessages(String ticketId) {
    return db
        .from('support_messages')
        .stream(primaryKey: ['id'])
        .eq('ticket_id', ticketId)
        .order('created_at', ascending: true)
        .map((rows) => (rows as List)
            .map((r) => SupportMessage.fromJson(r as Map<String, dynamic>))
            .toList());
  }

  @override
  Future<Result<void>> postMessage(String ticketId, String body) =>
      guard(() async {
        await db.rpc('customer_post_support_message', params: {
          'p_ticket_id': ticketId,
          'p_body': body,
        });
      });
}
