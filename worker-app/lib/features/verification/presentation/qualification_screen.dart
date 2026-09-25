import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/localization/l10n.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/verification.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../evidence/presentation/evidence_controller.dart';
import '../../evidence/presentation/evidence_section.dart';
import 'verification_controller.dart';

/// Qualifications and skill assessment.
///
/// Covers the ITI and diploma route, and the Recognition of Prior Learning
/// route for workers who learned on the job rather than in a classroom — which
/// is most of this trade. RPL is explained rather than assumed: a worker who has
/// never heard of it should be able to find out what it is from this screen.
class QualificationScreen extends ConsumerStatefulWidget {
  const QualificationScreen({super.key});

  @override
  ConsumerState<QualificationScreen> createState() =>
      _QualificationScreenState();
}

class _QualificationScreenState extends ConsumerState<QualificationScreen> {
  final _institution = TextEditingController();
  final _qualification = TextEditingController();
  final _specialisation = TextEditingController();
  final _year = TextEditingController();

  VerificationType _type = VerificationType.itiCertificate;
  Map<String, String> _errors = const {};
  bool _busy = false;

  @override
  void dispose() {
    _institution.dispose();
    _qualification.dispose();
    _specialisation.dispose();
    _year.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final qualification = Qualification(
      type: _type,
      status: VerificationStatus.notSubmitted,
      institution: _institution.text.trim(),
      qualificationName: _qualification.text.trim(),
      specialisation: _specialisation.text.trim().isEmpty
          ? null
          : _specialisation.text.trim(),
      yearOfPassing: int.tryParse(_year.text.trim()),
    );

    final errors = qualification.validate();
    if (errors.isNotEmpty) {
      setState(() => _errors = errors);
      return;
    }

    setState(() {
      _busy = true;
      _errors = const {};
    });

    final result = await ref
        .read(verificationControllerProvider.notifier)
        .submitQualification(qualification);

    if (!mounted) return;
    setState(() => _busy = false);

    result.fold(
      (_) {
        Navigator.of(context).pop();
        showSuccess(context, context.l10n.qualSubmitted);
      },
      (failure) => showFailure(context, failure.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const target = EvidenceTarget(purpose: MediaPurpose.workerQualification);
    final uploaded =
        ref.watch(evidenceAssetsProvider(target)).valueOrNull ?? const [];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.qualTitle)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              children: [
                SegmentedButton<VerificationType>(
                  segments: [
                    ButtonSegment(
                      value: VerificationType.itiCertificate,
                      label: Text(l10n.qualIti),
                    ),
                    ButtonSegment(
                      value: VerificationType.diploma,
                      label: Text(l10n.verifyDiploma),
                    ),
                  ],
                  selected: {_type},
                  onSelectionChanged: (selected) =>
                      setState(() => _type = selected.first),
                ),
                const SizedBox(height: AppSpacing.xl),

                TextField(
                  controller: _institution,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: l10n.qualInstitute,
                    hintText: l10n.qualInstituteHint,
                    errorText: _errors['institution'],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _qualification,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: l10n.qualName,
                    hintText: l10n.qualNameHint,
                    errorText: _errors['qualification'],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _specialisation,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: l10n.qualSpeciality,
                    hintText: l10n.qualSpecialityHint,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _year,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: l10n.qualYear,
                    errorText: _errors['year'],
                    counterText: '',
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                EvidenceSection(
                  target: target,
                  title: l10n.qualCertificate,
                  explanation: l10n.qualCertificateBody,
                  isRequired: true,
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
                onPressed: uploaded.isEmpty || _busy ? null : _submit,
                child: _busy
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Text(l10n.gigSubmitForReview),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
