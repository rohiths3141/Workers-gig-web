import 'server-only';

import { randomUUID } from 'node:crypto';

import type { NextRequest, NextResponse } from 'next/server';
import { ZodError, type ZodSchema } from 'zod';

import { fail, ok } from '@/lib/api/response';
import { requireCustomer, type CustomerSession } from '@/lib/auth/customer-session';
import { AppError, translateDatabaseError } from '@/lib/errors/app-error';
import { logger } from '@/lib/logging/logger';

/**
 * The customer API boundary. Identical shape to workerRoute in
 * lib/api/worker-handler.ts — see that file's comment for the full rationale.
 */

type RouteParams = { params: Promise<Record<string, string | undefined>> };

export interface CustomerRouteContext<TBody> {
  session: CustomerSession;
  body: TBody;
  params: Record<string, string | undefined>;
  requireParam: (name: string) => string;
  request: NextRequest;
  requestId: string;
}

type Handler<TBody, TResult> = (
  context: CustomerRouteContext<TBody>,
) => Promise<TResult>;

export function customerRoute<TBody = undefined, TResult = unknown>(
  handler: Handler<TBody, TResult>,
  options: { bodySchema?: ZodSchema<TBody> } = {},
) {
  return async (
    request: NextRequest,
    routeContext: RouteParams,
  ): Promise<NextResponse> => {
    const requestId = randomUUID();

    try {
      const session = await requireCustomer(request);
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

      logger.error('Customer route failed', {
        requestId,
        path: request.nextUrl.pathname,
        error: error instanceof Error ? error.message : 'unknown',
      });

      return fail(translateDatabaseError(error), requestId);
    }
  };
}
