import 'dart:convert';
import 'dart:io';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:wervexa_customer/core/localization/l10n.dart';

/// Every language the app offers carries every string in it.
///
/// A customer who picks their language and then meets screens in English has
/// been misled, so a partly translated language fails here rather than
/// shipping. The ARB files are read directly because the generated code
/// quietly falls back to English for a missing key.
void main() {
  final arbDir = Directory('lib/l10n');
  final placeholder = RegExp(r'\{\s*([A-Za-z_]\w*)\s*[,}]');

  Map<String, dynamic> readArb(String code) =>
      jsonDecode(File('${arbDir.path}/app_$code.arb').readAsStringSync())
          as Map<String, dynamic>;

  Map<String, String> messagesOf(Map<String, dynamic> arb) => {
        for (final e in arb.entries)
          if (!e.key.startsWith('@')) e.key: e.value as String,
      };

  final english = messagesOf(readArb('en'));

  test('the language list and the generated locales agree', () {
    expect(
      AppLocale.values.map((l) => l.code).toSet(),
      AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet(),
    );
    final arbs = arbDir
        .listSync()
        .map((f) => f.uri.pathSegments.last)
        .where((name) => name.endsWith('.arb'))
        .map((name) => name.substring(4, name.length - 4))
        .toSet();
    expect(arbs, AppLocale.values.map((l) => l.code).toSet());
  });

  for (final locale in AppLocale.values.where((l) => l != AppLocale.english)) {
    group(locale.englishName, () {
      final translated = messagesOf(readArb(locale.code));

      test('has every key and no stale ones', () {
        expect(
          english.keys.toSet().difference(translated.keys.toSet()),
          isEmpty,
          reason: 'missing',
        );
        expect(
          translated.keys.toSet().difference(english.keys.toSet()),
          isEmpty,
          reason: 'not in English',
        );
      });

      test('keeps every placeholder and plural', () {
        for (final key in english.keys) {
          final en = english[key]!;
          final tr = translated[key];
          if (tr == null) continue;
          expect(tr.trim(), isNotEmpty, reason: key);
          expect(
            placeholder.allMatches(tr).map((m) => m[1]).toSet(),
            placeholder.allMatches(en).map((m) => m[1]).toSet(),
            reason: key,
          );
          expect(tr.contains('plural,'), en.contains('plural,'), reason: key);
        }
      });

      test("is covered by Flutter's own widget strings", () {
        expect(
          GlobalMaterialLocalizations.delegate.isSupported(locale.locale),
          isTrue,
        );
        expect(
          GlobalCupertinoLocalizations.delegate.isSupported(locale.locale),
          isTrue,
        );
      });

      test('loads, and formats plurals and dates', () async {
        final l10n = await AppLocalizations.delegate.load(locale.locale);
        expect(l10n.localeName, locale.code);
        await GlobalMaterialLocalizations.delegate.load(locale.locale);
        expect(dateLocaleFor(locale.code), locale.code);
        expect(
          DateFormat.yMMMd(dateLocaleFor(locale.code))
              .format(DateTime(2026, 1, 26)),
          isNotEmpty,
        );
        for (final n in [0, 1, 2, 5]) {
          expect(l10n.offerCount(n), isNotEmpty);
        }
      });
    });
  }
}
