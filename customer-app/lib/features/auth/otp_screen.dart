import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/phone_format.dart';
import 'auth_controller.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final int? resendToken;

  const OtpScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
    this.resendToken,
  });

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  static const _resendSeconds = 30;

  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Timer? _resendTimer;
  int _resendIn = _resendSeconds;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startResendCountdown() {
    _resendTimer?.cancel();
    setState(() => _resendIn = _resendSeconds);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return timer.cancel();
      setState(() => _resendIn--);
      if (_resendIn <= 0) timer.cancel();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final smsCode = _otpController.text.trim();
    await ref
        .read(authControllerProvider.notifier)
        .verifyOtp(widget.verificationId, smsCode);
  }

  Future<void> _resend() async {
    final sent = await ref
        .read(authControllerProvider.notifier)
        .sendOtp(widget.phoneNumber);
    if (!mounted || !sent) return;
    _startResendCountdown();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('We sent a new code.')),
    );
  }

  /// The phone screen is replaced rather than pushed, so there is nothing to
  /// pop. Back has to take the customer back to entering their number.
  void _changeNumber() => context.go('/auth/phone');

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final theme = Theme.of(context);
    final canResend = _resendIn <= 0 && !state.isLoading;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _changeNumber();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Verify phone'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Change number',
            onPressed: _changeNumber,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Enter 6-digit code',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'We sent an SMS verification code to '
                  '${formatIndianPhone(widget.phoneNumber)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.inkSecondary,
                  ),
                ),
                TextButton(
                  onPressed: _changeNumber,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 36),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerLeft,
                  ),
                  child: const Text('Wrong number? Change it'),
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 6,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      letterSpacing: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '• • • • • •',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().length != 6) {
                        return 'Please enter 6 digits';
                      }
                      return null;
                    },
                  ),
                ),
                if (state.error != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.statusError.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppColors.statusError),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.error!,
                            style:
                                const TextStyle(color: AppColors.statusError),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Center(
                  child: canResend
                      ? TextButton(
                          onPressed: _resend,
                          child: const Text(
                            'Resend code',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Text(
                          'Resend code in ${_resendIn}s',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.inkSecondary,
                          ),
                        ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: state.isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: state.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Verify & Continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
