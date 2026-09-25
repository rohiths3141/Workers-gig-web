#!/usr/bin/env node
// ===========================================================================
// create-demo-admin — the shared prototype login shown on the sign-in page
// ===========================================================================
// Creates (or brings back in line) a dedicated demo administrator whose email
// and password are printed on /login for anyone to use:
//
//   node scripts/create-demo-admin.mjs
//
// Reads from web/.env.local:
//   DEMO_ADMIN_EMAIL     e.g. demo-admin@example.com (need not be a real inbox)
//   DEMO_ADMIN_PASSWORD  at least 8 characters
//   DEMO_ADMIN_ROLE      optional, default ADMIN. SUPER_ADMIN is refused: a
//                        published password must not be able to manage
//                        administrators.
//
// Safe to re-run. It resets the password to DEMO_ADMIN_PASSWORD, which is the
// fix if a visitor changes it, and reactivates the account.
//
// It will not touch a real person's account. The demo account carries a
// `demo: true` custom claim, which only the Admin SDK can set, and an existing
// Firebase account without it is refused — so is an admin_users row for that
// email belonging to a different Firebase user.
//
// NOT read-only: writes to Firebase Authentication, profiles, admin_users and
// audit_logs.
// ===========================================================================

import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const HERE = path.dirname(fileURLToPath(import.meta.url));
const ENV_PATH = path.join(HERE, '..', '.env.local');

const DISPLAY_NAME = 'Demo Admin';
const ROLES = ['ADMIN', 'VERIFICATION_ADMIN', 'OPERATIONS_ADMIN', 'FINANCE_ADMIN', 'SUPPORT_ADMIN'];

/**
 * A `.env` value may be wrapped in quotes and carry `\n` escapes — which is how
 * a PEM private key fits on one line. Stripping the quotes without unescaping
 * yields a key OpenSSL rejects with "DECODER routines::unsupported", so both
 * steps have to happen and only inside double quotes.
 */
function readEnv(file) {
  const out = {};
  for (const line of readFileSync(file, 'utf8').split(/\r?\n/)) {
    if (!line || line.startsWith('#')) continue;
    const eq = line.indexOf('=');
    if (eq < 0) continue;

    const key = line.slice(0, eq).trim();
    let value = line.slice(eq + 1).trim();

    if (value.startsWith('"') && value.endsWith('"') && value.length > 1) {
      value = value.slice(1, -1).replace(/\\n/g, '\n').replace(/\\"/g, '"');
    } else if (value.startsWith("'") && value.endsWith("'") && value.length > 1) {
      value = value.slice(1, -1);
    }
    out[key] = value;
  }
  return out;
}

function required(env, name) {
  const value = env[name];
  if (!value) {
    console.error(`Missing ${name} in ${ENV_PATH}`);
    process.exit(2);
  }
  return value;
}

function fail(message) {
  console.error(message);
  process.exit(1);
}

// ---------------------------------------------------------------------------
// Configuration
// ---------------------------------------------------------------------------

const env = readEnv(ENV_PATH);
const email = required(env, 'DEMO_ADMIN_EMAIL').toLowerCase();
const password = required(env, 'DEMO_ADMIN_PASSWORD');
const role = env.DEMO_ADMIN_ROLE || 'ADMIN';

if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) fail(`DEMO_ADMIN_EMAIL is not an email: ${email}`);
if (password.length < 8) fail('DEMO_ADMIN_PASSWORD must be at least 8 characters.');
if (!ROLES.includes(role)) {
  fail(`DEMO_ADMIN_ROLE must be one of ${ROLES.join(', ')}. SUPER_ADMIN is not allowed for a shared login.`);
}

const supabaseUrl = required(env, 'NEXT_PUBLIC_SUPABASE_URL');
const serviceKey = required(env, 'SUPABASE_SERVICE_ROLE_KEY');

async function rest(pathAndQuery, init = {}) {
  const response = await fetch(`${supabaseUrl}/rest/v1/${pathAndQuery}`, {
    ...init,
    headers: {
      apikey: serviceKey,
      Authorization: `Bearer ${serviceKey}`,
      'Content-Type': 'application/json',
      ...init.headers,
    },
  });
  const text = await response.text();
  if (!response.ok) fail(`Supabase ${init.method ?? 'GET'} ${pathAndQuery.split('?')[0]} failed (${response.status}): ${text}`);
  return text ? JSON.parse(text) : null;
}

const { default: admin } = await import('firebase-admin');
admin.initializeApp({
  credential: admin.credential.cert({
    projectId: required(env, 'FIREBASE_ADMIN_PROJECT_ID'),
    clientEmail: required(env, 'FIREBASE_ADMIN_CLIENT_EMAIL'),
    privateKey: required(env, 'FIREBASE_ADMIN_PRIVATE_KEY'),
  }),
});
const auth = admin.auth();

// ---------------------------------------------------------------------------
// Firebase account
// ---------------------------------------------------------------------------

let user = null;
try {
  user = await auth.getUserByEmail(email);
} catch (error) {
  if (error.code !== 'auth/user-not-found') throw error;
}

if (user && user.customClaims?.demo !== true) {
  fail(
    `${email} already has a Firebase account that this script did not create. ` +
      'Use a separate address for the demo login, e.g. demo-admin@example.com.',
  );
}

// Every refusal happens before the first write, so a refused run changes nothing.
const [existingAdmin] = await rest(
  `admin_users?select=firebase_uid&email=eq.${encodeURIComponent(email)}`,
);
if (existingAdmin && existingAdmin.firebase_uid !== user?.uid) {
  fail(`admin_users already has ${email} for a different Firebase user (${existingAdmin.firebase_uid}).`);
}

let created = false;

if (user) {
  await auth.updateUser(user.uid, { password, disabled: false, displayName: DISPLAY_NAME });
} else {
  user = await auth.createUser({ email, password, displayName: DISPLAY_NAME });
  created = true;
}

// `role` is what Supabase maps to the Postgres role; the sign-in endpoint would
// add it on first use anyway, and setting it here saves that round trip.
// `demo` marks the account as this script's to reset.
await auth.setCustomUserClaims(user.uid, {
  ...(user.customClaims ?? {}),
  role: 'authenticated',
  demo: true,
});

// ---------------------------------------------------------------------------
// Platform rows
// ---------------------------------------------------------------------------

const [profile] = await rest('profiles?on_conflict=firebase_uid&select=id', {
  method: 'POST',
  headers: { Prefer: 'resolution=merge-duplicates,return=representation' },
  body: JSON.stringify({
    firebase_uid: user.uid,
    role: 'ADMIN',
    account_status: 'ACTIVE',
    email,
    display_name: DISPLAY_NAME,
  }),
});

await rest('admin_users?on_conflict=firebase_uid', {
  method: 'POST',
  headers: { Prefer: 'resolution=merge-duplicates,return=minimal' },
  body: JSON.stringify({
    profile_id: profile.id,
    firebase_uid: user.uid,
    email,
    full_name: DISPLAY_NAME,
    role,
    is_active: true,
  }),
});

await rest('audit_logs', {
  method: 'POST',
  headers: { Prefer: 'return=minimal' },
  body: JSON.stringify({
    actor_type: 'SYSTEM',
    action: created ? 'admin.demo_created' : 'admin.demo_reset',
    resource_type: 'admin_user',
    resource_id: user.uid,
    after_state: { email, role },
    reason: 'Shared prototype login, set with scripts/create-demo-admin.mjs',
  }),
});

console.log(`${created ? 'Created' : 'Updated'} the demo administrator.`);
console.log(`  Email:  ${email}`);
console.log(`  Role:   ${role}`);
console.log(`  UID:    ${user.uid}`);
console.log('The sign-in page shows this login while DEMO_ADMIN_EMAIL and DEMO_ADMIN_PASSWORD are set.');
console.log('Restart `npm run dev` if it was already running, so it picks up the new values.');
process.exit(0);
