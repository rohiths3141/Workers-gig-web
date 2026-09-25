import '../../core/errors/app_failure.dart';
import '../../core/errors/result.dart';
import '../../core/logging/app_logger.dart';
import '../../core/money/money.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/repositories/repositories.dart';
import '../mappers/mappers.dart';
import 'supabase_repository_base.dart';
import '../../core/localization/app_locale.dart';

/// The wallet and its ledger.
///
/// Read-only by construction. `wallets.balance_minor` is recomputed by a
/// database trigger from `wallet_transactions`, the ledger rejects UPDATE and
/// DELETE outright, and no grant exists that would let this client write
/// either. The only money operation the app can perform is asking for a payout,
/// which lives in [SupabasePayoutRepository].
final class SupabaseWalletRepository extends SupabaseRepositoryBase
    implements WalletRepository {
  SupabaseWalletRepository(
    super.db, {
    required super.currentFirebaseUid,
  }) : super(logger: const AppLogger('WalletRepository'));

  static const _walletColumns = '''
    id, worker_id, balance_minor, total_credited_minor, total_debited_minor,
    currency, is_frozen, frozen_reason, last_transaction_at
  ''';

  static const _txColumns = '''
    id, type, amount_minor, balance_after_minor, currency, description,
    reference_type, reference_id, created_at
  ''';


  @override
  Future<Result<Wallet>> getWallet() => guard(
        operation: 'getWallet',
        () async {
          final row =
              await db.from('wallets').select(_walletColumns).maybeSingle();

          if (row == null) {
            // A wallet is created by trigger when the worker row is inserted.
            // Its absence is a real problem, not something to paper over with a
            // zero balance — a fabricated zero would tell a worker they have
            // no money when the truth is unknown.
            throw NotFoundFailure(
              message: AppStrings.current.walletLoadFailedRetry,
            );
          }

          final pending = await _pendingEarnings(
            row['currency'] as String? ?? 'INR',
          );

          return WalletMapper.fromRow(row, pendingEarnings: pending);
        },
      );

  /// Earned on a finished job but still inside the cooling period.
  ///
  /// Computed from the ledger against `payout.cooling_period_hours`, so what
  /// the worker sees as "pending" is the same set of rows the payout rules will
  /// treat as not yet withdrawable.
  Future<Money> _pendingEarnings(String currency) async {
    final hours = await readSetting<int>(
          'payout.cooling_period_hours',
          (v) => parseIntOr(v, 24),
        ) ??
        24;

    final cutoff = DateTime.now().toUtc().subtract(Duration(hours: hours));

    final rows = await db
        .from('wallet_transactions')
        .select('amount_minor')
        .eq('type', 'CREDIT_JOB_EARNING')
        .gte('created_at', cutoff.toIso8601String());

    var total = 0;
    for (final row in rows) {
      total += parseMinor(row['amount_minor']) ?? 0;
    }
    return Money(total, currency: currency);
  }

  @override
  Stream<Wallet> watchWallet() async* {
    // worker_id on wallets is the workers.id UUID, not the Firebase UID.
    final workerId = await resolveWorkerId();

    // The Realtime JWT can lag the HTTP session by a few seconds on startup.
    // Try once; if the subscription errors immediately (RLS rejection before
    // the token propagates), wait 2 s and try a second time.  A second error
    // surfaces normally — it is a genuine failure, not a startup race.
    Stream<Wallet> makeStream() => watchRows(
          table: 'wallets',
          primaryKey: ['id'],
          filterColumn: 'worker_id',
          filterValue: workerId,
        ).asyncMap((rows) async {
          if (rows.isEmpty) {
            throw NotFoundFailure(
                message: AppStrings.current.walletLoadFailed);
          }
          final row = rows.first;
          final pending =
              await _pendingEarnings(row['currency'] as String? ?? 'INR');
          return WalletMapper.fromRow(row, pendingEarnings: pending);
        });

    // First attempt — swallow the very first error to allow a retry.
    var firstErrorSeen = false;
    try {
      await for (final event in makeStream()) {
        yield event;
      }
      return; // stream closed cleanly
    } catch (_) {
      firstErrorSeen = true;
    }

    if (firstErrorSeen) {
      // Brief pause so the Realtime auth token has time to propagate.
      await Future<void>.delayed(const Duration(seconds: 2));
      // Second attempt — errors flow through normally.
      yield* makeStream();
    }
  }

  @override
  Future<Result<PagedResult<WalletTransaction>>> getTransactions({
    int limit = 20,
    int offset = 0,
  }) =>
      guard(
        operation: 'getTransactions',
        () async {
          // reference_id is polymorphic (booking, payout, claim...) and has no
          // foreign key, so PostgREST cannot embed bookings through it — the
          // embed failed with PGRST200 and the whole statement errored. The
          // booking details are fetched separately for BOOKING rows instead.
          final rows = await db
              .from('wallet_transactions')
              .select(_txColumns)
              .order('created_at', ascending: false)
              .range(offset, offset + limit);

          final hasMore = rows.length > limit;
          final page = (hasMore ? rows.sublist(0, limit) : rows)
              .map((r) => Map<String, dynamic>.from(r))
              .toList();

          final bookingIds = page
              .where((r) => r['reference_type'] == 'BOOKING' && r['reference_id'] != null)
              .map((r) => r['reference_id'] as String)
              .toSet()
              .toList();
          if (bookingIds.isNotEmpty) {
            final bookings = await db
                .from('bookings')
                .select('id, booking_code, services(name)')
                .inFilter('id', bookingIds);
            final byId = {for (final b in bookings) b['id'] as String: b};
            for (final r in page) {
              final booking = byId[r['reference_id']];
              if (r['reference_type'] == 'BOOKING' && booking != null) {
                r['bookings'] = booking;
              }
            }
          }

          return PagedResult(
            items: page
                .map(WalletMapper.transactionFromRow)
                .toList(growable: false),
            hasMore: hasMore,
          );
        },
      );

  @override
  Future<Result<List<EarningBreakdown>>> getEarningBreakdowns({
    int limit = 20,
    int offset = 0,
  }) =>
      guard(
        operation: 'getEarningBreakdowns',
        () async {
          // Grouped in the database so the fee shown beside an earning is the
          // fee row that actually exists. The client never derives a fee from a
          // percentage — if the ledger holds no fee line, none is displayed.
          final rows = await db.rpc<List<dynamic>>(
            'worker_earning_breakdowns',
            params: {'p_limit': limit, 'p_offset': offset},
          );

          return rows.whereType<Map>().map((raw) {
            final json = Map<String, dynamic>.from(raw);
            final currency = json['currency'] as String? ?? 'INR';
            return EarningBreakdown(
              bookingCode: json['booking_code'] as String? ?? '',
              serviceName: json['service_name'] as String? ?? 'Job',
              gross: parseMoneyOrZero(json['gross_minor'], currency: currency),
              fees: parseMoneyOrZero(json['fees_minor'], currency: currency),
              net: parseMoneyOrZero(json['net_minor'], currency: currency),
              at: parseDate(json['at']) ?? DateTime.now(),
            );
          }).toList(growable: false);
        },
      );
}

/// Payout requests.
final class SupabasePayoutRepository extends SupabaseRepositoryBase
    implements PayoutRepository {
  SupabasePayoutRepository(
    super.db, {
    required super.currentFirebaseUid,
  }) : super(logger: const AppLogger('PayoutRepository'));

  static const _columns = '''
    id, payout_code, amount_minor, currency, status, method, account_last4,
    bank_name, requested_at, completed_at, failure_reason, decision_reason
  ''';

  @override
  Future<Result<List<Payout>>> getPayouts({int limit = 20, int offset = 0}) =>
      guard(
        operation: 'getPayouts',
        () async {
          final rows = await db
              .from('payouts')
              .select(_columns)
              .order('requested_at', ascending: false)
              .range(offset, offset + limit - 1);

          return rows
              .map((r) => WalletMapper.payoutFromRow(Map<String, dynamic>.from(r)))
              .toList(growable: false);
        },
      );

  @override
  Future<Result<Payout>> requestPayout({
    required Money amount,
    required String idempotencyKey,
  }) =>
      guard(
        operation: 'requestPayout',
        () async {
          // The key makes a double tap safe: the server returns the existing
          // payout rather than creating a second one. A worker on a flaky
          // connection retrying is the normal case, not the exception.
          final row = await db.rpc<Map<String, dynamic>>(
            'request_payout',
            params: {
              'p_amount_minor': amount.minor,
              'p_idempotency_key': idempotencyKey,
            },
          );

          return WalletMapper.payoutFromRow(row);
        },
      );

  @override
  Future<Result<Money>> getMinimumPayout() => guard(
        operation: 'getMinimumPayout',
        () async {
          final minor = await readSetting<int>(
            'payout.minimum_amount_minor',
            (v) => parseIntOr(v, 0),
          );
          // The setting is not public to clients, so a null here is expected.
          // Zero means "no client-side floor"; the server still enforces the
          // real minimum and its refusal names the actual figure.
          return Money(minor ?? 0);
        },
      );
}
