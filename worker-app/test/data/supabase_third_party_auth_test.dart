import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Pins the Supabase SDK behaviour that a repository bug depended on.
///
/// This app configures the Supabase client with `accessToken`, because identity
/// is Firebase and Supabase validates the Firebase ID token rather than holding
/// a session of its own. Under that configuration `client.auth` does not return
/// an empty session — it throws.
///
/// Five repositories originally read `db.auth.currentUser?.id` to scope a query
/// to the signed-in worker. That analyzed cleanly and passed every test,
/// because nothing constructed a real client; it would have failed on a device,
/// on the first call, on most screens in the app.
///
/// This test makes the SDK's actual behaviour an executable fact, so if a
/// future SDK version changes it — or if someone assumes it works — the
/// assumption is checked rather than discovered in production.
void main() {
  test('client.auth throws when configured for third-party auth', () {
    final client = SupabaseClient(
      'https://example.supabase.co',
      'publishable-key',
      // Exactly how main.dart configures it: hand over the Firebase ID token
      // on every request, hold no Supabase session.
      accessToken: () async => 'a-firebase-id-token',
    );

    expect(
      () => client.auth,
      throwsA(isA<AuthException>()),
      reason: 'A repository must not read identity from the Supabase client',
    );
  });

  test('a client without accessToken does expose auth', () {
    // The contrast matters: the throw is caused by the accessToken option, not
    // by the client being unauthenticated. Reaching for db.auth is wrong here
    // specifically because of how this app is configured.
    final client = SupabaseClient(
      'https://example.supabase.co',
      'publishable-key',
    );

    expect(() => client.auth, returnsNormally);
    expect(client.auth.currentUser, isNull);
  });
}
