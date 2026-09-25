import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/money/money.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/verification.dart';
import '../../../domain/entities/wallet.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../verification/presentation/verification_controller.dart';
import 'wallet_controller.dart';

/// Requesting a withdrawal.
///
/// The request creates a payout record and nothing more. The money has not
/// moved, and this screen says so: "requested", then "being processed", and
/// only "paid" once the disbursement actually completed. Telling a worker their
/// money has been sent when it has not is the kind of thing they plan a week
/// around.
class PayoutScreen extends ConsumerStatefulWidget {
  const PayoutScreen({super.key});

  @override
  ConsumerState<PayoutScreen> createState() => _PayoutScreenState();
}

class _PayoutScreenState extends ConsumerState<PayoutScreen> {
  final _amount = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    ref.read(payoutControllerProvider.notifier).beginRequest();
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _submit(Wallet wallet, Money minimum) async {
    final l10n = context.l10n;
    final amount = Money.tryParseMajor(_amount.text);

    if (amount == null || !amount.isPositive) {
      setState(() => _error = l10n.payoutEnterAmount);
      return;
    }
    if (amount > wallet.balance) {
      setState(() => _error = l10n.payoutUpTo(wallet.balance.format()));
      return;
    }
    if (minimum.isPositive && amount < minimum) {
      setState(() => _error = l10n.payoutMinimum(minimum.format()));
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    final result =
        await ref.read(payoutControllerProvider.notifier).request(amount);

    if (!mounted) return;
    setState(() => _busy = false);

    result.fold(
      (payout) {
        Navigator.of(context).pop();
        showSuccess(
          context,
          l10n.payoutRequested(payout.amount.format()),
        );
      },
      (failure) => setState(() => _error = failure is InsufficientFundsFailure
          ? l10n.payoutUpTo(Money(failure.availableMinor).format())
          : failure.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final wallet = ref.watch(walletProvider);
    final minimum = ref.watch(minimumPayoutProvider).valueOrNull ??
        const Money.zero();
    final bankAccount = ref
        .watch(verificationsProvider)
        .valueOrNull
        ?.where((c) => c.type == VerificationType.bankAccount)
        .firstOrNull;
    final canWithdraw = bankAccount?.isCurrentlyValid ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.walletWithdraw)),
      body: AsyncValueView<Wallet>(
        value: wallet,
        onRetry: () => ref.invalidate(walletProvider),
        onData: (data) => Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.payoutAvailableNow,
                            style: AppTypography.label
                                .copyWith(color: context.inkSecondary)),
                        const SizedBox(height: AppSpacing.xs),
                        Text(data.balance.format(),
                            style: AppTypography.numericHero
                                .copyWith(color: AppColors.earnings)),
                        if (data.pendingEarnings.isPositive) ...[
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            l10n.payoutPendingMore(
                                data.pendingEarnings.format()),
                            style: AppTypography.bodySmall
                                .copyWith(color: context.inkSecondary),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  Text(l10n.payoutHowMuch,
                      style: AppTypography.titleMedium
                          .copyWith(color: context.ink)),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _amount,
                    autofocus: true,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                    ],
                    style: AppTypography.headlineLarge
                        .copyWith(color: context.ink),
                    decoration: InputDecoration(
                      prefixText: '₹ ',
                      errorText: _error,
                      errorMaxLines: 2,
                    ),
                    onChanged: (_) => setState(() => _error = null),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: [
                      for (final fraction in [0.25, 0.5, 1.0])
                        ActionChip(
                          label: Text(fraction == 1.0
                              ? l10n.payoutAll
                              : l10n.payoutPercent('${(fraction * 100).round()}')),
                          onPressed: () {
                            final part =
                                Money((data.balance.minor * fraction).round());
                            _amount.text =
                                (part.minor / 100).toStringAsFixed(2);
                            setState(() => _error = null);
                          },
                        ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),
                  _BankAccountCard(bankAccount: bankAccount),
                  const SizedBox(height: AppSpacing.md),
                  AppCard(
                    backgroundColor: context.surfaceMuted,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.schedule_rounded,
                            size: 20, color: context.inkSecondary),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            l10n.payoutProcessNotice,
                            style: AppTypography.bodySmall
                                .copyWith(color: context.inkSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.md,
                AppSpacing.screenPadding,
                AppSpacing.md + MediaQuery.of(context).padding.bottom,
              ),
              decoration: BoxDecoration(
                color: context.surface,
                border: Border(top: BorderSide(color: context.border)),
              ),
              child: SizedBox(
                height: AppSpacing.primaryActionHeight,
                child: FilledButton(
                  onPressed: _busy || !canWithdraw
                      ? null
                      : () => _submit(data, minimum),
                  child: _busy
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Text(l10n.payoutRequest),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Where the withdrawal will be paid, or what the worker must do first.
class _BankAccountCard extends StatelessWidget {
  const _BankAccountCard({required this.bankAccount});

  final VerificationCase? bankAccount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final account = bankAccount;
    final last4 = account?.details['account_last4'] as String?;
    final bankName = account?.details['bank_name'] as String?;

    final (String title, String body, bool showAction) = switch (account) {
      null => (l10n.bankChecking, '', false),
      final a when a.isCurrentlyValid => (
          l10n.bankPaidTo(last4 ?? '••••'),
          bankName ?? l10n.bankVerifiedFallback,
          false,
        ),
      final a when a.status == VerificationStatus.pending ||
          a.status == VerificationStatus.underReview =>
        (
          l10n.bankBeingVerified,
          l10n.bankBeingVerifiedBody,
          false,
        ),
      final a when a.status == VerificationStatus.rejected => (
          l10n.bankNotVerified,
          a.rejectionReason ?? l10n.bankNotVerifiedBody,
          true,
        ),
      _ => (
          l10n.bankAddTitle,
          l10n.bankAddBody,
          true,
        ),
    };

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.account_balance_outlined,
              size: 20, color: context.inkSecondary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTypography.titleMedium.copyWith(color: context.ink)),
                if (body.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(body,
                      style: AppTypography.bodySmall
                          .copyWith(color: context.inkSecondary)),
                ],
                if (showAction) ...[
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(
                    onPressed: () => context.push(Routes.bankAccount),
                    child: Text(l10n.bankAddAction),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
