import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/money/money.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/gig.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/common_widgets.dart';
import 'gigs_controller.dart';

/// Create or edit one service.
///
/// The trade picker offers only trades the worker is approved for, because
/// offering anything else would produce a refusal they cannot act on. If they
/// are approved for nothing yet, the screen says so and points at skills rather
/// than showing an empty dropdown.
class GigEditorScreen extends ConsumerStatefulWidget {
  const GigEditorScreen({this.gigId, super.key});

  final String? gigId;

  @override
  ConsumerState<GigEditorScreen> createState() => _GigEditorScreenState();
}

class _GigEditorScreenState extends ConsumerState<GigEditorScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();

  String? _serviceId;
  PricingUnit _pricingUnit = PricingUnit.perJob;
  int? _durationMinutes;
  double? _radiusKm;

  Map<String, String> _errors = const {};

  /// Drops one field's error as soon as the worker changes that field, so a
  /// corrected field doesn't keep showing the old message until resubmit.
  void _clearError(String field) {
    if (!_errors.containsKey(field)) return;
    _errors = Map.of(_errors)..remove(field);
  }
  bool _busy = false;
  bool _loaded = false;

  static const _durations = [
    (30, '30 minutes'),
    (45, '45 minutes'),
    (60, '1 hour'),
    (120, '2 hours'),
    (240, '4 hours'),
    (480, '8 hours (a working day)'),
    (1440, '24 hours'),
    (2880, '2 days'),
    (4320, '3 days'),
    (10080, '1 week'),
  ];

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _price.dispose();
    super.dispose();
  }

  void _hydrate(Gig gig) {
    if (_loaded) return;
    _loaded = true;
    _title.text = gig.title;
    _description.text = gig.description ?? '';
    _price.text = (gig.price.minor / 100).toStringAsFixed(
      gig.price.minor % 100 == 0 ? 0 : 2,
    );
    _serviceId = gig.serviceId;
    _pricingUnit = gig.pricingUnit;
    _durationMinutes = gig.estimatedDurationMinutes;
    _radiusKm = gig.serviceRadiusKm;
  }

  GigDraft _buildDraft() => GigDraft(
        id: widget.gigId,
        serviceId: _serviceId,
        title: _title.text,
        description: _description.text,
        priceMinor: Money.tryParseMajor(_price.text)?.minor,
        pricingUnit: _pricingUnit,
        estimatedDurationMinutes: _durationMinutes,
        serviceRadiusKm: _radiusKm,
      );

  Future<void> _submit({required bool publish}) async {
    final draft = _buildDraft();

    if (publish) {
      final errors = draft.validate();
      if (errors.isNotEmpty) {
        setState(() => _errors = errors);
        return;
      }
    }

    setState(() {
      _busy = true;
      _errors = const {};
    });

    final controller = ref.read(gigActionsProvider.notifier);
    final result =
        publish ? await controller.publish(draft) : await controller.saveDraft(draft);

    if (!mounted) return;
    setState(() => _busy = false);

    result.fold(
      (gig) {
        Navigator.of(context).pop();
        showSuccess(
          context,
          switch (gig.status) {
            GigStatus.draft => 'Saved as a draft.',
            GigStatus.pendingReview =>
              'Submitted. We will review it and let you know.',
            GigStatus.active => 'Your service is live.',
            _ => 'Saved.',
          },
        );
      },
      (failure) {
        // The server validates independently of the client. When it rejects a
        // specific field, surface that against the field rather than only as a
        // snackbar the worker has to remember.
        if (failure is ValidationFailure && failure.fieldErrors.isNotEmpty) {
          setState(() => _errors = failure.fieldErrors);
        }
        showFailure(context, failure.message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(gigCategoriesProvider);
    final existing =
        widget.gigId == null ? null : ref.watch(gigProvider(widget.gigId!));

    if (existing != null) {
      final gig = existing.valueOrNull;
      if (gig != null) _hydrate(gig);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gigId == null ? 'Add a service' : 'Edit service'),
      ),
      body: AsyncValueView<List<ServiceCategory>>(
        value: categories,
        onRetry: () => ref.invalidate(gigCategoriesProvider),
        onData: (available) {
          if (available.isEmpty) {
            return const EmptyStateView(
              icon: Icons.workspace_premium_outlined,
              title: 'No approved trades yet',
              message:
                  'Once a trade is approved for you, you can publish services under it. Add a trade from your profile to get started.',
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  children: [
                    _Field(
                      label: 'Which trade?',
                      child: DropdownButtonFormField<String>(
                        initialValue: available.any((c) => c.id == _serviceId)
                            ? _serviceId
                            : null,
                        isExpanded: true,
                        decoration:
                            InputDecoration(errorText: _errors['serviceId']),
                        items: [
                          for (final category in available)
                            DropdownMenuItem(
                              value: category.id,
                              child: Text(category.name),
                            ),
                        ],
                        onChanged: (value) => setState(() {
                          _serviceId = value;
                          _clearError('serviceId');
                        }),
                      ),
                    ),

                    _Field(
                      label: 'What is the service called?',
                      hint: 'Customers see this. Be specific.',
                      child: TextField(
                        controller: _title,
                        textCapitalization: TextCapitalization.sentences,
                        maxLength: 120,
                        onChanged: (_) {
                          if (_errors.containsKey('title')) {
                            setState(() => _clearError('title'));
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'e.g. Split AC deep cleaning',
                          errorText: _errors['title'],
                          errorMaxLines: 2,
                          counterText: '',
                        ),
                      ),
                    ),

                    _Field(
                      label: 'What does it include?',
                      hint: 'Optional, but it helps customers choose you.',
                      child: TextField(
                        controller: _description,
                        maxLines: 4,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText:
                              'e.g. Full indoor and outdoor unit clean, filter wash, gas pressure check.',
                        ),
                      ),
                    ),

                    _Field(
                      label: 'What do you charge?',
                      hint:
                          'Each service has its own price. This one does not affect your others.',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _price,
                              onChanged: (_) {
                                if (_errors.containsKey('price')) {
                                  setState(() => _clearError('price'));
                                }
                              },
                              keyboardType: const TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[\d.]')),
                              ],
                              decoration: InputDecoration(
                                prefixText: '₹ ',
                                // Empty errorText keeps the red border; the
                                // message itself is shown full width below,
                                // where it isn't cut to "Enter what ...".
                                errorText: _errors['price'] == null ? null : '',
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            flex: 3,
                            child: DropdownButtonFormField<PricingUnit>(
                              initialValue: _pricingUnit,
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem(
                                    value: PricingUnit.perJob,
                                    child: Text('per job')),
                                DropdownMenuItem(
                                    value: PricingUnit.perHour,
                                    child: Text('per hour')),
                                DropdownMenuItem(
                                    value: PricingUnit.perDay,
                                    child: Text('per day')),
                                DropdownMenuItem(
                                    value: PricingUnit.perUnit,
                                    child: Text('per unit')),
                                DropdownMenuItem(
                                    value: PricingUnit.perSqft,
                                    child: Text('per sq ft')),
                              ],
                              onChanged: (value) => setState(
                                  () => _pricingUnit = value ?? _pricingUnit),
                            ),
                          ),
                        ],
                      ),
                      if (_errors['price'] != null)
                        Padding(
                          padding: const EdgeInsets.only(
                              top: AppSpacing.xs, left: AppSpacing.md),
                          child: Text(
                            _errors['price']!,
                            style: AppTypography.bodySmall
                                .copyWith(color: AppColors.danger),
                          ),
                        ),
                        ],
                      ),
                    ),

                    _Field(
                      label: 'How long does it usually take?',
                      child: DropdownButtonFormField<int>(
                        initialValue: _durationMinutes,
                        isExpanded: true,
                        decoration:
                            InputDecoration(errorText: _errors['duration']),
                        items: [
                          for (final (minutes, label) in _durations)
                            DropdownMenuItem(value: minutes, child: Text(label)),
                        ],
                        onChanged: (value) => setState(() {
                          _durationMinutes = value;
                          _clearError('duration');
                        }),
                      ),
                    ),

                    _Field(
                      label: 'How far will you travel for this?',
                      hint:
                          'Leave as default to use your usual travel distance.',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _radiusKm == null
                                ? 'Your usual distance'
                                : '${_radiusKm!.round()} km',
                            style: AppTypography.titleMedium
                                .copyWith(color: context.ink),
                          ),
                          Slider(
                            value: _radiusKm ?? 10,
                            min: 1,
                            max: 50,
                            divisions: 49,
                            label: '${(_radiusKm ?? 10).round()} km',
                            onChanged: (value) =>
                                setState(() => _radiusKm = value),
                          ),
                          if (_radiusKm != null)
                            TextButton(
                              onPressed: () => setState(() => _radiusKm = null),
                              child: const Text('Use my usual distance'),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),
                    AppCard(
                      backgroundColor: AppColors.infoSurface,
                      borderColor: AppColors.info.withValues(alpha: 0.3),
                      child: Row(
                        children: [
                          const Icon(Icons.visibility_outlined,
                              size: 20, color: AppColors.info),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              'New and edited services are checked by our team before they go live. We will let you know as soon as it is done.',
                              style: AppTypography.bodySmall
                                  .copyWith(color: AppColors.info),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.huge),
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
                child: Row(
                  children: [
                    // 2:3 rather than 1:2 — at 1:2 "Save draft" had to wrap
                    // onto two lines on a normal phone.
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: AppSpacing.primaryActionHeight,
                        child: OutlinedButton(
                          onPressed:
                              _busy ? null : () => _submit(publish: false),
                          child: const Text(
                            'Save draft',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: AppSpacing.primaryActionHeight,
                        child: BusyFilledButton(
                          label: 'Submit for review',
                          busy: _busy,
                          onPressed: () => _submit(publish: true),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.child, this.hint});

  final String label;
  final String? hint;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTypography.titleMedium.copyWith(color: context.ink)),
          if (hint != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(hint!,
                style: AppTypography.bodySmall
                    .copyWith(color: context.inkSecondary)),
          ],
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}
