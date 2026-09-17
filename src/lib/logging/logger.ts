import { isProduction } from '@/lib/config/env';

/**
 * Structured logging.
 *
 * Logs are JSON in production so a log aggregator can index them, and readable
 * text in development.
 *
 * The redaction pass below is the important part: it strips anything that looks
 * like a credential or a personal identifier before it is written, so an
 * incident investigation never turns into a second data exposure.
 */

type LogLevel = 'debug' | 'info' | 'warn' | 'error';

const LEVEL_ORDER: Record<LogLevel, number> = {
  debug: 10,
  info: 20,
  warn: 30,
  error: 40,
};

function configuredLevel(): LogLevel {
  const raw = process.env.LOG_LEVEL;
  if (raw === 'debug' || raw === 'info' || raw === 'warn' || raw === 'error') {
    return raw;
  }
  return isProduction ? 'info' : 'debug';
}

/** Keys whose values are never written to a log, at any level. */
const REDACTED_KEYS = new Set([
  'password',
  'token',
  'idtoken',
  'id_token',
  'accesstoken',
  'access_token',
  'refreshtoken',
  'refresh_token',
  'sessioncookie',
  'session_cookie',
  'authorization',
  'cookie',
  'apikey',
  'api_key',
  'servicerolekey',
  'service_role_key',
  'privatekey',
  'private_key',
  'secret',
  'signature',
  'phone',
  'email',
  'aadhaar',
  'pan',
  'account_number',
  'accountnumber',
  'ifsc',
  'storage_path',
  'storagepath',
]);

function redact(value: unknown, depth = 0): unknown {
  if (depth > 6) return '[depth-limit]';
  if (value === null || value === undefined) return value;

  if (Array.isArray(value)) {
    return value.slice(0, 50).map((item) => redact(item, depth + 1));
  }

  if (value instanceof Error) {
    return { name: value.name, message: value.message, stack: value.stack };
  }

  if (typeof value === 'object') {
    const out: Record<string, unknown> = {};
    for (const [key, val] of Object.entries(value as Record<string, unknown>)) {
      out[key] = REDACTED_KEYS.has(key.toLowerCase()) ? '[redacted]' : redact(val, depth + 1);
    }
    return out;
  }

  return value;
}

export type LogContext = Record<string, unknown>;

function write(level: LogLevel, message: string, context?: LogContext): void {
  if (LEVEL_ORDER[level] < LEVEL_ORDER[configuredLevel()]) return;

  const entry = {
    level,
    message,
    timestamp: new Date().toISOString(),
    ...(context ? { context: redact(context) } : {}),
  };

  const line = isProduction ? JSON.stringify(entry) : `[${level}] ${message}`;
  const detail = isProduction ? '' : context ? redact(context) : '';

  switch (level) {
    case 'error':
      console.error(line, detail);
      break;
    case 'warn':
      console.warn(line, detail);
      break;
    default:
      console.log(line, detail);
  }
}

export const logger = {
  debug: (message: string, context?: LogContext) => write('debug', message, context),
  info: (message: string, context?: LogContext) => write('info', message, context),
  warn: (message: string, context?: LogContext) => write('warn', message, context),
  error: (message: string, context?: LogContext) => write('error', message, context),
};
