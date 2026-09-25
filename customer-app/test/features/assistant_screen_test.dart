import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_customer/app/providers/providers.dart';
import 'package:wervexa_customer/core/errors/result.dart';
import 'package:wervexa_customer/core/localization/l10n.dart';
import 'package:wervexa_customer/domain/entities/service_category.dart';
import 'package:wervexa_customer/domain/entities/service_problem.dart';
import 'package:wervexa_customer/domain/repositories/repositories.dart';
import 'package:wervexa_customer/features/assistant/assistant_screen.dart';

import '../fixtures/catalogue_rows.dart';

/// The assistant screen, driven the way a customer drives it.
///
/// The matcher is tested on its own; what is checked here is the part a
/// customer actually meets: that typing a sentence produces a service they
/// can act on, that a question gets asked when the answer is unclear, and —
/// most importantly — that the screen never strands them with a spinner and
/// no way forward.
void main() {
  Widget harness({CatalogueRepository? catalogue}) {
    return ProviderScope(
      overrides: [
        catalogueRepositoryProvider.overrideWithValue(
          catalogue ?? _StubCatalogue(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: appLocalizationsDelegates,
        supportedLocales: AppLocale.supportedLocales,
        home: const AssistantScreen(),
      ),
    );
  }

  /// Types [message] and waits for the reply, including the deliberate pause
  /// before the assistant answers.
  Future<void> ask(WidgetTester tester, String message) async {
    await tester.enterText(find.byType(TextField), message);
    await tester.testTextInput.receiveAction(TextInputAction.send);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
  }

  testWidgets('opens with an invitation to describe the problem',
      (tester) async {
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    expect(find.textContaining("Tell me what's wrong"), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('a described problem comes back as a service to act on',
      (tester) async {
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    await ask(tester, 'water is leaking under my sink');

    // The customer's own words stay in the transcript.
    expect(find.text('water is leaking under my sink'), findsOneWidget);
    // And the answer is a service with something to tap, not just prose.
    expect(find.text('Plumbing'), findsOneWidget);
    expect(find.text('Find workers'), findsOneWidget);
    expect(find.text('Post a request'), findsOneWidget);
  });

  testWidgets('an unclear problem is asked about, not guessed at',
      (tester) async {
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    await ask(tester, 'seepage problem');

    expect(find.textContaining('Which is closer?'), findsOneWidget);
    expect(find.text('Plumbing'), findsWidgets);
    expect(find.text('Painting'), findsWidgets);
    // Nothing is actionable yet — the customer has not chosen.
    expect(find.text('Find workers'), findsNothing);
  });

  testWidgets('choosing from the shortlist produces the offer', (tester) async {
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();
    await ask(tester, 'seepage problem');

    await tester.tap(find.text('Painting').last);
    await tester.pumpAndSettle();

    expect(find.text('Find workers'), findsOneWidget);
  });

  testWidgets('a message it cannot place still offers the whole catalogue',
      (tester) async {
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    await ask(tester, 'I want to learn the guitar');

    expect(find.textContaining('could not place that'), findsOneWidget);
    // Every service is offered as a chip — the screen does not dead-end.
    expect(find.text('Carpentry'), findsOneWidget);
    expect(find.text('Cleaning'), findsOneWidget);
  });

  testWidgets('a catalogue failure is reported with a way to retry',
      (tester) async {
    // The screen must say the network failed. Reporting it as "no service
    // fits your problem" would be a claim about the platform, not the
    // connection — and would leave the customer with nothing to do.
    await tester.pumpWidget(harness(catalogue: _FailingCatalogue()));
    await tester.pumpAndSettle();

    await ask(tester, 'my tap is leaking');

    expect(find.text('Try again'), findsOneWidget);
    expect(find.textContaining('No internet connection'), findsOneWidget);
  });

  testWidgets('the typing indicator always resolves', (tester) async {
    await tester.pumpWidget(harness(catalogue: _FailingCatalogue()));
    await tester.pumpAndSettle();

    await ask(tester, 'my tap is leaking');

    // A stuck indicator is the one failure mode with no way out of it.
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isTrue);
  });

  testWidgets('starting over clears the conversation', (tester) async {
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();
    await ask(tester, 'water is leaking under my sink');
    expect(find.text('Plumbing'), findsOneWidget);

    await tester.tap(find.byTooltip('Start over'));
    await tester.pumpAndSettle();

    expect(find.text('water is leaking under my sink'), findsNothing);
    expect(find.text('Plumbing'), findsNothing);
    expect(find.textContaining("Tell me what's wrong"), findsOneWidget);
  });
}

class _StubCatalogue implements CatalogueRepository {
  @override
  Future<Result<List<ServiceCategory>>> getServices() async =>
      Ok(catalogueServices);

  @override
  Future<Result<List<ServiceProblem>>> getAllServiceProblems() async =>
      Ok(catalogueProblems);

  @override
  Future<Result<List<ServiceProblem>>> getServiceProblems(String serviceId) async =>
      Ok(catalogueProblems.where((p) => p.serviceId == serviceId).toList());
}

class _FailingCatalogue implements CatalogueRepository {
  @override
  Future<Result<List<ServiceCategory>>> getServices() async =>
      const Err(NetworkFailure());

  @override
  Future<Result<List<ServiceProblem>>> getAllServiceProblems() async =>
      const Err(NetworkFailure());

  @override
  Future<Result<List<ServiceProblem>>> getServiceProblems(String serviceId) async =>
      const Err(NetworkFailure());
}
