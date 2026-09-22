import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/wallet.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/common_widgets.dart';
import 'wallet_controller.dart';

/// The wallet.
///
/// Three numbers, deliberately kept apart: what can be withdrawn now, what has
/// been earned but is still in its cooling period, and what has been earned in
/// total. Collapsing them into one "balance" is how a worker ends up believing
/// they have money they cannot take out, and then being refused at the till.
class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider);
    final breakdowns = ref.watch(earningBreakdownsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        actions: [
          IconButton(
            onPressed: () => context.push(Routes.transactions),
            icon: const Icon(Icons.receipt_long_outlined),
            tooltip: 'All transactions',
          ),
        ],
      ),
      body: AsyncValueView<Wallet>(
        value: wallet,
        onRetry: () => ref.invalidate(walletProvider),
        loading: const ListSkeleton(itemHeight: 120),
        onData: (data) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(walletProvider);
            ref.invalidate(earningBreakdownsProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              _BalanceCard(wallet: data),
              const SizedBox(height: AppSpacing.lg),

              if (data.isFrozen)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: AppCard(
                    backgroundColor: AppColors.warningSurface,
                    borderColor: AppColors.warning.withValues(alpha: 0.3),
                    child: Row(
                      children: [
                        const Icon(Icons.lock_outline_rounded,
                            color: AppColors.warning),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            data.frozenReason ??
                                'Withdrawals are on hold while we look into something. Contact support for details.',
                            style: AppTypography.bodyMedium
                                .copyWith(color: AppColors.warning),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              SizedBox(
                height: AppSpacing.primaryActionHeight,
                child: FilledButton.icon(
                  onPressed: data.canRequestPayout
                      ? () => context.push(Routes.payout)
                      : null,
                  icon: const Icon(Icons.arrow_outward_rounded),
                  label: const Text('Withdraw'),
                ),
              ),
              // A greyed-out Withdraw with nothing beside it left the worker
              // guessing why. The frozen case has its own card above.
              if (!data.canRequestPayout && !data.isFrozen) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  data.pendingEarnings.isPositive
                      ? 'Nothing to withdraw yet. ${data.pendingEarnings.format()} '
                          'is still being processed and moves to your balance '
                          'once those jobs are approved.'
                      : 'Nothing to withdraw yet. Your earnings appear here '
                          'once a customer approves a finished job.',
                  style: AppTypography.bodySmall
                      .copyWith(color: context.inkSecondary),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),

              SectionHeader(
                title: 'Recent earnings',
                actionLabel: 'See all',
                action: () => context.push(Routes.transactions),
              ),

              breakdowns.when(
                loading: () => const ListSkeleton(itemCount: 2, itemHeight: 90),
                error: (error, _) => FailureView(
                  failure: asFailure(error),
                  onRetry: () => ref.invalidate(earningBreakdownsProvider),
                  compact: true,
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return const EmptyStateView(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'No earnings yet',
                      message:
                          'Your earnings will appear here once a completed job has been paid for.',
                    );
                  }

                  return Column(
                    children: [
                      for (final item in items)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: _EarningCard(breakdown: item),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.wallet});

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Available to withdraw',
              style: AppTypography.label.copyWith(color: context.inkSecondary)),
          const SizedBox(height: AppSpacing.xs),
          Text(wallet.balance.format(),
              style:
                  AppTypography.numericHero.copyWith(color: AppColors.earnings)),
          const SizedBox(height: AppSpacing.lg),
          const Divider(),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Stat(
                  label: 'Being processed',
                  value: wallet.pendingEarnings.format(),
                  // Named precisely: this money exists and is the worker's, it
                  // simply is not withdrawable yet.
                  hint: 'Released after the holding period',
                ),
              ),
              Expanded(
                child: _Stat(
                  label: 'Earned in total',
                  value: wallet.totalCredited.format(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, this.hint});

  final String label;
  final String value;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTypography.bodySmall.copyWith(color: context.inkTertiary)),
        const SizedBox(height: AppSpacing.xxs),
        Text(value, style: AppTypography.amount.copyWith(color: context.ink)),
        if (hint != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(hint!,
              style: AppTypography.bodySmall
                  .copyWith(color: context.inkTertiary, fontSize: 12)),
        ],
      ],
    );
  }
}

/// One job's money, as the ledger holds it.
///
/// Gross, fee and net on three lines. The fee is the debit row that exists —
/// never a percentage this screen worked out for itself, which is how a display
/// ends up disagreeing with the accounts.
class _EarningCard extends StatelessWidget {
  const _EarningCard({required this.breakdown});

  final EarningBreakdown breakdown;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(breakdown.serviceName,
                    style:
                        AppTypography.titleMedium.copyWith(color: context.ink)),
              ),
              Text(DateFormat('d MMM').format(breakdown.at),
                  style: AppTypography.bodySmall
                      .copyWith(color: context.inkTertiary)),
            ],
          ),
          Text(breakdown.bookingCode,
              style:
                  AppTypography.bodySmall.copyWith(color: context.inkTertiary)),
          const SizedBox(height: AppSpacing.md),
          _Line(label: 'Job amount', value: breakdown.gross.format()),
          if (breakdown.fees.isPositive)
            _Line(
              label: 'Platform fee',
              value: '-${breakdown.fees.format()}',
              color: context.inkSecondary,
            ),
          const Divider(height: AppSpacing.xl),
          _Line(
            label: 'You earned',
            value: breakdown.net.format(),
            color: AppColors.earnings,
            emphasise: true,
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({
    required this.label,
    required this.value,
    this.color,
    this.emphasise = false,
  });

  final String label;
  final String value;
  final Color? color;
  final bool emphasise;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Row(
        children: [
          Text(label,
              style: (emphasise ? AppTypography.label : AppTypography.bodyMedium)
                  .copyWith(color: color ?? context.inkSecondary)),
          const Spacer(),
          Text(value,
              style:
                  (emphasise ? AppTypography.amountLarge : AppTypography.amount)
                      .copyWith(color: color ?? context.ink)),
        ],
      ),
    );
  }
}
