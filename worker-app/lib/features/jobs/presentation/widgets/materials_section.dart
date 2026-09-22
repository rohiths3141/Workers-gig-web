import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
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
    final materials = ref.watch(materialsProvider(bookingId));

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Materials',
                    style:
                        AppTypography.titleMedium.copyWith(color: context.ink)),
              ),
              TextButton.icon(
                onPressed: () => _requestMaterial(context, ref),
                icon: const Icon(Icons.add_rounded, size: 20),
                label: const Text('Add'),
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
                'Materials could not be loaded.',
                style: AppTypography.bodySmall.copyWith(color: AppColors.danger),
              ),
            ),
            data: (items) {
              if (items.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Text(
                    'If you need parts for this job, add them here and the customer will be asked to approve the cost.',
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
    final (label, color) = switch (material.status) {
      MaterialStatus.requested ||
      MaterialStatus.customerReview =>
        ('WAITING FOR CUSTOMER', AppColors.warning),
      MaterialStatus.approved => ('APPROVED', AppColors.success),
      MaterialStatus.rejected => ('DECLINED', AppColors.danger),
      MaterialStatus.purchased => ('BOUGHT', AppColors.info),
      MaterialStatus.costRecorded => ('COST RECORDED', AppColors.info),
      MaterialStatus.billed => ('ON THE BILL', AppColors.success),
      MaterialStatus.cancelled => ('CANCELLED', AppColors.inkTertiary),
    };

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
            '${material.quantity.toStringAsFixed(material.quantity % 1 == 0 ? 0 : 2)} ${material.unit}'
            '${material.actualCost == null ? ' · estimated' : ' · actual'}',
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
                  child: const Text('Record cost'),
                ),
            ],
          ),
          if (material.customerRejectionReason != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Customer said: ${material.customerRejectionReason}',
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
  final _unit = TextEditingController(text: 'piece');
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
      errors['name'] = 'What do you need?';
    }

    final quantity = double.tryParse(_quantity.text.trim());
    if (quantity == null || quantity <= 0) {
      errors['quantity'] = 'Enter how many';
    }

    // Parsed through Money so the paise are exact. A double here would be the
    // one place in the app where a rounding error could reach the invoice.
    final cost = Money.tryParseMajor(_cost.text);
    if (cost == null || !cost.isPositive) {
      errors['cost'] = 'Enter the expected cost';
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
        showSuccess(context, 'Sent to the customer for approval.');
      },
      (failure) => showFailure(context, failure.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What do you need?',
                style:
                    AppTypography.headlineMedium.copyWith(color: context.ink)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'The customer will be asked to approve this before you buy it.',
              style:
                  AppTypography.bodyMedium.copyWith(color: context.inkSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            TextField(
              controller: _name,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Material',
                hintText: 'e.g. 16A modular switch',
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
                      labelText: 'Quantity',
                      errorText: _errors['quantity'],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextField(
                    controller: _unit,
                    decoration: const InputDecoration(labelText: 'Unit'),
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
                labelText: 'Expected cost',
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
                  : const Text('Ask the customer'),
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
      setState(() => _error = 'Enter the amount you paid');
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
        showSuccess(context, 'Cost recorded.');
      },
      (failure) => setState(() => _error = failure.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What did it cost?',
                style:
                    AppTypography.headlineMedium.copyWith(color: context.ink)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Attach the receipt so this can be added to the customer\'s bill.',
              style:
                  AppTypography.bodyMedium.copyWith(color: context.inkSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            TextField(
              controller: _cost,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Amount paid',
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
              title: 'Receipt',
              explanation: 'A photo of the bill is required.',
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
                  : const Text('Record cost'),
            ),
          ],
        ),
      ),
    );
  }
}
