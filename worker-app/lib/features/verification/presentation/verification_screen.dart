import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/localization/l10n.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/verification.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/common_widgets.dart';
import 'verification_controller.dart';

/// The verification centre.
///
/// Every row shows the status the server holds. A check the worker has not
/// started reads "Not started"; one awaiting review reads "Being reviewed". The
/// previous application printed five hardcoded VERIFIED rows regardless of the
/// truth, which made the badge meaningless to customers and to the worker.
class VerificationScreen extends ConsumerWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final verifications = ref.watch(verificationsProvider);
    final policies = ref.watch(insurancePoliciesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.verificationTitle)),
      body: AsyncValueView<List<VerificationCase>>(
        value: verifications,
        onRetry: () => ref.invalidate(verificationsProvider),
        loading: const ListSkeleton(itemHeight: 88),
        onData: (cases) {
          final approved = cases.where((c) => c.isCurrentlyValid).length;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              AppCard(
                child: LabelledProgress(
                  label: l10n.verificationProgress,
                  value: cases.isEmpty ? 0 : approved / cases.length,
                  trailing: l10n.verificationCount(approved, cases.length),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              for (final verification in cases)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _VerificationTile(verification: verification),
                ),

              const SizedBox(height: AppSpacing.lg),
              SectionHeader(title: l10n.verificationInsurance),

              policies.when(
                loading: () => const ListSkeleton(itemCount: 1, itemHeight: 88),
                error: (error, _) => FailureView(
                  failure: asFailure(error),
                  onRetry: () => ref.invalidate(insurancePoliciesProvider),
                  compact: true,
                ),
                data: (items) {
                  // No row means no cover. The app never implies protection the
                  // platform has not actually arranged.
                  if (items.isEmpty) {
                    return AppCard(
                      child: Row(
                        children: [
                          Icon(Icons.shield_outlined,
                              size: 24, color: context.inkTertiary),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.verificationNoCover,
                                    style: AppTypography.titleMedium
                                        .copyWith(color: context.ink)),
                                const SizedBox(height: AppSpacing.xxs),
                                Text(
                                  l10n.verificationNoCoverBody,
                                  style: AppTypography.bodySmall
                                      .copyWith(color: context.inkSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      for (final policy in items)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: _PolicyTile(policy: policy),
                        ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _VerificationTile extends StatelessWidget {
  const _VerificationTile({required this.verification});

  final VerificationCase verification;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (title, description) = switch (verification.type) {
      VerificationType.identityKyc =>
        (l10n.verifyIdentity, l10n.verifyIdentityBody),
      VerificationType.address => (l10n.verifyAddress, l10n.verifyAddressBody),
      VerificationType.itiCertificate => (l10n.verifyIti, l10n.verifyItiBody),
      VerificationType.diploma => (l10n.verifyDiploma, l10n.verifyDiplomaBody),
      VerificationType.rplSkill => (l10n.verifyRpl, l10n.verifyRplBody),
      VerificationType.backgroundCheck =>
        (l10n.verifyBackground, l10n.verifyBackgroundBody),
      VerificationType.insurance =>
        (l10n.verificationInsurance, l10n.verifyInsuranceBody),
      VerificationType.bankAccount => (l10n.verifyBank, l10n.verifyBankBody),
    };

    final route = switch (verification.type) {
      VerificationType.identityKyc => Routes.kyc,
      VerificationType.itiCertificate ||
      VerificationType.diploma ||
      VerificationType.rplSkill =>
        Routes.qualification,
      VerificationType.bankAccount => Routes.bankAccount,
      _ => null,
    };

    final canAct = verification.status.needsWorkerAction &&
        verification.type.isWorkerSubmitted &&
        route != null;

    return AppCard(
      onTap: canAct ? () => context.push(route) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style:
                        AppTypography.titleMedium.copyWith(color: context.ink)),
              ),
              StatusBadge.forVerification(
                verification.isExpired
                    ? VerificationStatus.expired
                    : verification.status,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(description,
              style:
                  AppTypography.bodySmall.copyWith(color: context.inkSecondary)),

          // A rejection the worker cannot see the reason for is a rejection
          // they cannot fix.
          if (verification.rejectionReason != null) ...[
            const SizedBox(height: AppSpacing.md),
            _Note(
              text: verification.rejectionReason!,
              color: AppColors.danger,
              background: AppColors.dangerSurface,
            ),
          ],
          if (verification.infoRequested != null) ...[
            const SizedBox(height: AppSpacing.md),
            _Note(
              text: verification.infoRequested!,
              color: AppColors.warning,
              background: AppColors.warningSurface,
            ),
          ],
          if (verification.isCurrentlyValid &&
              verification.expiresAt != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.verificationValidUntil(DateFormat('d MMM yyyy', context.dateLocale)
                  .format(verification.expiresAt!)),
              style:
                  AppTypography.bodySmall.copyWith(color: context.inkTertiary),
            ),
          ],

          if (canAct) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Text(
                  verification.status == VerificationStatus.notSubmitted
                      ? l10n.verificationStart
                      : l10n.verificationUpdate,
                  style: AppTypography.label.copyWith(color: AppColors.primary),
                ),
                const Icon(Icons.chevron_right_rounded,
                    size: 20, color: AppColors.primary),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PolicyTile extends StatelessWidget {
  const _PolicyTile({required this.policy});

  final InsurancePolicy policy;

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
                child: Text(policy.providerName,
                    style:
                        AppTypography.titleMedium.copyWith(color: context.ink)),
              ),
              StatusBadge(
                label: policy.isCovering ? l10n.policyActive : l10n.policyNotActive,
                color:
                    policy.isCovering ? AppColors.success : AppColors.inkTertiary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          DetailRow(label: l10n.policyNumber, value: policy.maskedPolicyNumber),
          DetailRow(label: l10n.policyCover, value: policy.coverageAmount.format()),
          DetailRow(
            label: l10n.policyValidUntil,
            value: DateFormat('d MMM yyyy', context.dateLocale)
                .format(policy.endDate),
          ),
        ],
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({
    required this.text,
    required this.color,
    required this.background,
  });

  final String text;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(text,
          style: AppTypography.bodySmall.copyWith(color: color)),
    );
  }
}
