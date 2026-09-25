# Security

| Threat | Control |
| --- | --- |
| Signed-in customer/worker opens `/admin` | Layout resolves `admin_users` by verified UID; no row → redirect. RLS returns nothing for admin-only data. |
| Admin performs action outside their role | Route checks permission; DB function calls `require_permission()`. |
| Forged role/permission in request or token | Permissions read from Postgres only. |
| Stolen session via XSS | Session and ID token in httpOnly cookies; no tokens in localStorage; strict CSP. |
| CSRF | `SameSite=Lax` cookies; mutations are JSON POSTs; CSP `form-action 'self'`. |
| Removed admin keeps access | `verifySessionCookie(checkRevoked)` on every request; sign-out revokes refresh tokens. |
| Client sets booking status / wallet balance / verification outcome / match score | No UPDATE grants; column-scoped self-update excludes these; state changes only via `SECURITY DEFINER` functions. |
| Fake payment success | Constraint requires verified signature; `confirm_payment()` not executable by clients. |
| Double payout / double adjustment | Payout must be `REQUESTED`; derived ledger idempotency key; unique idempotency keys. |
| Self-approval of verification | `decide_verification()` refuses when reviewer UID equals worker UID. |
| Audit tampering | Trigger refuses UPDATE/DELETE on `audit_logs` and `wallet_transactions` for every role. |
| Reading another user's KYC document | Storage rules deny all client access; media opened by id only; purpose-rule permission check; path prefix enforced by trigger; access audited; 5-minute URLs. |
| Admin password guessed or reused | Firebase holds and checks passwords (never sent to this server) and rate-limits attempts (`auth/too-many-requests`). Email enumeration protection makes an unknown email look the same as a wrong password, and the reset form gives the same answer for every address. A password gets a Firebase account only; admin access still needs an active `admin_users` row for that UID. |
| Prototype demo login published on `/login` | Shown only while `DEMO_ADMIN_EMAIL` and `DEMO_ADMIN_PASSWORD` are set. It is a separate account marked with a `demo: true` Firebase claim, so the script can't take over or reset a real person's account. `SUPER_ADMIN` is refused. Leave it unset wherever the data is real. |
| Open redirect after login | `safeRedirect()` accepts only admin-relative paths. |
| PostgREST filter injection via search | `sanitiseSearchTerm()` strips filter syntax; enum filters narrowed with `asEnumValue()`. |
| Mass data extraction | Page size capped at 100; server-side pagination everywhere. |
| Contact form spam | Honeypot, DB-backed rate limit per salted IP hash, server validation. |
| Secret leakage | `server-only` on Admin SDK and service-role modules; test asserts no client component imports them; `.env.example` placeholders only. |
| Database errors leak schema | `translateDatabaseError()` maps tagged errors; unknown errors return a generic message; details logged with redaction. |
| Admin pages indexed or cached | `X-Robots-Tag: noindex`, `Cache-Control: no-store`, robots disallow. |

## Operational requirements

- Configure Supabase Third-Party Auth for the Firebase project.
- Add deployment hostnames to Firebase Authorized Domains.
- Deploy `firebase/storage.rules` (`npm run firebase:rules`).
- Store `FIREBASE_ADMIN_PRIVATE_KEY` and `SUPABASE_SERVICE_ROLE_KEY` only in the server environment.
- Consider Firebase App Check for phone OTP abuse.
