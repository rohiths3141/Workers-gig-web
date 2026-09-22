import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_worker/app/providers/providers.dart';
import 'package:wervexa_worker/core/errors/app_failure.dart';
import 'package:wervexa_worker/core/errors/result.dart';
import 'package:wervexa_worker/domain/entities/enums.dart';
import 'package:wervexa_worker/domain/entities/verification.dart';
import 'package:wervexa_worker/domain/repositories/repositories.dart';
import 'package:wervexa_worker/features/verification/presentation/kyc_screen.dart';

/// How fast the identity page learns the answer.
///
/// The decision is made server-side, from what DigiLocker actually returned,
/// and reaches this screen two ways:
///
///   * the poll, which is what makes the server *ask* MessageCentral at all;
///   * `worker_verifications` over Realtime, which is what the server writes
///     the decision to — already in the `supabase_realtime` publication.
///
/// The poll used to wait a flat six seconds before its **first** check, so a
/// worker who came back from a finished consent journey watched a spinner with
/// the answer already sitting on the server. And nothing listened to Realtime
/// here, so a decision landing after the poll window closed left the screen
/// saying "still waiting" until it was reopened.
void main() {
  late _FakeVerificationRepository repository;

  setUp(() => repository = _FakeVerificationRepository());

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          verificationRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: KycScreen()),
      ),
    );
    await tester.pump();
  }

  /// Drives the screen to the point where it is checking with the provider,
  /// exactly as returning from the DigiLocker browser does.
  Future<void> startAndReturnFromConsent(WidgetTester tester) async {
    await tester.tap(find.text('Verify with DigiLocker'));
    // The consent URL is issued and the browser would open here; url_launcher
    // is a no-op under test, which is fine — what matters is what the screen
    // does when the worker comes back.
    await tester.pump();

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
  }

  group('The identity page', () {
    testWidgets('asks the server immediately on return, not after a wait',
        (tester) async {
      await pumpScreen(tester);
      await startAndReturnFromConsent(tester);

      // No timer advanced: the very first check must already have gone out.
      await tester.pump();

      expect(repository.statusChecks, greaterThanOrEqualTo(1),
          reason: 'A worker back from a finished consent journey should not '
              'wait on a timer for a result the server already has');

      await tester.pumpAndSettle(const Duration(seconds: 1));
    });

    testWidgets('shows approval as soon as the server says so', (tester) async {
      repository.statusOutcome = DigilockerOutcome.approved;

      await pumpScreen(tester);
      await startAndReturnFromConsent(tester);
      await tester.pump();

      expect(find.text('Your identity is verified.'), findsOneWidget);
    });

    testWidgets('shows a rejection with the server\'s own reason',
        (tester) async {
      repository.statusOutcome = DigilockerOutcome.rejected;
      repository.rejectionReason =
          'The name on your Aadhaar does not match your registered name.';

      await pumpScreen(tester);
      await startAndReturnFromConsent(tester);
      await tester.pump();

      expect(
        find.text('The name on your Aadhaar does not match your registered name.'),
        findsOneWidget,
      );
      expect(find.text('Try again'), findsOneWidget);
    });

    testWidgets('lands a decision that arrives over Realtime alone',
        (tester) async {
      // The provider is still saying PENDING — this outcome reaches the screen
      // only because the server wrote it to worker_verifications.
      repository.statusOutcome = DigilockerOutcome.pending;

      await pumpScreen(tester);
      await startAndReturnFromConsent(tester);
      await tester.pump();
      expect(find.text('Your identity is verified.'), findsNothing);

      repository.emitVerification(VerificationStatus.approved);
      await tester.pump();
      await tester.pump();

      expect(find.text('Your identity is verified.'), findsOneWidget,
          reason: 'worker_verifications is in the realtime publication; a '
              'decision written there must not wait for the next poll tick');

      await tester.pumpAndSettle(const Duration(seconds: 1));
    });

    testWidgets('stops polling once the decision has landed', (tester) async {
      repository.statusOutcome = DigilockerOutcome.pending;

      await pumpScreen(tester);
      await startAndReturnFromConsent(tester);
      await tester.pump();

      repository.emitVerification(VerificationStatus.approved);
      await tester.pump();
      await tester.pump();

      final checksAtDecision = repository.statusChecks;
      await tester.pump(const Duration(seconds: 30));

      expect(repository.statusChecks, checksAtDecision,
          reason: 'A settled case must not keep asking the provider');
    });

    testWidgets('surfaces a provider outage instead of spinning forever',
        (tester) async {
      // What a wrong, expired or out-of-credit MessageCentral key looks like
      // from here: the function answers 502 with its own wording.
      repository.initFailure = const ServerFailure(
        message: 'DigiLocker verification is unavailable right now. '
            'Please try again later.',
      );

      await pumpScreen(tester);
      await tester.tap(find.text('Verify with DigiLocker'));
      await tester.pump();

      expect(
        find.text('DigiLocker verification is unavailable right now. '
            'Please try again later.'),
        findsOneWidget,
      );
    });
  });
}

// ---------------------------------------------------------------------------
// Fake
// ---------------------------------------------------------------------------

class _FakeVerificationRepository implements VerificationRepository {
  final _cases = StreamController<List<VerificationCase>>.broadcast();

  int statusChecks = 0;
  DigilockerOutcome statusOutcome = DigilockerOutcome.pending;
  String? rejectionReason;
  AppFailure? initFailure;

  void emitVerification(VerificationStatus status) {
    _cases.add([
      VerificationCase(
        type: VerificationType.identityKyc,
        status: status,
        id: 'case-1',
        rejectionReason: rejectionReason,
      ),
    ]);
  }

  @override
  Stream<List<VerificationCase>> watchVerifications() => _cases.stream;

  @override
  Future<Result<String?>> startDigilockerKyc() async {
    final failure = initFailure;
    if (failure != null) return Err(failure);
    return const Ok('https://consent.example.test/digilocker/session');
  }

  @override
  Future<Result<DigilockerStatus>> checkDigilockerStatus() async {
    statusChecks++;
    return Ok(DigilockerStatus(statusOutcome, reason: rejectionReason));
  }

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
