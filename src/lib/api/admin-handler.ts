import 'server-only';

import { randomUUID } from 'node:crypto';

import type { NextRequest, NextResponse } from 'next/server';
import { ZodError, type ZodSchema } from 'zod';

import { requireAdmin, type AdminSession } from '@/lib/auth/admin-session';
import { AppError, translateDatabaseError } from '@/lib/errors/app-error';
import { logger } from '@/lib/logging/logger';
import type { Permission } from '@/lib/permissions/permissions';
import { fail, ok, type ApiMeta } from '@/lib/api/response';
import { userScopedClient } from '@/lib/supabase/server';

/**
 * The admin API boundary.
 *
 * Every /api/admin/* route is wrapped by this. It is the single place where the
 * required sequence happens, so no individual endpoint can forget a step:
 *
 *   request
 *     -> authenticate (Firebase session cookie, verified by the Admin SDK)
 *     -> authorize    (permission resolved from Postgres, not from the request)
 *     -> validate     (Zod schema over body and query)
 *     -> execute      (which calls a SECURITY DEFINER function that re-checks
 *                      the permission and writes the audit log atomically)
 *     -> respond      (typed envelope; database internals never leak out)
 *
 * The authorization check here is the first of two. The database performs the
 * second. That redundancy is intentional: this layer gives a clean 403 with a
 * useful message, and the database guarantees the rule even if a future caller
 * reaches the RPC by some other path.
 */

export interface AdminRouteContext<TBody, TQuery> {
  session: AdminSession;
  body: TBody;
  query: TQuery;
  params: Record<string, string>;
  request: NextRequest;
  requestId: string;
}

interface AdminRouteOptions<TBody, TQuery> {
  /** Permission required to reach the handler at all. */
  permission: Permission;
  /** Schema for the JSON request body. Omit for GET and DELETE. */
  bodySchema?: ZodSchema<TBody>;
  /** Schema for the parsed query string. */
  querySchema?: ZodSchema<TQuery>;
  /**
   * Sensitive actions require a reason, which is recorded in the audit trail.
   * The check is here as well as in the database so the operator gets a form
   * error rather than a transaction failure.
   */
  requiresReason?: boolean;
}

type Handler<TBody, TQuery, TResult> = (
  context: AdminRouteContext<TBody, TQuery>,
) => Promise<{ data: TResult; meta?: ApiMeta; status?: number }>;

/** Next.js 15 passes route params as a promise. */
type RouteParams = { params: Promise<Record<string, string>> };

export function withAdminRoute<TBody = undefined, TQuery = undefined, TResult = unknown>(
  options: AdminRouteOptions<TBody, TQuery>,
  handler: Handler<TBody, TQuery, TResult>,
) {
  return async (request: NextRequest, routeContext?: RouteParams): Promise<NextResponse> => {
    const requestId = request.headers.get('x-request-id') ?? randomUUID();
    const started = Date.now();

    try {
      // ---- authenticate + authorize ------------------------------------
      const session = await requireAdmin(options.permission);

      // Rebuild the database client with this request's context attached, so
      // audit rows written by the RPC carry the caller's IP and request id.
      const db = userScopedClient(session.idToken, {
        clientIp: clientIpOf(request),
        userAgent: request.headers.get('user-agent'),
        requestId,
      });

      // ---- validate ----------------------------------------------------
      const params = routeContext ? await routeContext.params : {};

      let body = undefined as TBody;
      if (options.bodySchema) {
        body = options.bodySchema.parse(await readJson(request));
      }

      let query = undefined as TQuery;
      if (options.querySchema) {
        query = options.querySchema.parse(
          Object.fromEntries(request.nextUrl.searchParams.entries()),
        );
      }

      if (options.requiresReason) {
        const reason = (body as { reason?: unknown } | undefined)?.reason;
        if (typeof reason !== 'string' || reason.trim().length < 5) {
          throw AppError.validation('A reason is required for this action.', {
            reason: ['Enter at least 5 characters explaining why.'],
          });
        }
      }

      // ---- execute -----------------------------------------------------
      const result = await handler({
        session: { ...session, db },
        body,
        query,
        params,
        request,
        requestId,
      });

      logger.info('Admin API call', {
        requestId,
        adminId: session.adminId,
        permission: options.permission,
        method: request.method,
        path: request.nextUrl.pathname,
        durationMs: Date.now() - started,
      });

      return ok(result.data, { ...result.meta, requestId }, result.status ?? 200);
    } catch (error) {
      return handleError(error, {
        requestId,
        method: request.method,
        path: request.nextUrl.pathname,
        permission: options.permission,
        durationMs: Date.now() - started,
      });
    }
  };
}

// ---------------------------------------------------------------------------
// Error handling
// ---------------------------------------------------------------------------

function handleError(error: unknown, context: Record<string, unknown>): NextResponse {
  // Validation: return field-level messages the form can render inline.
  if (error instanceof ZodError) {
    const fieldErrors: Record<string, string[]> = {};
    for (const issue of error.issues) {
      const key = issue.path.join('.') || '_';
      (fieldErrors[key] ??= []).push(issue.message);
    }

    logger.debug('Admin API validation failed', { ...context, fieldErrors });
    return fail(
      AppError.validation('Please correct the highlighted fields.', fieldErrors),
      context.requestId as string,
    );
  }

  if (error instanceof AppError) {
    // 4xx is the caller's problem and expected traffic; 5xx is ours.
    const level = error.status >= 500 ? 'error' : 'warn';
    logger[level]('Admin API error', { ...context, code: error.code, message: error.message });
    return fail(error, context.requestId as string);
  }

  // Anything from Postgres or PostgREST: translate, and log the original with
  // full detail while returning only the safe message.
  const translated = translateDatabaseError(error);

  logger.error('Admin API unhandled failure', {
    ...context,
    code: translated.code,
    error,
  });

  return fail(translated, context.requestId as string);
}

// ---------------------------------------------------------------------------
// Request helpers
// ---------------------------------------------------------------------------

async function readJson(request: NextRequest): Promise<unknown> {
  try {
    return await request.json();
  } catch {
    throw AppError.validation('The request body must be valid JSON.');
  }
}

/**
 * Best-effort client IP.
 *
 * Only the left-most entry of x-forwarded-for is used, and only because Vercel
 * rewrites that header at the edge. Behind a different proxy this would need
 * revisiting; it is advisory audit context, never an authorization input.
 */
function clientIpOf(request: NextRequest): string | null {
  const forwarded = request.headers.get('x-forwarded-for');
  if (forwarded) {
    const first = forwarded.split(',')[0]?.trim();
    if (first) return first;
  }
  return request.headers.get('x-real-ip');
}
