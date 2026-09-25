import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/providers/session_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/localization/l10n.dart';
import '../../../domain/entities/gig.dart';
import '../../../domain/entities/worker.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../../shared/widgets/service_names.dart';
import 'profile_controller.dart';

/// Editing the profile.
///
/// Only the fields a worker owns. Their name and phone are shown but not
/// editable here: both are tied to identity verification, and letting someone
/// change the name on a verified profile would undo the check. Changing them is
/// a support request, and the screen says so instead of silently omitting them.
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _bio = TextEditingController();
  final _experience = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _pincode = TextEditingController();

  String? _gender;
  bool _loaded = false;
  bool _busy = false;

  @override
  void dispose() {
    _bio.dispose();
    _experience.dispose();
    _address.dispose();
    _city.dispose();
    _state.dispose();
    _pincode.dispose();
    super.dispose();
  }

  void _hydrate(Worker worker) {
    if (_loaded) return;
    _loaded = true;
    _bio.text = worker.bio ?? '';
    _experience.text = worker.experienceYears.toString();
    _address.text = worker.addressLine ?? '';
    _city.text = worker.city ?? '';
    _state.text = worker.state ?? '';
    _pincode.text = worker.pincode ?? '';
    _gender = worker.gender;
  }

  String? _pincodeError;

  Future<void> _save() async {
    final pincode = _pincode.text.trim();
    // Empty is allowed here (the field is optional after onboarding), but a
    // partial PIN code is not: it silently breaks job matching.
    if (pincode.isNotEmpty && !RegExp(r'^[1-9][0-9]{5}$').hasMatch(pincode)) {
      setState(() => _pincodeError = context.l10n.profilePinInvalid);
      return;
    }
    setState(() {
      _busy = true;
      _pincodeError = null;
    });

    final result = await ref.read(profileControllerProvider.notifier).updateDetails(
          bio: _bio.text,
          experienceYears: int.tryParse(_experience.text.trim()),
          addressLine: _address.text,
          city: _city.text,
          state: _state.text,
          pincode: pincode,
          gender: _gender,
        );

    if (!mounted) return;
    setState(() => _busy = false);

    result.fold(
      (_) {
        Navigator.of(context).pop();
        showSuccess(context, context.l10n.profileUpdated);
      },
      (failure) => showFailure(context, failure.message),
    );
  }

  Future<void> _changePhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 88,
      maxWidth: 1200,
    );
    if (picked == null || !mounted) return;

    setState(() => _busy = true);
    final result = await ref
        .read(profileControllerProvider.notifier)
        .updatePhoto(File(picked.path));

    if (!mounted) return;
    setState(() => _busy = false);

    result.fold(
      (_) => showSuccess(context, context.l10n.profilePhotoUpdated),
      (failure) => showFailure(context, failure.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final worker = ref.watch(currentWorkerProvider);
    final skills = ref.watch(skillsProvider);
    final services = ref.watch(allServicesProvider);

    if (worker == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    _hydrate(worker);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileEdit)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              children: [
                Center(
                  child: Column(
                    children: [
                      WorkerAvatar(
                        name: worker.fullName,
                        photoUrl: worker.profilePhotoUrl,
                        size: 96,
                      ),
                      TextButton.icon(
                        onPressed: _busy ? null : _changePhoto,
                        icon: const Icon(Icons.photo_camera_outlined, size: 20),
                        label: Text(l10n.profileChangePhoto),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                AppCard(
                  backgroundColor: context.surfaceMuted,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailRow(label: l10n.profileName, value: worker.fullName),
                      DetailRow(label: l10n.profilePhone, value: worker.phone),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        l10n.profileLockedNotice,
                        style: AppTypography.bodySmall
                            .copyWith(color: context.inkTertiary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                Text(l10n.profileAbout,
                    style:
                        AppTypography.titleMedium.copyWith(color: context.ink)),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _bio,
                  maxLines: 4,
                  maxLength: 400,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: l10n.profileBioHint,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _experience,
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: l10n.profileYearsExperience,
                    counterText: '',
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                Text(l10n.profileBased,
                    style:
                        AppTypography.titleMedium.copyWith(color: context.ink)),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _address,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: l10n.profileAddress),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _city,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(labelText: l10n.profileCity),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextField(
                        controller: _pincode,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          labelText: l10n.profilePin,
                          counterText: '',
                          errorText: _pincodeError,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Set during onboarding and then unreachable: a worker who
                // picked the wrong chip had no way to correct it.
                Text(l10n.profileGender,
                    style: AppTypography.label
                        .copyWith(color: context.inkSecondary)),
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
                        onSelected: (_) =>
                            setState(() => _gender = option.$1),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // Multiple trades, added one at a time, each needing approval.
                // This is what makes multiple gigs possible: the worker's trade
                // list is a set, never a single value.
                Text(l10n.profileTrades,
                    style:
                        AppTypography.titleMedium.copyWith(color: context.ink)),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  l10n.profileTradesBody,
                  style: AppTypography.bodySmall
                      .copyWith(color: context.inkSecondary),
                ),
                const SizedBox(height: AppSpacing.md),

                skills.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => Text(
                    l10n.profileTradesLoadFailed,
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.danger),
                  ),
                  data: (items) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final skill in items)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: AppCard(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(localizedServiceName(l10n, skill.serviceName),
                                      style: AppTypography.bodyLarge
                                          .copyWith(color: context.ink)),
                                ),
                                StatusBadge(
                                  label: skill.isApproved
                                      ? l10n.materialStatusApproved
                                      : l10n.tradePending,
                                  color: skill.isApproved
                                      ? AppColors.success
                                      : AppColors.warning,
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: AppSpacing.sm),
                      services.maybeWhen(
                        data: (all) {
                          final taken =
                              items.map((s) => s.serviceId).toSet();
                          final available = all
                              .where((s) => !taken.contains(s.id))
                              .toList(growable: false);

                          if (available.isEmpty) return const SizedBox.shrink();

                          return OutlinedButton.icon(
                            onPressed: () =>
                                _addTrade(context, ref, available),
                            icon: const Icon(Icons.add_rounded),
                            label: Text(l10n.profileAddTrade),
                          );
                        },
                        orElse: () => const SizedBox.shrink(),
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
            child: SizedBox(
              height: AppSpacing.primaryActionHeight,
              width: double.infinity,
              child: BusyFilledButton(
                label: l10n.profileSave,
                busy: _busy,
                busyLabel: l10n.commonSaving,
                onPressed: _save,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addTrade(
    BuildContext context,
    WidgetRef ref,
    List<ServiceCategory> available,
  ) async {
    final chosen = await showModalBottomSheet<ServiceCategory>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(sheetContext.l10n.profileAddTrade,
                style: AppTypography.titleLarge
                    .copyWith(color: sheetContext.ink)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              sheetContext.l10n.profileAddTradeBody,
              style: AppTypography.bodySmall
                  .copyWith(color: sheetContext.inkSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final service in available)
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

    final result =
        await ref.read(profileControllerProvider.notifier).addSkill(chosen.id);

    if (!context.mounted) return;
    result.fold(
      (_) => showSuccess(
        context,
        context.l10n.profileTradeRequested,
      ),
      (failure) => showFailure(context, failure.message),
    );
  }
}
