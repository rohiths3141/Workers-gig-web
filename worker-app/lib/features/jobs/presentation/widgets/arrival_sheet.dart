import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../jobs_controller.dart';

/// Arrival verification.
///
/// The customer reads a code aloud; the worker types it here. The comparison
/// happens on the server and nowhere else — the correct code is never sent to
/// this device, so there is nothing here to compare against and no way to
/// shortcut the check.
///
/// This is the screen the previous application got most wrong: it reported
/// success even when the server rejected the code, which made the whole
/// arrival record worthless. Here the only thing that closes this sheet with a
/// success is the server returning verified: true.
class ArrivalSheet extends ConsumerStatefulWidget {
  const ArrivalSheet({required this.bookingId, super.key});

  final String bookingId;

  static Future<bool> show(BuildContext context, String bookingId) async {
    final verified = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      // The inset has to be read from the sheet's own context. Reading it from
      // the caller's captured a keyboard height of zero that never updated, so
      // the keyboard sat on top of the whole sheet: the worker could not see
      // the field they were typing into or reach the confirm button.
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: ArrivalSheet(bookingId: bookingId),
      ),
    );
    return verified ?? false;
  }

  @override
  ConsumerState<ArrivalSheet> createState() => _ArrivalSheetState();
}

class _ArrivalSheetState extends ConsumerState<ArrivalSheet> {
  final _controller = TextEditingController();
  String? _error;
  int? _attemptsRemaining;
  bool _busy = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _controller.text.trim();
    if (code.length < 4 || _busy) return;

    setState(() {
      _busy = true;
      _error = null;
    });

    final result = await ref
        .read(jobActionsProvider.notifier)
        .verifyArrival(widget.bookingId, code);

    if (!mounted) return;
    setState(() => _busy = false);

    result.fold(
      (verification) {
        // The ONLY success path. A rejected code falls through to the else
        // branch and stays on this sheet.
        if (verification.isVerified) {
          Navigator.of(context).pop(true);
          return;
        }

        setState(() {
          _controller.clear();
          _attemptsRemaining = verification.attemptsRemaining;
          _error = _attemptsRemaining == null
              ? 'That code is not correct.'
              : 'That code is not correct. '
                  '${_attemptsRemaining!} attempt${_attemptsRemaining == 1 ? '' : 's'} left.';
        });
      },
      // A failure is the request not landing, not a wrong code: keep what the
      // worker typed so they can simply tap again.
      (failure) => setState(() => _error = failure.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final outOfAttempts = _attemptsRemaining == 0;

    return SafeArea(
      // Scrollable so the sheet still works on a short screen with the
      // keyboard up.
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Confirm you have arrived',
                style:
                    AppTypography.headlineMedium.copyWith(color: context.ink)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Ask the customer to read out the code from their app, then type it here.',
              style:
                  AppTypography.bodyLarge.copyWith(color: context.inkSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),

            TextField(
              controller: _controller,
              autofocus: true,
              enabled: !outOfAttempts,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              style: AppTypography.displayLarge.copyWith(
                color: context.ink,
                letterSpacing: 10,
              ),
              decoration: InputDecoration(
                hintText: '······',
                errorText: _error,
                errorMaxLines: 2,
              ),
              onChanged: (_) => setState(() => _error = null),
            ),
            const SizedBox(height: AppSpacing.xl),

            if (outOfAttempts)
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.dangerSurface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Text(
                  'Too many incorrect codes. Please contact support to continue this job.',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.danger),
                ),
              )
            else
              FilledButton(
                onPressed: _busy ? null : _verify,
                child: _busy
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Text('Confirm arrival'),
              ),

            const SizedBox(height: AppSpacing.md),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Not yet'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
