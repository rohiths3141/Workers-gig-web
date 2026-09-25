import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/localization/l10n.dart';
import '../../../domain/entities/wallet.dart';
import '../../../domain/repositories/repositories.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/common_widgets.dart';
import 'wallet_controller.dart';

/// The ledger, and payout history.
///
/// Every line is an immutable entry with the running balance the database
/// recorded at the time. Nothing here is computed on the device, so a
/// reconciliation against the platform's books can never disagree with what the
/// worker was shown.
class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statementTitle),
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: l10n.statementTabTransactions),
            Tab(text: l10n.statementTabWithdrawals),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [_TransactionList(), _PayoutList()],
      ),
    );
  }
}

class _TransactionList extends ConsumerWidget {
  const _TransactionList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);

    return AsyncValueView<PagedResult<WalletTransaction>>(
      value: transactions,
      onRetry: () => ref.invalidate(transactionsProvider),
      loading: const ListSkeleton(itemHeight: 72),
      onData: (page) {
        if (page.items.isEmpty) {
          return EmptyStateView(
            icon: Icons.receipt_long_outlined,
            title: context.l10n.statementEmpty,
            message: context.l10n.statementEmptyBody,
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          itemCount: page.items.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (_, index) => _TransactionTile(item: page.items[index]),
        );
      },
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.item});

  final WalletTransaction item;

  @override
  Widget build(BuildContext context) {
    final isCredit = item.isCredit;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (isCredit ? AppColors.earnings : AppColors.inkTertiary)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              isCredit
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              size: 20,
              color: isCredit ? AppColors.earnings : AppColors.inkTertiary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.label,
                    style:
                        AppTypography.titleMedium.copyWith(color: context.ink)),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  [
                    if (item.bookingCode != null) item.bookingCode!,
                    DateFormat('d MMM, h:mm a', context.dateLocale)
                        .format(item.createdAt),
                  ].join(' · '),
                  style: AppTypography.bodySmall
                      .copyWith(color: context.inkTertiary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.amount.format(showSign: true),
                style: AppTypography.amount.copyWith(
                  color: isCredit ? AppColors.earnings : context.ink,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                  context.l10n
                      .statementBalance(item.balanceAfter.formatCompact()),
                  style: AppTypography.bodySmall
                      .copyWith(color: context.inkTertiary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PayoutList extends ConsumerWidget {
  const _PayoutList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payouts = ref.watch(payoutsProvider);

    return AsyncValueView<List<Payout>>(
      value: payouts,
      onRetry: () => ref.invalidate(payoutsProvider),
      loading: const ListSkeleton(itemHeight: 80),
      onData: (items) {
        if (items.isEmpty) {
          return EmptyStateView(
            icon: Icons.arrow_outward_rounded,
            title: context.l10n.statementNoWithdrawals,
            message: context.l10n.statementNoWithdrawalsBody,
          );
        }

        final l10n = context.l10n;
        final dateFormat = DateFormat('d MMM, h:mm a', context.dateLocale);
        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (_, index) {
            final payout = items[index];

            final color = switch (payout.status.name) {
              'completed' => AppColors.success,
              'failed' || 'rejected' => AppColors.danger,
              _ => AppColors.info,
            };

            return AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Says "Paid" only when the money has genuinely left the
                      // platform. Everything earlier says what it really is.
                      StatusBadge(
                        label: payout.statusLabel.toUpperCase(),
                        color: color,
                      ),
                      const Spacer(),
                      Text(payout.amount.format(),
                          style: AppTypography.amountLarge
                              .copyWith(color: context.ink)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.payoutRequestedAt(
                        dateFormat.format(payout.requestedAt)),
                    style: AppTypography.bodySmall
                        .copyWith(color: context.inkSecondary),
                  ),
                  if (payout.completedAt != null)
                    Text(
                      l10n.payoutPaidAt(
                          dateFormat.format(payout.completedAt!)),
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.success),
                    ),
                  if (payout.failureReason != null ||
                      payout.decisionReason != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      payout.failureReason ?? payout.decisionReason!,
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.danger),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}
