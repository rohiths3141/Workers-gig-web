import '../../core/errors/app_failure.dart';
import '../../core/errors/result.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/support.dart';
import '../../domain/entities/verification.dart';
import '../../domain/repositories/repositories.dart';
import '../mappers/mappers.dart';
import 'supabase_repository_base.dart';
import '../../core/localization/app_locale.dart';

/// Verification, insurance and claims.
///
/// Note what this class cannot do. There is no `approve()`, no way to set a
/// status, and no constructor path that produces an approved case. Submission
/// reaches PENDING and stops. The old application let a worker award themselves
/// VERIFIED; here the only writer of a decision is `decide_verification()`,
/// which resolves the reviewer from an admin identity and refuses a self-review
/// outright.
final class SupabaseVerificationRepository extends SupabaseRepositoryBase
    implements VerificationRepository {
  SupabaseVerificationRepository(
    super.db, {
    required super.currentFirebaseUid,
  }) : super(logger: const AppLogger('VerificationRepository'));

  static const _columns = '''
    id, type, status, details, submitted_at, reviewed_at, rejection_reason,
    info_requested, expires_at, created_at, updated_at
  ''';

  /// Types a worker sees in the verification centre, in the order they matter.
  static const _displayedTypes = [
    VerificationType.identityKyc,
    VerificationType.backgroundCheck,
    VerificationType.itiCertificate,
    VerificationType.insurance,
    VerificationType.bankAccount,
  ];

  @override
  Future<Result<List<VerificationCase>>> getVerifications() => guard(
        operation: 'getVerifications',
        () async {
          final rows = await db.from('worker_verifications').select(_columns);

          final byType = <VerificationType, VerificationCase>{
            for (final row in rows)
              VerificationType.parse(row['type'] as String?):
                  VerificationMapper.fromRow(Map<String, dynamic>.from(row)),
          };

          // Every type is returned, and one with no row is NOT_SUBMITTED —
          // never approved, and never silently omitted. A worker must be able
          // to see what they have not started.
          return _displayedTypes
              .map((type) => byType[type] ?? VerificationCase.notSubmitted(type))
              .toList(growable: false);
        },
      );

  @override
  Stream<List<VerificationCase>> watchVerifications() {
    return db
        .from('worker_verifications')
        .stream(primaryKey: ['id'])
        .asyncMap((_) async {
          final result = await getVerifications();
          return result.fold(
            (cases) => cases,
            (failure) => throw failure,
          );
        });
  }

  @override
  Future<Result<VerificationCase>> submit({
    required VerificationType type,
    Map<String, dynamic> details = const {},
  }) =>
      guard(
        operation: 'submitVerification(${type.wire})',
        () async {
          // The server requires a completed document upload for every type it
          // expects paperwork for, and refuses otherwise. Reaches PENDING.
          final row = await db.rpc<Map<String, dynamic>>(
            'worker_submit_verification',
            params: {'p_type': type.wire, 'p_details': details},
          );
          return VerificationMapper.fromRow(row);
        },
      );

  @override
  Future<Result<VerificationCase>> submitQualification(
    Qualification qualification,
  ) async {
    final errors = qualification.validate();
    if (errors.isNotEmpty) {
      return Err(ValidationFailure(
        message: errors.values.first,
        fieldErrors: errors,
      ));
    }

    return submit(
      type: qualification.type,
      details: qualification.toDetails(),
    );
  }

  @override
  Future<Result<VerificationCase>> submitBankAccount({
    required String accountHolderName,
    required String accountNumber,
    required String ifsc,
    String? bankName,
  }) =>
      guard(
        operation: 'submitBankAccount',
        () async {
          final row = await db.rpc<Map<String, dynamic>>(
            'worker_submit_bank_account',
            params: {
              'p_account_holder_name': accountHolderName,
              'p_account_number': accountNumber,
              'p_ifsc': ifsc,
              'p_bank_name': bankName,
            },
          );
          return VerificationMapper.fromRow(row);
        },
      );

  @override
  Future<Result<String?>> startDigilockerKyc() => guard(
        operation: 'startDigilockerKyc',
        () async {
          final response = await db.functions.invoke('kyc-digilocker/init');
          final body = Map<String, dynamic>.from(response.data as Map);

          if (body['error'] != null) {
            throw ServerFailure(message: body['error'] as String);
          }
          if (body['status'] == 'ALREADY_VERIFIED') return null;
          return body['url'] as String?;
        },
      );

  @override
  Future<Result<DigilockerStatus>> checkDigilockerStatus() => guard(
        operation: 'checkDigilockerStatus',
        () async {
          final response = await db.functions.invoke('kyc-digilocker/status');
          final body = Map<String, dynamic>.from(response.data as Map);

          if (body['error'] != null) {
            throw ServerFailure(message: body['error'] as String);
          }

          return switch (body['status']) {
            'APPROVED' => const DigilockerStatus(DigilockerOutcome.approved),
            'REJECTED' => DigilockerStatus(
                DigilockerOutcome.rejected,
                reason: body['reason'] as String?,
              ),
            _ => const DigilockerStatus(DigilockerOutcome.pending),
          };
        },
      );

  @override
  Future<Result<List<InsurancePolicy>>> getInsurancePolicies() => guard(
        operation: 'getInsurancePolicies',
        () async {
          final rows = await db
              .from('insurance_policies')
              .select('''
                id, provider_name, policy_number, coverage_amount_minor,
                premium_amount_minor, currency, start_date, end_date, status
              ''')
              .order('end_date', ascending: false);

          // An empty list means no policy. The UI says "no active cover"; it
          // never implies protection the platform has not arranged.
          return rows
              .map((r) =>
                  VerificationMapper.policyFromRow(Map<String, dynamic>.from(r)))
              .toList(growable: false);
        },
      );

  @override
  Future<Result<List<Claim>>> getClaims() => guard(
        operation: 'getClaims',
        () async {
          final rows = await db
              .from('claims')
              .select('''
                id, claim_code, type, status, description, amount_claimed_minor,
                amount_approved_minor, currency, info_requested, decision_note,
                rejection_reason, incident_at, created_at,
                bookings(booking_code)
              ''')
              .order('created_at', ascending: false);

          return rows
              .map((r) =>
                  VerificationMapper.claimFromRow(Map<String, dynamic>.from(r)))
              .toList(growable: false);
        },
      );

  @override
  Future<Result<void>> respondToClaim({
    required String claimId,
    required String response,
  }) =>
      guard(
        operation: 'respondToClaim',
        () async {
          if (response.trim().length < 10) {
            throw ValidationFailure(
              message: AppStrings.current.claimResponseTooShort,
            );
          }
          await db.rpc<dynamic>(
            'worker_respond_to_claim',
            params: {'p_claim_id': claimId, 'p_response': response.trim()},
          );
        },
      );
}

/// Support tickets and their threads.
final class SupabaseSupportRepository extends SupabaseRepositoryBase
    implements SupportRepository {
  SupabaseSupportRepository(
    super.db, {
    required super.currentFirebaseUid,
  }) : super(logger: const AppLogger('SupportRepository'));

  @override
  Future<Result<List<SupportTicket>>> getTickets() => guard(
        operation: 'getTickets',
        () async {
          final rows = await db
              .from('support_tickets')
              .select('''
                id, ticket_code, subject, category, status, resolution_note,
                created_at, last_message_at, bookings(booking_code)
              ''')
              .order('last_message_at', ascending: false);

          return rows
              .map((r) => SupportMapper.ticketFromRow(Map<String, dynamic>.from(r)))
              .toList(growable: false);
        },
      );

  @override
  Future<Result<List<SupportMessage>>> getMessages(String ticketId) => guard(
        operation: 'getMessages',
        () async {
          // Internal staff notes are filtered out by the RLS policy itself, not
          // by a client-side condition that could be bypassed or forgotten.
          final rows = await db
              .from('support_messages')
              .select('id, ticket_id, body, author_type, created_at')
              .eq('ticket_id', ticketId)
              .order('created_at', ascending: true);

          return rows
              .map((r) => SupportMapper.messageFromRow(Map<String, dynamic>.from(r)))
              .toList(growable: false);
        },
      );

  @override
  Stream<List<SupportMessage>> watchMessages(String ticketId) {
    return watchRows(
      table: 'support_messages',
      primaryKey: ['id'],
      filterColumn: 'ticket_id',
      filterValue: ticketId,
    ).map((rows) {
      final messages = rows
          .map((r) => SupportMapper.messageFromRow(Map<String, dynamic>.from(r)))
          .toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return messages;
    });
  }

  @override
  Future<Result<SupportTicket>> createTicket({
    required String subject,
    required SupportCategory category,
    required String message,
    String? bookingId,
  }) =>
      guard(
        operation: 'createTicket',
        () async {
          final row = await db.rpc<Map<String, dynamic>>(
            'worker_create_support_ticket',
            params: {
              'p_subject': subject.trim(),
              'p_category': category.wire,
              'p_message': message.trim(),
              'p_booking_id': bookingId,
            },
          );
          return SupportMapper.ticketFromRow(row);
        },
      );

  @override
  Future<Result<SupportMessage>> postMessage({
    required String ticketId,
    required String body,
  }) =>
      guard(
        operation: 'postSupportMessage',
        () async {
          final row = await db.rpc<Map<String, dynamic>>(
            'worker_post_support_message',
            params: {'p_ticket_id': ticketId, 'p_body': body.trim()},
          );
          return SupportMapper.messageFromRow(row);
        },
      );
}

/// The notification centre.
///
/// Backed entirely by `public.notifications`. There is no seed data, no sample
/// list, and no code path that produces a notification the server did not send.
final class SupabaseNotificationRepository extends SupabaseRepositoryBase
    implements NotificationRepository {
  SupabaseNotificationRepository(
    super.db, {
    required super.currentFirebaseUid,
  }) : super(logger: const AppLogger('NotificationRepository'));

  static const _columns =
      'id, title, body, template_key, payload, read_at, created_at';


  @override
  Future<Result<PagedResult<AppNotification>>> getNotifications({
    int limit = 20,
    int offset = 0,
  }) =>
      guard(
        operation: 'getNotifications',
        () async {
          final rows = await db
              .from('notifications')
              .select(_columns)
              .eq('channel', 'IN_APP')
              .order('created_at', ascending: false)
              .range(offset, offset + limit);

          final hasMore = rows.length > limit;
          final page = hasMore ? rows.sublist(0, limit) : rows;

          return PagedResult(
            items: page
                .map((r) => NotificationMapper.fromRow(Map<String, dynamic>.from(r)))
                .toList(growable: false),
            hasMore: hasMore,
          );
        },
      );

  @override
  Stream<List<AppNotification>> watchNotifications() {
    return watchRows(
      table: 'notifications',
      primaryKey: ['id'],
      filterColumn: 'recipient_firebase_uid',
      filterValue: uid,
    ).map((rows) {
      final items = rows
          .where((r) => r['channel'] == 'IN_APP')
          .map((r) => NotificationMapper.fromRow(Map<String, dynamic>.from(r)))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return items;
    });
  }

  @override
  Future<Result<int>> getUnreadCount() => guard(
        operation: 'getUnreadCount',
        () async {
          final rows = await db
              .from('notifications')
              .select('id')
              .eq('channel', 'IN_APP')
              .isFilter('read_at', null);
          return rows.length;
        },
      );

  @override
  Future<Result<void>> markRead(String notificationId) => guard(
        operation: 'markRead',
        () async {
          // read_at is the single column the recipient is granted update on.
          await db
              .from('notifications')
              .update({'read_at': DateTime.now().toUtc().toIso8601String()})
              .eq('id', notificationId)
              .isFilter('read_at', null);
        },
      );

  @override
  Future<Result<void>> markAllRead() => guard(
        operation: 'markAllRead',
        () async {
          await db
              .from('notifications')
              .update({'read_at': DateTime.now().toUtc().toIso8601String()})
              .eq('channel', 'IN_APP')
              .isFilter('read_at', null);
        },
      );

  @override
  Future<Result<void>> registerPushToken({
    required String token,
    required String platform,
    String? deviceLabel,
  }) =>
      guard(
        operation: 'registerPushToken',
        () async {
          // Through an RPC so the profile is resolved server-side: a device
          // cannot register a token against somebody else's account.
          await db.rpc<dynamic>(
            'worker_register_push_token',
            params: {
              'p_token': token,
              'p_platform': platform,
              'p_device_label': deviceLabel,
            },
          );
        },
      );

  @override
  Future<Result<void>> deactivatePushToken(String token) => guard(
        operation: 'deactivatePushToken',
        () async {
          // Direct, not an RPC: migration 0009 grants a worker
          // `update (is_active, last_seen_at, device_label)` on push_tokens
          // under `firebase_uid = public.firebase_uid()`, so this can only
          // ever switch off a token registered to the caller.
          //
          // Without it a sign-out left the row active, and every job alert for
          // the worker who signed out kept arriving on a phone they no longer
          // held. The `on conflict (token)` in worker_register_push_token
          // re-points the row on the next sign-in, so this closes the gap in
          // between rather than duplicating that.
          await db
              .from('push_tokens')
              .update({
                'is_active': false,
                'last_seen_at': DateTime.now().toUtc().toIso8601String(),
              })
              .eq('token', token)
              .eq('firebase_uid', uid);
        },
      );
}
