import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_worker/app/providers/session_controller.dart';

/// Onboarding progress is derived from server state, never from a local step
/// counter — so a reinstall resumes where the worker left off, and clearing app
/// data cannot skip a step.
///
/// The old wizard had seven steps of which only two persisted. These tests pin
/// down what "complete" means and, importantly, what it does not include.
void main() {
  OnboardingProgress progress({
    bool basics = false,
    bool trade = false,
    bool skills = false,
    bool area = false,
    bool kyc = false,
  }) =>
      OnboardingProgress(
        hasBasicProfile: basics,
        hasTrade: trade,
        hasSkills: skills,
        hasServiceArea: area,
        hasSubmittedKyc: kyc,
      );

  group('Completion', () {
    test('a brand-new worker has done nothing', () {
      final p = progress();
      expect(p.completedSteps, 0);
      expect(p.fraction, 0);
      expect(p.isComplete, isFalse);
      expect(p.nextStep, OnboardingStep.basicProfile);
    });

    test('is complete once the worker has done their part', () {
      final p = progress(
          basics: true, trade: true, skills: true, area: true, kyc: true);

      expect(p.isComplete, isTrue);
      expect(p.fraction, 1.0);
      expect(p.nextStep, OnboardingStep.review);
    });

    test('completion means SUBMITTED, not APPROVED', () {
      // A worker who has uploaded everything asked of them is done. Blocking
      // the app on somebody else's review queue would be both wrong and
      // infuriating — they should be building gigs while they wait.
      final p = progress(
          basics: true, trade: true, skills: true, area: true, kyc: true);

      expect(p.isComplete, isTrue,
          reason: 'Onboarding must not wait on an admin decision');
    });
  });

  group('Resume point', () {
    test('points at the first unfinished step, in order', () {
      expect(progress().nextStep, OnboardingStep.basicProfile);
      expect(progress(basics: true).nextStep, OnboardingStep.trade);
      expect(progress(basics: true, trade: true).nextStep, OnboardingStep.skills);
      expect(
        progress(basics: true, trade: true, skills: true).nextStep,
        OnboardingStep.serviceArea,
      );
      expect(
        progress(basics: true, trade: true, skills: true, area: true).nextStep,
        OnboardingStep.kyc,
      );
    });

    test('a later step being done does not skip an earlier gap', () {
      // Someone who did KYC first still has to go back and set their trade.
      final p = progress(kyc: true);
      expect(p.nextStep, OnboardingStep.basicProfile);
      expect(p.isComplete, isFalse);
      expect(p.completedSteps, 1);
    });
  });

  group('Progress fraction', () {
    test('counts steps out of the real total', () {
      expect(progress(basics: true).fraction, 1 / OnboardingProgress.totalSteps);
      expect(
        progress(basics: true, trade: true, skills: true).fraction,
        3 / OnboardingProgress.totalSteps,
      );
    });

    test('the total matches the number of steps actually checked', () {
      expect(OnboardingProgress.totalSteps, 5);
    });
  });
}
