import { z } from 'zod';

/**
 * Environment configuration.
 *
 * Two separate schemas, because the boundary matters:
 *
 *   publicEnv - inlined into the browser bundle. Safe to expose.
 *   serverEnv - read only in Node. Accessing it from a client component throws.
 *
 * Every NEXT_PUBLIC_ variable is referenced as a literal member expression
 * below. Next.js only substitutes statically analysable references, so
 * `process.env[name]` would silently be undefined in the browser.
 */

const optionalUrl = z
  .string()
  .trim()
  .url()
  .optional()
  .or(z.literal('').transform(() => undefined));

const optionalString = z
  .string()
  .trim()
  .optional()
  .or(z.literal('').transform(() => undefined));

// ---------------------------------------------------------------------------
// Public
// ---------------------------------------------------------------------------
const publicEnvSchema = z.object({
  firebase: z.object({
    apiKey: z.string().min(1),
    authDomain: z.string().min(1),
    projectId: z.string().min(1),
    storageBucket: z.string().min(1),
    messagingSenderId: z.string().min(1),
    appId: z.string().min(1),
  }),
  supabase: z.object({
    url: z.string().url(),
    anonKey: z.string().min(1),
  }),
  site: z.object({
    siteUrl: z.string().url(),
    publicBaseUrl: z.string().url(),
    adminBaseUrl: z.string().url(),
    apiBaseUrl: z.string().url(),
    /**
     * Where the admin panel is mounted. `/admin` today; `''` once the panel
     * moves to its own hostname. Nothing in the application hard-codes the
     * literal string — see lib/config/routes.ts.
     */
    adminPathPrefix: z.string().regex(/^(\/[a-z0-9-]+)?$/, {
      message: 'adminPathPrefix must be empty or a single lowercase path segment such as "/admin"',
    }),
  }),
  brand: z.object({
    name: z.string().min(1),
    tagline: z.string().min(1),
    legalEntityName: z.string().optional(),
    supportEmail: z.string().email(),
    supportPhone: z.string().optional(),
    businessAddress: z.string().optional(),
    grievanceEmail: z.string().email().optional(),
  }),
  /**
   * Store links are optional on purpose. When a link is absent the CTA is not
   * rendered at all, rather than pointing at a placeholder URL that 404s.
   */
  apps: z.object({
    customerAndroid: optionalUrl,
    customerIos: optionalUrl,
    workerAndroid: optionalUrl,
    workerIos: optionalUrl,
  }),
  features: z.object({
    adminRealtime: z.boolean(),
  }),
});

export type PublicEnv = z.infer<typeof publicEnvSchema>;

function readPublicEnv(): PublicEnv {
  const raw = {
    firebase: {
      apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY ?? '',
      authDomain: process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN ?? '',
      projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID ?? '',
      storageBucket: process.env.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET ?? '',
      messagingSenderId: process.env.NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID ?? '',
      appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID ?? '',
    },
    supabase: {
      url: process.env.NEXT_PUBLIC_SUPABASE_URL ?? '',
      anonKey: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ?? '',
    },
    site: {
      siteUrl: process.env.NEXT_PUBLIC_SITE_URL ?? 'http://localhost:3000',
      publicBaseUrl:
        process.env.NEXT_PUBLIC_PUBLIC_BASE_URL ??
        process.env.NEXT_PUBLIC_SITE_URL ??
        'http://localhost:3000',
      adminBaseUrl:
        process.env.NEXT_PUBLIC_ADMIN_BASE_URL ??
        process.env.NEXT_PUBLIC_SITE_URL ??
        'http://localhost:3000',
      apiBaseUrl:
        process.env.NEXT_PUBLIC_API_BASE_URL ??
        `${process.env.NEXT_PUBLIC_SITE_URL ?? 'http://localhost:3000'}/api`,
      adminPathPrefix: process.env.NEXT_PUBLIC_ADMIN_PATH_PREFIX ?? '/admin',
    },
    brand: {
      name: process.env.NEXT_PUBLIC_BRAND_NAME || 'Wervexa',
      tagline:
        process.env.NEXT_PUBLIC_BRAND_TAGLINE || 'Verified home-service professionals, near you',
      legalEntityName: process.env.NEXT_PUBLIC_LEGAL_ENTITY_NAME || undefined,
      supportEmail: process.env.NEXT_PUBLIC_SUPPORT_EMAIL || 'support@example.com',
      supportPhone: process.env.NEXT_PUBLIC_SUPPORT_PHONE || undefined,
      businessAddress: process.env.NEXT_PUBLIC_BUSINESS_ADDRESS || undefined,
      grievanceEmail: process.env.NEXT_PUBLIC_GRIEVANCE_OFFICER_EMAIL || undefined,
    },
    apps: {
      customerAndroid: process.env.NEXT_PUBLIC_CUSTOMER_APP_ANDROID_URL || undefined,
      customerIos: process.env.NEXT_PUBLIC_CUSTOMER_APP_IOS_URL || undefined,
      workerAndroid: process.env.NEXT_PUBLIC_WORKER_APP_ANDROID_URL || undefined,
      workerIos: process.env.NEXT_PUBLIC_WORKER_APP_IOS_URL || undefined,
    },
    features: {
      adminRealtime: process.env.NEXT_PUBLIC_ADMIN_REALTIME_ENABLED !== 'false',
    },
  };

  const parsed = publicEnvSchema.safeParse(raw);

  if (!parsed.success) {
    // During `next build` the Firebase and Supabase values may legitimately be
    // absent (for example a CI type-check with no secrets). Fail loudly at
    // runtime instead of shipping a half-configured bundle.
    const issues = parsed.error.issues
      .map((issue) => `  - ${issue.path.join('.')}: ${issue.message}`)
      .join('\n');
    throw new Error(
      `Invalid public environment configuration:\n${issues}\n\n` +
        'Copy .env.example to .env.local and fill in the required values.',
    );
  }

  return parsed.data;
}

let cachedPublicEnv: PublicEnv | null = null;

export function publicEnv(): PublicEnv {
  cachedPublicEnv ??= readPublicEnv();
  return cachedPublicEnv;
}

// ---------------------------------------------------------------------------
// Server
// ---------------------------------------------------------------------------
const serverEnvSchema = z.object({
  firebaseAdmin: z.object({
    projectId: z.string().min(1),
    clientEmail: z.string().email(),
    privateKey: z.string().min(1),
    storageBucket: z.string().min(1),
    sessionCookieMaxAgeSeconds: z.number().int().min(300).max(1209600),
  }),
  supabase: z.object({
    url: z.string().url(),
    serviceRoleKey: z.string().min(1),
  }),
  routing: z.object({
    /** Hostname that serves the admin panel once it moves to a subdomain. */
    adminHost: optionalString,
    authCookieDomain: optionalString,
  }),
  features: z.object({
    contactFormEnabled: z.boolean(),
  }),
  logLevel: z.enum(['debug', 'info', 'warn', 'error']),
  /**
   * Razorpay — used only server-side to create orders and verify payment
   * signatures for the Customer App checkout flow. The key SECRET must never
   * reach a client; the key ID (not secret) is separately embedded in the
   * Flutter app's own build config to open the checkout SDK.
   */
  razorpay: z.object({
    keyId: optionalString,
    keySecret: optionalString,
  }),
});

export type ServerEnv = z.infer<typeof serverEnvSchema>;

function readServerEnv(): ServerEnv {
  if (typeof window !== 'undefined') {
    throw new Error('serverEnv() was called in the browser. Server secrets must never be bundled.');
  }

  const raw = {
    firebaseAdmin: {
      projectId: process.env.FIREBASE_ADMIN_PROJECT_ID ?? '',
      clientEmail: process.env.FIREBASE_ADMIN_CLIENT_EMAIL ?? '',
      // Vercel environment variables cannot contain literal newlines, so the
      // PEM is stored with \n escapes and normalised here.
      privateKey: (process.env.FIREBASE_ADMIN_PRIVATE_KEY ?? '').replace(/\\n/g, '\n'),
      storageBucket:
        process.env.FIREBASE_ADMIN_STORAGE_BUCKET ??
        process.env.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET ??
        '',
      sessionCookieMaxAgeSeconds: Number.parseInt(
        process.env.FIREBASE_SESSION_COOKIE_MAX_AGE ?? '28800',
        10,
      ),
    },
    supabase: {
      url: process.env.NEXT_PUBLIC_SUPABASE_URL ?? '',
      serviceRoleKey: process.env.SUPABASE_SERVICE_ROLE_KEY ?? '',
    },
    routing: {
      adminHost: process.env.ADMIN_HOST || undefined,
      authCookieDomain: process.env.AUTH_COOKIE_DOMAIN || undefined,
    },
    features: {
      contactFormEnabled: process.env.CONTACT_FORM_ENABLED !== 'false',
    },
    logLevel: (process.env.LOG_LEVEL ?? 'info') as ServerEnv['logLevel'],
    razorpay: {
      keyId: process.env.RAZORPAY_KEY_ID || undefined,
      keySecret: process.env.RAZORPAY_KEY_SECRET || undefined,
    },
  };

  const parsed = serverEnvSchema.safeParse(raw);

  if (!parsed.success) {
    const issues = parsed.error.issues
      .map((issue) => `  - ${issue.path.join('.')}: ${issue.message}`)
      .join('\n');
    throw new Error(`Invalid server environment configuration:\n${issues}`);
  }

  return parsed.data;
}

let cachedServerEnv: ServerEnv | null = null;

export function serverEnv(): ServerEnv {
  cachedServerEnv ??= readServerEnv();
  return cachedServerEnv;
}

/** True only in a real production deployment. Gates development affordances. */
export const isProduction = process.env.NODE_ENV === 'production';
export const isDevelopment = process.env.NODE_ENV === 'development';
