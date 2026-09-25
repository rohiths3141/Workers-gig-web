import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wervexa_worker/core/localization/l10n.dart';
import 'package:wervexa_worker/features/settings/presentation/settings_screen.dart';

/// Picking a language changes the app there and then.
///
/// The completeness test proves every string exists; this proves a worker
/// actually sees them: the screen they are on redraws in the language they
/// tapped, Urdu lays out right to left, and the choice outlives a restart.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Widget app({AppLocale initial = AppLocale.english}) {
    return ProviderScope(
      overrides: [initialAppLocaleProvider.overrideWithValue(initial)],
      child: Consumer(
        builder: (context, ref, _) => MaterialApp(
          locale: ref.watch(localeControllerProvider).locale,
          supportedLocales: AppLocale.supportedLocales,
          localizationsDelegates: appLocalizationsDelegates,
          home: const SettingsScreen(),
        ),
      ),
    );
  }

  TextDirection directionOf(WidgetTester tester) =>
      Directionality.of(tester.element(find.byType(SettingsScreen)));

  Future<void> tapLanguage(WidgetTester tester, AppLocale locale) async {
    final option = find.text(locale.nativeName);
    await tester.ensureVisible(option);
    await tester.pumpAndSettle();
    await tester.tap(option);
    await tester.pumpAndSettle();
  }

  testWidgets('tapping a language redraws the screen in it', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    await tapLanguage(tester, AppLocale.hindi);

    final hindi = lookupAppLocalizations(AppLocale.hindi.locale);
    expect(find.text(hindi.settingsTitle), findsOneWidget);
    expect(find.text('Settings'), findsNothing);
    expect(directionOf(tester), TextDirection.ltr);
    // Code without a BuildContext follows along too.
    expect(AppStrings.current.localeName, 'hi');

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('app_locale'), 'hi');
    expect(await LocaleController.loadInitial(), AppLocale.hindi);
  });

  testWidgets('Urdu lays the app out right to left', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tapLanguage(tester, AppLocale.urdu);

    final urdu = lookupAppLocalizations(AppLocale.urdu.locale);
    expect(find.text(urdu.settingsTitle), findsOneWidget);
    expect(directionOf(tester), TextDirection.rtl);
  });

  for (final locale in AppLocale.values) {
    testWidgets('Settings renders in ${locale.englishName}', (tester) async {
      await tester.pumpWidget(app(initial: locale));
      await tester.pumpAndSettle();

      final l10n = lookupAppLocalizations(locale.locale);
      expect(find.text(l10n.settingsTitle), findsOneWidget);
      expect(find.text(l10n.settingsLanguage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
