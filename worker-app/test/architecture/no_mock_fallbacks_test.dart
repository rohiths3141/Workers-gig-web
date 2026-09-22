@TestOn('vm')
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards against the specific defects the previous Worker/Captain application
/// shipped with. These are source-level checks: they read the codebase and fail
/// if a banned pattern reappears.
///
/// Every one of them corresponds to a finding in the audit of the old app. A
/// code review catches these once; a test catches them every time.
void main() {
  final libFiles = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  String sourceOf(File file) => file.readAsStringSync();

  /// Strips comments so prose *describing* a banned pattern does not trip a
  /// check that is looking for the pattern itself.
  String codeOf(File file) {
    final source = sourceOf(file);
    return source
        .replaceAll(RegExp(r'///.*'), '')
        .replaceAll(RegExp(r'//.*'), '')
        .replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '');
  }

  setUpAll(() {
    expect(libFiles, isNotEmpty, reason: 'No Dart sources found to check');
  });

  group('No fabricated data', () {
    test('nothing in the app builds sample, dummy or fake content', () {
      final offenders = <String>[];

      // The old app substituted sample jobs, a fake wallet and dummy
      // notifications whenever an API call failed.
      final banned = RegExp(
        r'\b(dummyData|mockData|sampleData|fakeData|_dummy|_mock|_sample|'
        r'placeholderJobs|sampleJobs|mockJobs|fakeWorker|dummyWallet)\b',
      );

      for (final file in libFiles) {
        if (banned.hasMatch(codeOf(file))) offenders.add(file.path);
      }

      expect(offenders, isEmpty,
          reason: 'Fabricated data found in: ${offenders.join(', ')}');
    });

    test('no repository returns a default value in place of a failure', () {
      final offenders = <String>[];

      // Patterns like `catch (_) { return []; }` are how "API failed -> show
      // sample jobs" gets reintroduced. Failures must reach the caller.
      final swallowed = RegExp(
        r'catch\s*\([^)]*\)\s*\{\s*return\s+(\[\]|const\s*\[\]|0|Money\.zero)',
      );

      for (final file in libFiles
          .where((f) => f.path.contains('data/repositories'))) {
        if (swallowed.hasMatch(codeOf(file))) offenders.add(file.path);
      }

      expect(offenders, isEmpty,
          reason: 'A failure is being swallowed into a default in: '
              '${offenders.join(', ')}');
    });
  });

  group('No client-side verification', () {
    test('nothing assigns a verification flag to true', () {
      final offenders = <String>[];

      // Every is*Verified value comes from the server. An assignment here would
      // be the old app's "worker awards themselves VERIFIED" bug returning.
      final assignment = RegExp(
        r'\bis(Kyc|Qualification|Skill|Background)Verified\s*[:=]\s*true',
      );

      for (final file in libFiles) {
        if (assignment.hasMatch(codeOf(file))) offenders.add(file.path);
      }

      expect(offenders, isEmpty,
          reason: 'A verification flag is set locally in: '
              '${offenders.join(', ')}');
    });

    test('Worker.copyWith cannot change status or any verification flag', () {
      final worker = File('lib/domain/entities/worker.dart');
      final copyWith =
          RegExp(r'Worker copyWith\(\{(.*?)\}\)', dotAll: true)
              .firstMatch(sourceOf(worker))
              ?.group(1);

      expect(copyWith, isNotNull, reason: 'copyWith signature not found');

      for (final banned in [
        'status',
        'isKycVerified',
        'isQualificationVerified',
        'isSkillVerified',
        'isBackgroundVerified',
        'isInsured',
        'ratingAvg',
        'jobsCompleted',
      ]) {
        expect(copyWith, isNot(contains(banned)),
            reason: '$banned must not be settable on the client');
      }
    });
  });

  group('No client-side arrival verification', () {
    test('the app never compares an arrival code locally', () {
      final offenders = <String>[];

      // The correct code is never sent to the device. Any local comparison
      // would mean someone had reintroduced a way to fake arrival.
      final localCompare = RegExp(
        r'arrivalCode\s*==|==\s*arrivalCode|arrival_code.*==',
      );

      for (final file in libFiles) {
        if (localCompare.hasMatch(codeOf(file))) offenders.add(file.path);
      }

      expect(offenders, isEmpty,
          reason: 'An arrival code is compared on the client in: '
              '${offenders.join(', ')}');
    });

    test('the arrival sheet closes successfully only on a server yes', () {
      final sheet = File(
          'lib/features/jobs/presentation/widgets/arrival_sheet.dart');
      final code = codeOf(sheet);

      // Exactly one pop(true), and it sits behind verification.isVerified.
      expect('pop(true)'.allMatches(code).length, 1,
          reason: 'There must be exactly one success path');
      expect(code, contains('if (verification.isVerified)'));
    });
  });

  group('No client-side money', () {
    test('no wallet balance is assigned or computed in the app', () {
      final offenders = <String>[];
      final assignment = RegExp(r'\b(balance|balanceMinor)\s*=\s*(?!=)');

      for (final file in libFiles.where((f) => !f.path.contains('mappers'))) {
        if (assignment.hasMatch(codeOf(file))) offenders.add(file.path);
      }

      expect(offenders, isEmpty,
          reason: 'A balance is written on the client in: '
              '${offenders.join(', ')}');
    });

    test('no hardcoded platform fee percentage', () {
      final offenders = <String>[];

      // The fee comes from the ledger rows that exist. A percentage here would
      // eventually disagree with the accounts.
      final feeMath = RegExp(
        r'(platformFee|commission)\s*=.*[*/]\s*0?\.\d+|'
        r'\*\s*0\.1[05]\b|'
        r'commissionPercent\s*=\s*\d+',
      );

      for (final file in libFiles) {
        if (feeMath.hasMatch(codeOf(file))) offenders.add(file.path);
      }

      expect(offenders, isEmpty,
          reason: 'A fee is computed on the client in: ${offenders.join(', ')}');
    });

    test('no double is used for an amount', () {
      final offenders = <String>[];
      final doubleAmount = RegExp(
        r'double\s+\w*(amount|price|balance|fee|earning|cost)\w*',
        caseSensitive: false,
      );

      for (final file in libFiles) {
        if (doubleAmount.hasMatch(codeOf(file))) offenders.add(file.path);
      }

      expect(offenders, isEmpty,
          reason: 'Money held as a double in: ${offenders.join(', ')}');
    });
  });

  group('Layering', () {
    test('no presentation file imports a backend SDK', () {
      final offenders = <String>[];

      final banned = RegExp(
        r"import\s+'package:(supabase_flutter|firebase_auth|firebase_storage|firebase_core)/",
      );

      for (final file
          in libFiles.where((f) => f.path.contains('/presentation/'))) {
        if (banned.hasMatch(sourceOf(file))) offenders.add(file.path);
      }

      expect(offenders, isEmpty,
          reason: 'A screen reaches the backend directly in: '
              '${offenders.join(', ')}');
    });

    test('no presentation file imports a repository implementation', () {
      final offenders = <String>[];

      for (final file
          in libFiles.where((f) => f.path.contains('/presentation/'))) {
        if (sourceOf(file).contains("data/repositories/")) {
          offenders.add(file.path);
        }
      }

      expect(offenders, isEmpty,
          reason: 'A screen depends on a concrete repository in: '
              '${offenders.join(', ')}');
    });

    test('domain entities depend on nothing outside the domain', () {
      final offenders = <String>[];

      for (final file
          in libFiles.where((f) => f.path.contains('domain/entities'))) {
        final imports = RegExp(r"import\s+'([^']+)'")
            .allMatches(sourceOf(file))
            .map((m) => m.group(1)!)
            .where((i) => i.startsWith('package:') && !i.startsWith('package:intl'));

        if (imports.isNotEmpty) {
          offenders.add('${file.path}: ${imports.join(', ')}');
        }
      }

      expect(offenders, isEmpty,
          reason: 'Domain entities must stay pure: ${offenders.join('; ')}');
    });
  });

  group('Identity comes from Firebase, not Supabase', () {
    test('no repository reads identity from the Supabase auth client', () {
      final offenders = <String>[];

      // This client is configured for Supabase third-party auth, so it holds no
      // session of its own and `db.auth` THROWS when touched. A repository
      // reaching for db.auth.currentUser compiles and analyzes cleanly, then
      // fails at runtime on every call — which is exactly how it slipped in the
      // first time. The UID is injected from the auth layer instead.
      final supabaseAuth = RegExp(r'\b_?db\.auth\b');

      for (final file in libFiles) {
        if (supabaseAuth.hasMatch(codeOf(file))) offenders.add(file.path);
      }

      expect(offenders, isEmpty,
          reason: 'db.auth throws under third-party auth; used in: '
              '${offenders.join(', ')}');
    });
  });

  group('No fake features', () {
    test('there is no SOS or emergency dispatch control', () {
      final offenders = <String>[];

      // The old app had an SOS screen that called nobody, dispatched nothing
      // and recorded no incident. Until a real integration exists there must be
      // no control that looks like one.
      final sosControl = RegExp(
        r'(triggerSos|sendSos|activateSos|SosButton|EmergencyDispatch)',
        caseSensitive: false,
      );

      for (final file in libFiles) {
        if (sosControl.hasMatch(codeOf(file))) offenders.add(file.path);
      }

      expect(offenders, isEmpty,
          reason: 'An SOS control exists with no backend behind it in: '
              '${offenders.join(', ')}');
    });

    test('no coordinates are hardcoded', () {
      final offenders = <String>[];

      // A fake map centred on a made-up location is worse than no map.
      final coordinate = RegExp(
        r'(latitude|longitude)\s*[:=]\s*-?\d+\.\d{3,}',
      );

      for (final file in libFiles) {
        if (coordinate.hasMatch(codeOf(file))) offenders.add(file.path);
      }

      expect(offenders, isEmpty,
          reason: 'Hardcoded coordinates in: ${offenders.join(', ')}');
    });
  });

  group('Ordering is always stated', () {
    test('no query relies on postgrest\'s default sort direction', () {
      final offenders = <String>[];

      // `.order(column)` defaults to DESCENDING in postgrest-dart, which is
      // the opposite of what almost every call here wants. Seven bare calls
      // were reversed before anyone noticed, including the job timeline and
      // the support-ticket chat — both of which read newest-first, so a
      // conversation ran backwards and a job's history started at the end.
      // Nothing about that is visible to the compiler or the analyzer.
      final bareOrder = RegExp(r'\.order\(\s*[^)]*?\)', dotAll: true);

      for (final file in libFiles) {
        for (final match in bareOrder.allMatches(codeOf(file))) {
          if (!match.group(0)!.contains('ascending:')) {
            offenders.add('${file.path}: ${match.group(0)}');
          }
        }
      }

      expect(offenders, isEmpty,
          reason: 'Say which direction you mean: ${offenders.join('; ')}');
    });
  });

  group('A session ends on the device', () {
    test('signing out drops the Realtime channels', () {
      // disposeChannels() existed, documented as "called on sign-out", with no
      // callers at all — so a signed-out phone stayed joined to the departing
      // worker's channels and went on receiving their offers and booking
      // changes. A method whose whole job is teardown has to be wired to
      // something.
      final callers = libFiles
          .where((f) => !f.path.contains('supabase_client_provider'))
          .where((f) => codeOf(f).contains('disposeChannels'))
          .map((f) => f.path)
          .toList();

      expect(callers, isNotEmpty,
          reason: 'Nothing calls disposeChannels(), so Realtime subscriptions '
              'outlive the session that opened them');
    });

    test('signing out switches this device off for the departing worker', () {
      final session =
          codeOf(File('lib/app/providers/session_controller.dart'));

      // push_tokens keys on the token and re-points profile_id on conflict, so
      // an un-deactivated row keeps delivering one worker's job alerts to a
      // phone somebody else is now holding.
      expect(session, contains('deactivatePushToken'),
          reason: 'Sign-out must deactivate this device\'s push token');
    });

    test('signing out rebuilds the repositories', () {
      final session =
          codeOf(File('lib/app/providers/session_controller.dart'));

      // Each one caches the workers.id it resolved, and they are app-lifetime
      // providers: without this the next worker on the phone queries with the
      // previous worker's UUID.
      expect(session, contains('invalidate(workerRepositoryProvider)'));
      expect(session, contains('invalidate(jobRepositoryProvider)'));
      expect(session, contains('invalidate(walletRepositoryProvider)'));
    });
  });
}
