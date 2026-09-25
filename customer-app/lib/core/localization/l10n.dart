import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import 'app_locale.dart';

export '../../l10n/app_localizations.dart';
export 'app_locale.dart';

extension L10nContext on BuildContext {
  /// This app's strings in the language on screen.
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// The locale to format dates in. See [dateLocaleFor].
  String? get dateLocale => dateLocaleFor(l10n.localeName);
}

/// The app's language where intl has date names for it, otherwise the
/// language its Flutter widgets borrow, otherwise null — intl's default,
/// which is always loaded.
String? dateLocaleFor(String localeName) {
  if (DateFormat.localeExists(localeName)) return localeName;
  final fallback = AppLocale.widgetFallbacks[localeName];
  if (fallback != null && DateFormat.localeExists(fallback)) return fallback;
  return null;
}

/// Every delegate the app needs, in the order Flutter consults them.
///
/// Flutter takes the first delegate of each type that supports the locale, so
/// the fallbacks at the end only answer for the nine languages Flutter's own
/// widget strings do not cover.
const List<LocalizationsDelegate<dynamic>> appLocalizationsDelegates = [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
  _FallbackMaterialLocalizations(),
  _FallbackWidgetsLocalizations(),
  _FallbackCupertinoLocalizations(),
];

Locale? _fallbackFor(Locale locale) {
  final code = AppLocale.widgetFallbacks[locale.languageCode];
  return code == null ? null : Locale(code);
}

class _FallbackMaterialLocalizations
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _FallbackMaterialLocalizations();

  @override
  bool isSupported(Locale locale) => _fallbackFor(locale) != null;

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      GlobalMaterialLocalizations.delegate.load(_fallbackFor(locale)!);

  @override
  bool shouldReload(_FallbackMaterialLocalizations old) => false;
}

class _FallbackWidgetsLocalizations
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const _FallbackWidgetsLocalizations();

  @override
  bool isSupported(Locale locale) => _fallbackFor(locale) != null;

  @override
  Future<WidgetsLocalizations> load(Locale locale) =>
      GlobalWidgetsLocalizations.delegate.load(_fallbackFor(locale)!);

  @override
  bool shouldReload(_FallbackWidgetsLocalizations old) => false;
}

class _FallbackCupertinoLocalizations
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _FallbackCupertinoLocalizations();

  @override
  bool isSupported(Locale locale) => _fallbackFor(locale) != null;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      GlobalCupertinoLocalizations.delegate.load(_fallbackFor(locale)!);

  @override
  bool shouldReload(_FallbackCupertinoLocalizations old) => false;
}
