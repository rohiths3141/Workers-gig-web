import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/localization/l10n.dart';
import '../../../domain/entities/wallet.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../../shared/widgets/service_names.dart';
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
    final l10n = context.l10n;
    final wallet = ref.watch(walletProvider);
    final breakdowns = ref.watch(earningBreakdownsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navWallet),
        actions: [
          IconButton(
            onPressed: () => context.push(Routes.transactions),
            icon: const Icon(Icons.receipt_long_outlined),
            tooltip: l10n.walletAllTransactions,
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
                            data.frozenReason ?? l10n.walletFrozen,
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
                  label: Text(l10n.walletWithdraw),
                ),
              ),
              // A greyed-out Withdraw with nothing beside it left the worker
              // guessing why. The frozen case has its own card above.
              if (!data.canRequestPayout && !data.isFrozen) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  data.pendingEarnings.isPositive
                      ? l10n.walletNothingPending(data.pendingEarnings.format())
                      : l10n.walletNothingYet,
                  style: AppTypography.bodySmall
                      .copyWith(color: context.inkSecondary),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),

              SectionHeader(
                title: l10n.walletRecentEarnings,
                actionLabel: l10n.commonSeeAll,
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
                    return EmptyStateView(
                      icon: Icons.account_balance_wallet_outlined,
                      title: l10n.walletNoEarnings,
                      message: l10n.walletNoEarningsBody,
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
    final l10n = context.l10n;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.walletAvailable,
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
                  label: l10n.walletProcessing,
                  value: wallet.pendingEarnings.format(),
                  // Named precisely: this money exists and is the worker's, it
                  // simply is not withdrawable yet.
                  hint: l10n.walletProcessingHint,
                ),
              ),
              Expanded(
                child: _Stat(
                  label: l10n.walletTotalEarned,
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
    final l10n = context.l10n;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(localizedServiceName(l10n, breakdown.serviceName),
                    style:
                        AppTypography.titleMedium.copyWith(color: context.ink)),
              ),
              Text(DateFormat('d MMM', context.dateLocale).format(breakdown.at),
                  style: AppTypography.bodySmall
                      .copyWith(color: context.inkTertiary)),
            ],
          ),
          Text(breakdown.bookingCode,
              style:
                  AppTypography.bodySmall.copyWith(color: context.inkTertiary)),
          const SizedBox(height: AppSpacing.md),
          _Line(label: l10n.jobAmount, value: breakdown.gross.format()),
          if (breakdown.fees.isPositive)
            _Line(
              label: l10n.walletTxPlatformFee,
              value: '-${breakdown.fees.format()}',
              color: context.inkSecondary,
            ),
          const Divider(height: AppSpacing.xl),
          _Line(
            label: l10n.jobYouEarned,
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
