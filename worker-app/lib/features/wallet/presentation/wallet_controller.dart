import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../app/providers/providers.dart';
import '../../../core/errors/result.dart';
import '../../../core/money/money.dart';
import '../../../domain/entities/wallet.dart';
import '../../../domain/repositories/repositories.dart';

final walletProvider = StreamProvider.autoDispose<Wallet>((ref) {
  return ref.watch(walletRepositoryProvider).watchWallet();
});

final transactionsProvider =
    FutureProvider.autoDispose<PagedResult<WalletTransaction>>((ref) async {
  final result = await ref.watch(walletRepositoryProvider).getTransactions();
  return result.fold((page) => page, (failure) => throw failure);
});

final earningBreakdownsProvider =
    FutureProvider.autoDispose<List<EarningBreakdown>>((ref) async {
  final result =
      await ref.watch(walletRepositoryProvider).getEarningBreakdowns();
  return result.fold((items) => items, (failure) => throw failure);
});

final payoutsProvider = FutureProvider.autoDispose<List<Payout>>((ref) async {
  final result = await ref.watch(payoutRepositoryProvider).getPayouts();
  return result.fold((items) => items, (failure) => throw failure);
});

final minimumPayoutProvider = FutureProvider.autoDispose<Money>((ref) async {
  final result = await ref.watch(payoutRepositoryProvider).getMinimumPayout();
  // A client-side floor is a convenience. When it cannot be read the server
  // still enforces the real minimum, and its refusal names the figure.
  return result.valueOrNull ?? const Money.zero();
});

/// Requesting a payout.
class PayoutController extends AutoDisposeAsyncNotifier<void> {
  static const _uuid = Uuid();

  /// Generated once per attempt and reused across retries of that attempt, so a
  /// worker tapping twice on a bad connection cannot request the money twice.
  String? _idempotencyKey;

  @override
  Future<void> build() async {}

  void beginRequest() => _idempotencyKey = _uuid.v4();

  Future<Result<Payout>> request(Money amount) async {
    final key = _idempotencyKey ??= _uuid.v4();

    state = const AsyncLoading();
    final result = await ref
        .read(payoutRepositoryProvider)
        .requestPayout(amount: amount, idempotencyKey: key);
    state = const AsyncData(null);

    result.fold((_) {
      // Only clear the key once the server accepted it: a failed attempt that
      // may have landed must keep the same key on retry.
      _idempotencyKey = null;
      ref.invalidate(walletProvider);
      ref.invalidate(payoutsProvider);
    }, (_) {});

    return result;
  }
}

final payoutControllerProvider =
    AutoDisposeAsyncNotifierProvider<PayoutController, void>(
        PayoutController.new);
