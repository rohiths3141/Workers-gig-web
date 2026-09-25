import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/app_localizations.dart';

/// The languages this app ships: English and the 22 languages of the Eighth
/// Schedule of the Constitution.
///
/// The previous project advertised a 23-language catalogue of which only a
/// handful were meaningfully translated, which is worse than offering fewer
/// honestly: a worker who picks their language and finds half the app in
/// English has been misled. So every language here carries every string in
/// the app, and the l10n completeness test fails the build otherwise.
///
/// Order is English, Hindi, then the rest alphabetically by English name,
/// which is how most Indian apps list them and what people scan for.
enum AppLocale {
  english('en', 'English', 'English'),
  hindi('hi', 'हिन्दी', 'Hindi'),
  assamese('as', 'অসমীয়া', 'Assamese'),
  bengali('bn', 'বাংলা', 'Bengali'),
  bodo('brx', 'बड़ो', 'Bodo', widgetFallback: 'hi'),
  dogri('doi', 'डोगरी', 'Dogri', widgetFallback: 'hi'),
  gujarati('gu', 'ગુજરાતી', 'Gujarati'),
  kannada('kn', 'ಕನ್ನಡ', 'Kannada'),
  kashmiri('ks', 'کٲشُر', 'Kashmiri', widgetFallback: 'ur'),
  konkani('kok', 'कोंकणी', 'Konkani', widgetFallback: 'mr'),
  maithili('mai', 'मैथिली', 'Maithili', widgetFallback: 'hi'),
  malayalam('ml', 'മലയാളം', 'Malayalam'),
  manipuri('mni', 'ꯃꯩꯇꯩꯂꯣꯟ', 'Manipuri', widgetFallback: 'en'),
  marathi('mr', 'मराठी', 'Marathi'),
  nepali('ne', 'नेपाली', 'Nepali'),
  odia('or', 'ଓଡ଼ିଆ', 'Odia'),
  punjabi('pa', 'ਪੰਜਾਬੀ', 'Punjabi'),
  sanskrit('sa', 'संस्कृतम्', 'Sanskrit', widgetFallback: 'hi'),
  santali('sat', 'ᱥᱟᱱᱛᱟᱲᱤ', 'Santali', widgetFallback: 'en'),
  sindhi('sd', 'سنڌي', 'Sindhi', widgetFallback: 'ur'),
  tamil('ta', 'தமிழ்', 'Tamil'),
  telugu('te', 'తెలుగు', 'Telugu'),
  urdu('ur', 'اردو', 'Urdu');

  const AppLocale(
    this.code,
    this.nativeName,
    this.englishName, {
    this.widgetFallback,
  });

  final String code;

  /// The language's name in its own script — what the picker leads with, so
  /// a worker who cannot read English can still find their language.
  final String nativeName;
  final String englishName;

  /// Flutter ships its own widget strings (date picker, text selection menu,
  /// tooltips) and text direction for 13 of the 22 languages. For the other
  /// nine this names the language those widgets borrow instead: one the reader
  /// is likely to also read, in the same direction — Urdu for the Perso-Arabic
  /// scripts, Hindi or Marathi for Devanagari.
  final String? widgetFallback;

  Locale get locale => Locale(code);

  static AppLocale fromCode(String? code) => AppLocale.values.firstWhere(
        (l) => l.code == code,
        orElse: () => AppLocale.english,
      );

  /// The first of the phone's languages this app ships, or English.
  static AppLocale fromSystem(List<Locale> systemLocales) {
    for (final system in systemLocales) {
      for (final locale in AppLocale.values) {
        if (locale.code == system.languageCode) return locale;
      }
    }
    return AppLocale.english;
  }

  static List<Locale> get supportedLocales =>
      AppLocale.values.map((l) => l.locale).toList(growable: false);

  /// Locale codes whose Flutter widget strings come from another language.
  static final Map<String, String> widgetFallbacks = {
    for (final l in AppLocale.values)
      if (l.widgetFallback != null) l.code: l.widgetFallback!,
  };
}

/// The strings for the language on screen, for code that has no
/// [BuildContext]: failure messages, domain labels and controllers.
///
/// Widgets use `context.l10n` instead, which also rebuilds them when the
/// language changes.
abstract final class AppStrings {
  static AppLocalizations _current =
      lookupAppLocalizations(AppLocale.english.locale);

  static AppLocalizations get current => _current;

  static void use(AppLocale locale) =>
      _current = lookupAppLocalizations(locale.locale);
}

/// The language the app starts in. Overridden in `main` with the saved choice,
/// read before the first frame so the app never flashes in English first.
final initialAppLocaleProvider = Provider<AppLocale>(
  (ref) => AppLocale.fromSystem(PlatformDispatcher.instance.locales),
);

/// The worker's chosen language, remembered across launches.
class LocaleController extends Notifier<AppLocale> {
  static const _key = 'app_locale';

  /// The saved choice, or the phone's language when nothing is saved yet.
  static Future<AppLocale> loadInitial() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_key);
      if (saved != null) return AppLocale.fromCode(saved);
    } catch (_) {
      // Unreadable preferences are not worth failing launch over.
    }
    return AppLocale.fromSystem(PlatformDispatcher.instance.locales);
  }

  @override
  AppLocale build() {
    final initial = ref.watch(initialAppLocaleProvider);
    AppStrings.use(initial);
    return initial;
  }

  Future<void> setLocale(AppLocale locale) async {
    AppStrings.use(locale);
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.code);
  }
}

final localeControllerProvider =
    NotifierProvider<LocaleController, AppLocale>(LocaleController.new);
