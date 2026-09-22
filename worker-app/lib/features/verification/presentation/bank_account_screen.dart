import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../shared/widgets/common_widgets.dart';
import 'verification_controller.dart';

/// Payout bank account. The worker enters it; an admin verifies it before any
/// withdrawal is paid there.
class BankAccountScreen extends ConsumerStatefulWidget {
  const BankAccountScreen({super.key});

  @override
  ConsumerState<BankAccountScreen> createState() => _BankAccountScreenState();
}

class _BankAccountScreenState extends ConsumerState<BankAccountScreen> {
  static final _ifscPattern = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
  static final _accountPattern = RegExp(r'^[0-9]{9,18}$');

  final _holder = TextEditingController();
  final _number = TextEditingController();
  final _confirmNumber = TextEditingController();
  final _ifsc = TextEditingController();
  final _bankName = TextEditingController();

  Map<String, String> _errors = const {};
  bool _busy = false;

  @override
  void dispose() {
    _holder.dispose();
    _number.dispose();
    _confirmNumber.dispose();
    _ifsc.dispose();
    _bankName.dispose();
    super.dispose();
  }

  Map<String, String> _validate() {
    final errors = <String, String>{};
    if (_holder.text.trim().length < 2) {
      errors['holder'] = 'Enter the name exactly as it appears on the account';
    }
    if (!_accountPattern.hasMatch(_number.text.trim())) {
      errors['number'] = 'An account number is 9 to 18 digits';
    } else if (_confirmNumber.text.trim() != _number.text.trim()) {
      errors['confirm'] = 'The account numbers do not match';
    }
    if (!_ifscPattern.hasMatch(_ifsc.text.trim().toUpperCase())) {
      errors['ifsc'] = 'Enter the 11-character IFSC, e.g. SBIN0001234';
    }
    return errors;
  }

  Future<void> _submit() async {
    final errors = _validate();
    if (errors.isNotEmpty) {
      setState(() => _errors = errors);
      return;
    }

    setState(() {
      _busy = true;
      _errors = const {};
    });

    final result =
        await ref.read(verificationControllerProvider.notifier).submitBankAccount(
              accountHolderName: _holder.text.trim(),
              accountNumber: _number.text.trim(),
              ifsc: _ifsc.text.trim().toUpperCase(),
              bankName:
                  _bankName.text.trim().isEmpty ? null : _bankName.text.trim(),
            );

    if (!mounted) return;
    setState(() => _busy = false);

    result.fold(
      (_) {
        Navigator.of(context).pop();
        showSuccess(context, 'Bank account sent for verification.');
      },
      (failure) => showFailure(context, failure.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final digitsOnly = [FilteringTextInputFormatter.digitsOnly];

    return Scaffold(
      appBar: AppBar(title: const Text('Bank account')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              children: [
                AppCard(
                  backgroundColor: AppColors.infoSurface,
                  borderColor: AppColors.info.withValues(alpha: 0.3),
                  child: Text(
                    'Your withdrawals are paid to this account. Our team verifies it before the first payout.',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.info),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                TextField(
                  controller: _holder,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Account holder name',
                    errorText: _errors['holder'],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _number,
                  keyboardType: TextInputType.number,
                  inputFormatters: digitsOnly,
                  maxLength: 18,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Account number',
                    errorText: _errors['number'],
                    counterText: '',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _confirmNumber,
                  keyboardType: TextInputType.number,
                  inputFormatters: digitsOnly,
                  maxLength: 18,
                  decoration: InputDecoration(
                    labelText: 'Re-enter account number',
                    errorText: _errors['confirm'],
                    counterText: '',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _ifsc,
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 11,
                  decoration: InputDecoration(
                    labelText: 'IFSC code',
                    hintText: 'e.g. SBIN0001234',
                    errorText: _errors['ifsc'],
                    counterText: '',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _bankName,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Bank name (optional)',
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
            child: SizedBox(
              height: AppSpacing.primaryActionHeight,
              width: double.infinity,
              child: FilledButton(
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
                    : const Text('Submit for verification'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
