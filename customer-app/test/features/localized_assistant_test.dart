import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wervexa_customer/app/providers/providers.dart';
import 'package:wervexa_customer/core/errors/result.dart';
import 'package:wervexa_customer/core/localization/l10n.dart';
import 'package:wervexa_customer/domain/entities/service_category.dart';
import 'package:wervexa_customer/domain/entities/service_problem.dart';
import 'package:wervexa_customer/domain/repositories/repositories.dart';
import 'package:wervexa_customer/features/assistant/assistant_screen.dart';
import 'package:wervexa_customer/shared/widgets/language_picker.dart';

import '../fixtures/catalogue_rows.dart';

/// The assistant in the customer's own language.
///
/// The completeness test proves every string exists; this proves a customer
/// actually sees them: a screen they reach first renders in each language,
/// the answer it gives names the service in that language, and picking Urdu
/// from the language sheet turns the screen right to left on the spot.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Widget app({AppLocale initial = AppLocale.english}) {
    return ProviderScope(
      overrides: [
        initialAppLocaleProvider.overrideWithValue(initial),
        catalogueRepositoryProvider.overrideWithValue(_StubCatalogue()),
      ],
      child: Consumer(
        builder: (context, ref, _) => MaterialApp(
          locale: ref.watch(localeControllerProvider).locale,
          supportedLocales: AppLocale.supportedLocales,
          localizationsDelegates: appLocalizationsDelegates,
          home: const AssistantScreen(),
        ),
      ),
    );
  }

  TextDirection directionOf(WidgetTester tester) =>
      Directionality.of(tester.element(find.byType(AssistantScreen)));

  for (final locale in AppLocale.values) {
    testWidgets('opens in ${locale.englishName}', (tester) async {
      await tester.pumpWidget(app(initial: locale));
      await tester.pumpAndSettle();

      final l10n = lookupAppLocalizations(locale.locale);
      expect(find.text(l10n.assistantTitle), findsOneWidget);
      expect(find.text(l10n.assistantOpening), findsOneWidget);
      expect(
        directionOf(tester),
        locale == AppLocale.urdu ? TextDirection.rtl : TextDirection.ltr,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('answers with the service named in Hindi', (tester) async {
    await tester.pumpWidget(app(initial: AppLocale.hindi));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byType(TextField), 'water is leaking under my sink');
    await tester.testTextInput.receiveAction(TextInputAction.send);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    final hindi = lookupAppLocalizations(AppLocale.hindi.locale);
    expect(find.text(hindi.servicePlumbing), findsWidgets);
    expect(find.text(hindi.assistantFindWorkers), findsOneWidget);
    expect(find.text('Plumbing'), findsNothing);
  });

  testWidgets('picking Urdu turns the app right to left', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(directionOf(tester), TextDirection.ltr);

    showLanguagePicker(tester.element(find.byType(AssistantScreen)));
    await tester.pumpAndSettle();
    final urduOption = find.text(AppLocale.urdu.nativeName);
    // The sheet builds its rows lazily; Urdu is last.
    await tester.scrollUntilVisible(
      urduOption,
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(urduOption);
    await tester.pumpAndSettle();

    final urdu = lookupAppLocalizations(AppLocale.urdu.locale);
    expect(find.text(urdu.assistantTitle), findsOneWidget);
    expect(find.text(urdu.assistantInputHint), findsOneWidget);
    // What was already said stays as it was said, like any chat.
    expect(
      find.text(lookupAppLocalizations(AppLocale.english.locale)
          .assistantOpening),
      findsOneWidget,
    );
    expect(directionOf(tester), TextDirection.rtl);
    expect(AppStrings.current.localeName, 'ur');

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('app_locale'), 'ur');
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
