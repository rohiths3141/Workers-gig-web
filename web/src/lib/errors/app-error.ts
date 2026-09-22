/**
 * Application errors.
 *
 * Two audiences, deliberately separated:
 *
 *   `message`  is shown to the user. It says what happened and what to do, and
 *              never leaks a table name, a constraint name, a SQL fragment or a
 *              stack trace.
 *   `cause`    stays on the server and goes to the log.
 *
 * `translateDatabaseError` maps the exceptions raised by the SECURITY DEFINER
 * functions in migrations 0010 and 0011 onto these types, so a violated business
 * rule reaches the operator as a sentence rather than a Postgres error code.
 */

export type ErrorCode =
  | 'UNAUTHENTICATED'
  | 'FORBIDDEN'
  | 'NOT_FOUND'
  | 'VALIDATION_FAILED'
  | 'INVALID_TRANSITION'
  | 'CONFLICT'
  | 'INSUFFICIENT_FUNDS'
  | 'RATE_LIMITED'
  | 'IMMUTABLE'
  | 'UPSTREAM_FAILURE'
  | 'INTERNAL';

const STATUS_BY_CODE: Record<ErrorCode, number> = {
  UNAUTHENTICATED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  VALIDATION_FAILED: 422,
  INVALID_TRANSITION: 422,
  CONFLICT: 409,
  INSUFFICIENT_FUNDS: 422,
  RATE_LIMITED: 429,
  IMMUTABLE: 409,
  UPSTREAM_FAILURE: 502,
  INTERNAL: 500,
};

export class AppError extends Error {
  readonly code: ErrorCode;
  readonly status: number;
  /** Field-level messages for a form, keyed by field name. */
  readonly fieldErrors?: Record<string, string[]>;

  constructor(
    code: ErrorCode,
    message: string,
    options?: { cause?: unknown; fieldErrors?: Record<string, string[]> },
  ) {
    super(message, options?.cause ? { cause: options.cause } : undefined);
    this.name = 'AppError';
    this.code = code;
    this.status = STATUS_BY_CODE[code];
    this.fieldErrors = options?.fieldErrors;
  }

  static unauthenticated(message = 'Please sign in to continue.'): AppError {
    return new AppError('UNAUTHENTICATED', message);
  }

  static forbidden(message = 'You do not have permission to perform this action.'): AppError {
    return new AppError('FORBIDDEN', message);
  }

  static notFound(what = 'The requested record'): AppError {
    return new AppError('NOT_FOUND', `${what} could not be found.`);
  }

  static validation(message: string, fieldErrors?: Record<string, string[]>): AppError {
    return new AppError('VALIDATION_FAILED', message, { fieldErrors });
  }

  static conflict(message: string): AppError {
    return new AppError('CONFLICT', message);
  }

  static internal(message = 'Something went wrong. Please try again.', cause?: unknown): AppError {
    return new AppError('INTERNAL', message, { cause });
  }
}

/**
 * Map a Postgres or PostgREST error onto an AppError.
 *
 * The database functions raise messages prefixed with a machine-readable tag
 * (`FORBIDDEN:`, `INVALID_TRANSITION:` and so on). That prefix is matched here
 * and then stripped, so the operator sees the explanatory half of the message
 * without the tag.
 */
export function translateDatabaseError(error: unknown): AppError {
  const message = extractMessage(error);

  if (!message) {
    return AppError.internal(undefined, error);
  }

  const tagged = /^([A-Z_]+):\s*(.*)$/s.exec(message);

  if (tagged) {
    const [, tag, detail] = tagged;
    const text = (detail ?? '').trim();

    switch (tag) {
      case 'UNAUTHENTICATED':
        return new AppError('UNAUTHENTICATED', 'Your session has expired. Please sign in again.', {
          cause: error,
        });
      case 'FORBIDDEN':
        return new AppError('FORBIDDEN', humanise(text, 'You are not allowed to do that.'), {
          cause: error,
        });
      case 'NOT_FOUND':
        return new AppError('NOT_FOUND', humanise(text, 'That record no longer exists.'), {
          cause: error,
        });
      case 'INVALID_TRANSITION':
        return new AppError('INVALID_TRANSITION', humanise(text, 'That change is not allowed from the current status.'), {
          cause: error,
        });
      case 'INVALID':
        return new AppError('VALIDATION_FAILED', humanise(text, 'That request was not valid.'), {
          cause: error,
        });
      case 'CONFLICT':
        return new AppError('CONFLICT', humanise(text, 'Someone else changed this record first.'), {
          cause: error,
        });
      case 'INSUFFICIENT_FUNDS':
        return new AppError('INSUFFICIENT_FUNDS', humanise(text, 'There is not enough balance for this operation.'), {
          cause: error,
        });
      case 'IMMUTABLE':
        return new AppError('IMMUTABLE', humanise(text, 'That record cannot be changed.'), {
          cause: error,
        });
      default:
        break;
    }
  }

  // Postgres error codes, for failures that bypass the tagged messages.
  const code = extractCode(error);

  switch (code) {
    case '42501':
      return AppError.forbidden();
    case '23505':
      return AppError.conflict('That record already exists or was already updated.');
    case '23503':
      return AppError.validation('A related record is missing or was removed.');
    case '23514':
      return AppError.validation('That value is not allowed by the platform rules.');
    case 'P0002':
      return AppError.notFound();
    case '28000':
      return AppError.unauthenticated();
    default:
      // Never surface a raw database message to a user.
      return AppError.internal(undefined, error);
  }
}

function humanise(detail: string, fallback: string): string {
  if (!detail) return fallback;
  const trimmed = detail.trim();
  const sentence = trimmed.charAt(0).toUpperCase() + trimmed.slice(1);
  return sentence.endsWith('.') ? sentence : `${sentence}.`;
}

function extractMessage(error: unknown): string | null {
  if (typeof error === 'string') return error;
  if (error && typeof error === 'object' && 'message' in error) {
    const message = (error as { message: unknown }).message;
    return typeof message === 'string' ? message : null;
  }
  return null;
}

function extractCode(error: unknown): string | null {
  if (error && typeof error === 'object' && 'code' in error) {
    const code = (error as { code: unknown }).code;
    return typeof code === 'string' ? code : null;
  }
  return null;
}
