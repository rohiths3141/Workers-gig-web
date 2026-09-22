import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The languages this app ships.
///
/// Three, not twenty-three. The previous project advertised a 23-language
/// catalogue of which only a handful were meaningfully translated, which is
/// worse than offering fewer honestly: a worker who picks their language and
/// finds half the app in English has been misled.
///
/// [isFullyTranslated] is the flag that keeps this honest, and the language
/// picker shows it.
enum AppLocale {
  english('en', 'English', 'English', true),
  tamil('ta', 'தமிழ்', 'Tamil', false),
  hindi('hi', 'हिन्दी', 'Hindi', false);

  const AppLocale(
    this.code,
    this.nativeName,
    this.englishName,
    this.isFullyTranslated,
  );

  final String code;
  final String nativeName;
  final String englishName;

  /// Whether every string in the app exists in this language. When false the
  /// UI says so, and untranslated strings fall back to English.
  final bool isFullyTranslated;

  Locale get locale => Locale(code);

  static AppLocale fromCode(String? code) => AppLocale.values.firstWhere(
        (l) => l.code == code,
        orElse: () => AppLocale.english,
      );

  static List<Locale> get supportedLocales =>
      AppLocale.values.map((l) => l.locale).toList(growable: false);
}

/// The worker's chosen language, remembered across launches.
class LocaleController extends Notifier<AppLocale> {
  static const _key = 'app_locale';
  SharedPreferences? _prefs;

  @override
  AppLocale build() {
    _restore();
    return AppLocale.english;
  }

  Future<void> _restore() async {
    _prefs = await SharedPreferences.getInstance();
    final saved = _prefs?.getString(_key);
    if (saved != null) state = AppLocale.fromCode(saved);
  }

  Future<void> setLocale(AppLocale locale) async {
    state = locale;
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setString(_key, locale.code);
  }
}

final localeControllerProvider =
    NotifierProvider<LocaleController, AppLocale>(LocaleController.new);
