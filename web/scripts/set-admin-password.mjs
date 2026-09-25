#!/usr/bin/env node
// ===========================================================================
// set-admin-password — let an administrator sign in with email and password
// ===========================================================================
// Sets (or replaces) the Firebase password on an existing administrator's
// account. The password is added to the same Firebase user, so the UID — and
// therefore the admin_users row — does not change, and any Google or phone
// sign-in the account already has keeps working.
//
//   node scripts/set-admin-password.mjs admin@example.com
//
// Only the email of an ACTIVE row in public.admin_users is accepted: this
// cannot hand a password to a customer, a worker or a removed administrator.
// If the Firebase account has no email yet (a phone-only admin), the
// admin_users email is added to it along with the password.
//
// The password is read from the keyboard with echo off, never from arguments,
// so it does not land in shell history. That needs a real terminal: use
// PowerShell, Command Prompt or Windows Terminal, or `winpty node …` in Git Bash.
//
// NOT read-only: it changes the Firebase account and writes an audit_logs row.
// Credentials come from web/.env.local.
// ===========================================================================

import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const HERE = path.dirname(fileURLToPath(import.meta.url));
const ENV_PATH = path.join(HERE, '..', '.env.local');

const MIN_LENGTH = 12;
const MAX_LENGTH = 128;

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

/** Read one line from the terminal without echoing it. */
function promptHidden(question) {
  return new Promise((resolve) => {
    const stdin = process.stdin;
    let value = '';

    const finish = () => {
      stdin.off('data', onData);
      stdin.setRawMode(false);
      stdin.pause();
      process.stdout.write('\n');
      resolve(value);
    };

    const onData = (chunk) => {
      for (const ch of chunk) {
        if (ch === '\r' || ch === '\n') return finish();
        if (ch === '\u0003') {
          // Ctrl+C: raw mode swallows the signal, so honour it by hand.
          stdin.setRawMode(false);
          process.stdout.write('\nCancelled. Nothing was changed.\n');
          process.exit(130);
        }
        if (ch === '\u007f' || ch === '\b') value = value.slice(0, -1);
        else if (ch >= ' ') value += ch;
      }
    };

    process.stdout.write(question);
    stdin.setEncoding('utf8');
    stdin.setRawMode(true);
    stdin.resume();
    stdin.on('data', onData);
  });
}

// ---------------------------------------------------------------------------
// Arguments
// ---------------------------------------------------------------------------

const email = process.argv[2]?.trim();

if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
  console.error('Usage: node scripts/set-admin-password.mjs <admin email>');
  process.exit(2);
}
if (process.argv.length > 3) {
  console.error(
    'Only the email goes on the command line. Do not pass the password as an argument —\n' +
      'it would be saved in your shell history. You will be asked for it.',
  );
  process.exit(2);
}

// ---------------------------------------------------------------------------
// Resolve the administrator
// ---------------------------------------------------------------------------

const env = readEnv(ENV_PATH);
const supabaseUrl = required(env, 'NEXT_PUBLIC_SUPABASE_URL');
const serviceKey = required(env, 'SUPABASE_SERVICE_ROLE_KEY');
const supabaseHeaders = { apikey: serviceKey, Authorization: `Bearer ${serviceKey}` };

// admin_users.email is citext, so eq matches regardless of case.
const lookup = await fetch(
  `${supabaseUrl}/rest/v1/admin_users?select=firebase_uid,email,full_name,role,is_active` +
    `&email=eq.${encodeURIComponent(email)}`,
  { headers: supabaseHeaders },
);
if (!lookup.ok) {
  console.error(`Could not read admin_users (${lookup.status}):`, await lookup.text());
  process.exit(1);
}
const [adminRow] = await lookup.json();

if (!adminRow) {
  console.error(
    `No administrator uses ${email}. Passwords are only set for existing administrators;\n` +
      'create the administrator first (supabase/seed/bootstrap_super_admin.sql for the first one).',
  );
  process.exit(1);
}
if (!adminRow.is_active) {
  console.error(`${adminRow.email} is an inactive administrator. Reactivate them first.`);
  process.exit(1);
}

const { default: admin } = await import('firebase-admin');
admin.initializeApp({
  credential: admin.credential.cert({
    projectId: required(env, 'FIREBASE_ADMIN_PROJECT_ID'),
    clientEmail: required(env, 'FIREBASE_ADMIN_CLIENT_EMAIL'),
    privateKey: required(env, 'FIREBASE_ADMIN_PRIVATE_KEY'),
  }),
});

let user;
try {
  user = await admin.auth().getUser(adminRow.firebase_uid);
} catch {
  console.error(
    `admin_users points ${adminRow.email} at Firebase UID ${adminRow.firebase_uid}, ` +
      'which does not exist in this Firebase project.',
  );
  process.exit(1);
}

// Email/password sign-in uses the email on the Firebase account. If that
// differs from admin_users, the admin would be told one address and have to
// type another; better to stop and have someone decide which is right.
if (user.email && user.email.toLowerCase() !== adminRow.email.toLowerCase()) {
  console.error(
    `The Firebase account for this administrator uses ${user.email}, not ${adminRow.email}.\n` +
      'Make the two match before setting a password.',
  );
  process.exit(1);
}
if (user.disabled) {
  console.error(`The Firebase account for ${adminRow.email} is disabled. Enable it first.`);
  process.exit(1);
}

const providers = user.providerData.map((p) => p.providerId);
const hasPassword = providers.includes('password');

console.log(`Administrator:  ${adminRow.full_name} <${adminRow.email}>, ${adminRow.role}`);
console.log(`Firebase UID:   ${user.uid}`);
console.log(`Signs in with:  ${providers.length ? providers.join(', ') : '(nothing yet)'}`);
console.log(
  hasPassword
    ? 'This REPLACES the existing password.\n'
    : `This adds a password${user.email ? '' : ` and the email ${adminRow.email}`}. ` +
        'Existing sign-in methods keep working.\n',
);

// ---------------------------------------------------------------------------
// Read and set the password
// ---------------------------------------------------------------------------

if (!process.stdin.isTTY) {
  console.error(
    'The password is read with echo off, which needs an interactive terminal.\n' +
      'Run this from PowerShell, Command Prompt or Windows Terminal, or prefix it with `winpty` in Git Bash.',
  );
  process.exit(2);
}

const password = await promptHidden(`New password (at least ${MIN_LENGTH} characters): `);

if (password.length < MIN_LENGTH || password.length > MAX_LENGTH) {
  console.error(`The password must be ${MIN_LENGTH}–${MAX_LENGTH} characters. Nothing was changed.`);
  process.exit(1);
}
if (password.toLowerCase().includes(adminRow.email.split('@')[0].toLowerCase())) {
  console.error('The password must not contain the email name. Nothing was changed.');
  process.exit(1);
}
if ((await promptHidden('Type it again: ')) !== password) {
  console.error('The two entries do not match. Nothing was changed.');
  process.exit(1);
}

try {
  await admin.auth().updateUser(user.uid, {
    password,
    ...(user.email ? {} : { email: adminRow.email }),
  });
} catch (error) {
  console.error(`Firebase refused the change (${error.code ?? 'unknown'}): ${error.message}`);
  process.exit(1);
}

// The credential change is done; failing to record it should be loud but must
// not suggest that the password was not set.
const audit = await fetch(`${supabaseUrl}/rest/v1/audit_logs`, {
  method: 'POST',
  headers: { ...supabaseHeaders, 'Content-Type': 'application/json', Prefer: 'return=minimal' },
  body: JSON.stringify({
    actor_type: 'SYSTEM',
    action: 'admin.password_set',
    resource_type: 'admin_user',
    resource_id: user.uid,
    after_state: {
      email: adminRow.email,
      replaced_existing_password: hasPassword,
      email_added: !user.email,
    },
    reason: 'Set with scripts/set-admin-password.mjs',
  }),
});
if (!audit.ok) {
  console.warn(
    `Warning: the password WAS set, but the audit_logs row could not be written ` +
      `(${audit.status}): ${await audit.text()}`,
  );
}

console.log(`Done. ${adminRow.email} can now sign in at /login with this email and password.`);
console.log(
  'Firebase may end sessions this account already has open, because its password changed.',
);
process.exit(0);
