# Wervexa Captain App — Architecture and Backend Contracts

This document is the output of the architecture phase and the reference the
implementation follows. It records what was reused from the previous
Worker/Captain application, what was deliberately not reused, how the app is
layered, and exactly which backend contracts it depends on.

The platform backend already exists in `web/` (Next.js admin + public site,
Supabase migrations `0001`–`0012`, Firebase Storage rules). **That schema is the
source of truth.** This app was designed against it rather than inventing a
parallel data model, and the one migration this app adds (`0013`) follows the
existing file's conventions exactly.

---

## 1. Product concepts carried over

These came from the previous application's feature inventory and are worth
keeping. They are business concepts, not code.

| Concept | Why it survives |
| --- | --- |
| Booking lifecycle `REQUESTED → … → CLOSED` | Already modelled as data in `booking_transitions`; the app reads it rather than restating it |
| Cryptographic arrival code | The right mechanism for proving a worker actually arrived |
| Material request → customer approval → invoice | The strongest workflow in the old product |
| Immutable wallet ledger | Correct financial primitive; `wallet_transactions` already enforces it |
| RPL / Skill India qualification pathway | Genuine differentiator for this worker segment |
| Two-sided ratings with completion gating | Already modelled in `ratings` |
| Threaded support tickets | Already modelled in `support_tickets` / `support_messages` |
| 48px minimum touch targets | Correct discipline for the usage context |
| Tamil / English / Hindi language support | Correct for the target market |

## 2. Patterns deliberately not reused

Each of these was a defect in the old application. The replacement is listed so
the absence is a decision, not an oversight.

| Old defect | What this app does instead |
| --- | --- |
| Any password accepted; fabricated verified profile | Firebase phone OTP is the only credential. No local account is ever synthesised. |
| Five hardcoded `VERIFIED` rows on the profile | Every badge renders `worker_verifications.status` read from the server; `NOT_SUBMITTED` is the default, not `APPROVED` |
| Worker could self-award verified status | Only `decide_verification()` writes a decision, and it refuses self-review |
| Arrival OTP returned success when the server rejected it | `verify_arrival_code()` is authoritative; the client renders whatever it returns and never assumes success |
| Evidence captured as a URL text box | Real camera/gallery capture → validated → signed-URL upload to Firebase Storage → `media_assets` row |
| Dummy fallback data when an API failed | There is no fallback path. Failure renders an error with a retry action. This is enforced by a test. |
| Fake notifications, fake SOS | Notifications read `public.notifications`. SOS is not shipped as a working feature — the screen states plainly that it is unavailable. |
| Onboarding wizard where 5 of 7 steps discarded input | Every step persists server-side before advancing; progress is recomputed from the server |
| Wallet dummy balance | Balance is read from `wallets`, which is itself derived from the ledger by trigger |
| One worker locked to one trade | `worker_gigs` — a worker holds many skills and many gigs (§7) |

## 3. Layering

```
presentation   widgets, screens          — no Firebase or Supabase types cross this line
     ↓
application    Riverpod controllers      — AsyncValue<T>, orchestration, no SDK calls
     ↓
domain         entities, enums, failures — pure Dart, no dependencies
     ↑
data           repository implementations — Supabase/Firebase live only here
```

Rules enforced by review and by `test/architecture_test.dart`:

- No file under `lib/features/**/presentation/**` may import `supabase_flutter`,
  `firebase_auth`, `firebase_storage` or `dart:io`.
- Repository *interfaces* live in `lib/domain/repositories/`; implementations in
  `lib/data/repositories/`. Controllers depend on the interface only.
- Every repository method returns `Result<T>` (`Ok`/`Err`) rather than throwing,
  so failure is part of the type and cannot be forgotten.

## 4. Trust boundary

The client is never authoritative. It requests actions and renders server state.

The app **may** read directly from Supabase (PostgREST) because RLS scopes every
row to `public.firebase_uid()`, which is derived from the verified Firebase ID
token — never from a request body. Reads are therefore safe to do from the
device.

The app **may not** write anything that carries business meaning. Every mutation
below goes through a `security definer` RPC that re-derives the caller's worker
identity server-side:

| Action | Contract | Notes |
| --- | --- | --- |
| Change availability | `worker_set_availability(text)` | Refuses when the worker is not eligible, and says why |
| Accept a job offer | `worker_accept_offer(uuid)` | Locks the booking; loses cleanly to a competing accept |
| Decline a job offer | `worker_decline_offer(uuid, text)` | |
| Start travel / arrive / start work / finish | `worker_advance_booking(uuid, booking_status, text)` | Delegates to `transition_booking()` |
| Verify arrival | `worker_verify_arrival(uuid, text)` | Constant-time compare, attempt-limited |
| Request material | `worker_request_material(...)` | Worker can never mark it approved |
| Record actual material cost | `worker_record_material_cost(uuid, bigint)` | Requires an uploaded receipt |
| Submit a verification case | `worker_submit_verification(verification_type, jsonb)` | Sets `PENDING`, never `APPROVED` |
| Create / update / pause a gig | `worker_upsert_gig(...)`, `worker_set_gig_status(...)` | Checked against approved skills |
| Add a skill | `worker_request_service(uuid)` | Creates an unapproved row; admin approves |
| Request a payout | `request_payout(bigint, text)` | Already existed; idempotent |
| Rate the customer | `worker_rate_customer(uuid, smallint, text)` | Only on an eligible booking |
| Create a support ticket / message | `worker_create_support_ticket(...)`, `worker_post_support_message(...)` | |
| Register for push | `worker_register_push_token(...)` | |

Things the client can never write, by grant: `bookings.status`,
`workers.status`, any `is_*_verified` flag, `wallets.balance_minor`, any
`wallet_transactions` row, `worker_verifications.status`, `materials.status`
past its own request, `booking_match_candidates.*`.

## 5. Authentication

```
Worker → Firebase phone OTP → Firebase ID token
                                    ↓
              ┌─────────────────────┴─────────────────────┐
              ↓                                           ↓
   Supabase PostgREST                           Trusted web tier
   (Third-Party Auth: Firebase)                 (Admin SDK verifies token)
   auth.jwt()->>'sub' = Firebase UID            mints signed Storage URLs
   RLS scopes every row
```

Supabase Third-Party Auth is already configured for this Firebase project
(`SUPABASE_THIRD_PARTY_AUTH_FIREBASE_PROJECT_ID`), and `public.firebase_uid()`
accepts a `sub` claim only when `iss` is `https://securetoken.google.com/…`.
The app therefore passes the Firebase ID token straight to Supabase and holds no
second session.

`AuthRepository` exposes `Stream<AuthState>`. When Firebase reports signed-out —
including on token-refresh failure or a disabled account — the session provider
clears all cached state and the router redirects to `/auth`. There is no local
"remember me" that can outlive the Firebase session.

## 6. Media pipeline

The Firebase Storage rules in `web/firebase/storage.rules` are **deny-all** for
clients. This is deliberate: a Storage rule cannot know who is a party to a
booking. So the client never writes to Storage directly.

```
capture (camera/gallery)
   ↓ client-side validation: MIME allow-list, size ceiling, both read from
   ↓ media_purpose_rules — the same row the server validates against
compress (image → WebP/JPEG; video → H.264)
   ↓
POST /api/worker/media/upload-url   { purpose, bookingId?, mimeType, sizeBytes, fileName }
   ↓ server: verify Firebase ID token → resolve worker → check ownership of the
   ↓ owning resource → build the storage path itself (never from the body) →
   ↓ insert media_assets row PENDING → mint a resumable signed upload URL
   ↓
PUT bytes to the signed URL  (progress, cancel, resume, retry with backoff)
   ↓
POST /api/worker/media/{id}/complete
   ↓ server: confirm the object exists and its size matches → mark COMPLETED
```

`media_assets.sensitivity` is derived from `purpose` by trigger, and
`enforce_media_asset_integrity()` rebuilds the expected path prefix and rejects
anything outside it — so even a compromised client cannot register a row
pointing at another worker's KYC document.

Download is the mirror image: the app asks for a media id, the server checks
`can_read_media()` and returns a short-lived signed URL. No sensitive file ever
has a public URL.

## 7. Worker ≠ gig

A worker is a person. A gig is one service they offer. The existing schema had
`worker_services` (which trades a worker is *approved* for) but no gig concept,
so migration `0013` adds `worker_gigs`.

```
workers (1) ─── (N) worker_services ─── (1) services      "may I work this trade?"
   │
   └────────── (N) worker_gigs ──────── (1) services      "what am I offering?"
```

- One KYC, one wallet, one availability state, one rating — on the worker.
- Many gigs, each with its own category, title, price, duration, media, status.
- A gig may only be created under a service the worker holds an **approved**
  `worker_services` row for. This is checked in `worker_upsert_gig()`, not in the UI.
- No limit on gig count is hardcoded. `gigs.max_active_per_worker` is a
  `platform_settings` row; when absent, unlimited.

Availability and gig status are independent, and matching needs both:

```
worker.availability = AVAILABLE
  AND worker.status = ACTIVE
  AND gig.status = ACTIVE
  AND worker_services.is_approved for that trade
  AND within service radius
  → eligible for that booking
```

Booking snapshots the agreed price at creation time (`bookings.gig_id` plus the
existing `quoted_amount_minor`), so a later gig price edit cannot rewrite the
amount a customer already agreed to — which matters because the Customer App's
Razorpay charge is derived from the booking, not the gig.

## 8. Onboarding state machine

Progress is **derived from server state**, never from a local "step" counter, so
a reinstall resumes exactly where the worker left off.

| Step | Complete when |
| --- | --- |
| Account | Firebase user exists and `workers` row exists |
| Basic profile | `full_name`, `city`, `pincode` non-null |
| Trade | `primary_service_id` non-null |
| Skills | ≥1 `worker_services` row |
| Experience | `experience_years` set (0 is a valid answer) |
| Service area | `latitude`/`longitude`/`service_radius_km` set |
| KYC | `worker_verifications` row for `IDENTITY_KYC` past `NOT_SUBMITTED` |
| Qualification | `ITI_CERTIFICATE` or `DIPLOMA` submitted, or explicitly skipped |
| Review | all of the above |

Onboarding is *complete* at "Review". Verification approval is **not** an
onboarding step — a worker finishes onboarding and then waits. The home screen
distinguishes the two (§9).

## 9. Account status vs. work availability

These are different axes and the home screen shows both, because conflating them
is what made the old app confusing.

- **Account status** — `workers.status`, server-owned: `REGISTERED`,
  `VERIFICATION_PENDING`, `ACTIVE`, `INACTIVE`, `RESTRICTED`, `SUSPENDED`,
  `REJECTED`, `DEACTIVATED`.
- **Work availability** — `workers.availability`: `AVAILABLE`, `BUSY`, `OFFLINE`.

A worker who is `VERIFICATION_PENDING` can still open the app, edit their
profile, build gigs and contact support. Attempting to go available returns a
structured refusal naming the missing requirement, which the UI renders as a
task list — it does not silently fail and does not hide the control.

## 10. Booking state machine integration

The app never invents a status. It reads `booking_transitions` and asks the
server which moves are legal, so the two copies of the rules cannot drift.

Worker-driven moves: `CONFIRMED→TRAVELING`, `TRAVELING→ARRIVED`,
`ARRIVED→IN_PROGRESS` (gated on `arrival_verified_at`),
`IN_PROGRESS→AWAITING_APPROVAL`. Everything after that belongs to the customer,
the payment webhook, or operations.

Client-side gating before offering "Complete": arrival verified, before-work
evidence uploaded, after-work evidence uploaded, no material still awaiting the
customer. The server re-checks all of it — the client check exists to give a
useful message, not to enforce.

## 11. Money

The Worker App has no payment collection UI and never will; Razorpay belongs to
the Customer App.

```
Customer App → Razorpay → webhook → confirm_payment() → payments.SUCCESS
   → post_wallet_transaction(CREDIT_JOB_EARNING) and (DEBIT_PLATFORM_FEE)
   → wallets.balance_minor recomputed by trigger from the ledger
   → cooling period (payout.cooling_period_hours)
   → request_payout() → admin decide_payout() → DEBIT_PAYOUT
```

The wallet screen distinguishes three numbers, because treating them as one is
how a worker ends up believing money is available when it is not:

- **Available** — `wallets.balance_minor`, past its cooling period, withdrawable now.
- **Pending** — earned on a completed job but not yet released.
- **Lifetime** — `total_credited_minor`.

All amounts are integer minor units end to end. `lib/core/money/money.dart`
wraps them; there is no `double` anywhere in the financial path. The platform fee
is read from the ledger rows that actually exist — never computed client-side
from a hardcoded percentage.

## 12. Offline behaviour

Connectivity is surfaced, never faked.

- **Reads** — last successful response is cached and shown with an "offline,
  last updated <time>" banner.
- **Safe writes** (draft gig text, profile edits) — queued and retried.
- **Sensitive writes** (accept, any status transition, arrival verification,
  payout, material) — never queued. Offline disables the control and says why.
  A retry after reconnect is a fresh server call, and accept carries an
  idempotency key so a double tap cannot double-accept.
- **Uploads** — resumable, survive app restart, retry with exponential backoff.

## 13. Realtime

Supabase Realtime, subscribed narrowly — never a whole-table subscription:

| Channel | Filter |
| --- | --- |
| `bookings` | `worker_id=eq.<me>` |
| `booking_match_candidates` | `worker_id=eq.<me>` — new offers |
| `materials` | on the active booking only |
| `wallet_transactions` | `worker_id=eq.<me>` |
| `worker_verifications` | `worker_id=eq.<me>` |
| `notifications` | `recipient_firebase_uid=eq.<me>` |
| `support_messages` | on an open ticket only |

Subscriptions are torn down with the screen. There is no polling loop anywhere.

## 14. Schema gaps this app fills (migration 0013)

Everything the app needs that `0001`–`0012` did not already provide:

**New:** `gig_status` enum; `worker_gigs` table; `bookings.gig_id`;
`booking_arrival_attempts` (rate-limiting the arrival code);
`worker_gigs` RLS + grants.

**New worker-facing RPCs:** `worker_set_availability`, `worker_accept_offer`,
`worker_decline_offer`, `worker_advance_booking`, `worker_verify_arrival`,
`worker_request_material`, `worker_record_material_cost`,
`worker_submit_verification`, `worker_upsert_gig`, `worker_set_gig_status`,
`worker_request_service`, `worker_rate_customer`,
`worker_create_support_ticket`, `worker_post_support_message`,
`worker_register_push_token`, `worker_eligibility` (read-only explainer).

**Not added, deliberately:** anything that would let a client write a
verification decision, a wallet balance, a booking status directly, or a
material approval.

## 15. Error taxonomy

`AppFailure` is a sealed class. Postgres error codes raised by the RPCs map onto
it, and each case has one worker-readable sentence. No SQL text, no stack trace,
and no Firebase internal code is ever shown.

| Source | `AppFailure` | Shown to the worker |
| --- | --- | --- |
| `42501` FORBIDDEN | `PermissionFailure` | "You're not able to do that right now." |
| `P0002` NOT_FOUND | `NotFoundFailure` | "That job is no longer available." |
| `23505` CONFLICT | `ConflictFailure` | "Someone else took this job." |
| `23514` INVALID | `ValidationFailure` | The server's own message, which is written for the worker |
| `INSUFFICIENT_FUNDS` | `InsufficientFundsFailure` | "Your available balance is ₹X." |
| socket / timeout | `NetworkFailure` | "Check your connection and try again." |
| anything else | `UnexpectedFailure` | "Something went wrong." + Crashlytics report |

## 16. Analytics and crash reporting

`AnalyticsService` is an interface with a Firebase implementation and a no-op
default. Event names are the ones listed in the specification. A guard in
`analytics_test.dart` asserts that no event payload key is on the
sensitive-fields deny-list (document numbers, phone, address, coordinates).
Crashlytics receives errors with the worker's Firebase UID and nothing else.

## 17. What is *not* implemented, and is labelled as such in the UI

Honesty about gaps is the point of the rebuild:

- **SOS / emergency dispatch** — no backend, no integration. The screen shows
  local emergency numbers via `tel:` and states that in-app dispatch is not
  available. There is no button that pretends to summon help.
- **Maps / live location** — `LocationService` and `NavigationLauncher` are
  interfaces. Navigation hands off to the installed maps app via a geo: intent.
  There is no embedded map and no synthetic coordinates.
- **BGV** — status is displayed from `worker_verifications`. There is no
  provider integration, and the UI says the check is performed by operations.
- **Insurance** — policies are displayed if `insurance_policies` has a row.
  The app never fabricates coverage; with no row it says "No active policy".
- **Tamil and Hindi** — the ARB files carry real translations for the strings
  that have been translated and fall back to English elsewhere. The language
  picker marks partially translated languages as such rather than implying full coverage.
