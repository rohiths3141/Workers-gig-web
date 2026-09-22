import type { NextConfig } from 'next';

/**
 * Content Security Policy.
 *
 * The browser may only talk to the two backends this platform actually uses:
 *   - Firebase  (Identity Toolkit for auth, Storage for media)
 *   - Supabase  (PostgREST for data, websocket for Realtime)
 *
 * Both origins are derived from environment configuration so a misconfigured
 * deployment fails closed rather than silently widening the policy.
 */
function originOf(raw: string | undefined): string {
  if (!raw) return '';
  try {
    return new URL(raw).origin;
  } catch {
    return '';
  }
}

const supabaseOrigin = originOf(process.env.NEXT_PUBLIC_SUPABASE_URL);
const supabaseWsOrigin = supabaseOrigin.replace(/^http/, 'ws');

const firebaseAuthDomain = process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN
  ? `https://${process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN}`
  : '';

// Firebase Auth (Identity Toolkit + token refresh) and Firebase Storage.
const firebaseApiOrigins = [
  'https://identitytoolkit.googleapis.com',
  'https://securetoken.googleapis.com',
  'https://firebasestorage.googleapis.com',
  // Signed download/upload URLs are served from the GCS host.
  'https://storage.googleapis.com',
  firebaseAuthDomain,
].filter(Boolean);

/**
 * Sign-in uses exactly two methods: phone OTP and Google.
 *
 * Phone OTP requires Firebase's invisible reCAPTCHA, and the Google provider
 * runs its flow through apis.google.com. Both need explicit allowance — the
 * default-deny policy would otherwise break sign-in with no visible error.
 */
const googleSignInOrigins = [
  'https://apis.google.com',
  'https://www.google.com',
  'https://www.gstatic.com',
  'https://accounts.google.com',
];

const connectSrc = [
  "'self'",
  supabaseOrigin,
  supabaseWsOrigin,
  ...firebaseApiOrigins,
  ...googleSignInOrigins,
].filter(Boolean);

const imgSrc = [
  "'self'",
  'data:',
  'blob:',
  'https://firebasestorage.googleapis.com',
  'https://storage.googleapis.com',
  // Google account avatars, returned by the Google sign-in provider.
  'https://lh3.googleusercontent.com',
  'https://www.gstatic.com',
].filter(Boolean);

const csp = [
  "default-src 'self'",
  // Next.js injects an inline bootstrap script. Beyond that, scripts may come
  // only from this origin and from Google's sign-in and reCAPTCHA hosts — no
  // general-purpose script CDN is permitted.
  `script-src 'self' 'unsafe-inline' ${googleSignInOrigins.join(' ')}${
    process.env.NODE_ENV === 'development' ? " 'unsafe-eval'" : ''
  }`,
  "style-src 'self' 'unsafe-inline'",
  `img-src ${imgSrc.join(' ')}`,
  "font-src 'self' data:",
  `connect-src ${connectSrc.join(' ')}`,
  // The Firebase Auth handler, the Google account chooser, and the reCAPTCHA
  // challenge each render in an iframe.
  `frame-src 'self' https://www.google.com https://accounts.google.com${
    firebaseAuthDomain ? ` ${firebaseAuthDomain}` : ''
  }`,
  "frame-ancestors 'none'",
  "object-src 'none'",
  "base-uri 'self'",
  "form-action 'self'",
].join('; ');

const securityHeaders = [
  { key: 'Content-Security-Policy', value: csp },
  { key: 'X-Content-Type-Options', value: 'nosniff' },
  { key: 'X-Frame-Options', value: 'DENY' },
  { key: 'Referrer-Policy', value: 'strict-origin-when-cross-origin' },
  { key: 'Permissions-Policy', value: 'camera=(), microphone=(), geolocation=(self), payment=()' },
  { key: 'X-DNS-Prefetch-Control', value: 'on' },
  { key: 'Strict-Transport-Security', value: 'max-age=63072000; includeSubDomains; preload' },
];

const nextConfig: NextConfig = {
  reactStrictMode: true,
  poweredByHeader: false,
  // firebase-admin pulls in native/optional deps that must not be bundled.
  serverExternalPackages: ['firebase-admin'],
  experimental: {
    optimizePackageImports: ['lucide-react'],
  },
  images: {
    remotePatterns: [
      { protocol: 'https', hostname: 'firebasestorage.googleapis.com' },
      { protocol: 'https', hostname: 'storage.googleapis.com' },
    ],
  },
  async headers() {
    return [
      { source: '/:path*', headers: securityHeaders },
      // The admin surface must never be cached by a shared cache or indexed.
      {
        source: '/admin/:path*',
        headers: [
          { key: 'Cache-Control', value: 'no-store, max-age=0' },
          { key: 'X-Robots-Tag', value: 'noindex, nofollow, noarchive' },
        ],
      },
      {
        source: '/api/:path*',
        headers: [{ key: 'Cache-Control', value: 'no-store, max-age=0' }],
      },
    ];
  },
};

export default nextConfig;
