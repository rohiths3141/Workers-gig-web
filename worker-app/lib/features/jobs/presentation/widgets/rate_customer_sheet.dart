import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../jobs_controller.dart';

/// Rating a customer after a finished job.
///
/// Eligibility is the server's call: it accepts a rating only on a booking that
/// actually reached completion, and only once. A second attempt comes back as a
/// conflict, which this sheet reports rather than hiding.
class RateCustomerSheet extends ConsumerStatefulWidget {
  const RateCustomerSheet({required this.bookingId, super.key});

  final String bookingId;

  static Future<void> show(BuildContext context, String bookingId) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: RateCustomerSheet(bookingId: bookingId),
      ),
    );
  }

  @override
  ConsumerState<RateCustomerSheet> createState() => _RateCustomerSheetState();
}

class _RateCustomerSheetState extends ConsumerState<RateCustomerSheet> {
  final _comment = TextEditingController();
  int _rating = 0;
  bool _busy = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0 || _busy) return;
    setState(() => _busy = true);

    final result = await ref.read(jobActionsProvider.notifier).rateCustomer(
          bookingId: widget.bookingId,
          rating: _rating,
          comment: _comment.text.trim().isEmpty ? null : _comment.text.trim(),
        );

    if (!mounted) return;
    setState(() => _busy = false);

    result.fold(
      (_) {
        Navigator.of(context).pop();
        showSuccess(context, 'Thank you for the feedback.');
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
            Text('How was this customer?',
                style:
                    AppTypography.headlineMedium.copyWith(color: context.ink)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Your rating is private and helps us look after workers.',
              style:
                  AppTypography.bodyMedium.copyWith(color: context.inkSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var star = 1; star <= 5; star++)
                  IconButton(
                    onPressed: () => setState(() => _rating = star),
                    iconSize: 40,
                    icon: Icon(
                      star <= _rating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: star <= _rating
                          ? AppColors.warning
                          : context.inkTertiary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _comment,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Anything to add? (optional)',
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: _rating == 0 || _busy ? null : _submit,
              child: _busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Text('Submit rating'),
            ),
          ],
        ),
      ),
    );
  }
}
