# Customer app — device test findings (CPH2643, debug, +91 9191919191)

Status: upfront payment deployed (migrations 0053–0059) and tested end to end on the device. Round 3 findings below.

| # | Severity | Screen | Finding |
|---|----------|--------|---------|
| C1 | High | Startup (log) | Unhandled exception: `getToken()` throws `FIS_AUTH_ERROR` in `push_registration_provider.dart:36` and nothing catches it. Same Firebase config issue as worker #2, but here it is an uncaught async error (reported to Crashlytics as a crash). |
| C2 | Medium | Startup (log) | `PGRST303 JWT issued at future`: the Firebase token's `iat` is ahead of Supabase's clock, so the first profile load fails with 401. It recovered on retry, but a customer with a slightly fast phone clock can hit "Something went wrong" on launch. |
| C3 | Low (UI) | Verify phone | No back button to fix a mistyped number; number shown unformatted "+919191919191"; "Resend Code" is active immediately with no countdown. |
| C4 | Low (UI) | Complete profile / Verify phone / Payment | Screen titles are small, left-aligned body text rather than an app bar, inconsistent with other screens. |
| C5 | Low (UI) | Home | Category labels truncated ("Other Hom…", "Appliance R…"). |
| C6 | Medium (UI) | Request Electrical | "When do you need the service?" chips truncate their labels ("⚡ Instant (30", "Schedule Late"). |
| C7 | Medium | Find workers | The same worker appears twice (one card per service), which reads as two different people. |
| C8 | **High** | Book a service | Today's 9:00 AM slot is pre-selected and bookable at 9:19 PM. Past time slots are not disabled, and the booking was created for a time already gone. |
| C9 | Medium | Payment | "Service" row in Booking summary is empty (should be "Ceiling fan installation"). Payment screen has no back button. |
| C10 | Medium | Bookings | An unpaid booking is listed under Active as "FINDING A PROFESSIONAL…" (label truncated) even though a specific worker was chosen and payment never finished. |
| C11 | Low | Bookings | "Track Live" is offered before any worker has accepted. |
| — | Note | Worker app → Jobs | Booking BKG-26-EC3808 is not in the worker's New jobs, most likely because payment was not completed. To be confirmed after a test payment. |
| Setup | Note | USB | The phone dropped off adb twice mid-run ("Lost connection to device"); restarting the adb server fixed it. |

Checked and working: phone login + OTP, name validation, current location (Erode), categories, sub-issue list, worker search within 5 km (test worker found at 700 m), worker profile with KYC/Background badges, booking creation (booking 141c0370-…), Razorpay test checkout opens with ₹499.

## Booking → job → payment flow

| # | Severity | Finding | Status |
|---|----------|---------|--------|
| C12 | **Blocker** | Booked jobs never reach the worker. Matching inserts the gig's worker as candidate #1 but nothing sets `was_offered`, which the worker's New jobs list and `worker_accept_job()` both require. No booking could ever be accepted. | Fixed (needs db push): migration 0053 offers gig bookings to the gig's worker and backfills open ones. |
| C13 | **Blocker** | Test payment succeeded at Razorpay (pay_TdBCQxIyPOVfrX, test mode) but "We could not confirm this payment". `confirm_payment()` moves the booking to PAID, which the state machine only allows from PAYMENT_PENDING (after completion). The prototype create-order route allows paying at REQUESTED, so verify always fails there and the payment row stays PENDING. | Fixed (needs db push + app rebuild): migration 0054. Payment is captured at REQUESTED and held; the job is then offered to the chosen worker; the worker's share is credited and the booking settles to PAID only when the customer approves the work. |
| C14 | Medium | Tapping an unpaid booking in Bookings does nothing; there is no way back to payment. | Open. |

## Upfront payment change (0053, 0054 + apps)

| # | Severity | Finding | Status |
|---|----------|---------|--------|
| C15 | **Blocker** | Nothing ever moved a booking ACCEPTED → CONFIRMED, and only a CONFIRMED booking can start travel. No job could ever get past "Professional found". | Fixed: a prepaid booking is confirmed automatically when the worker accepts (0054); SYSTEM added to that transition's allowed actors. |
| C16 | **High** | Cancelling always failed: the database requires a reason for a customer cancellation and the app sent none. | Fixed: the cancel dialog asks for a reason and warns about the refund when the booking is paid. |
| C17 | Medium | A paid booking that is cancelled or expires had no refund path. | Fixed: a PENDING refund row is opened automatically (0054). The gateway refund itself is still manual — the admin refund API route does not exist yet. |
| C18 | Medium | Worker earnings were never credited: nothing computed platform_fee_minor / worker_amount_minor, so the credit was always skipped. | Fixed: `split_payment_amounts()` applies `platform.commission_percent` (15%) at capture. |
| C9 | Medium | Empty "Service" row on the payment screen. | Fixed: realtime booking updates no longer blank the joined service name. |
| C10, C11, C14 | Medium | Unpaid bookings showed "Finding a professional…" with Track Live and no way to pay. | Fixed: unpaid bookings show "Payment pending" with a "Pay now" button, cards open the booking, Track Live only shows once the worker is travelling. |

## Round 3 — end-to-end run on the device (18 Sep, booking BKG-26-7752DB)

The whole flow now works: book → pay ₹499 upfront → the job is offered to the
chosen worker → accept (auto-confirmed) → travel with live tracking → arrive →
arrival code → work → finish → awaiting the customer's approval.

| # | Severity | Where | Finding | Status |
|---|----------|-------|---------|--------|
| C19 | **Blocker** | Worker app → New jobs | The paid job was offered but the worker's list stayed empty. The offer query joins `bookings!inner`, and the only worker policy on bookings is `worker_id = current_worker_id()` — which is null until someone accepts. An offer could be made but never seen. | Fixed: 0055 adds a read policy for a booking the worker has an unanswered offer on. |
| C20 | High | Booking | `bookings.gig_id` was never written; the chosen gig lived only in the first event's metadata, so the worker's card could not name the service sold. | Fixed: 0055 records it on the booking and backfills old rows. |
| C21 | **Blocker** | Everywhere | 0055's first version tested the candidates table from a policy on bookings, and the candidates policy reads bookings: every query failed with 42P17 infinite recursion and the worker app lost its session. | Fixed: 0057 moves the test into a security definer function. |
| C22 | High | Worker app → New jobs | `booking_match_candidates` was never in the `supabase_realtime` publication, so the offers subscription failed every time and the tab showed "Something went wrong at our end". | Fixed: 0056. Same omission as wallets in 0052. |
| C23 | **Blocker** | Worker app → arrival | Entering the customer's arrival code always failed: `worker_verify_arrival()` hashes with pgcrypto's `digest()` but pins `search_path` to `public, pg_temp`, and Supabase installs pgcrypto into `extensions`. No job could pass ARRIVED. | Fixed: 0058. |
| C24 | High | Customer app | A 9:00 AM booking reached the worker as 2:30 PM: the local time was serialised without an offset and `timestamptz` read it as UTC. | Fixed: send `.toUtc()`, and parse booking timestamps back to local. |
| C25 | High | Customer app → booking | The detail screen never showed the worker's name or phone — the booking query never fetched them, so live tracking showed the service name where the person should be and the call button was dead. | Fixed: the booking embeds `workers(full_name, phone, rating_avg)`. |
| C26 | High | Customer app → booking | The screen kept showing "Waiting for the professional to accept" while the worker was already travelling: realtime drops while the app is backgrounded and nothing replays it. | Fixed: every change re-reads the full booking, and the booking reloads when the app resumes. |
| C27 | Medium | Customer app → booking | Back exited the app: payment lands here with nothing to pop. | Fixed: a back button that returns to Bookings. |
| C8 | **High** | Customer app → Book a service | Confirmed again: at 11:37 PM today's 9:00 AM slot was selected and bookable. | Fixed: past slots (and a day with none left) are disabled, and the screen opens on the first slot anyone could still turn up for. |
| C1 | High | Customer app → startup | The FCM failure was an uncaught async error reported as a crash. | Fixed: push registration is best-effort in both apps. |
| C5, C6 | Low (UI) | Customer app | Category labels ("Other Hom…") and the timing chips ("⚡ Instant (30") were clipped. | Fixed: two-line category labels, chips that scale their label. |
| C7 | Low | Find workers | The same worker still appears once per gig (₹499 ceiling fan, ₹800 electric). Each card is a different service, so this is arguably correct; it reads as duplication. | Open — product decision. |
| C28 | Medium | Customer app → address | The map on Select Service Address renders as a blank grey sheet, while the tracking map draws fine. | Open. |

## Round 4 — remaining open findings closed (18 Sep)

Tested on two devices over Wi-Fi debugging at the same time: the customer app
on a moto g34 5G (Android 15) and the worker app on the CPH2643 (Android 16).

| # | Severity | Where | Finding | Status |
|---|----------|-------|---------|--------|
| C2 | Medium | Startup | `PGRST303 JWT issued at future` surfaced as "Something went wrong" and the router then dropped the customer back on the phone screen, costing them another OTP. | Fixed: PGRST303 maps to a `ClockSkewFailure`, the profile load retries it with backoff and a forced token refresh, and a session error now opens a real error screen with Try again / Sign out instead of the login screen. |
| C3 | Low (UI) | Verify phone | No back button, unformatted `+919191919191`, Resend active immediately. | Fixed and verified on device: app-bar back plus a "Wrong number? Change it" link, `+91 80808 08080`, and a 30-second "Resend code in 25s" countdown. |
| C4 | Low (UI) | Verify phone / Complete profile / Payment | Titles were body text, not an app bar. | Fixed: all three screens carry an app bar; Payment also has a back button. |
| C7 | Low | Find workers | The same worker appeared once per gig and read as two people. | Fixed: one card per professional, with each of their matching services as its own priced row and Book button. |
| C8 | High | Book a service | Follow-up: the chips are disabled from the clock at build time, so a screen left open across a slot boundary could still submit a time that had passed. | Fixed: re-checked at the moment of booking, which moves the selection to the next free slot and says so. |
| C28 | Medium | Select Service Address | Map rendered as a blank sheet. | Partly fixed — see below. Code half fixed; the key is still rejected. |

### New in round 4

| # | Severity | Where | Finding | Status |
|---|----------|-------|---------|--------|
| C29 | **Blocker** | Startup, new account | A brand-new sign-in could not read its own profile: `permission denied for table workers/customers`. `setCustomUserClaims` and Firebase's token service settle independently, so the forced refresh straight after the claim was written still minted a token without `role: authenticated` — and that token was then cached for an hour, so every Supabase call ran as `anon`. | Fixed: the app now refreshes until the claim is actually in the token (checked by decoding it), and a denied profile read re-provisions the claim and retries once. Reproduced and confirmed fixed on device. |
| C30 | **High** | Everywhere | `postgrest`'s `.order(column)` defaults to **descending**, and eleven calls across the two apps relied on the bare form. The customer's categories came out Other Home Services → Electrical, sub-issue lists were reversed, and the booking timeline and support chat ran newest-first. | Fixed: every call that means ascending now says `ascending: true`; the one deliberate descending sort says so explicitly. Category order verified correct on device. |
| C31 | Medium | Error messages | A request rejected as `anon` arrives with the HTTP status in `PostgrestException.code` and the Postgres `42501` only inside the message body, so it fell through to "Something went wrong at our end". | Fixed: mapped to a plain "Your sign-in is not fully set up yet. Try again in a moment." |
| C28 | Medium | Select Service Address | Root cause found. Two separate problems. (1) The map was built in `initState` while the system location-permission dialog had the activity paused, so its surface came back blank — fixed by building it only once the first fix has landed, as the other maps already do. (2) Tiles still do not load: logcat shows `GoogleApiManager … statusCode=DEVELOPER_ERROR` from the Maps module. | Code fixed; **key still rejected** — see the API key note below. |

### One API key is behind both C28 and C1 / worker #2

Both apps use the **same** key (`AIzaSy…LK4Mz4`) for Google Maps *and* for
Firebase. That one key explains both symptoms: Maps returns `DEVELOPER_ERROR`
and Firebase Installations returns `FIS_AUTH_ERROR`. This is a Google Cloud
Console setting, not code. In the console, for that key:

- **API restrictions** must include *Maps SDK for Android*, *Firebase
  Installations API*, *Firebase Cloud Messaging API* and *Identity Toolkit
  API* — or be set to unrestricted while testing.
- **Application restrictions**, if set to Android apps, must list both
  `com.wervexa.app` and `com.wervexa.worker` against the **debug** signing
  certificate as well as the release one. The debug SHA-1 on this machine is
  `BA:1E:5F:90:91:D6:1F:AD:7A:9D:6F:30:8E:8B:3A:D7:38:56:15:56`.
- *Maps SDK for Android* must also be **enabled** in the project.

Splitting this into two keys (one Maps, one Firebase) is worth doing so each
can be restricted tightly. The key was also committed in the worker app's
`AndroidManifest.xml`; it now comes from `android/local.properties` as it
already did in the customer app, so **rotate it**.

## Round 5 — sign-in

| # | Severity | Screen | Finding | Status |
|---|----------|--------|---------|--------|
| C32 | **Blocker** | Sign-in | Same defect as worker #49, and present here for the same reason: identity is anchored on `firebase_uid`, so a customer whose Firebase user record was deleted and re-created for the same number matched no row, was sent to Register, and was then refused there with "that number is already registered as a customer account". | Fixed by migration 0061: `customer_claim_account()` re-binds the existing account when the OTP-verified number on the token matches, and the app calls it before concluding that registration is missing. `customer_create_profile` re-binds on the same evidence instead of dead-ending. See the worker doc's round 5 for the evidence and the reasoning on why it cannot be used to take over an account. |

Not reproduced on a customer number — all four customer test numbers still
matched their Firebase UID — but the code path was identical, so it was fixed
in both apps rather than left to be found later.

## Round 6 — written tests

The customer app had one test, which asserted that a class existed. It now has
83. Writing them found six defects; all six are fixed and each has a test that
fails if it comes back.

| # | Severity | Area | Finding | Status |
|---|----------|------|---------|--------|
| C33 | **Blocker** | Payments | The payment screen treated "we could not find out whether this booking is paid" as "it is not paid" — `paymentForBookingProvider` answered a failure with null, and the screen's `error:` branch rendered the Pay flow. The bookings list did the same via `valueOrNull ?? {}`. Either one could take a second payment for a booking already paid for. | Fixed. The provider surfaces the failure; the screen shows "We could not check whether this booking has already been paid for" with a retry; the list rule moved to `Booking.awaitingPayment(Set<String>?)`, where null means unknown and never asks for money. Five tests in `test/domain/payment_safety_test.dart`. |
| C34 | **High** | Home | A booking sat at REQUESTED from the moment it was placed until a worker accepted, and `BookingStatus.isActive` excluded REQUESTED — copied from the worker app, where excluding it is right because an unassigned job is not that worker's work. `activeBookingsProvider` filters on it, so a customer booked, paid, returned to Home and found no trace of it. | Fixed: REQUESTED is active for the customer. `test/domain/booking_status_test.dart` also asserts no status falls outside every bucket. |
| C35 | **High** | Everywhere | Ten providers answered a failure with an empty list or set. A network drop, an expired token or an RLS refusal reached the screen as "you have no bookings / addresses / categories", with no error and no retry, while every one of those screens already had an `error:` branch that nothing could reach. | Fixed: a shared `_orThrow` lets the failure through. `test/architecture/no_silent_failures_test.dart` fails if the pattern returns. |
| C36 | Medium | Materials | `MaterialRequest.quantity` was hardcoded to `1` and the row's real `quantity` and `unit` were never read, so a worker's request for 5 metres of cable was shown to the customer as "Qty: 1". The cost was also treated as a unit price and multiplied by that quantity — right only by accident. | Fixed: quantity and unit are read; `estimated_cost_minor` is the line total, as the worker app has always rendered it. |
| C37 | Medium | Money | Amounts were divided by 100 in six places, and not consistently: some rounded with `toStringAsFixed(0)`, some truncated with `toInt()`, so ₹499.50 read as ₹500 on one screen and ₹499 on another. | Fixed: one `formatRupees(int minor)`, integer maths, paise shown only when present. Ten tests in `test/core/money_format_test.dart`. |
| C38 | Low | Support | `SupportCategory` was missing PAYOUT, VERIFICATION and CLAIM, so a ticket recategorised by support threw `Unknown support_category` when the customer opened it. | Fixed: all nine values parse; the customer's picker still offers only the six that make sense for them. |
| C39 | Low | Timeline | `BookingEvent.fromJson` cast `id` to String, but `booking_events.id` is `bigint`. Every row threw. Latent only because nothing consumes `watchBookingEvents` yet. | Fixed: read as int. |

### How the tests work

Three of them check the app against the database rather than against
themselves, which is what caught C38 and C39:

- `test/contract/db_enum_contract_test.dart` — every Dart enum against every
  value its Postgres type can hold. `_parse` throws on anything it does not
  know, so a value added in SQL and not in Dart is a crash on a real phone,
  and nothing in the build catches it.
- `test/data/live_shape_mapping_test.dart` — every `fromJson` against rows
  shaped like the live tables: one fully populated, one with every column that
  is null in production set to null. No personal data is stored; the fixture
  records types, nullability and code-like values only.
- `test/contract/rpc_payload_contract_test.dart` — the keys a `jsonb_build_object`
  RPC sends against the keys the mapper reads.

Regenerate the fixtures with `node web/supabase/scripts/generate-db-contract.mjs`
and `node web/supabase/scripts/profile-app-data.mjs`.

### Known gap, not a bug

`customer_find_gigs` does not send `worker_photo_url`, so every gig card falls
back to initials. The photo is in Firebase Storage and needs a signed URL from
the web tier, which a Postgres function cannot mint; closing it means giving the
customer app the media pipeline the worker app already has. The contract test
records this deliberately and will fail if the function ever starts sending it.
