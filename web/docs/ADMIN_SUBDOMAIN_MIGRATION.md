# Moving the admin panel to its own subdomain

Phase 1: `yourdomain.com/admin`. Phase 2: `admin.yourdomain.com`. The move is configuration; no admin component, service, permission, API contract or audit record changes.

## Why no code changes are needed

- Every admin link uses `adminRoutes` / `adminRoute()` from `src/lib/config/routes.ts`; nothing hard-codes `/admin`.
- Middleware rewrites requests on `ADMIN_HOST` to the admin tree and redirects `/admin/*` on the public host to the admin host.
- API contracts (`/api/admin/*`, `/api/auth/session`) are host-independent.
- Authorization depends on the verified Firebase UID and Postgres, never on the hostname.

## Steps

1. Add `admin.yourdomain.com` to the Vercel project (or a second project from the same repo).
2. Add it to Firebase Console → Authentication → Authorized domains.
3. Set environment variables for the admin deployment:

   ```
   ADMIN_HOST=admin.yourdomain.com
   NEXT_PUBLIC_ADMIN_BASE_URL=https://admin.yourdomain.com
   NEXT_PUBLIC_ADMIN_PATH_PREFIX=
   ```

4. Cookies: leave `AUTH_COOKIE_DOMAIN` empty. Admin sessions stay host-only (`__Host-` prefix) on the admin host, which is the safer choice; administrators sign in once on the new host.
5. Redeploy. Old `/admin/...` URLs on the public host 308-redirect to the admin host.

## If splitting into a separate application later

Copy `src/app/admin`, `src/app/login`, `src/app/api/admin`, `src/app/api/auth`, `src/components/{admin,ui,shared,auth}` and `src/lib`. The public site keeps `src/app/(public)`. Both keep the same Supabase and Firebase projects.
