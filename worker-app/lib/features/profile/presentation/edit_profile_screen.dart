import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/providers/session_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/gig.dart';
import '../../../domain/entities/worker.dart';
import '../../../shared/widgets/common_widgets.dart';
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
      setState(() => _pincodeError = 'Enter a valid 6-digit PIN code');
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
        showSuccess(context, 'Profile updated.');
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
      (_) => showSuccess(context, 'Photo updated.'),
      (failure) => showFailure(context, failure.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final worker = ref.watch(currentWorkerProvider);
    final skills = ref.watch(skillsProvider);
    final services = ref.watch(allServicesProvider);

    if (worker == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    _hydrate(worker);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
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
                        label: const Text('Change photo'),
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
                      DetailRow(label: 'Name', value: worker.fullName),
                      DetailRow(label: 'Phone', value: worker.phone),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Your name and number are linked to your identity check. Contact support if either needs to change.',
                        style: AppTypography.bodySmall
                            .copyWith(color: context.inkTertiary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                Text('About you',
                    style:
                        AppTypography.titleMedium.copyWith(color: context.ink)),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _bio,
                  maxLines: 4,
                  maxLength: 400,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText:
                        'Tell customers about your experience and what you are good at.',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _experience,
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Years of experience',
                    counterText: '',
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                Text('Where you are based',
                    style:
                        AppTypography.titleMedium.copyWith(color: context.ink)),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _address,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _city,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(labelText: 'City'),
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
                          labelText: 'PIN code',
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
                Text('Gender',
                    style: AppTypography.label
                        .copyWith(color: context.inkSecondary)),
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
                        onSelected: (_) =>
                            setState(() => _gender = option.$1),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // Multiple trades, added one at a time, each needing approval.
                // This is what makes multiple gigs possible: the worker's trade
                // list is a set, never a single value.
                Text('Your trades',
                    style:
                        AppTypography.titleMedium.copyWith(color: context.ink)),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'You can work in as many trades as you are approved for.',
                  style: AppTypography.bodySmall
                      .copyWith(color: context.inkSecondary),
                ),
                const SizedBox(height: AppSpacing.md),

                skills.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => Text(
                    'Your trades could not be loaded.',
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
                                  child: Text(skill.serviceName,
                                      style: AppTypography.bodyLarge
                                          .copyWith(color: context.ink)),
                                ),
                                StatusBadge(
                                  label:
                                      skill.isApproved ? 'APPROVED' : 'PENDING',
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
                            label: const Text('Add a trade'),
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
                label: 'Save changes',
                busy: _busy,
                busyLabel: 'Saving…',
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
            Text('Add a trade',
                style: AppTypography.titleLarge
                    .copyWith(color: sheetContext.ink)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'We may ask for proof of your skills before approving it.',
              style: AppTypography.bodySmall
                  .copyWith(color: sheetContext.inkSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final service in available)
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

    final result =
        await ref.read(profileControllerProvider.notifier).addSkill(chosen.id);

    if (!context.mounted) return;
    result.fold(
      (_) => showSuccess(
        context,
        'Requested. We will let you know once it is approved.',
      ),
      (failure) => showFailure(context, failure.message),
    );
  }
}
