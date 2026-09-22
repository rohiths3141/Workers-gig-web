import 'server-only';

import { createClient, type SupabaseClient } from '@supabase/supabase-js';

import { publicEnv, serverEnv } from '@/lib/config/env';
import type { Database } from '@/types/database.types';

/**
 * Supabase access from the server.
 *
 * Supabase here is a database, a realtime bus and a function host. It is not the
 * authentication provider and not the file store.
 *
 * Two clients, with deliberately different trust levels:
 *
 *   userScopedClient(idToken)
 *     Carries the caller's verified Firebase ID token. Supabase Third-Party Auth
 *     validates it against Google's JWKS, so request.jwt.claims holds the
 *     Firebase claims, public.firebase_uid() resolves, and every RLS policy
 *     applies. This is the default for everything the admin panel reads and
 *     writes: authorization is enforced by the database, not merely by the code
 *     that called it.
 *
 *   serviceClient()
 *     Bypasses RLS. Reserved for system work with no authenticated caller — the
 *     public contact form, scheduled sweeps, webhook handlers. Never used to
 *     satisfy an admin request, because doing so would move the authorization
 *     decision out of the database and into whichever code path remembered to
 *     check.
 */

export type TypedSupabaseClient = SupabaseClient<Database>;

const commonOptions = {
  auth: {
    // There is no Supabase Auth session to persist, refresh, or detect. Identity
    // comes from the Firebase token attached per request.
    persistSession: false,
    autoRefreshToken: false,
    detectSessionInUrl: false,
  },
} as const;

/**
 * Advisory request context forwarded to the database for the audit trail.
 *
 * public.write_audit_log() reads these from PostgREST's request.headers. They
 * are recorded for investigation only and are never an authorization input — a
 * direct client could set them itself.
 */
export interface RequestContext {
  clientIp?: string | null;
  userAgent?: string | null;
  requestId?: string | null;
}

function contextHeaders(context?: RequestContext): Record<string, string> {
  if (!context) return {};

  const headers: Record<string, string> = {};
  if (context.clientIp) headers['x-client-ip'] = context.clientIp;
  if (context.userAgent) headers['user-agent'] = context.userAgent.slice(0, 512);
  if (context.requestId) headers['x-request-id'] = context.requestId;
  return headers;
}

/**
 * A client acting as the authenticated Firebase user.
 *
 * @param firebaseIdToken A token already verified by the Firebase Admin SDK.
 *   Passing an unverified token would still be safe — Supabase validates the
 *   signature itself — but callers verify first so that a bad token produces a
 *   clear 401 rather than an empty result set.
 * @param context Advisory request metadata recorded alongside audit entries.
 */
export function userScopedClient(
  firebaseIdToken: string,
  context?: RequestContext,
): TypedSupabaseClient {
  const { supabase } = publicEnv();

  return createClient<Database>(supabase.url, supabase.anonKey, {
    ...commonOptions,
    global: {
      headers: {
        Authorization: `Bearer ${firebaseIdToken}`,
        ...contextHeaders(context),
      },
    },
  });
}

/**
 * A client that bypasses Row Level Security.
 *
 * Every call site must be justifiable without reference to a signed-in user. If
 * a caller reaches for this to serve an admin request, that is a bug: use
 * userScopedClient so the database enforces the permission.
 */
export function serviceClient(): TypedSupabaseClient {
  const { supabase } = serverEnv();

  return createClient<Database>(supabase.url, supabase.serviceRoleKey, commonOptions);
}

/**
 * An unauthenticated client for public catalogue reads.
 *
 * Used by the public website, where RLS exposes only active services, service
 * problems, FAQs, public settings and non-hidden ratings.
 */
export function anonClient(): TypedSupabaseClient {
  const { supabase } = publicEnv();
  return createClient<Database>(supabase.url, supabase.anonKey, commonOptions);
}
