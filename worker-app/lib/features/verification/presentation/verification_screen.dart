import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
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
    final verifications = ref.watch(verificationsProvider);
    final policies = ref.watch(insurancePoliciesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Verification')),
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
                  label: 'Verified checks',
                  value: cases.isEmpty ? 0 : approved / cases.length,
                  trailing: '$approved of ${cases.length}',
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              for (final verification in cases)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _VerificationTile(verification: verification),
                ),

              const SizedBox(height: AppSpacing.lg),
              const SectionHeader(title: 'Insurance'),

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
                                Text('No active cover',
                                    style: AppTypography.titleMedium
                                        .copyWith(color: context.ink)),
                                const SizedBox(height: AppSpacing.xxs),
                                Text(
                                  'You do not currently have an insurance policy on file with us.',
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
    final (title, description) = switch (verification.type) {
      VerificationType.identityKyc => (
          'Identity',
          'A government ID so customers know who is coming to their home.',
        ),
      VerificationType.address => ('Address', 'Proof of where you live.'),
      VerificationType.itiCertificate => (
          'ITI certificate',
          'Your trade certificate from an Industrial Training Institute.',
        ),
      VerificationType.diploma => ('Diploma', 'A recognised technical diploma.'),
      VerificationType.rplSkill => (
          'Skill assessment',
          'Recognition of Prior Learning: your experience assessed and certified.',
        ),
      VerificationType.backgroundCheck => (
          'Background check',
          'We run this ourselves. You do not need to do anything.',
        ),
      VerificationType.insurance => (
          'Insurance',
          'Cover for accidental damage while you work. Our team adds your policy once it is arranged.',
        ),
      VerificationType.bankAccount => (
          'Bank account',
          'Where your withdrawals are paid.',
        ),
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
              'Valid until ${DateFormat('d MMM yyyy').format(verification.expiresAt!)}',
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
                      ? 'Start'
                      : 'Update',
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
                label: policy.isCovering ? 'ACTIVE' : 'NOT ACTIVE',
                color:
                    policy.isCovering ? AppColors.success : AppColors.inkTertiary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          DetailRow(label: 'Policy', value: policy.maskedPolicyNumber),
          DetailRow(label: 'Cover', value: policy.coverageAmount.format()),
          DetailRow(
            label: 'Valid until',
            value: DateFormat('d MMM yyyy').format(policy.endDate),
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
