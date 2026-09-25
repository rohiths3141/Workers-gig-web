import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/localization/l10n.dart';
import '../../../../core/money/money.dart';
import '../../../../domain/entities/enums.dart';
import '../../../../domain/entities/job.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../evidence/presentation/evidence_controller.dart';
import '../../../evidence/presentation/evidence_section.dart';
import '../jobs_controller.dart';

/// Materials for the current job.
///
/// The worker asks; the customer decides. There is no control anywhere on this
/// screen that marks a material approved, because approval is not the worker's
/// to give — the server would refuse it and, more importantly, it would be
/// wrong. Status here is always the customer's real answer.
class MaterialsSection extends ConsumerWidget {
  const MaterialsSection({required this.bookingId, super.key});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final materials = ref.watch(materialsProvider(bookingId));

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(l10n.jobMaterials,
                    style:
                        AppTypography.titleMedium.copyWith(color: context.ink)),
              ),
              TextButton.icon(
                onPressed: () => _requestMaterial(context, ref),
                icon: const Icon(Icons.add_rounded, size: 20),
                label: Text(l10n.materialsAdd),
              ),
            ],
          ),

          materials.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            error: (error, _) => Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Text(
                l10n.materialsLoadFailed,
                style: AppTypography.bodySmall.copyWith(color: AppColors.danger),
              ),
            ),
            data: (items) {
              if (items.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Text(
                    l10n.materialsEmpty,
                    style: AppTypography.bodySmall
                        .copyWith(color: context.inkSecondary),
                  ),
                );
              }

              return Column(
                children: [
                  const SizedBox(height: AppSpacing.sm),
                  for (final material in items)
                    _MaterialTile(
                      material: material,
                      onRecordCost: () =>
                          _recordCost(context, ref, material),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _requestMaterial(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: _MaterialRequestSheet(bookingId: bookingId),
      ),
    );
  }

  Future<void> _recordCost(
    BuildContext context,
    WidgetRef ref,
    MaterialRequest material,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: _RecordCostSheet(material: material, bookingId: bookingId),
      ),
    );
  }
}

class _MaterialTile extends StatelessWidget {
  const _MaterialTile({required this.material, required this.onRecordCost});

  final MaterialRequest material;
  final VoidCallback onRecordCost;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (label, color) = switch (material.status) {
      MaterialStatus.requested ||
      MaterialStatus.customerReview =>
        (l10n.materialStatusWaiting, AppColors.warning),
      MaterialStatus.approved => (l10n.materialStatusApproved, AppColors.success),
      MaterialStatus.rejected => (l10n.materialStatusDeclined, AppColors.danger),
      MaterialStatus.purchased => (l10n.materialStatusBought, AppColors.info),
      MaterialStatus.costRecorded =>
        (l10n.materialStatusCostRecorded, AppColors.info),
      MaterialStatus.billed => (l10n.materialStatusBilled, AppColors.success),
      MaterialStatus.cancelled =>
        (l10n.materialStatusCancelled, AppColors.inkTertiary),
    };
    final quantity = material.quantity
        .toStringAsFixed(material.quantity % 1 == 0 ? 0 : 2);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(material.name,
                    style:
                        AppTypography.titleMedium.copyWith(color: context.ink)),
              ),
              Text(
                (material.actualCost ?? material.estimatedCost).format(),
                style: AppTypography.amount.copyWith(color: context.ink),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            material.actualCost == null
                ? l10n.materialQuantityEstimated(quantity, material.unit)
                : l10n.materialQuantityActual(quantity, material.unit),
            style: AppTypography.bodySmall.copyWith(color: context.inkSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              StatusBadge(label: label, color: color),
              const Spacer(),
              if (material.status.canRecordCost && material.actualCost == null)
                TextButton(
                  onPressed: onRecordCost,
                  child: Text(l10n.materialRecordCost),
                ),
            ],
          ),
          if (material.customerRejectionReason != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.materialCustomerSaid(material.customerRejectionReason!),
              style: AppTypography.bodySmall.copyWith(color: AppColors.danger),
            ),
          ],
        ],
      ),
    );
  }
}

class _MaterialRequestSheet extends ConsumerStatefulWidget {
  const _MaterialRequestSheet({required this.bookingId});

  final String bookingId;

  @override
  ConsumerState<_MaterialRequestSheet> createState() =>
      _MaterialRequestSheetState();
}

class _MaterialRequestSheetState extends ConsumerState<_MaterialRequestSheet> {
  final _name = TextEditingController();
  final _quantity = TextEditingController(text: '1');
  // Late so the default unit is read in the language on screen, on first
  // build.
  late final _unit =
      TextEditingController(text: context.l10n.materialUnitPiece);
  final _cost = TextEditingController();
  Map<String, String> _errors = const {};
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _quantity.dispose();
    _unit.dispose();
    _cost.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final errors = <String, String>{};

    if (_name.text.trim().length < 2) {
      errors['name'] = context.l10n.materialWhatNeeded;
    }

    final quantity = double.tryParse(_quantity.text.trim());
    if (quantity == null || quantity <= 0) {
      errors['quantity'] = context.l10n.materialEnterQuantity;
    }

    // Parsed through Money so the paise are exact. A double here would be the
    // one place in the app where a rounding error could reach the invoice.
    final cost = Money.tryParseMajor(_cost.text);
    if (cost == null || !cost.isPositive) {
      errors['cost'] = context.l10n.materialEnterCost;
    }

    if (errors.isNotEmpty) {
      setState(() => _errors = errors);
      return;
    }

    setState(() {
      _busy = true;
      _errors = const {};
    });

    final result = await ref.read(materialActionsProvider.notifier).request(
          bookingId: widget.bookingId,
          name: _name.text,
          quantity: quantity!,
          unit: _unit.text,
          estimatedCostMinor: cost!.minor,
        );

    if (!mounted) return;
    setState(() => _busy = false);

    result.fold(
      (_) {
        Navigator.of(context).pop();
        showSuccess(context, context.l10n.jobSentForApproval);
      },
      (failure) => showFailure(context, failure.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.materialWhatNeeded,
                style:
                    AppTypography.headlineMedium.copyWith(color: context.ink)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.materialRequestBody,
              style:
                  AppTypography.bodyMedium.copyWith(color: context.inkSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            TextField(
              controller: _name,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.materialName,
                hintText: l10n.materialNameHint,
                errorText: _errors['name'],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _quantity,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: l10n.materialQuantity,
                      errorText: _errors['quantity'],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextField(
                    controller: _unit,
                    decoration: InputDecoration(labelText: l10n.materialUnit),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _cost,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
              ],
              decoration: InputDecoration(
                labelText: l10n.materialExpectedCost,
                prefixText: '₹ ',
                errorText: _errors['cost'],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: _busy ? null : _submit,
              child: _busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Text(l10n.materialAskCustomer),
            ),
          ],
        ),
      ),
    );
  }
}

/// Recording what a material actually cost.
///
/// Requires a receipt: the server refuses without one, because an unevidenced
/// cost is an unrecoverable cost and the worker is the one who loses.
class _RecordCostSheet extends ConsumerStatefulWidget {
  const _RecordCostSheet({required this.material, required this.bookingId});

  final MaterialRequest material;
  final String bookingId;

  @override
  ConsumerState<_RecordCostSheet> createState() => _RecordCostSheetState();
}

class _RecordCostSheetState extends ConsumerState<_RecordCostSheet> {
  late final _cost =
      TextEditingController(text: widget.material.estimatedCost.format());
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _cost.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final cost = Money.tryParseMajor(_cost.text);
    if (cost == null) {
      setState(() => _error = context.l10n.materialEnterPaid);
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    final result = await ref.read(materialActionsProvider.notifier).recordCost(
          materialId: widget.material.id,
          actualCostMinor: cost.minor,
        );

    if (!mounted) return;
    setState(() => _busy = false);

    result.fold(
      (_) {
        Navigator.of(context).pop();
        showSuccess(context, context.l10n.materialCostRecorded);
      },
      (failure) => setState(() => _error = failure.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.materialWhatCost,
                style:
                    AppTypography.headlineMedium.copyWith(color: context.ink)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.materialReceiptBody,
              style:
                  AppTypography.bodyMedium.copyWith(color: context.inkSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            TextField(
              controller: _cost,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.materialAmountPaid,
                prefixText: '₹ ',
                errorText: _error,
                errorMaxLines: 2,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            EvidenceSection(
              target: EvidenceTarget(
                purpose: MediaPurpose.bookingReceipt,
                bookingId: widget.bookingId,
                materialId: widget.material.id,
              ),
              title: l10n.materialReceipt,
              explanation: l10n.materialReceiptRequired,
              isRequired: true,
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: _busy ? null : _submit,
              child: _busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Text(l10n.materialRecordCost),
            ),
          ],
        ),
      ),
    );
  }
}
