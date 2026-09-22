# Wervexa Captain

The mobile application skilled service professionals use to receive work, run
jobs, prove their qualifications and get paid.

Built from scratch against the platform's existing backend in `web/`. The
architecture, the contracts it depends on, and the reasoning behind each
decision are in [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md).

## Stack

| Concern | Technology |
| --- | --- |
| Identity | Firebase Authentication (phone OTP only — there are no passwords) |
| Media | Firebase Storage, via server-authorized signed URLs |
| Business data | Supabase PostgreSQL with RLS |
| Live updates | Supabase Realtime |
| Trusted operations | `security definer` functions + the Next.js worker API |
| Payments | Razorpay, on the **customer** side only |

## Running it

Configuration arrives through `--dart-define`, so nothing identifying an
environment is committed. A build without it fails visibly at launch rather
than surfacing later as a confusing network error.

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://<project>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<publishable key> \
  --dart-define=API_BASE_URL=https://<host>/api \
  --dart-define=ENVIRONMENT=development
```

Firebase configuration comes from the platform files `flutterfire configure`
writes (`android/app/google-services.json`,
`ios/Runner/GoogleService-Info.plist`); neither is in this repository.

```bash
flutter analyze     # static analysis
flutter test        # 149 tests
```

## Layout

```
lib/
├── app/          configuration, router, theme, providers, session
├── core/         errors, money, logging, Firebase/Supabase bootstrap, locale
├── domain/       entities, enums, repository interfaces — pure Dart
├── data/         repository implementations, row mappers
├── features/     one folder per feature, each with presentation/
└── shared/       widgets used across features
```

The dependency rule is one-directional: `presentation → application → domain`,
with `data` implementing the domain's interfaces. No screen imports Supabase,
Firebase, or a concrete repository — and `test/architecture/` fails the build
if one starts to.

## The rules this app is built on

These are not style preferences. Each one is the direct answer to a defect in
the previous Worker/Captain application, and most are enforced by a test rather
than by review.

**The server is authoritative.** The client requests actions and renders what
comes back. It cannot write a booking status, a verification decision, a wallet
balance, or an availability state. `Worker.copyWith` has no parameter for
`status` or any `is*Verified` flag, so the trust boundary is enforced by the
type system.

**No fallback data, anywhere.** Repositories return `Result<T>`, so a caller
cannot reach a value without handling failure. There is no `getJobsOrEmpty()`.
A failure renders an error with a retry; an empty list means the server said
there was nothing.

**Arrival verification happens on the server.** The correct code is never sent
to the device, so there is nothing here to compare against. The arrival sheet
has exactly one success path and it is behind the server's answer.

**Money is integer minor units end to end.** No `double` touches the financial
path. Fees shown beside an earning are the ledger rows that exist, never a
percentage computed on the device.

**A worker is not one gig.** One person, one identity, one wallet, one
availability state — and as many services as their approved trades allow. No
count check, no disabled "add" button, no single-trade assumption. A limit, if
the business ever wants one, is a `platform_settings` row.

**Nothing pretends to work.** There is no SOS button, because there is no
dispatch behind one; the support screen dials the real emergency services and
says so. There is no embedded map and no invented coordinate. A language that
is only partly translated is labelled as such.

## What is not implemented

Stated here rather than discovered later:

- **SOS / emergency dispatch** — no backend exists. Local emergency numbers only.
- **Maps and live location** — `geo:` hand-off to the installed maps app. No
  embedded map, no location streaming.
- **BGV** — status is displayed; the check is run by operations, not by a
  provider integration.
- **Insurance** — policies are displayed when a row exists. No row means no
  cover, and the UI says that.
- **Account deletion** — routed to a real support workflow rather than clearing
  local data and calling it deleted.
- **Tamil and Hindi** — the architecture is in place and the picker marks
  partial coverage honestly; the ARB translations are not complete.
