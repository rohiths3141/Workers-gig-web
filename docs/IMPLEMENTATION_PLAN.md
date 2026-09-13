# Implementation plan and status

| Phase | Scope | Status |
| --- | --- | --- |
| 1 Foundation | Next.js 15, strict TS, Tailwind v4, env validation, route config, logging, error model | Done |
| 2 Public website | Home, services, service detail, how it works, customers, workers, verification, safety, about, contact, FAQ, 4 legal pages, sitemap, robots, structured data | Done — legal text is draft pending legal review |
| 3 Admin authentication | Firebase Google + phone OTP, session cookie exchange, ID token refresh, admin resolution, permissions | Done |
| 4 Admin foundation | Layout, sidebar, breadcrumbs, data table, filters, pagination, toasts, confirm dialog, permission guard | Done |
| 5 Operations | Dashboard, workers, customers, bookings + timeline + transitions, matching, materials | Done |
| 6 Verification | Queue tabs, case detail, decisions, document access, insurance | Done |
| 7 Finance | Payments (read), wallets + ledger + adjustment, payouts + decisions | Done — refunds pending (contract 4) |
| 8 Trust & safety | Claims + evidence + decisions, support tickets + replies + status | Done |
| 9 System | Notifications log, audit logs, settings (read) | Done — admin/settings writes pending (contracts 11, 12) |
| 10 Hardening | Static security tests, enum/permission parity, state machine tests, input safety | Partly done — see below |

## Not yet done

- Items in `BACKEND_CONTRACTS.md` → Pending.
- Realtime subscriptions in the admin UI (contract 13).
- Integration tests against a running Supabase (RLS behaviour with real Firebase tokens, IDOR checks per table). Current tests are static and unit-level.
- Browser tests for accessibility and responsive layouts (Playwright + axe).
- Lighthouse/performance pass on a deployed build.
- Legal review of privacy, terms, refund and cancellation text.
- Ratings moderation UI and Reports section from the navigation brief.

## Running

```bash
npm run typecheck
npm test
npm run build
```
