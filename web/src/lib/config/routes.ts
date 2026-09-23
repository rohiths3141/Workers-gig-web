import { publicEnv } from './env';

/**
 * Central route configuration.
 *
 * The admin panel is mounted under a configurable prefix. Nothing in the
 * application writes the literal string "/admin" — every link and redirect goes
 * through `adminRoute()`, and every server-side guard goes through
 * `isAdminPath()`.
 *
 * Phase 1:  NEXT_PUBLIC_ADMIN_PATH_PREFIX="/admin"   -> yourdomain.com/admin
 * Phase 2:  NEXT_PUBLIC_ADMIN_PATH_PREFIX=""         -> admin.yourdomain.com
 *           ADMIN_HOST="admin.yourdomain.com"
 *
 * The Phase 2 switch is configuration only. Admin components, services,
 * permissions, API contracts and audit history are untouched.
 */

/** The prefix the admin panel is currently served under. */
export function adminPathPrefix(): string {
  return publicEnv().site.adminPathPrefix;
}

/**
 * Build a path inside the admin panel.
 *
 *   adminRoute()                 -> "/admin"
 *   adminRoute('/workers')       -> "/admin/workers"
 *   adminRoute('/workers', id)   -> "/admin/workers/<id>"
 *
 * After the subdomain migration the same calls return "/", "/workers", ...
 */
export function adminRoute(path = '', ...segments: Array<string | number>): string {
  const prefix = adminPathPrefix();
  const tail = segments.length ? `/${segments.map((s) => encodeURIComponent(String(s))).join('/')}` : '';
  const joined = `${prefix}${path}${tail}`;
  return joined === '' ? '/' : joined;
}

/** An absolute URL into the admin panel, for emails and cross-origin redirects. */
export function absoluteAdminUrl(path = ''): string {
  const { adminBaseUrl } = publicEnv().site;
  return new URL(adminRoute(path), adminBaseUrl).toString();
}

/** An absolute URL on the public website, for canonical tags and sitemaps. */
export function absolutePublicUrl(path = '/'): string {
  const { publicBaseUrl } = publicEnv().site;
  return new URL(path, publicBaseUrl).toString();
}

/** Does this pathname belong to the admin surface? */
export function isAdminPath(pathname: string): boolean {
  const prefix = adminPathPrefix();
  if (prefix === '') {
    // Subdomain mode: the host decides, not the path. Callers pair this with a
    // host check in middleware.
    return true;
  }
  return pathname === prefix || pathname.startsWith(`${prefix}/`);
}

// ---------------------------------------------------------------------------
// Public website routes
// ---------------------------------------------------------------------------
export const publicRoutes = {
  home: '/',
  services: '/services',
  service: (slug: string) => `/services/${slug}`,
  howItWorks: '/how-it-works',
  forCustomers: '/for-customers',
  forWorkers: '/for-workers',
  download: '/download',
  verification: '/verification',
  safety: '/safety',
  about: '/about',
  contact: '/contact',
  faq: '/faq',
  privacy: '/privacy',
  terms: '/terms',
  refundPolicy: '/refund-policy',
  cancellationPolicy: '/cancellation-policy',
  login: '/login',
} as const;

// ---------------------------------------------------------------------------
// Admin routes
// ---------------------------------------------------------------------------
/**
 * Every admin destination in one place. Pages and navigation import from here
 * so a route rename is a single edit, and so the eventual subdomain move needs
 * no search-and-replace through business logic.
 */
export const adminRoutes = {
  root: () => adminRoute(),
  dashboard: () => adminRoute('/dashboard'),

  workers: () => adminRoute('/workers'),
  worker: (id: string) => adminRoute('/workers', id),

  customers: () => adminRoute('/customers'),
  customer: (id: string) => adminRoute('/customers', id),

  bookings: () => adminRoute('/bookings'),
  booking: (id: string) => adminRoute('/bookings', id),

  verification: () => adminRoute('/verification'),
  verificationCase: (id: string) => adminRoute('/verification', id),
  gigs: () => adminRoute('/gigs'),

  services: () => adminRoute('/services'),
  matching: () => adminRoute('/matching'),
  materials: () => adminRoute('/materials'),

  payments: () => adminRoute('/payments'),
  payment: (id: string) => adminRoute('/payments', id),
  wallets: () => adminRoute('/wallets'),
  wallet: (workerId: string) => adminRoute('/wallets', workerId),
  payouts: () => adminRoute('/payouts'),

  claims: () => adminRoute('/claims'),
  claim: (id: string) => adminRoute('/claims', id),
  insurance: () => adminRoute('/insurance'),

  support: () => adminRoute('/support'),
  supportTicket: (id: string) => adminRoute('/support', id),

  notifications: () => adminRoute('/notifications'),
  auditLogs: () => adminRoute('/audit-logs'),
  settings: () => adminRoute('/settings'),

  forbidden: () => adminRoute('/forbidden'),
} as const;

// ---------------------------------------------------------------------------
// API routes
// ---------------------------------------------------------------------------
/**
 * The admin API contract. These paths stay stable across the subdomain
 * migration — only the origin they are served from changes — so the Flutter
 * apps and any future admin client keep working.
 */
export const apiRoutes = {
  session: '/api/auth/session',
  sessionRefresh: '/api/auth/session/refresh',
  /** Adds the Supabase role claim for app users. Bearer Firebase ID token. */
  authClaims: '/api/auth/claims',

  adminWorkers: '/api/admin/workers',
  adminWorker: (id: string) => `/api/admin/workers/${id}`,
  adminWorkerStatus: (id: string) => `/api/admin/workers/${id}/status`,
  adminWorkerBackgroundCheck: (id: string) => `/api/admin/workers/${id}/background-check`,
  adminGigDecision: (id: string) => `/api/admin/gigs/${id}/decision`,

  adminCustomers: '/api/admin/customers',
  adminCustomerStatus: (id: string) => `/api/admin/customers/${id}/status`,

  adminBookings: '/api/admin/bookings',
  adminBookingTransition: (id: string) => `/api/admin/bookings/${id}/transition`,

  adminVerification: '/api/admin/verification',
  adminVerificationDecision: (id: string) => `/api/admin/verification/${id}/decision`,

  adminMatching: (bookingId: string) => `/api/admin/matching/${bookingId}`,

  adminPayments: '/api/admin/payments',
  adminPaymentRefund: (id: string) => `/api/admin/payments/${id}/refund`,

  adminWallets: '/api/admin/wallets',
  adminWalletAdjust: (workerId: string) => `/api/admin/wallets/${workerId}/adjust`,

  adminPayouts: '/api/admin/payouts',
  adminPayoutDecision: (id: string) => `/api/admin/payouts/${id}/decision`,

  adminMaterials: '/api/admin/materials',
  adminClaims: '/api/admin/claims',
  adminClaimDecision: (id: string) => `/api/admin/claims/${id}/decision`,
  adminInsurance: '/api/admin/insurance',

  adminSupport: '/api/admin/support',
  adminSupportMessage: (id: string) => `/api/admin/support/${id}/messages`,
  adminSupportStatus: (id: string) => `/api/admin/support/${id}/status`,

  adminNotifications: '/api/admin/notifications',
  adminAuditLogs: '/api/admin/audit-logs',
  adminSettings: '/api/admin/settings',

  /** Short-lived signed URL for one Supabase Storage object. */
  adminMediaUrl: (mediaId: string) => `/api/admin/media/${mediaId}/url`,

  publicContact: '/api/public/contact',
} as const;
