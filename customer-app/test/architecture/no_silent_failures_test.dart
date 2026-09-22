@TestOn('vm')
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Source-level guards for the defects this app is built to avoid.
///
/// A code review catches these once. A test catches them every time someone
/// adds a provider by copying the one above it.
void main() {
  final libFiles = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  String sourceOf(File file) => file.readAsStringSync();

  /// Strips comments so prose *describing* a banned pattern does not trip a
  /// check looking for the pattern itself.
  String codeOf(File file) => sourceOf(file)
      .replaceAll(RegExp(r'///.*'), '')
      .replaceAll(RegExp(r'//.*'), '')
      .replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '');

  setUpAll(() {
    expect(libFiles, isNotEmpty, reason: 'No Dart sources found to check');
  });

  group('A failure never looks like an empty account', () {
    test('no provider answers a failure with an empty collection or null', () {
      // This is the bug this group exists for. Every list provider used to end
      //
      //     return res.fold((bookings) => bookings, (_) => []);
      //
      // so a network drop, an expired token or an RLS refusal arrived at the
      // screen as an empty list. The customer was told they had no bookings, no
      // saved addresses and no categories, with no error and no retry — and for
      // paidBookingIdsProvider, with an offer to pay for the booking again.
      //
      // Providers must let the failure through: Riverpod turns it into
      // AsyncError and the screens already have an `error:` branch for it.
      final swallowed = RegExp(
        r'\(_\)\s*=>\s*(\[\]|const\s*\[\]|<[^>]+>\[\]|<[^>]+>\{\}|\{\})',
      );

      final offenders = <String>[];
      for (final file in libFiles.where((f) => f.path.contains('providers'))) {
        for (final line in codeOf(file).split('\n')) {
          if (swallowed.hasMatch(line)) offenders.add('${file.path}: ${line.trim()}');
        }
      }

      expect(
        offenders,
        isEmpty,
        reason: 'A failure is being turned into an empty result in:\n'
            '${offenders.join('\n')}\n'
            'Use _orThrow(...) so the screen can show what went wrong.',
      );
    });

    test('no repository returns a default value in place of a failure', () {
      final swallowed = RegExp(
        r'catch\s*\([^)]*\)\s*\{\s*return\s+(\[\]|const\s*\[\]|0|null)\s*;',
      );

      final offenders = [
        for (final file
            in libFiles.where((f) => f.path.contains('data/repositories')))
          if (swallowed.hasMatch(codeOf(file))) file.path,
      ];

      expect(offenders, isEmpty,
          reason: 'A failure is swallowed into a default in: ${offenders.join(', ')}');
    });
  });

  group('No fabricated data', () {
    test('nothing builds sample, dummy or fake content', () {
      final banned = RegExp(
        r'\b(dummyData|mockData|sampleData|fakeData|_dummy|_mock|_sample|'
        r'placeholderBookings|sampleBookings|mockBookings|fakeWorker)\b',
      );

      final offenders = [
        for (final file in libFiles)
          if (banned.hasMatch(codeOf(file))) file.path,
      ];

      expect(offenders, isEmpty,
          reason: 'Fabricated data found in: ${offenders.join(', ')}');
    });
  });

  group('No client-side money', () {
    test('no amount is held as a double', () {
      // Amounts are integer minor units end to end. A double here is how a
      // rupee goes missing in the third decimal place.
      //
      // The `get` alternative matters: this check originally missed
      // `double get estimatedPrice => quotedAmountMinor / 100.0`, which is
      // exactly the shape the money bugs took.
      final doubleAmount = RegExp(
        r'double\s+(get\s+)?\w*(amount|price|balance|fee|cost)\w*',
        caseSensitive: false,
      );

      final offenders = [
        for (final file in libFiles)
          if (doubleAmount.hasMatch(codeOf(file))) file.path,
      ];

      expect(offenders, isEmpty,
          reason: 'Money held as a double in: ${offenders.join(', ')}');
    });

    test('no platform fee or commission is computed on the client', () {
      final feeMath = RegExp(
        r'(platformFee|commission)\s*=.*[*/]\s*0?\.\d+|'
        r'\*\s*0\.1[05]\b|'
        r'commissionPercent\s*=\s*\d+',
      );

      final offenders = [
        for (final file in libFiles)
          if (feeMath.hasMatch(codeOf(file))) file.path,
      ];

      expect(offenders, isEmpty,
          reason: 'A fee is computed on the client in: ${offenders.join(', ')}');
    });
  });

  group('Layering', () {
    test('no screen talks to Supabase directly', () {
      // Features go through a repository, so there is one place where a query
      // and its failure mapping live.
      final offenders = [
        for (final file in libFiles.where((f) => f.path.contains('features')))
          if (sourceOf(file).contains('package:supabase_flutter')) file.path,
      ];

      expect(offenders, isEmpty,
          reason: 'Supabase reached directly from: ${offenders.join(', ')}');
    });
  });
}
