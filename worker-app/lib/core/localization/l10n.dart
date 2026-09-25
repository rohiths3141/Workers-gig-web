import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';

export '../../l10n/app_localizations.dart';
export 'app_locale.dart';

extension L10nContext on BuildContext {
  /// This app's strings in the language on screen.
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// The locale to format dates in. See [dateLocaleFor].
  String? get dateLocale => dateLocaleFor(l10n.localeName);
}

/// The app's language where intl has date names for it, otherwise null —
/// intl's default, which is always loaded.
String? dateLocaleFor(String localeName) =>
    DateFormat.localeExists(localeName) ? localeName : null;

/// Every delegate the app needs. Flutter's own widget strings (date picker,
/// text selection menu, tooltips) cover every language the app ships.
const List<LocalizationsDelegate<dynamic>> appLocalizationsDelegates = [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];
