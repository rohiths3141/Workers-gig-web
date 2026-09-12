import { NextResponse } from 'next/server';

import { AppError } from '@/lib/errors/app-error';

/**
 * The API envelope.
 *
 * Every admin endpoint answers in one of two shapes, so clients — the admin UI
 * today, a separate admin application after the subdomain migration, and the
 * Flutter apps where they share endpoints — can handle responses uniformly.
 *
 *   { ok: true,  data: T, meta?: { ... } }
 *   { ok: false, error: { code, message, fieldErrors? } }
 */

export interface ApiMeta {
  page?: number;
  pageSize?: number;
  total?: number;
  totalPages?: number;
  requestId?: string;
}

export interface ApiSuccess<T> {
  ok: true;
  data: T;
  meta?: ApiMeta;
}

export interface ApiFailure {
  ok: false;
  error: {
    code: string;
    message: string;
    fieldErrors?: Record<string, string[]>;
  };
}

export type ApiResponse<T> = ApiSuccess<T> | ApiFailure;

export function ok<T>(data: T, meta?: ApiMeta, status = 200): NextResponse<ApiSuccess<T>> {
  return NextResponse.json({ ok: true as const, data, ...(meta ? { meta } : {}) }, { status });
}

export function fail(error: AppError, requestId?: string): NextResponse<ApiFailure> {
  return NextResponse.json(
    {
      ok: false as const,
      error: {
        code: error.code,
        message: error.message,
        ...(error.fieldErrors ? { fieldErrors: error.fieldErrors } : {}),
      },
    },
    {
      status: error.status,
      headers: requestId ? { 'x-request-id': requestId } : undefined,
    },
  );
}

/** Build pagination metadata from a total count and the requested page. */
export function paginationMeta(total: number, page: number, pageSize: number): ApiMeta {
  return {
    page,
    pageSize,
    total,
    totalPages: Math.max(1, Math.ceil(total / pageSize)),
  };
}
