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
import '../../../core/localization/l10n.dart';
import '../../../domain/entities/gig.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../../shared/widgets/service_names.dart';
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

    final l10n = context.l10n;
    final progress = session.progress;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.onboardingTitle),
        actions: [
          TextButton(
            onPressed: () => context.push(Routes.support),
            child: Text(l10n.onboardingHelp),
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
                Text(l10n.onboardingHello(session.worker.shortName),
                    style: AppTypography.headlineMedium
                        .copyWith(color: context.ink)),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.onboardingIntro,
                  style: AppTypography.bodyLarge
                      .copyWith(color: context.inkSecondary),
                ),
                const SizedBox(height: AppSpacing.lg),
                LabelledProgress(
                  label: l10n.onboardingSetup,
                  value: progress.fraction,
                  trailing: l10n.onboardingStepCount(
                      progress.completedSteps, OnboardingProgress.totalSteps),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          _Step(
            step: OnboardingStep.basicProfile,
            isDone: progress.hasBasicProfile,
            isNext: progress.nextStep == OnboardingStep.basicProfile,
            description: l10n.onboardingBasicBody,
            onTap: () => _basicProfile(context),
          ),
          _Step(
            step: OnboardingStep.trade,
            isDone: progress.hasTrade,
            isNext: progress.nextStep == OnboardingStep.trade,
            description: l10n.onboardingTradeBody,
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
                ? l10n.onboardingSkillsDoneBody
                : l10n.onboardingSkillsBody,
            onTap: () => context.push(Routes.editProfile),
          ),
          _Step(
            step: OnboardingStep.serviceArea,
            isDone: progress.hasServiceArea,
            isNext: progress.nextStep == OnboardingStep.serviceArea,
            description: l10n.onboardingAreaBody,
            onTap: () => _serviceArea(context, ref),
          ),
          _Step(
            step: OnboardingStep.kyc,
            isDone: progress.hasSubmittedKyc,
            isNext: progress.nextStep == OnboardingStep.kyc,
            description: l10n.onboardingKycBody,
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
                    l10n.onboardingReviewNotice,
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
        showFailure(context, context.l10n.onboardingTradesLoadFailed);
      }
      return;
    }
    if (services.isEmpty) {
      if (context.mounted) {
        showFailure(context, context.l10n.onboardingTradesLoadFailed);
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
            Text(sheetContext.l10n.onboardingMainTrade,
                style: AppTypography.titleLarge
                    .copyWith(color: sheetContext.ink)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              sheetContext.l10n.onboardingMainTradeBody,
              style: AppTypography.bodySmall
                  .copyWith(color: sheetContext.inkSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final service in services)
              ListTile(
                title: Text(localizedServiceName(sheetContext.l10n, service.name)),
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
      (_) => showSuccess(
          context,
          context.l10n.onboardingTradeSet(
              localizedServiceName(context.l10n, chosen.name))),
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
                Text(builderContext.l10n.onboardingTravelTitle,
                    style: AppTypography.headlineMedium
                        .copyWith(color: builderContext.ink)),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  builderContext.l10n.onboardingTravelBody,
                  style: AppTypography.bodyMedium
                      .copyWith(color: builderContext.inkSecondary),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(builderContext.l10n.distanceKm('${radius.round()}'),
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
                    Text(builderContext.l10n.distanceKm('1'),
                        style: AppTypography.bodySmall
                            .copyWith(color: builderContext.inkTertiary)),
                    Text(builderContext.l10n.distanceKm('50'),
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
                  builderContext.l10n.onboardingTravelCentre,
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
                              error = builderContext.l10n.onboardingLocationOff;
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
                      : Text(builderContext.l10n.commonSave),
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
        context.l10n.notificationsStayOff,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_needed) return const SizedBox.shrink();
    final l10n = context.l10n;

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
                  child: Text(l10n.notificationsPrimerTitle,
                      style:
                          AppTypography.titleMedium.copyWith(color: context.ink)),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.notificationsPrimerBody,
              style:
                  AppTypography.bodySmall.copyWith(color: context.inkSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                BusyFilledButton(
                  label: l10n.notificationsTurnOn,
                  busy: _busy,
                  onPressed: _enable,
                ),
                const SizedBox(width: AppSpacing.sm),
                TextButton(
                  onPressed:
                      _busy ? null : () => setState(() => _needed = false),
                  child: Text(l10n.commonNotNow),
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
    final l10n = context.l10n;
    setState(() {
      _cityError = city.length < 2 ? l10n.onboardingCityRequired : null;
      // Indian PIN codes are six digits and never start with 0.
      _pincodeError = RegExp(r'^[1-9][0-9]{5}$').hasMatch(pincode)
          ? null
          : l10n.profilePinInvalid;
      _genderError = _gender == null ? l10n.onboardingGenderRequired : null;
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
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.onboardingWhereBased,
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
                    InputDecoration(labelText: l10n.profileCity, errorText: _cityError),
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
                  labelText: l10n.profilePin,
                  counterText: '',
                  errorText: _pincodeError,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.profileGender,
                  style: AppTypography.label.copyWith(color: context.inkSecondary)),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  for (final option in [
                    ('MALE', l10n.genderMale),
                    ('FEMALE', l10n.genderFemale),
                    ('OTHER', l10n.genderOther),
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
                label: l10n.commonSave,
                busy: _isSaving,
                busyLabel: l10n.commonSaving,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
