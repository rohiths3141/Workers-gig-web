import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wervexa_worker/core/errors/app_failure.dart';
import 'package:wervexa_worker/data/repositories/supabase_repository_base.dart';

/// `workers.id` is cached, and the cache must not outlive the session.
///
/// Several tables key `worker_id` as the `workers.id` UUID rather than as the
/// Firebase UID, so [SupabaseRepositoryBase.resolveWorkerId] looks it up once
/// and holds it. The repositories that use it — offers, wallet, gigs — are
/// app-lifetime `Provider`s: signing out invalidated the session and nothing
/// else, so the cached UUID survived into the next worker's session.
///
/// That is not hypothetical here. A small pool of test numbers is recycled
/// across the same handful of phones, so one worker signing out and another
/// signing in on the same device is the ordinary case rather than the edge.
/// The symptom is a worker who cannot see their own offers, because the query
/// went out carrying somebody else's UUID.
void main() {
  /// Every PostgREST path the repository asked for, so a test can say how many
  /// times the lookup really went to the database.
  late List<String> requested;
  late Map<String, String> workerIdByFirebaseUid;

  MockClient stubTransport() => MockClient((request) async {
        requested.add('${request.method} ${request.url.path}');

        // workers?select=id&firebase_uid=eq.<uid>
        final filter = request.url.queryParameters['firebase_uid'] ?? '';
        final uid = filter.startsWith('eq.') ? filter.substring(3) : filter;
        final id = workerIdByFirebaseUid[uid];

        if (id == null) {
          return http.Response(
            jsonEncode({
              'code': 'PGRST116',
              'message': 'JSON object requested, multiple (or no) rows returned',
            }),
            406,
            request: request,
            headers: {'content-type': 'application/json'},
          );
        }

        return http.Response(
          jsonEncode({'id': id}),
          200,
          request: request,
          headers: {'content-type': 'application/json'},
        );
      });

  setUp(() {
    requested = [];
    workerIdByFirebaseUid = {
      'firebase-uid-ravi': '11111111-1111-4111-8111-111111111111',
      'firebase-uid-arun': '22222222-2222-4222-8222-222222222222',
    };
  });

  /// The real base class over a real Supabase client, so what is under test is
  /// the caching behaviour itself rather than a restatement of it.
  _TestRepository repositoryReading(String? Function() uid) => _TestRepository(
        SupabaseClient(
          'https://example.supabase.co',
          'publishable-key',
          httpClient: stubTransport(),
          // Exactly how main.dart configures it: Firebase holds the session.
          accessToken: () async => 'a-firebase-id-token',
        ),
        currentFirebaseUid: uid,
      );

  group('The workers.id cache', () {
    test('resolves once for a single signed-in worker', () async {
      final repository = repositoryReading(() => 'firebase-uid-ravi');

      final first = await repository.resolveWorkerId();
      final second = await repository.resolveWorkerId();

      expect(first, '11111111-1111-4111-8111-111111111111');
      expect(second, first);
      expect(requested, hasLength(1),
          reason: 'A second call must be served from the cache');
    });

    test('re-resolves when a different worker signs in on the same device',
        () async {
      // One repository instance, because that is what the app has: the
      // provider is never rebuilt between the two sign-ins.
      var currentUid = 'firebase-uid-ravi';
      final repository = repositoryReading(() => currentUid);

      final ravi = await repository.resolveWorkerId();
      expect(ravi, '11111111-1111-4111-8111-111111111111');

      // Ravi signs out; Arun signs in on the same phone.
      currentUid = 'firebase-uid-arun';
      final arun = await repository.resolveWorkerId();

      expect(arun, '22222222-2222-4222-8222-222222222222',
          reason: "Arun's queries must not carry Ravi's worker id");
      expect(requested, hasLength(2),
          reason: 'A change of worker must go back to the database');
    });

    test('re-resolves after the same number returns on a new Firebase UID',
        () async {
      // Firebase mints a new UID when a user record is deleted and the same
      // number signs in again. worker_claim_account() re-binds the row, so the
      // workers.id is unchanged while the Firebase UID is not — the cache key
      // has to be the UID, or the lookup is skipped and never corrected.
      var currentUid = 'firebase-uid-ravi';
      final repository = repositoryReading(() => currentUid);

      await repository.resolveWorkerId();

      currentUid = 'firebase-uid-ravi-rebound';
      workerIdByFirebaseUid[currentUid] =
          '11111111-1111-4111-8111-111111111111';

      expect(await repository.resolveWorkerId(),
          '11111111-1111-4111-8111-111111111111');
      expect(requested, hasLength(2));
    });

    test('clearSessionCache forces the next call back to the database',
        () async {
      final repository = repositoryReading(() => 'firebase-uid-ravi');

      await repository.resolveWorkerId();
      repository.clearSessionCache();
      await repository.resolveWorkerId();

      expect(requested, hasLength(2));
    });

    test('refuses outright when nobody is signed in', () async {
      final repository = repositoryReading(() => null);

      await expectLater(
        repository.resolveWorkerId(),
        throwsA(isA<AuthFailure>().having(
            (f) => f.requiresReauthentication, 'requires re-auth', isTrue)),
      );
      expect(requested, isEmpty,
          reason: 'A signed-out caller must not reach the database at all');
    });
  });
}

/// The base class is abstract; this exposes it unchanged.
final class _TestRepository extends SupabaseRepositoryBase {
  _TestRepository(super.db, {required super.currentFirebaseUid});
}
