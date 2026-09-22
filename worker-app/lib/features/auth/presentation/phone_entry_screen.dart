import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../shared/widgets/common_widgets.dart';
import 'auth_controller.dart';

/// Enter a mobile number.
///
/// One task on the screen, a very large input, and a numeric keypad. There is
/// no password field because the platform has no passwords: the only credential
/// is a code sent to a number the worker controls.
class PhoneEntryScreen extends ConsumerStatefulWidget {
  const PhoneEntryScreen({super.key});

  @override
  ConsumerState<PhoneEntryScreen> createState() => _PhoneEntryScreenState();
}

class _PhoneEntryScreenState extends ConsumerState<PhoneEntryScreen> {
  final _controller = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isValid {
    final digits = _controller.text.replaceAll(RegExp(r'\D'), '');
    return digits.length == 10 && RegExp(r'^[6-9]').hasMatch(digits);
  }

  Future<void> _submit() async {
    if (!_isValid || _busy) return;

    setState(() {
      _busy = true;
      _error = null;
    });

    final result =
        await ref.read(authControllerProvider.notifier).requestOtp(_controller.text);

    if (!mounted) return;
    setState(() => _busy = false);

    result.fold(
      (pending) => context.push(Routes.otp, extra: {
        'verificationId': pending.verificationId,
        'phoneNumber': pending.phoneNumber,
      }),
      (failure) => setState(() => _error = failure.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('What is your mobile number?',
                        style: AppTypography.headlineLarge
                            .copyWith(color: context.ink)),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'We will send you a one-time code to confirm it is you.',
                      style: AppTypography.bodyLarge
                          .copyWith(color: context.inkSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    TextField(
                      controller: _controller,
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                      onChanged: (_) => setState(() => _error = null),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      style: AppTypography.headlineMedium.copyWith(
                        color: context.ink,
                        letterSpacing: 2,
                      ),
                      decoration: InputDecoration(
                        hintText: '98765 43210',
                        errorText: _error,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(
                            left: AppSpacing.lg,
                            right: AppSpacing.sm,
                          ),
                          child: Text(
                            '+91',
                            style: AppTypography.headlineMedium
                                .copyWith(color: context.inkSecondary),
                          ),
                        ),
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 0, minHeight: 0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: BusyFilledButton(
                label: 'Send code',
                busy: _busy,
                busyLabel: 'Sending…',
                onPressed: _isValid ? _submit : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
