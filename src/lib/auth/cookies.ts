import 'server-only';

import { isProduction, serverEnv } from '@/lib/config/env';

/**
 * Session cookie configuration.
 *
 * Two cookies, both httpOnly, because they do different jobs:
 *
 *   SESSION_COOKIE  A Firebase session cookie. Long-lived (hours), and the thing
 *                   that proves the user authenticated. Firebase will only mint
 *                   one from an ID token less than five minutes old, so it
 *                   cannot be created without a real, recent sign-in.
 *
 *   ID_TOKEN_COOKIE The current Firebase ID token. Short-lived (an hour), and
 *                   forwarded to Supabase as the bearer token so PostgREST
 *                   validates it against Google's JWKS and Row Level Security
 *                   applies with the caller's real identity. Refreshed from the
 *                   browser by the session keeper before it expires.
 *
 * Neither is readable from JavaScript, so a cross-site scripting bug cannot
 * exfiltrate a usable credential.
 *
 * The `__Host-` prefix is used wherever the browser will accept it. It is the
 * strongest cookie binding available: the browser refuses a `__Host-` cookie
 * unless it is Secure, Path=/, and has no Domain attribute, which means a
 * subdomain cannot overwrite it. It is dropped only when running over plain
 * HTTP locally, or when a cookie domain is deliberately configured.
 */

function usesHostPrefix(): boolean {
  return isProduction && !serverEnv().routing.authCookieDomain;
}

export function sessionCookieName(): string {
  return usesHostPrefix() ? '__Host-ss_session' : 'ss_session';
}

export function idTokenCookieName(): string {
  return usesHostPrefix() ? '__Host-ss_idtoken' : 'ss_idtoken';
}

export interface CookieOptions {
  httpOnly: true;
  secure: boolean;
  sameSite: 'lax' | 'strict';
  path: string;
  maxAge: number;
  domain?: string;
}

export function sessionCookieOptions(maxAgeSeconds: number): CookieOptions {
  const domain = serverEnv().routing.authCookieDomain;

  return {
    httpOnly: true,
    secure: isProduction,
    // 'strict' would break the redirect back from an external identity provider
    // during a redirect-based sign-in. 'lax' still blocks cross-site POSTs,
    // which is the case that matters for CSRF here.
    sameSite: 'lax',
    path: '/',
    maxAge: maxAgeSeconds,
    // Only set when the admin panel and public site must share a session across
    // subdomains. Omitted by default so cookies stay host-only.
    ...(domain && !usesHostPrefix() ? { domain } : {}),
  };
}

/** Options that immediately expire a cookie. */
export function clearedCookieOptions(): CookieOptions {
  return sessionCookieOptions(0);
}
