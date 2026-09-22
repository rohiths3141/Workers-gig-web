import '../../core/money/money.dart';
import 'enums.dart';

/// The worker's wallet.
///
/// Every figure here is derived server-side from the immutable ledger. The app
/// has no arithmetic that produces a balance, and no code path that writes one.
class Wallet {
  const Wallet({
    required this.id,
    required this.workerId,
    required this.balance,
    required this.totalCredited,
    required this.totalDebited,
    required this.isFrozen,
    this.pendingEarnings = const Money.zero(),
    this.frozenReason,
    this.lastTransactionAt,
  });

  final String id;
  final String workerId;

  /// Withdrawable now. Not "everything earned" — see [pendingEarnings].
  final Money balance;

  /// Earned on a completed job but still inside the cooling period, so not yet
  /// withdrawable. Shown as a separate number because presenting it as
  /// available is how a worker ends up believing they have money they cannot
  /// take out.
  final Money pendingEarnings;

  final Money totalCredited;
  final Money totalDebited;

  /// Set by trust and safety while a claim is open. Payouts are refused, and
  /// the app says so plainly rather than failing at the last step.
  final bool isFrozen;
  final String? frozenReason;

  final DateTime? lastTransactionAt;

  bool get canRequestPayout => !isFrozen && balance.isPositive;
}

/// One immutable ledger entry.
///
/// There is no update path and no delete path — for the same reason the
/// database has a trigger that rejects both. A correction is another entry.
class WalletTransaction {
  const WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    required this.description,
    required this.createdAt,
    this.referenceType,
    this.referenceId,
    this.bookingCode,
    this.serviceName,
  });

  final String id;
  final WalletTransactionType type;

  /// Signed: positive for a credit, negative for a debit. The sign comes from
  /// the database, which enforces that it matches the type.
  final Money amount;

  /// Running balance at the moment this entry was written, for reconciliation.
  final Money balanceAfter;

  final String description;

  /// 'BOOKING' | 'PAYMENT' | 'PAYOUT' | 'CLAIM' | 'MANUAL'
  final String? referenceType;
  final String? referenceId;

  /// Joined for display, so the worker sees which job paid them.
  final String? bookingCode;
  final String? serviceName;

  final DateTime createdAt;

  bool get isCredit => type.isCredit;

  /// What the worker calls this line.
  String get label => switch (type) {
        WalletTransactionType.creditJobEarning => serviceName ?? 'Job earning',
        WalletTransactionType.creditMaterialReimbursement => 'Material reimbursed',
        WalletTransactionType.creditAdjustment => 'Adjustment',
        WalletTransactionType.creditPayoutReversal => 'Payout returned',
        WalletTransactionType.debitPlatformFee => 'Platform fee',
        WalletTransactionType.debitPayout => 'Withdrawn',
        WalletTransactionType.debitAdjustment => 'Adjustment',
        WalletTransactionType.debitClaimRecovery => 'Claim recovery',
      };
}

/// A withdrawal request.
class Payout {
  const Payout({
    required this.id,
    required this.payoutCode,
    required this.amount,
    required this.status,
    required this.requestedAt,
    this.method = 'BANK_TRANSFER',
    this.accountLast4,
    this.bankName,
    this.completedAt,
    this.failureReason,
    this.decisionReason,
  });

  final String id;
  final String payoutCode;
  final Money amount;
  final PayoutStatus status;
  final String method;
  final String? accountLast4;
  final String? bankName;
  final DateTime requestedAt;
  final DateTime? completedAt;
  final String? failureReason;
  final String? decisionReason;

  /// Wording that does not overclaim. A payout is only described as paid once
  /// the money has actually moved.
  String get statusLabel => switch (status) {
        PayoutStatus.requested => 'Requested',
        PayoutStatus.processing => 'Being processed',
        PayoutStatus.completed => 'Paid',
        PayoutStatus.failed => 'Failed',
        PayoutStatus.rejected => 'Not approved',
      };
}

/// A group of ledger entries belonging to one job, so the wallet can show
/// "₹850 earned, ₹85 fee, ₹765 net" instead of three disconnected rows.
class EarningBreakdown {
  const EarningBreakdown({
    required this.bookingCode,
    required this.serviceName,
    required this.gross,
    required this.fees,
    required this.net,
    required this.at,
  });

  final String bookingCode;
  final String serviceName;

  /// What the job was worth.
  final Money gross;

  /// The sum of the fee debits that actually exist in the ledger for this job.
  /// Never a percentage computed on the client.
  final Money fees;

  /// gross - fees, as recorded.
  final Money net;

  final DateTime at;
}
