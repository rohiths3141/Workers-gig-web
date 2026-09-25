import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../shared/widgets/common_widgets.dart';
import 'auth_controller.dart';
import '../../profile/presentation/profile_screen.dart' show formatIndianPhone;
import '../../../core/localization/l10n.dart';

/// Enter the one-time code.
///
/// Verification happens at Firebase. This screen renders whatever Firebase
/// decides and has no path that treats a rejected code as success.
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({
    required this.verificationId,
    required this.phoneNumber,
    super.key,
  });

  final String verificationId;
  final String phoneNumber;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _controller = TextEditingController();
  String? _error;
  bool _busy = false;
  int _resendIn = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startResendCountdown() {
    _timer?.cancel();
    setState(() => _resendIn = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return timer.cancel();
      setState(() => _resendIn--);
      if (_resendIn <= 0) timer.cancel();
    });
  }

  Future<void> _verify() async {
    if (_controller.text.trim().length < 6 || _busy) return;

    setState(() {
      _busy = true;
      _error = null;
    });

    final result =
        await ref.read(authControllerProvider.notifier).verifyOtp(
          verificationId: widget.verificationId,
          smsCode: _controller.text,
          phoneNumber: widget.phoneNumber,
        );

    if (!mounted) return;
    setState(() => _busy = false);

    // On success the router redirects: the session has re-resolved and decides
    // whether the worker goes to registration, onboarding or home. Nothing is
    // navigated from here on a guess.
    result.fold(
      (_) {},
      (failure) => setState(() {
        _error = failure.message;
        _controller.clear();
      }),
    );
  }

  Future<void> _resend() async {
    final result = await ref.read(authControllerProvider.notifier).resend(widget.phoneNumber);
    if (!mounted) return;

    result.fold(
      (_) {
        _startResendCountdown();
        showSuccess(context, context.l10n.authNewCodeSent);
      },
      (failure) => setState(() => _error = failure.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                    Text(l10n.otpTitle,
                        style: AppTypography.headlineLarge
                            .copyWith(color: context.ink)),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.otpSentTo(formatIndianPhone(widget.phoneNumber)),
                      style: AppTypography.bodyLarge
                          .copyWith(color: context.inkSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    TextField(
                      controller: _controller,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      // Lets Android fill the code from the SMS automatically,
                      // which saves the worker typing it while on a ladder.
                      autofillHints: const [AutofillHints.oneTimeCode],
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      style: AppTypography.displayLarge.copyWith(
                        color: context.ink,
                        letterSpacing: 12,
                      ),
                      decoration: InputDecoration(
                        hintText: '······',
                        errorText: _error,
                      ),
                      onChanged: (value) {
                        setState(() => _error = null);
                        if (value.length == 6) _verify();
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Center(
                      child: _resendIn > 0
                          ? Text(
                              l10n.otpResendIn(_resendIn),
                              style: AppTypography.bodyMedium
                                  .copyWith(color: context.inkTertiary),
                            )
                          : TextButton(
                              onPressed: _resend,
                              child: Text(l10n.otpSendNew),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: BusyFilledButton(
                label: l10n.otpVerify,
                busy: _busy,
                busyLabel: l10n.otpVerifying,
                onPressed: _controller.text.length == 6 ? _verify : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
