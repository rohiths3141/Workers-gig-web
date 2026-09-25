import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/providers.dart';
import '../../../app/providers/session_controller.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../shared/widgets/common_widgets.dart';
import 'auth_controller.dart';
import '../../profile/presentation/profile_screen.dart' show formatIndianPhone;
import '../../../core/localization/l10n.dart';

/// Creates the worker profile for an authenticated Firebase user.
///
/// Asks for a name and nothing else. Documents, trades and service areas come
/// later, in onboarding: making someone photograph an Aadhaar card before they
/// have seen a single screen of the product is how you lose them.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _nameError;
  String? _emailError;
  bool _busy = false;

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    final l10n = context.l10n;
    final nameError = name.length < 2 ? l10n.registerNameRequired : null;
    // Optional, as the field's own label and the nullable `p_email` argument
    // both say. It used to refuse an empty field with "Please enter a valid
    // email address", which read as a required field nobody had marked.
    final emailError = email.isNotEmpty && !_emailPattern.hasMatch(email)
        ? l10n.registerEmailInvalid
        : null;

    if (nameError != null || emailError != null) {
      setState(() {
        _nameError = nameError;
        _emailError = emailError;
      });
      return;
    }

    final session = ref.read(sessionProvider).valueOrNull;
    final phone = session is SessionNeedsRegistration ? session.phoneNumber : null;

    if (phone == null || phone.isEmpty) {
      // Without a verified number there is nothing to register against. Sending
      // the worker back to sign in is the honest outcome.
      showFailure(context, l10n.authErrorSignInAgain);
      await ref.read(authRepositoryProvider).signOut();
      return;
    }

    setState(() {
      _busy = true;
      _nameError = null;
      _emailError = null;
    });

    final result =
        await ref.read(registrationControllerProvider.notifier).register(
              fullName: name,
              phone: phone,
              email: email.isEmpty ? null : email,
            );

    if (!mounted) return;
    setState(() => _busy = false);

    // On success the router moves the worker to onboarding.
    result.fold((_) {}, (failure) => showFailure(context, failure.message));
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider).valueOrNull;
    final phone = session is SessionNeedsRegistration ? session.phoneNumber : null;
    final l10n = context.l10n;

    return Scaffold(
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
                    const SizedBox(height: AppSpacing.xxxl),
                    Text(l10n.registerTitle,
                        style: AppTypography.headlineLarge
                            .copyWith(color: context.ink)),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.registerSubtitle,
                      style: AppTypography.bodyLarge
                          .copyWith(color: context.inkSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    TextField(
                      controller: _nameController,
                      autofocus: true,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) => setState(() => _nameError = null),
                      decoration: InputDecoration(
                        labelText: l10n.registerNameLabel,
                        hintText: l10n.registerNameHint,
                        errorText: _nameError,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      onChanged: (_) => setState(() => _emailError = null),
                      onSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: l10n.registerEmailLabel,
                        hintText: 'arun@example.com',
                        helperText: l10n.registerEmailHelper,
                        errorText: _emailError,
                      ),
                    ),
                    if (phone != null) ...[
                      const SizedBox(height: AppSpacing.xl),
                      AppCard(
                        backgroundColor: context.surfaceMuted,
                        child: Row(
                          children: [
                            Icon(Icons.verified_user_outlined,
                                size: 20, color: context.inkSecondary),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                l10n.registerVerifiedPhone(formatIndianPhone(phone)),
                                style: AppTypography.bodyMedium
                                    .copyWith(color: context.inkSecondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: BusyFilledButton(
                label: l10n.commonContinue,
                busy: _busy,
                busyLabel: l10n.commonSaving,
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
