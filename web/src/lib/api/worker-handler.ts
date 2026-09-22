import 'server-only';

import { randomUUID } from 'node:crypto';

import type { NextRequest, NextResponse } from 'next/server';
import { ZodError, type ZodSchema } from 'zod';

import { fail, ok } from '@/lib/api/response';
import { requireWorker, type WorkerSession } from '@/lib/auth/worker-session';
import { AppError, translateDatabaseError } from '@/lib/errors/app-error';
import { logger } from '@/lib/logging/logger';

/**
 * The worker API boundary.
 *
 * Mirrors the admin handler, with the authorization step replaced: an admin
 * route checks a permission, a worker route resolves the caller's own worker id
 * and lets RLS and the SECURITY DEFINER functions enforce the rest. No worker
 * endpoint takes a worker id as an argument.
 *
 *   request
 *     -> authenticate (Bearer ID token, verified by the Admin SDK)
 *     -> resolve      (worker id from the token subject, never from the body)
 *     -> validate     (Zod over body and params)
 *     -> execute      (against an RLS-scoped client)
 *     -> respond      (typed envelope; database internals never leak out)
 */

/**
 * Next.js 15 types the second argument of a route export as required, so
 * declaring it optional makes `next build` reject the export. A route with no
 * dynamic segment simply receives an empty params object.
 */
type RouteParams = { params: Promise<Record<string, string | undefined>> };

export interface WorkerRouteContext<TBody> {
  session: WorkerSession;
  body: TBody;
  params: Record<string, string | undefined>;
  /**
   * A required path parameter, or a 404.
   *
   * Next types route params as possibly-undefined. Reaching for `params.id!`
   * would turn a malformed URL into a confusing downstream error, so this
   * fails cleanly instead.
   */
  requireParam: (name: string) => string;
  request: NextRequest;
  requestId: string;
}

type Handler<TBody, TResult> = (
  context: WorkerRouteContext<TBody>,
) => Promise<TResult>;

export function workerRoute<TBody = undefined, TResult = unknown>(
  handler: Handler<TBody, TResult>,
  options: { bodySchema?: ZodSchema<TBody> } = {},
) {
  return async (
    request: NextRequest,
    routeContext: RouteParams,
  ): Promise<NextResponse> => {
    const requestId = randomUUID();

    try {
      const session = await requireWorker(request);
      const params = (await routeContext?.params) ?? {};

      let body = undefined as TBody;
      if (options.bodySchema) {
        const raw = await request.json().catch(() => ({}));
        body = options.bodySchema.parse(raw);
      }

      const result = await handler({
        session,
        body,
        params,
        requireParam: (name) => {
          const value = params[name];
          if (!value) throw AppError.notFound('That record');
          return value;
        },
        request,
        requestId,
      });

      return ok(result, { requestId });
    } catch (error) {
      if (error instanceof ZodError) {
        const fieldErrors: Record<string, string[]> = {};
        for (const issue of error.issues) {
          const key = issue.path.join('.') || 'body';
          (fieldErrors[key] ??= []).push(issue.message);
        }
        return fail(
          AppError.validation('Some of that could not be accepted.', fieldErrors),
          requestId,
        );
      }

      if (error instanceof AppError) {
        return fail(error, requestId);
      }

      // Anything unrecognised is logged with its detail and returned without
      // it. A worker must never see a stack trace or a SQLSTATE.
      logger.error('Worker route failed', {
        requestId,
        path: request.nextUrl.pathname,
        error: error instanceof Error ? error.message : 'unknown',
      });

      return fail(translateDatabaseError(error), requestId);
    }
  };
}
