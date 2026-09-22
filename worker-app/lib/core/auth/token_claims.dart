import 'dart:convert';

/// Reads the `role` claim out of a Firebase ID token without verifying it.
///
/// Verification is the server's job. The app only needs to know whether the
/// token it is about to hand PostgREST will be read as `authenticated` rather
/// than `anon` — Supabase's third-party auth maps the Postgres role from this
/// claim, and a token minted before the claim was written runs as `anon`,
/// where every RLS policy denies.
///
/// Returns null for anything that is not a decodable JWT payload.
String? roleClaimOf(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) return null;

    final payload =
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final claims = jsonDecode(payload);
    if (claims is! Map) return null;

    final role = claims['role'];
    return role is String ? role : null;
  } catch (_) {
    // A malformed token is not something the caller can act on differently
    // from a missing claim.
    return null;
  }
}

/// Whether [token] will be accepted by Supabase as an authenticated caller.
bool hasSupabaseRole(String? token) =>
    token != null && roleClaimOf(token) == 'authenticated';
