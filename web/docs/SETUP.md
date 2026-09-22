# Setup: local development and Vercel

You need three accounts: **Firebase** (sign-in + file storage), **Supabase** (database), and **Vercel** (hosting). Everything below happens inside the `web/` folder.

Estimated time: about 45 minutes the first time.

---

## 0. Prerequisites

- Node.js 20.11 or newer (`node -v`)
- Git
- Optional: Firebase CLI (`npm install -g firebase-tools`) to deploy storage rules
- Optional: Supabase CLI (`npm install -g supabase`) to run migrations without copy-pasting

```bash
cd web
npm install
cp .env.example .env.local
```

You'll fill `.env.local` in the steps below. Never commit it.

---

## 1. Firebase

### 1.1 Create the project
1. Go to <https://console.firebase.google.com> and create a project.
2. **Project settings → General → Your apps → Add app → Web (`</>`)**. Register it (no hosting needed).
3. Copy the config values into `.env.local`:

| Firebase config key | `.env.local` variable |
| --- | --- |
| `apiKey` | `NEXT_PUBLIC_FIREBASE_API_KEY` |
| `authDomain` | `NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN` |
| `projectId` | `NEXT_PUBLIC_FIREBASE_PROJECT_ID` |
| `storageBucket` | `NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET` |
| `messagingSenderId` | `NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID` |
| `appId` | `NEXT_PUBLIC_FIREBASE_APP_ID` |

### 1.2 Enable sign-in methods
**Build → Authentication → Get started → Sign-in method**:
- Enable **Google** (set a support email).
- Enable **Phone**.

For development, add a test number so you don't use SMS quota: **Phone → Phone numbers for testing**, e.g. `+91 99999 00000` with code `123456`.

**Authentication → Settings → Authorized domains**: `localhost` is there by default. You'll add your Vercel domain in step 5.

### 1.3 Storage
**Build → Storage → Get started** (production mode). Then deploy the platform's deny-by-default rules:

```bash
firebase login
firebase use --add
npm run firebase:rules
```

### 1.4 Service account (server-only credentials)
**Project settings → Service accounts → Generate new private key**. A JSON file downloads. Copy three fields into `.env.local`:

```
FIREBASE_ADMIN_PROJECT_ID=<project_id>
FIREBASE_ADMIN_CLIENT_EMAIL=<client_email>
FIREBASE_ADMIN_PRIVATE_KEY="<private_key, including the BEGIN/END lines>"
FIREBASE_ADMIN_STORAGE_BUCKET=<same as NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET>
```

Keep the `\n` sequences exactly as they appear in the JSON. Then delete the downloaded JSON file.

---

## 2. Supabase

### 2.1 Create the project
Create a project at <https://supabase.com/dashboard>. Using a hosted project for development is recommended. A local Docker stack (`supabase start`) is optional and not yet verified with Firebase tokens.

**Project Settings → API**, copy into `.env.local`:

```
NEXT_PUBLIC_SUPABASE_URL=<Project URL>
NEXT_PUBLIC_SUPABASE_ANON_KEY=<anon / publishable key>
SUPABASE_SERVICE_ROLE_KEY=<service_role / secret key>
SUPABASE_THIRD_PARTY_AUTH_FIREBASE_PROJECT_ID=<your Firebase project id>
```

### 2.2 Connect Firebase as the identity provider (required)
**Authentication → Sign In / Providers → Third-Party Auth → Add provider → Firebase**, and enter your Firebase **project ID**.

Supabase also needs every token to carry `role: "authenticated"`. You don't have to do anything for the website: the sign-in endpoint adds that claim automatically on first sign-in. The Flutter apps must call `POST /api/auth/claims` once after sign-in (see `docs/BACKEND_CONTRACTS.md`).

### 2.3 Run the migrations
Run the files in `supabase/migrations/` **in order**, `0001` through `0012`.

**Option A — Supabase CLI (recommended; no copy-paste):**

```bash
supabase login
supabase link --project-ref <your-project-ref>
supabase db push
```

**Option B — SQL Editor:**
For each file, open it in your code editor, select all, copy, paste into a **new, empty** query in the SQL Editor, click in the editor, and **Run** with nothing highlighted. If text is highlighted, the editor runs only the highlighted part.

`0012` is safe to run again if a previous attempt failed part-way.

### 2.4 Create your first administrator
There is deliberately no way to become an admin from the UI, so the first one is created by script:

1. Start the app (step 3) and sign in at <http://localhost:3000/login> with the Google account or phone number you want to use. You'll see "This account is not an administrator". That is expected: the sign-in created your profile row.
2. Copy your **User UID** from **Firebase → Authentication → Users**.
3. Open `supabase/seed/bootstrap_super_admin.sql`, replace the three `REPLACE_WITH_…` values, and run it in the SQL Editor.
4. Sign in again. You'll land on the admin dashboard.

### 2.5 Optional: sample data (development only)
Paste this line first, then the whole of `supabase/seed/dev_seed.sql`, and run both together:

```sql
set app.allow_dev_seed = 'on';
```

Never run this against production.

---

## 3. Run locally

Leave the routing variables in `.env.local` at their defaults (`http://localhost:3000`, `NEXT_PUBLIC_ADMIN_PATH_PREFIX=/admin`), then:

```bash
npm run dev
```

- Public site: <http://localhost:3000>
- Admin panel: <http://localhost:3000/admin> (redirects to `/login`)

Checks before pushing:

```bash
npm run typecheck
npm test
npm run build
```

---

## 4. Deploy to Vercel

1. Push the repository to GitHub.
2. At <https://vercel.com/new>, import the repository.
3. **Root Directory: `web`**. This is required because the Next.js app is not at the repo root. Framework preset: Next.js. Leave build and output settings at their defaults.
4. **Environment Variables**: add every variable from your `.env.local`, then change the URL ones to your Vercel domain:

```
NEXT_PUBLIC_SITE_URL=https://<your-app>.vercel.app
NEXT_PUBLIC_PUBLIC_BASE_URL=https://<your-app>.vercel.app
NEXT_PUBLIC_ADMIN_BASE_URL=https://<your-app>.vercel.app
NEXT_PUBLIC_API_BASE_URL=https://<your-app>.vercel.app/api
NEXT_PUBLIC_ADMIN_PATH_PREFIX=/admin
```

   Do **not** add `NODE_ENV` (or `LOG_LEVEL=debug`): Vercel sets `NODE_ENV=production` itself, and a copied `NODE_ENV=development` would switch off secure cookies.

   For `FIREBASE_ADMIN_PRIVATE_KEY`, paste the value **without** the surrounding double quotes. Both the `\n` form and real line breaks work.
5. Click **Deploy**.

`NEXT_PUBLIC_*` values are compiled into the build. If you change one later, redeploy.

---

## 5. After the first deploy

- **Firebase → Authentication → Settings → Authorized domains → Add** `<your-app>.vercel.app` (and any custom domain). Without this, Google sign-in and phone OTP fail on the live site.
- Sign in at `https://<your-app>.vercel.app/login` with your bootstrapped admin account.
- Custom domain: add it in Vercel → Domains, update the URL variables above, add it to Firebase authorized domains, and redeploy.

---

## Troubleshooting

| Symptom | Cause | Fix |
| --- | --- | --- |
| App fails to start with "Invalid public environment configuration" | A `NEXT_PUBLIC_*` value is missing | Fill every variable listed in the error |
| Google popup: `auth/unauthorized-domain` | Domain not authorized in Firebase | Step 5 |
| Sign-in succeeds but says "not an administrator" | No `admin_users` row for your UID | Step 2.4 |
| Admin, but every page is empty or you're sent back to login | Third-Party Auth not configured, or wrong Firebase project ID | Step 2.2 |
| "Your account is still being set up" | Claim was added but a fresh token wasn't picked up yet | Sign in again |
| SQL Editor: `relation "…" does not exist` | Files run out of order, or only part of the script was highlighted | Run `0001`→`0012` in order with nothing highlighted, or use `supabase db push` |
| Phone OTP never arrives in development | SMS quota / real number | Use a Firebase test phone number (step 1.2) |
