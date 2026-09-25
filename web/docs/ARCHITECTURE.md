# Architecture

## Responsibilities

| Concern | Technology | Where it lives |
| --- | --- | --- |
| Authentication (phone OTP; admin panel also Google and email/password) | Firebase Authentication | Firebase project |
| Identity reference | Firebase UID | `public.profiles.firebase_uid` |
| Files (photos, video, KYC, certificates, receipts, evidence) | Firebase Storage | `firebase/storage.rules` (deny-all) |
| File references + access rules | Postgres | `public.media_assets`, `public.media_purpose_rules` |
| Business data, authorization data | Supabase Postgres | `supabase/migrations` |
| Database security | RLS + `SECURITY DEFINER` operations | `0009`, `0010`, `0011` |
| Realtime | Supabase Realtime (RLS-filtered) | publication in `0009` |
| Public website + Admin Panel | Next.js 15 on Vercel | `src/` |
| Customer / Worker apps | Flutter | `../customer-app`, `../worker-app` |

Supabase Auth and Supabase Storage are disabled (`supabase/config.toml`) and unused.

## Identity: how a Firebase UID reaches Postgres

```
Flutter app ── Firebase ID token ──> PostgREST
                                     Supabase Third-Party Auth validates against Google JWKS
                                     request.jwt.claims.sub = Firebase UID
                                     public.firebase_uid() resolves it (issuer must be securetoken.google.com)

Admin browser ── email+password / Google / phone OTP ──> Firebase ── ID token ──> POST /api/auth/session
                 server: Admin SDK verifyIdToken(checkRevoked)
                 sets httpOnly session cookie + httpOnly ID-token cookie
                 every request: verify session cookie, forward ID token to Supabase as bearer
```

The ID token is forwarded rather than using the service role, so **RLS applies to admin reads and writes too**. `SessionKeeper` refreshes the ID-token cookie from the browser via `/api/auth/session/refresh`, which rejects a token whose UID differs from the session.

`serviceClient()` (RLS bypass) is used only where there is no signed-in actor: the contact form and sign-in bookkeeping.

## Authorization: five layers for every admin mutation

1. **Middleware** — no session cookie → redirect to `/login`. Cheap, unverified; not a security boundary.
2. **Admin layout** — verifies the cookie with the Admin SDK, resolves `admin_users` by Firebase UID, loads permissions from Postgres. Non-admins are redirected.
3. **Page** — `guardPage(permission)` renders a Forbidden panel when the permission is missing.
4. **API route** — `withAdminRoute` authenticates, checks the permission, validates with Zod, translates errors.
5. **Database** — the `SECURITY DEFINER` function calls `require_permission()`, validates the business rule, and writes the audit row in the same transaction.

Permissions are never read from a token claim or request body. `src/lib/permissions/permissions.ts` is a UX mirror; `tests/permissions.test.ts` keeps it identical to the SQL.

## Business rules live in the database

| Rule | Enforcement |
| --- | --- |
| Booking status changes | `booking_transitions` table + `transition_booking()`; no UPDATE grant on `bookings` |
| Verification decisions | `decide_verification()`; self-review refused; outcome flags on `workers` derived by trigger |
| Matching scores | `run_matching()` reads DB state; no client write grant on candidates |
| Wallet balance | derived from append-only `wallet_transactions` by trigger |
| Payout approval | `decide_payout()` debits ledger atomically with derived idempotency key |
| Payment success | constraint requires verified gateway signature; `confirm_payment()` not granted to clients |
| Claims | `decide_claim()`; no automatic path |
| Audit trail | `write_audit_log()`; UPDATE/DELETE refused by trigger |
| Media paths | trigger rebuilds expected prefix from purpose + owner; sensitivity derived, not supplied |

## Media flow

Download: admin UI sends a **media id** → `/api/admin/media/[id]/url` → RLS-scoped row read → purpose rule permission check → audit row for `SENSITIVE` → Admin SDK signed URL (5 min for sensitive). The URL is fetched on click, never rendered into HTML.

Upload (apps): backend authorizes purpose/owner/type/size → inserts `media_assets` row `PENDING` (path validated by trigger) → signed upload URL → client uploads → backend verifies object exists and size matches → `COMPLETED`. See `BACKEND_CONTRACTS.md` for the endpoint still to be built.

## Source layout

```
src/app/(public)/     public website (own layout)
src/app/login/        admin sign-in
src/app/admin/        admin panel (own layout, own auth guard)
src/app/api/admin/    admin API contract (stable across subdomain move)
src/app/api/auth/     session exchange
src/components/{ui,shared,public,admin}
src/features/         server-side domain modules (dashboard, media)
src/lib/{config,auth,api,firebase,supabase,permissions,errors,logging,validation,utils,data}
```
