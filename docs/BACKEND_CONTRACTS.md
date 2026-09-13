# Backend contracts

What the web tier needs from the platform, and the status of each. "Built" means implemented in this repository; "Pending" means the web tier depends on it but it does not exist yet.

## Built

| Contract | Location |
| --- | --- |
| Identity binding: `profiles.firebase_uid`, `firebase_uid()` resolving JWT or trusted GUC | `0002` |
| Permission catalogue, role mapping, per-user grants, `require_permission()` | `0002` |
| RLS on every table, column-scoped self-update grants | `0009` |
| Booking state machine: `booking_transitions`, `transition_booking()`, `admin_transition_booking()` | `0010` |
| Verification decisions and derived worker flags, expiry sweep | `0010` |
| Matching engine `run_matching()`, `admin_rerun_matching()` | `0011` |
| Ledger `post_wallet_transaction()`, `admin_adjust_wallet()` | `0011` |
| Payouts `request_payout()` (worker), `decide_payout()` (admin) | `0011` |
| Claims `decide_claim()` | `0011` |
| Payment confirmation `confirm_payment()` (server-only) | `0011` |
| Account moderation, support messaging/status/assignment | `0011` |
| Media references, purpose rules, path enforcement | `0008` |
| Admin API routes (workers, customers, bookings, verification, payouts, claims, wallets, matching, support, media URL) | `src/app/api/admin` |
| Session exchange + refresh | `src/app/api/auth/session` |
| Public contact endpoint with DB-backed rate limit | `src/app/api/public/contact` |

## Pending — required before production

| # | Contract | Needed by | Notes |
| --- | --- | --- | --- |
| 1 | **Supabase Third-Party Auth configured for the Firebase project** | Everything authenticated | Dashboard → Authentication → Third-Party Auth → Firebase. Without it PostgREST rejects the forwarded Firebase token and admin pages render as unauthenticated. Tokens must also carry `role: "authenticated"`: the web sign-in adds it automatically, and the Flutter apps must call `POST /api/auth/claims` once after sign-in (or the project can use a Firebase `beforeUserCreated` blocking function instead). |
| 2 | **Payment gateway webhook** (Edge Function) that verifies the HMAC signature and calls `confirm_payment()` with the service role | Payments, wallets | `confirm_payment` refuses unverified input; the webhook itself is not built. |
| 3 | **Payment order creation** for the customer app (server creates gateway order + `payments` row with idempotency key) | Customer app checkout | |
| 4 | **Refund execution**: `admin_refund_payment()` RPC + gateway refund call + webhook reconciliation | Admin payments page | Schema (`refunds`) exists; `refundSchema` and `apiRoutes.adminPaymentRefund` are defined; the operation is not. UI shows refunds read-only. |
| 5 | **Payout disbursement worker**: moves `PROCESSING` → `COMPLETED`/`FAILED` from the payout provider; on failure posts `CREDIT_PAYOUT_REVERSAL` | Payouts | Approval already debits the ledger. |
| 6 | **Media upload endpoint** for the apps: authorize purpose/owner → insert `PENDING` row → signed upload URL → completion check via `verifyStoredObject()` | Worker KYC, job evidence, claims, support | Download path is built; upload is not. |
| 7 | **Customer/worker booking RPCs**: create booking, accept offer, start travel, verify arrival code, start work, request/approve materials, approve completion | Flutter apps | `transition_booking()` supports CUSTOMER/WORKER actors, but wrapper RPCs that resolve the caller and validate ownership are not written. |
| 8 | **Profile provisioning for workers and customers** from the apps (create `customers`/`workers` row on registration) | Flutter apps | Sign-in creates a `profiles` row only. |
| 9 | **Notification delivery worker**: dequeues `notifications`, sends via FCM/SMS/email, records provider message id, handles delivery webhooks | Notifications page | Page is read-only by design. |
| 10 | **Scheduled jobs** (pg_cron): `expire_stale_verifications()`, insurance `EXPIRING_SOON`/`EXPIRED`, stale `PENDING` media sweep, `REQUESTED` booking expiry | Verification, insurance, matching | Functions exist for verification expiry only. |
| 11 | **Admin management**: create/disable admin, change role, grant/revoke permission (`admins.manage`) | Settings | Use `seed/bootstrap_super_admin.sql` for the first admin. |
| 12 | **Settings and service catalogue writes** (`settings.update`, `services.update`) | Settings, Services | Read-only views built. |
| 13 | **Realtime subscriptions in the admin UI** | Dashboard freshness | Tables are published and RLS-filtered; a client subscription component is not built. Pages are server-rendered per request. |
| 14 | **Sign-in rate limiting / abuse controls** | Login | Firebase phone auth has quota + reCAPTCHA; consider Firebase App Check. |
| 15 | **Regenerated database types** (`npm run db:types`) | Type safety of joins | `database.types.ts` is hand-written; joined selects use `overrideTypes`. |
