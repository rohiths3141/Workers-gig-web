# Worker app — device test findings (CPH2643, debug, +91 9292929292)

Status: full job lifecycle tested on the device (booking BKG-26-7752DB). Round 3 below.

| # | Severity | Screen | Finding |
|---|----------|--------|---------|
| 1 | Setup | Launch | `flutter run` without `--dart-define-from-file=define.json` shows "This build is missing its configuration". Not a code bug, but easy to hit. |
| 2 | High | Startup (log) | FCM token retrieval fails: `FIS_AUTH_ERROR` / "Firebase Installations Service is unavailable". Push notifications cannot register on this build (check Firebase API key restrictions / package `com.wervexa.worker` in google-services.json). |
| 3 | Low (copy) | Welcome | "Prove your skills" still mentions "skill certificates" though skill assessment was removed. Last feature text is clipped behind the bottom button with no fade. |
| 4 | Low (UI) | Enter code | Phone number shown unformatted: "+919292929292" (also on registration "Verified:" chip). |
| 5 | Low (UI) | Send code | Loading spinner inside the disabled grey button is very faint; button looks disabled rather than busy. |
| 6 | Low (UX) | Profile setup | Notification permission is requested immediately on arrival, with no explanation first. |
| 7 | Low (UI) | Profile setup | "Help" action in the header sits flush against the right screen edge (missing right padding). |
| 8 | Medium | Your details sheet | Empty City and PIN code show no error; only "Please select your gender" appears. |
| 9 | High | Your details sheet | PIN code "123" accepted and saved. No 6-digit PIN validation. |
| 10 | Medium | Profile setup | Completed steps (Your details, etc.) lose their chevron and cannot be reopened to correct a mistake. |
| 11 | Low (UI) | Main trade sheet | Trades listed in an odd order ("Other Home Services" first, "Electrical" last); last item text clipped by the gesture bar. |
| 12 | Medium | Profile setup | Choosing the main trade also marks "What you can do" complete without the worker opening it. |
| 13 | Low (UI) | Travel radius sheet | Slider is tiny (about 1/6 of the width) instead of full width; no min/max labels. |
| 14 | Low (UI) | Profile setup | "Electrical set as your main trade." snackbar covers the next step card. |
| 15 | **Blocker** | Identity check | "Verify with DigiLocker" fails: Edge Function returns 502 "Could not start DigiLocker verification". User only sees generic "Something went wrong". No alternative path, so onboarding cannot be completed. |
| 16 | High | Identity check → back | After the failed DigiLocker attempt, pressing back leaves a blank screen with an endless spinner. The session became Ready, but the router never leaves `/onboarding`, and OnboardingScreen shows a spinner for any non-onboarding session. |
| 17 | High | Onboarding progress | A failed DigiLocker start still creates a PENDING IDENTITY_KYC case, so "KYC submitted" counts as done and onboarding completes without a real identity check. |
| 18 | Medium | Home | Checklist shows both "Your documents are being reviewed" and "Complete identity verification", which contradict each other. |
| 19 | High (UI) | Home → Go available | "Not quite ready" bottom sheet overflows by 92 px (yellow/black stripes); last steps unreachable. |
| 20 | Low (UI) | Profile | Status badge truncated "VERIFICATION INCOMPL…"; phone shown without +91 / formatting. |
| 21 | Low (UI) | Wallet | "Earned in total" is vertically misaligned with "Being processed"; "See all" sits lower than the "Recent earnings" heading. |
| 22 | Low (copy) | Jobs → New | Empty state says "Stay available", but this worker cannot go available yet. |
| 23 | Low | Edit profile | Correction: City and PIN code are editable further down Edit profile (not reached in testing), but it accepted any PIN. Gender is not editable after onboarding. |

## Fix status (round 1)

| # | Status | Change |
|---|--------|--------|
| 3 | Fixed | Welcome copy no longer mentions skill certificates. |
| 4, 20 | Fixed | Phone shown as "+91 92929 29292" on OTP, registration and Profile; badge shortened to "NOT VERIFIED". |
| 7 | Fixed | Right padding after the Help action. |
| 8, 9 | Fixed | Details sheet validates City (2+ chars) and a 6-digit PIN code, with inline errors. Edit profile also rejects partial PIN codes. |
| 10 | Fixed | Finished onboarding steps can be reopened; the details sheet is pre-filled with saved values. |
| 13 | Fixed | Travel radius slider is full width with 1 km / 50 km labels. |
| 15, 17 | Fixed (needs deploy) | `kyc-digilocker` now asks the provider for the consent URL before opening the identity case, so a provider failure leaves no PENDING case and shows "DigiLocker verification is unavailable right now". The provider error is logged. |
| 16 | Fixed | Router sends a Ready session away from /onboarding to Home. |
| 18 | Fixed (needs db push) | Migration 0050: eligibility reasons reflect each check's real state; no duplicate "being reviewed" line; service-area and trade actions point at an existing route. |
| 19 | Fixed | "Not quite ready" sheet is scrollable, full-height capable and above the bottom nav. |
| 21 | Fixed | Wallet stats top-aligned; section header action vertically centred. |
| 22 | Fixed | Jobs empty-state copy. |
| 2 | Config | FCM `FIS_AUTH_ERROR`: check the Android API key restrictions in Google Cloud and that `com.wervexa.worker` is registered in the Firebase project. Not a code fix. |
| 11 | Data | Trade order comes from `services.display_order`; set the values in the database. |
| 12 | Not changed | Choosing the main trade adds it as a skill, which satisfies "What you can do". Behaviour is consistent with the data; needs a product decision. |
| 5, 6, 14, 23 (gender) | Open | Low-priority polish, not changed yet. |
| Test data | Note | Worker +91 9292929292 still has the PENDING identity case (no DigiLocker link) created by the old function. The updated function reuses that case and attaches the link once the provider responds, so no cleanup is needed. |

## Round 2 (after all 5 checks were verified)

| # | Severity | Screen | Finding | Status |
|---|----------|--------|---------|--------|
| 24 | **Critical** | My services | Showed every worker's live services as the worker's own (a new worker saw "Pipeline" and "Wiring" with Edit/Pause). `worker_gigs_active_read` lets any signed-in user read ACTIVE gigs, and the query had no worker filter. | Fixed: explicit `worker_id` filter in `getMyGigs` and `watchMyGigs`. |
| 25 | Medium | Home | "Before you can receive jobs" items looked tappable but did nothing. | Fixed: items with a destination open it (chevron shown). |
| 26 | High | Home | Account stays "Under review" after all checks pass (activation is a manual admin step), but after migration 0050 the checklist no longer said so. Regression from round 1. | Fixed (needs db push): 0051 adds "Your checks are approved. Our team will activate your account shortly." |
| 27 | High | Wallet → Statement | Transactions tab failed ("Something went wrong"): PostgREST cannot embed `bookings` through `wallet_transactions.reference_id` (no FK, PGRST200). | Fixed: bookings fetched separately for BOOKING rows. |
| 28 | Medium | Wallet | Realtime wallet subscription failed on every open; balance never live-updates. `wallets` not in the `supabase_realtime` publication. | Fixed (needs db push): 0052. |
| 29 | High | Home → My offers | Failed with PGRST201: two relationships between `service_request_offers` and `customer_service_requests`. | Fixed: embed names the `service_request_id` FK. |
| 30 | Low (UI) | My offers / Customer requests | Error state had no padding (button edge to edge); titles in Title Case unlike the rest of the app. | Fixed. |
| 31 | Medium (UI) | Add a service | Errors stayed after the field was corrected; title and price errors truncated ("at least 6…", "Enter what …"); travel slider showed no value; "1 day" vs "1 full day" ambiguous. | Fixed: errors clear on change, price error shown full width, title error wraps, distance label, durations "8 hours (a working day)" / "24 hours". |
| 32 | — | Verification | Insurance "Valid until" date. | Not a bug: the date was set that way by the admin. Migration 0053 withdrawn. |
| 33 | Low (UI) | Add a service | "Save draft" wraps onto two lines; card's second button reads "Not live" for in-review services. | Open. |
| 34 | Low (UX) | Wallet | Withdraw disabled at ₹0 with no explanation. | Open. |

Checked and working: service submission (goes to In review), Verification (5 of 5 + insurance card), Statement tabs, Notifications, Help and support, Settings, Customer requests (empty), My offers (after fix).

Not yet testable: going available, receiving and doing jobs, live tracking, payouts. These need the service approved and the worker activated in admin, then a customer booking from the customer app.
| 35 | **Blocker** | Admin → Worker | No way to activate a new worker. The page only had Restrict / Suspend (and Reinstate for restricted workers), so a worker with every check approved stayed "Under review" and could never go available. | Fixed: "Activate worker" button for REGISTERED / VERIFICATION_PENDING workers (reason required, audited), warning if identity or background check is not yet approved. Needs web deploy. |


## Round 3 — doing a real job (18 Sep)

Two product decisions were taken during this run: **the platform takes no
commission** (workers keep the whole amount the customer pays), and **finishing
a job is never blocked by photographs**. Both are in migration 0059.

| # | Severity | Screen | Finding | Status |
|---|----------|--------|---------|--------|
| 36 | **Blocker** | Current job | "Finish job" was permanently disabled and nothing on screen said why: completion required an after-work photo, and the checklist explaining that only renders once the readiness check answers. | Fixed: finishing is always allowed (0059 drops the server gate too); an unanswered readiness check no longer disables the button. |
| 37 | **High** | Current job | Scrolling down the page snapped back to the top and felt stuck. The screen watched the live-location provider, so every GPS fix (a few seconds apart) rebuilt the whole view. | Fixed: location is broadcast from a leaf widget, and the list keeps its scroll offset. |
| 38 | **High** | Arrival code sheet | The keyboard covered the entire sheet — the worker could not see the field or reach "Confirm arrival" — because the keyboard inset was read from the caller's context, where it is always zero. | Fixed: read from the sheet's own context; the sheet also scrolls. |
| 39 | Medium | Arrival code sheet | A failed request cleared the typed code, so the worker had to type it again. | Fixed: only a genuinely wrong code clears the field. |
| 40 | Medium | Jobs → Done | A finished job showed "₹0". The earning is only written when the customer's payment is captured. | Fixed: falls back to the agreed amount; with no commission that is what they earn. |
| 41 | Low (UI) | Jobs list | The status badge squeezed the title to "Ceili…". | Fixed: the title gets its own line, the badge sits under it. |
| 42 | Low (UI) | Offer card / Current job | "Decline" wrapped as "Decli / ne" and "Directions" as "Direction / s". | Fixed. |
| 43 | Low (UX) | Home | Nothing on Home links to the job in progress; the worker has to go to Jobs → Active. | Open. |
| 44 | Medium | Jobs → Active | A job waiting for the customer's approval appears under Done, and Active is empty. Defensible, but "Done" overstates it — the money has not moved yet. | Open. |
| 2 | High | Startup | FCM `FIS_AUTH_ERROR` still fails (a Firebase config problem, not code), but it no longer throws into the void. | Partly fixed: registration failure is logged, not crashed. Config still needed. |

## Round 4 — the open items closed (18 Sep)

Both apps were run at the same time over Wi-Fi debugging: the worker app on the
CPH2643 (Android 16, +91 90909 09090) and the customer app on a moto g34 5G
(Android 15, +91 80808 08080).

| # | Severity | Screen | Finding | Status |
|---|----------|--------|---------|--------|
| 3 | Low (UI) | Welcome | The copy half was fixed in round 1, but the last promise was still cut mid-word ("withdrawals on your **terms**") behind the Get started button, with no fade. Confirmed again on device. | Fixed: bottom padding on the scroll area plus a fade at its edge. |
| 5 | Low (UI) | Send code | A busy FilledButton went grey with a faint white spinner and read as disabled. | Fixed and verified on device: a shared `BusyFilledButton` keeps the filled colours while working and shows "Sending…". Applied to Send code, Verify, Continue, Save and Submit for review. |
| 6 | Low (UX) | Profile setup | The notification permission dialog fired the moment profile setup opened. | Fixed and verified on device: nothing prompts on arrival. Push registration no longer raises the dialog at all; a card on profile setup explains why job alerts matter and asks only when the worker taps it. |
| 11 | Low (UI) | Main trade sheet | Trades in an arbitrary order ("Other Home Services" first, "Electrical" last). | Fixed — and the diagnosis in round 1 was incomplete. Two causes: every `services.display_order` was still at the column default of 100 (0012 seeds with `on conflict do nothing`), **and** `postgrest`'s `.order()` defaults to descending. Migration 0060 sets the values, and the query now says `ascending: true`. Verified on device: Electrical, Plumbing, AC Service, Appliance Repair… |
| 12 | Medium | Profile setup | Choosing the main trade silently ticked "What you can do". | Fixed (copy): the step now reads "Your main trade counts as one. Open this to add every other trade you work in." The behaviour is right; it just never said so. |
| 14 | Low (UI) | Profile setup | The trade snackbar covered the next step card. | Fixed and verified on device: snackbars are floating with a margin and success messages last 3s, so the next card stays readable. |
| 23 | Low | Edit profile | Gender could not be changed after onboarding. | Fixed: a gender chip row on Edit profile, saved through the existing nullable `gender` argument. |
| 33 | Low (UI) | Add a service | "Save draft" wrapped onto two lines; the card's second button read "Not live". | Fixed: the button row is 2:3 instead of 1:2 and the label cannot wrap; a gig with no pause/resume action now shows its state as text ("In review", "Draft — submit it for review", "Rejected — edit and resubmit") instead of a button that did nothing. |
| 34 | Low (UX) | Wallet | Withdraw was disabled at ₹0 with no explanation. | Fixed: a line under the button says why, naming the amount still being processed when there is one. |
| 43 | Low (UX) | Home | Nothing on Home linked to the job in progress. | Fixed via #44: Home already renders an "Right now" card from `getActiveJob()`, but that query excluded AWAITING_APPROVAL, so the card vanished the moment the worker finished. |
| 44 | Medium | Jobs → Active | A job waiting for the customer's approval appeared under Done and Active was empty. | Fixed: AWAITING_APPROVAL counts as active in both `BookingStatus.isActive` and the list query. Opening it lands on the execution view, whose waiting footer already said "Waiting for the customer to approve your work". |
| 2 | High | Startup | FCM `FIS_AUTH_ERROR`. | Root cause identified — see the API key note in the customer findings. Not a code fix. |

### New in round 4

| # | Severity | Screen | Finding | Status |
|---|----------|--------|---------|--------|
| 45 | **Blocker** | Registration | A brand-new worker could not get past sign-in: `permission denied for table workers`, shown as "Something went wrong at our end" with only Try again and Sign out. The role claim is written server-side, but the forced token refresh straight afterwards still minted a token without it, and that token was cached for an hour, so every request ran as `anon`. | Fixed: the app decodes the refreshed token and keeps refreshing until `role: authenticated` is really present; a denied profile read re-provisions the claim and retries once. Reproduced on device, then confirmed fixed on the same account. |
| 46 | Medium | Registration | The Email field is labelled optional in every other respect ("For receipts and statements.", nullable `p_email`) but an empty one was refused with "Please enter a valid email address". | Fixed: empty is accepted and sent as null; the label now says "Email (optional)"; a non-empty value is still format-checked. |
| 47 | **High** | Everywhere | `postgrest`'s `.order(column)` defaults to **descending**. Seven bare calls in this app were therefore reversed, including the job timeline and the support-ticket chat, which both ran newest-first. | Fixed: `ascending: true` wherever ascending was meant; the one deliberate descending sort now says so. |
| 48 | Low | Security | The Google Maps API key was committed in `android/app/src/main/AndroidManifest.xml`. | Fixed: it comes from `android/local.properties` (gitignored) via a manifest placeholder, as the customer app already did. **The key still needs rotating**, since it is in the git history. |

### Still open

- **#15 DigiLocker** — the fix is in `supabase/functions/kyc-digilocker`, still
  marked "needs deploy". Not re-tested this round; onboarding cannot pass the
  identity step until that function is deployed.
- **#35 Activate worker** — the admin "Activate worker" button is written but
  still needs a web deploy, so a new worker cannot be activated and therefore
  cannot go available or receive a booking. This is what stopped the round-4
  run short of a full customer→worker job.

## Round 5 — sign-in

Reported as "the app only works as signup, not signin — a registered worker
cannot log in". Reproduced against the live project without a device, by
minting a real Firebase ID token for each test number and comparing it with
what the database holds.

| # | Severity | Screen | Finding | Status |
|---|----------|--------|---------|--------|
| 49 | **Blocker** | Sign-in | A registered worker could sign up but never sign back in. Identity is anchored on `firebase_uid`, and Firebase mints a **new UID** whenever the user record is deleted and the same number signs in again — deleting an account, recycling a test-number slot, a support deletion. From then on `getCurrentWorker()` matched nothing, so the app decided registration had never finished and sent the worker to Register; registering was then refused with "that number is already registered", because the old row still held the number. No third option was offered and the account, its jobs and its wallet were unreachable. | Fixed. Migration 0061 adds `public.firebase_phone()`, which reads the OTP-verified number out of the Google-signed ID token, and `worker_claim_account()`, which re-binds the existing account to the caller's new UID when that number matches. The app calls it before it ever concludes that registration is missing. `worker_create_profile` no longer dead-ends either: same-number re-binds instead of raising CONFLICT. |

**Evidence.** Firebase held exactly 10 users, and two no longer matched the
database: `+919292929292` (Firebase `VerUFXFG…`, database `Xto93HFs…`) and
`+919393939393` (Firebase `7Rz2ZxAi…`, database `2RzlDZDL…`). Both had been
signed up again after their Firebase user was removed to free a test slot.

**Verified end-to-end** on `+919292929292` with a genuine Firebase ID token:

- the token carries `phone_number: +919292929292` and `role: authenticated`;
- `worker_claim_account()` returned the existing worker (`Test Worker`, ACTIVE)
  and moved the row onto `VerUFXFG…`;
- the app's own self-read, `workers?firebase_uid=eq.<new uid>`, then returned
  that row — so the worker signs straight in with no Register screen.

`+919393939393` was deliberately left mismatched as an on-device test case.

**Why this cannot be used to take over an account.** `worker_claim_account()`
takes no parameters. The number it matches on comes only from
`public.firebase_phone()`, which reads `phone_number` from a token whose `iss`
is `https://securetoken.google.com/…` — a client can type any number into the
app but cannot put one into a Google-signed token. The re-bind inside
`worker_create_profile` is gated on the same verified value, so a mismatched
`p_phone` still gets the original refusal. Where the new UID already has a
profile carrying an account of its own, the two identities are left alone and
the call raises CONFLICT rather than merging them. Every re-bind writes a
`profile.rebind_firebase_uid` audit entry with both UIDs.

## Round 6 — written tests

The worker app already had 150 tests. Two of them had been failing, and both
were pointing at a real defect rather than at themselves.

| # | Severity | Area | Finding | Status |
|---|----------|------|---------|--------|
| 50 | **High** | Finish a job | `CompletionReadiness.canComplete` required a verified arrival and no open material request, and said in a comment that photographs are never a condition of finishing. The server disagrees: `worker_advance_booking` refuses AWAITING_APPROVAL without at least one completed BOOKING_AFTER_WORK photo. So Finish was enabled, the worker tapped it, and the server answered "upload at least one photo of the finished work" — while the checklist above the button had never mentioned a photo. | Fixed: the client's gates are now exactly the server's three, and "Add a photo of the finished work" appears in the blocker list. The two pre-existing failing tests pass. |
| 51 | **High** | Documents | `MediaPurpose` modelled only the purposes a worker can upload, but `getAssets(workerId: ...)` filters by owner and only optionally by purpose, so it returns whatever is attached. A background check — opened automatically for every worker by migration 0046 and filed by operations — threw `Unknown media_purpose` on the worker's own document list. | Fixed: all 17 values parse. The exhaustive `MediaConstraints.forPurpose` switch made the compiler point at the four that needed an answer. |

New in this round: `test/contract/db_enum_contract_test.dart` and
`test/data/live_shape_mapping_test.dart`, described in the customer app's round
6. 195 tests now pass, up from 148 passing of 150.

## Round 7 — session lifecycle audit (20 Sep)

A full read of the app looking for what was left. `flutter analyze` was clean
and all 195 tests passed at the start of this round, so nothing here was
visible to either; every one of the six is a lifecycle defect — something that
outlives the thing it belonged to.

Five of the six only show up when **one worker signs out and another signs in
on the same phone**, which is the ordinary case here rather than an edge: a
pool of ten test numbers is recycled across two handsets.

| # | Severity | Area | Finding | Status |
|---|----------|------|---------|--------|
| 52 | **High** | Sign-out | `SupabaseClientProvider.disposeChannels()` is documented "called on sign-out so a signed-out device stops receiving another session's events". It had **no callers at all**. Every Realtime channel joined for the departing worker stayed joined on the socket, so a signed-out phone went on receiving their offers and booking changes, and the next worker to sign in inherited them. | Fixed: `signOut()` drops the channels before Firebase drops the session. Guarded by an architecture test — a teardown method with no callers is the shape of the bug, not just this instance. |
| 53 | **High** | Everywhere | `SupabaseRepositoryBase` caches the caller's `workers.id`, and the repositories holding it are app-lifetime `Provider`s that sign-out never invalidated. The cached UUID therefore survived into the next worker's session, and their queries against `booking_match_candidates`, `wallets` and `worker_gigs` went out carrying the **previous worker's id** — surfacing as a worker who could not see their own offers. | Fixed twice over: the cache is keyed on the UID it was resolved for, and `signOut()` rebuilds every repository. `test/data/worker_id_cache_test.dart` drives the real base class over a stubbed PostgREST and fails on the old code. |
| 54 | **High** | Push | Registration was latched behind one process-wide `_started` flag, so the FCM token was bound to whichever worker signed in **first after launch**. The second worker on the same phone was never registered and got no job alerts at all, while the first worker's row stayed active and kept receiving theirs. Nothing deactivated the token on sign-out either. | Fixed: registration is keyed on the Firebase UID, so a change of worker re-registers (`on conflict (token)` in `worker_register_push_token` re-points the row), and sign-out sets `is_active = false`. Migration 0009 already grants a worker `update (is_active, ...)` on their own token, so no schema change was needed. |
| 55 | **Medium** | Live location | `locationBroadcastProvider` opens the GPS stream after two awaits, the second of which can raise a permission dialog. `ref.onDispose` cancelled a `subscription` variable that was still null for the whole of that window, so leaving the screen before answering left the stream to open afterwards with nothing holding a handle to it — draining the battery all day and writing to `worker_locations`, where the customer's map reads it, long after the job was closed. | Fixed: a disposal flag, checked both before the stream opens and after. `test/app/location_broadcast_test.dart` swaps `GeolocatorPlatform.instance` for a fake that holds the permission answer; against the unfixed provider it records a position write with no screen open. |
| 56 | **Medium** | Uploads | `MediaRepository.retry()` re-ran the pipeline with only `purpose` and `bookingId`. The server builds the storage path from the purpose rule **and the owning resource id**, so retrying a material photo, a gig photo or a ticket attachment asked it to authorize an asset with no owner — refused, or filed against nothing. It also handed the already-compressed file back to be compressed a second time. | Fixed: the whole target is kept with the pending upload and re-presented unchanged; the original file is what a retry re-sends. |
| 57 | Low (UI) | Profile | `watchCurrentWorker()` mapped the Realtime row straight through. The avatar is not a column on `workers`, so the worker's own photo blinked back to their initials on every unrelated profile change. | Fixed: the live stream resolves the photo the same way the one-shot read does. |

**A defect introduced and caught in the same sitting.** The first cut of #52/#54
had `SessionController.signOut()` read `pushRegistrationProvider` — which
listens to `sessionProvider`, so reading it back is a genuine cycle and
Riverpod throws `CircularDependencyError` for it in debug, **on the sign-out
button**. The test written for the fix failed immediately; the token now lives
in a holder with no dependencies of its own, and a test pins that the path
stays acyclic.

**Also in this round.** Every `withOpacity`, the three deprecated
`DropdownButtonFormField(value:)` and the deprecated `RadioListTile`
group API are gone: `flutter analyze` now reports **no issues at all**, down
from 27 deprecation warnings that would become hard errors on the next Flutter
upgrade.

New tests: `test/data/worker_id_cache_test.dart`,
`test/app/session_signout_test.dart`, `test/app/location_broadcast_test.dart`,
`test/data/media_retry_target_test.dart`,
`test/app/push_registration_test.dart`, plus four architecture guards. **231
tests pass, up from 195.** Each of the four regression suites was run against
the unfixed code first and fails there — a test that passes both ways is not a
regression test.
