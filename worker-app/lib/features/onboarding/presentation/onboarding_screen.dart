import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/push_registration_provider.dart';
import '../../../app/providers/session_controller.dart';
import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/gig.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../profile/presentation/profile_controller.dart';

/// Onboarding.
///
/// Progress is derived from the server on every build, never from a local step
/// counter. A worker who reinstalls the app, or switches phones, resumes
/// exactly where they left off — and cannot skip a step by clearing app data.
/// The old wizard had seven steps of which only two actually persisted; here
/// each step writes before the next one opens.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider).valueOrNull;

    if (session is! SessionOnboarding) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final progress = session.progress;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set up your profile'),
        actions: [
          TextButton(
            onPressed: () => context.push(Routes.support),
            child: const Text('Help'),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello, ${session.worker.shortName}',
                    style: AppTypography.headlineMedium
                        .copyWith(color: context.ink)),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'A few things and you are ready to start getting work.',
                  style: AppTypography.bodyLarge
                      .copyWith(color: context.inkSecondary),
                ),
                const SizedBox(height: AppSpacing.lg),
                LabelledProgress(
                  label: 'Setup',
                  value: progress.fraction,
                  trailing:
                      '${progress.completedSteps} of ${OnboardingProgress.totalSteps}',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          _Step(
            step: OnboardingStep.basicProfile,
            isDone: progress.hasBasicProfile,
            isNext: progress.nextStep == OnboardingStep.basicProfile,
            description: 'Your city and PIN code, so we can find work near you.',
            onTap: () => _basicProfile(context),
          ),
          _Step(
            step: OnboardingStep.trade,
            isDone: progress.hasTrade,
            isNext: progress.nextStep == OnboardingStep.trade,
            description: 'The trade you mainly work in.',
            onTap: () => _chooseTrade(context, ref),
          ),
          _Step(
            step: OnboardingStep.skills,
            isDone: progress.hasSkills,
            isNext: progress.nextStep == OnboardingStep.skills,
            // Says the quiet part out loud: this platform does not tie a worker
            // to one trade, and the earlier they know it the better. Picking a
            // main trade adds it as a skill, so this step can tick itself —
            // the copy then has to say there is still something worth opening.
            description: progress.hasSkills
                ? 'Your main trade counts as one. Open this to add every other '
                    'trade you work in.'
                : 'Add every trade you work in. You are not limited to one.',
            onTap: () => context.push(Routes.editProfile),
          ),
          _Step(
            step: OnboardingStep.serviceArea,
            isDone: progress.hasServiceArea,
            isNext: progress.nextStep == OnboardingStep.serviceArea,
            description: 'How far you are willing to travel for a job.',
            onTap: () => _serviceArea(context, ref),
          ),
          _Step(
            step: OnboardingStep.kyc,
            isDone: progress.hasSubmittedKyc,
            isNext: progress.nextStep == OnboardingStep.kyc,
            description:
                'A government ID. Customers are letting you into their homes.',
            onTap: () => context.push(Routes.kyc),
          ),

          const SizedBox(height: AppSpacing.xl),
          const _NotificationPrimer(),
          AppCard(
            backgroundColor: context.surfaceMuted,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.schedule_rounded,
                    size: 20, color: context.inkSecondary),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Once you have finished these, our team checks your documents. You can carry on setting up your services while you wait.',
                    style: AppTypography.bodySmall
                        .copyWith(color: context.inkSecondary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Future<void> _basicProfile(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => const _BasicProfileSheet(),
    );
  }

  // _BasicProfileSheet owns its TextEditingControllers via State.dispose()
  // rather than a caller disposing them right after `await
  // showModalBottomSheet(...)` returns — that await resolves as soon as
  // Navigator.pop() runs, while the sheet's closing transition is still
  // rendering the same TextFields, so disposing there raced the animation
  // and threw "TextEditingController used after being disposed" (plus
  // cascading RenderFlex/GlobalKey/dependents errors from the corrupted
  // frame). The framework now disposes them at the right point in the
  // sheet's own lifecycle instead.

  Future<void> _chooseTrade(BuildContext context, WidgetRef ref) async {
    final List<ServiceCategory> services;
    try {
      // .future awaits the underlying fetch — reading .valueOrNull here
      // instead would race it: on a cold autoDispose provider nothing has
      // subscribed yet, so the read always lands on AsyncLoading (null),
      // reporting "could not be loaded" even though nothing has failed.
      services = await ref.read(allServicesProvider.future);
    } catch (_) {
      if (context.mounted) {
        showFailure(context, 'Trades could not be loaded. Try again.');
      }
      return;
    }
    if (services.isEmpty) {
      if (context.mounted) {
        showFailure(context, 'Trades could not be loaded. Try again.');
      }
      return;
    }
    if (!context.mounted) return;

    final chosen = await showModalBottomSheet<ServiceCategory>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text('What is your main trade?',
                style: AppTypography.titleLarge
                    .copyWith(color: sheetContext.ink)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'You can add more trades afterwards.',
              style: AppTypography.bodySmall
                  .copyWith(color: sheetContext.inkSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final service in services)
              ListTile(
                title: Text(service.name),
                subtitle: Text(service.shortDescription),
                onTap: () => Navigator.of(sheetContext).pop(service),
              ),
          ],
        ),
      ),
    );

    if (chosen == null || !context.mounted) return;

    final result = await ref
        .read(profileControllerProvider.notifier)
        .setPrimaryTrade(chosen.id);

    if (!context.mounted) return;
    result.fold(
      (_) => showSuccess(context, '${chosen.name} set as your main trade.'),
      (failure) => showFailure(context, failure.message),
    );
  }

  Future<void> _serviceArea(BuildContext context, WidgetRef ref) async {
    var radius = 10.0;
    var isSaving = false;
    String? error;

    await showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (sheetContext) => StatefulBuilder(
        builder: (builderContext, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('How far will you travel?',
                    style: AppTypography.headlineMedium
                        .copyWith(color: builderContext.ink)),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'We will only offer you jobs within this distance of where '
                  'you are right now.',
                  style: AppTypography.bodyMedium
                      .copyWith(color: builderContext.inkSecondary),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('${radius.round()} km',
                    style: AppTypography.numericHero
                        .copyWith(color: AppColors.primary)),
                Slider(
                  value: radius,
                  min: 1,
                  max: 50,
                  divisions: 49,
                  onChanged: isSaving
                      ? null
                      : (value) => setSheetState(() => radius = value),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('1 km',
                        style: AppTypography.bodySmall
                            .copyWith(color: builderContext.inkTertiary)),
                    Text('50 km',
                        style: AppTypography.bodySmall
                            .copyWith(color: builderContext.inkTertiary)),
                  ],
                ),
                if (error != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(error!,
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.danger)),
                ],
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'We use your current location as the centre point. You can '
                  'change this any time from your profile.',
                  style: AppTypography.bodySmall
                      .copyWith(color: builderContext.inkTertiary),
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          setSheetState(() {
                            isSaving = true;
                            error = null;
                          });

                          final position = await _currentPosition();
                          if (position == null) {
                            setSheetState(() {
                              isSaving = false;
                              error = 'Turn on location access to set your '
                                  'work area.';
                            });
                            return;
                          }

                          final result = await ref
                              .read(profileControllerProvider.notifier)
                              .updateServiceArea(
                                latitude: position.latitude,
                                longitude: position.longitude,
                                radiusKm: radius,
                              );

                          if (!builderContext.mounted) return;
                          result.fold(
                            (_) => Navigator.of(builderContext).pop(),
                            (failure) => setSheetState(() {
                              isSaving = false;
                              error = failure.message;
                            }),
                          );
                        },
                  child: isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// The device's current position, or null if location access was denied.
  ///
  /// This is a one-time read for the service-area centre point, not a
  /// tracking subscription — there is nothing to fabricate here if the
  /// worker refuses access, so the caller must handle null explicitly rather
  /// than falling back to an invented location.
  Future<Position?> _currentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
    } catch (_) {
      return null;
    }
  }
}

/// Explains what notifications are for before the system prompt appears.
///
/// The prompt used to fire the moment profile setup opened, with nothing on
/// screen to say what it was about; a worker who declines it there never sees
/// a job offer arrive. This asks only once the reason is on screen, and takes
/// no space at all once the worker has answered.
class _NotificationPrimer extends ConsumerStatefulWidget {
  const _NotificationPrimer();

  @override
  ConsumerState<_NotificationPrimer> createState() =>
      _NotificationPrimerState();
}

class _NotificationPrimerState extends ConsumerState<_NotificationPrimer> {
  bool _needed = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final needed =
        await ref.read(pushRegistrationProvider).needsPermissionPrompt;
    if (!mounted) return;
    setState(() => _needed = needed);
  }

  Future<void> _enable() async {
    setState(() => _busy = true);
    final granted =
        await ref.read(pushRegistrationProvider).requestPermissionAndRegister();
    if (!mounted) return;
    setState(() {
      _busy = false;
      _needed = false;
    });
    if (!granted) {
      showFailure(
        context,
        'Notifications stay off. You can turn them on in your phone settings.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_needed) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.notifications_active_rounded,
                    size: 20, color: context.ink),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text('Get told when a job comes in',
                      style:
                          AppTypography.titleMedium.copyWith(color: context.ink)),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Job offers expire. A notification is how you hear about one '
              'while the app is closed — nothing else is sent.',
              style:
                  AppTypography.bodySmall.copyWith(color: context.inkSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                BusyFilledButton(
                  label: 'Turn on notifications',
                  busy: _busy,
                  onPressed: _enable,
                ),
                const SizedBox(width: AppSpacing.sm),
                TextButton(
                  onPressed:
                      _busy ? null : () => setState(() => _needed = false),
                  child: const Text('Not now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.step,
    required this.isDone,
    required this.isNext,
    required this.description,
    required this.onTap,
  });

  final OnboardingStep step;
  final bool isDone;
  final bool isNext;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        onTap: onTap,
        borderColor: isNext ? AppColors.primary.withValues(alpha: 0.5) : null,
        child: Row(
          children: [
            Icon(
              isDone
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 28,
              color: isDone ? AppColors.success : context.inkTertiary,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step.label,
                      style: AppTypography.titleMedium.copyWith(
                        color: isDone ? context.inkSecondary : context.ink,
                      )),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(description,
                      style: AppTypography.bodySmall
                          .copyWith(color: context.inkSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

class _BasicProfileSheet extends ConsumerStatefulWidget {
  const _BasicProfileSheet();

  @override
  ConsumerState<_BasicProfileSheet> createState() => _BasicProfileSheetState();
}

class _BasicProfileSheetState extends ConsumerState<_BasicProfileSheet> {
  final _city = TextEditingController();
  final _pincode = TextEditingController();
  String? _gender;
  bool _isSaving = false;
  String? _genderError;
  String? _cityError;
  String? _pincodeError;

  @override
  void initState() {
    super.initState();
    // Reopening a finished step shows what was saved, so it can be corrected.
    final session = ref.read(sessionProvider).valueOrNull;
    if (session is SessionOnboarding) {
      _city.text = session.worker.city ?? '';
      _pincode.text = session.worker.pincode ?? '';
      _gender = session.worker.gender;
    }
  }

  @override
  void dispose() {
    _city.dispose();
    _pincode.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final city = _city.text.trim();
    final pincode = _pincode.text.trim();
    setState(() {
      _cityError = city.length < 2 ? 'Please enter your city' : null;
      // Indian PIN codes are six digits and never start with 0.
      _pincodeError = RegExp(r'^[1-9][0-9]{5}$').hasMatch(pincode)
          ? null
          : 'Enter a valid 6-digit PIN code';
      _genderError = _gender == null ? 'Please select your gender' : null;
    });
    if (_cityError != null || _pincodeError != null || _genderError != null) {
      return;
    }

    setState(() {
      _isSaving = true;
      _genderError = null;
    });

    final result = await ref.read(profileControllerProvider.notifier).updateDetails(
          city: city,
          pincode: pincode,
          gender: _gender,
        );

    if (!mounted) return;
    result.fold(
      (_) => Navigator.of(context).pop(),
      (failure) {
        setState(() => _isSaving = false);
        showFailure(context, failure.message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Where are you based?',
                  style: AppTypography.headlineMedium.copyWith(color: context.ink)),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _city,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                onChanged: (_) {
                  if (_cityError != null) setState(() => _cityError = null);
                },
                decoration:
                    InputDecoration(labelText: 'City', errorText: _cityError),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _pincode,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) {
                  if (_pincodeError != null) setState(() => _pincodeError = null);
                },
                decoration: InputDecoration(
                  labelText: 'PIN code',
                  counterText: '',
                  errorText: _pincodeError,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Gender',
                  style: AppTypography.label.copyWith(color: context.inkSecondary)),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  for (final option in const [
                    ('MALE', 'Male'),
                    ('FEMALE', 'Female'),
                    ('OTHER', 'Other'),
                  ])
                    ChoiceChip(
                      label: Text(option.$2),
                      selected: _gender == option.$1,
                      onSelected: (_) => setState(() {
                        _gender = option.$1;
                        _genderError = null;
                      }),
                    ),
                ],
              ),
              if (_genderError != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(_genderError!,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.danger)),
              ],
              const SizedBox(height: AppSpacing.xl),
              BusyFilledButton(
                label: 'Save',
                busy: _isSaving,
                busyLabel: 'Saving…',
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
