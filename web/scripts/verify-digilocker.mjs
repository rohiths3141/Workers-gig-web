#!/usr/bin/env node
// ===========================================================================
// verify-digilocker — exercise the live DigiLocker eKYC path without a device
// ===========================================================================
// Mints a genuine Firebase ID token for a test worker and calls the deployed
// `kyc-digilocker` function exactly as the worker app does, so "DigiLocker is
// unavailable right now" can be traced to the provider, the credentials or the
// worker's own case rather than guessed at.
//
//   node scripts/verify-digilocker.mjs status +919090909090
//   node scripts/verify-digilocker.mjs init   +919090909090 --yes
//
// `status` is read-only against our own tables and asks MessageCentral only
// about a session that already exists.
//
// `init` is NOT read-only. On success it consumes a real MessageCentral
// DigiLocker session (which is metered) and opens a PENDING IDENTITY_KYC case
// for that worker, so it requires --yes.
//
// Credentials come from web/.env.local. The MessageCentral key itself is not
// here and never has been: it lives only in the Supabase project's secrets,
// which is why the check has to go through the deployed function.
// ===========================================================================

import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const HERE = path.dirname(fileURLToPath(import.meta.url));
const ENV_PATH = path.join(HERE, '..', '.env.local');

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

const action = process.argv[2] ?? 'status';
const phone = process.argv[3] ?? '+919090909090';
const confirmed = process.argv.includes('--yes');

if (!['status', 'init', 'users'].includes(action)) {
  console.error(
    'Usage: verify-digilocker.mjs <status|init|users> [+91XXXXXXXXXX] [--yes]',
  );
  process.exit(2);
}
if (action === 'init' && !confirmed) {
  console.error(
    'init consumes a real DigiLocker session and opens a PENDING KYC case.\n' +
      'Re-run with --yes if that is what you want.',
  );
  process.exit(2);
}

const env = readEnv(ENV_PATH);

const { default: admin } = await import('firebase-admin');
admin.initializeApp({
  credential: admin.credential.cert({
    projectId: required(env, 'FIREBASE_ADMIN_PROJECT_ID'),
    clientEmail: required(env, 'FIREBASE_ADMIN_CLIENT_EMAIL'),
    privateKey: required(env, 'FIREBASE_ADMIN_PRIVATE_KEY'),
  }),
});

// Test numbers are recycled, so the pool changes; `users` says what is
// actually there rather than leaving you guessing at a number.
if (action === 'users') {
  const { users } = await admin.auth().listUsers(100);
  console.log(`${users.length} Firebase users:`);
  for (const u of users) {
    console.log(`  ${(u.phoneNumber ?? '(no phone)').padEnd(16)} ${u.uid}`);
  }
  process.exit(0);
}

let user;
try {
  user = await admin.auth().getUserByPhoneNumber(phone);
} catch {
  console.error(
    `No Firebase user for ${phone}. Run "node scripts/verify-digilocker.mjs users" ` +
      'to see the current pool.',
  );
  process.exit(1);
}

const customToken = await admin.auth().createCustomToken(user.uid);
const exchanged = await fetch(
  `https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=${required(env, 'NEXT_PUBLIC_FIREBASE_API_KEY')}`,
  {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ token: customToken, returnSecureToken: true }),
  },
).then((r) => r.json());

if (!exchanged.idToken) {
  console.error('Token exchange failed:', exchanged.error ?? exchanged);
  process.exit(1);
}

const claims = JSON.parse(
  Buffer.from(exchanged.idToken.split('.')[1], 'base64url').toString(),
);
console.log(`worker   ${phone}  uid=${user.uid}`);
console.log(`token    role=${claims.role ?? '(none)'}  phone=${claims.phone_number ?? '(none)'}`);
if (claims.role !== 'authenticated') {
  console.log('         ^ without role=authenticated every RLS policy denies');
}

const base = `${required(env, 'NEXT_PUBLIC_SUPABASE_URL')}/functions/v1/kyc-digilocker`;
const response = await fetch(`${base}/${action}`, {
  method: 'POST',
  headers: {
    apikey: required(env, 'NEXT_PUBLIC_SUPABASE_ANON_KEY'),
    Authorization: `Bearer ${exchanged.idToken}`,
    'Content-Type': 'application/json',
  },
});

const text = await response.text();
console.log(`\n${action} -> HTTP ${response.status}`);
console.log(text);

let body = {};
try {
  body = JSON.parse(text);
} catch {
  /* a non-JSON body is itself the finding */
}

// The function returns 502 with this exact wording for every provider-side
// refusal — a wrong key, an expired subscription and an outage all look the
// same from here, so say so rather than guessing which one it is.
console.log('\n--- reading ---');
if (response.status === 502) {
  console.log(
    'MessageCentral refused or was unreachable. The function logs the raw\n' +
      'provider body; read it with:\n' +
      '  npx supabase functions logs kyc-digilocker\n' +
      'Most often: MESSAGECENTRAL_API_KEY / MESSAGECENTRAL_CUSTOMER_ID wrong,\n' +
      'expired, or the account is out of eKYC credits.',
  );
} else if (response.status === 401) {
  console.log('The gateway rejected the token before the function ran.');
} else if (body.status === 'PENDING' && body.url) {
  console.log(`Provider is live. Consent URL issued:\n  ${body.url}`);
} else if (body.status) {
  console.log(`Case status: ${body.status}${body.reason ? ` — ${body.reason}` : ''}`);
}

process.exit(0);
