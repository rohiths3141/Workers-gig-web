import { NextResponse, type NextRequest } from 'next/server';

/**
 * Middleware.
 *
 * Two jobs, and one deliberate non-job.
 *
 *   1. Host routing. When ADMIN_HOST is configured, requests arriving on that
 *      hostname are rewritten onto the admin surface and the public website is
 *      not served from it. This is the whole of the subdomain migration as far
 *      as the application is concerned.
 *
 *   2. A cheap gate. A request to an admin path with no session cookie is sent
 *      to the sign-in page without spending a database round trip.
 *
 * What it deliberately does not do is authorize. Middleware runs on the Edge
 * runtime, where the Firebase Admin SDK cannot run, so it cannot verify a
 * signature. A present cookie here means nothing more than "a cookie is
 * present" — a forged value passes this check and then fails at the layout, the
 * page, the API route and the database, each of which verifies properly.
 *
 * Treating middleware as the security boundary is the mistake this comment
 * exists to prevent. It is a routing optimisation.
 */

const ADMIN_PATH_PREFIX = process.env.NEXT_PUBLIC_ADMIN_PATH_PREFIX ?? '/admin';
const ADMIN_HOST = process.env.ADMIN_HOST ?? '';

// Must match the names in lib/auth/cookies.ts. Duplicated because middleware
// cannot import server-only modules.
const SESSION_COOKIES = ['__Host-ss_session', 'ss_session'];

function hasSessionCookie(request: NextRequest): boolean {
  return SESSION_COOKIES.some((name) => Boolean(request.cookies.get(name)?.value));
}

function isAdminPath(pathname: string): boolean {
  if (ADMIN_PATH_PREFIX === '') return true;
  return pathname === ADMIN_PATH_PREFIX || pathname.startsWith(`${ADMIN_PATH_PREFIX}/`);
}

export function middleware(request: NextRequest) {
  const { pathname, search } = request.nextUrl;
  const host = request.headers.get('host') ?? '';

  // ---------------------------------------------------------------------
  // Phase 2: the admin panel has its own hostname
  // ---------------------------------------------------------------------
  if (ADMIN_HOST && host === ADMIN_HOST) {
    // Auth and API routes are shared and must not be rewritten.
    if (!pathname.startsWith('/api') && !pathname.startsWith('/login')) {
      const target = pathname === '/' ? '/admin' : `/admin${pathname}`;

      if (!hasSessionCookie(request) && !pathname.startsWith('/_next')) {
        return redirectToLogin(request, target);
      }

      const url = request.nextUrl.clone();
      url.pathname = target;
      return NextResponse.rewrite(url);
    }

    return NextResponse.next();
  }

  // The public website must not be reachable on the admin hostname, and the
  // admin panel should not remain reachable by path once it has its own host.
  if (ADMIN_HOST && host !== ADMIN_HOST && isAdminPath(pathname)) {
    const url = new URL(`${request.nextUrl.protocol}//${ADMIN_HOST}${pathname}${search}`);
    return NextResponse.redirect(url, 308);
  }

  // ---------------------------------------------------------------------
  // Phase 1: the admin panel lives under /admin on the main host
  // ---------------------------------------------------------------------
  if (isAdminPath(pathname) && !hasSessionCookie(request)) {
    return redirectToLogin(request, `${pathname}${search}`);
  }

  return NextResponse.next();
}

function redirectToLogin(request: NextRequest, next: string): NextResponse {
  const url = request.nextUrl.clone();
  url.pathname = '/login';
  url.search = '';
  url.searchParams.set('next', next);
  return NextResponse.redirect(url);
}

export const config = {
  /**
   * Skip static assets and image optimisation. Matching them would add latency
   * to every asset for no benefit, since none of them are protected.
   */
  matcher: ['/((?!_next/static|_next/image|favicon.ico|robots.txt|sitemap.xml|.*\\..*).*)'],
};
