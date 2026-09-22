/**
 * Delete a test account and everything hanging off it.
 *
 *   node web/supabase/scripts/delete-test-account.mjs 9292929292            # dry run
 *   node web/supabase/scripts/delete-test-account.mjs 9292929292 --confirm  # delete
 *   node ... 9292929292 9393939393 --confirm --firebase                     # also delete the Firebase user
 *
 * Takes 10-digit numbers, as workers.phone and customers.phone store them.
 *
 * Why this is a script and not `delete from profiles`: the schema deliberately
 * declares ON DELETE RESTRICT on everything that represents money or a record
 * of what happened — bookings, payments, refunds, claims, payouts, wallet
 * transactions — so a customer or worker who has traded cannot be erased by
 * accident. That is right for production and merely inconvenient for a test
 * number, so this walks those tables in dependency order first and then lets
 * the cascades from public.profiles take the rest.
 *
 * Deleting the Firebase user is opt-in and usually unnecessary: since migration
 * 0061 a number whose Firebase UID has changed is re-bound to its existing
 * account on sign-in, so reusing a test number no longer requires a clean slate.
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { createRequire } from 'node:module';

const WEB_DIR = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..', '..');

const env = {};
for (const line of fs.readFileSync(path.join(WEB_DIR, '.env.local'), 'utf8').split(/\r?\n/)) {
  const t = line.trim();
  if (!t || t.startsWith('#')) continue;
  const i = t.indexOf('=');
  if (i <= 0) continue;
  const k = t.slice(0, i);
  if (!/^[A-Z0-9_]+$/.test(k)) continue;
  let v = t.slice(i + 1).trim();
  if (v.length > 1 && v[0] === '"' && v[v.length - 1] === '"') v = v.slice(1, -1);
  env[k] = v;
}

const SUPABASE_URL = env.NEXT_PUBLIC_SUPABASE_URL;
const SERVICE_KEY = env.SUPABASE_SERVICE_ROLE_KEY;
if (!SUPABASE_URL || !SERVICE_KEY) {
  console.error('NEXT_PUBLIC_SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY must be set in web/.env.local');
  process.exit(1);
}

const args = process.argv.slice(2);
const confirm = args.includes('--confirm');
const alsoFirebase = args.includes('--firebase');
const phones = args.filter((a) => /^\d{10}$/.test(a));

if (phones.length === 0) {
  console.error('Usage: node delete-test-account.mjs <10-digit-phone> [more...] [--confirm] [--firebase]');
  process.exit(1);
}

async function rest(pathAndQuery, init = {}) {
  const res = await fetch(`${SUPABASE_URL}/rest/v1/${pathAndQuery}`, {
    ...init,
    headers: {
      apikey: SERVICE_KEY,
      Authorization: `Bearer ${SERVICE_KEY}`,
      'Content-Type': 'application/json',
      Prefer: 'return=representation',
      ...(init.headers || {}),
    },
  });
  const text = await res.text();
  let body;
  try {
    body = text ? JSON.parse(text) : null;
  } catch {
    body = text;
  }
  if (!res.ok) {
    throw new Error(`${init.method || 'GET'} ${pathAndQuery} -> ${res.status} ${JSON.stringify(body)}`);
  }
  return body ?? [];
}

const inList = (ids) => `(${ids.map((id) => `"${id}"`).join(',')})`;

/** How many rows match, without assuming the table has an `id` column. */
async function count(table, filter) {
  const res = await fetch(`${SUPABASE_URL}/rest/v1/${table}?select=*&${filter}`, {
    method: 'HEAD',
    headers: {
      apikey: SERVICE_KEY,
      Authorization: `Bearer ${SERVICE_KEY}`,
      Prefer: 'count=exact',
      Range: '0-0',
    },
  });
  if (!res.ok && res.status !== 206) {
    throw new Error(`HEAD ${table}?${filter} -> ${res.status}`);
  }
  const range = res.headers.get('content-range') || '';
  return Number(range.split('/')[1] || 0);
}

/** Deletes rows matching `filter`, or reports what it would delete. */
async function wipe(label, table, filter) {
  const n = await count(table, filter);
  if (n === 0) return 0;
  if (!confirm) {
    console.log(`   would delete ${String(n).padStart(4)}  ${label}`);
    return n;
  }
  await rest(`${table}?${filter}`, { method: 'DELETE' });
  console.log(`   deleted      ${String(n).padStart(4)}  ${label}`);
  return n;
}

for (const phone of phones) {
  console.log(`\n=== +91 ${phone} ===`);

  const workers = await rest(`workers?select=id,profile_id,full_name,status&phone=eq.${phone}`);
  const customers = await rest(`customers?select=id,profile_id,full_name,status&phone=eq.${phone}`);
  const profiles = await rest(`profiles?select=id,firebase_uid,role,display_name&phone=eq.${phone}`);

  if (workers.length === 0 && customers.length === 0 && profiles.length === 0) {
    console.log('   nothing in the database for this number');
    continue;
  }

  for (const w of workers) console.log(`   worker   ${w.full_name} (${w.status})`);
  for (const c of customers) console.log(`   customer ${c.full_name} (${c.status})`);

  const workerIds = workers.map((w) => w.id);
  const customerIds = customers.map((c) => c.id);
  const profileIds = [
    ...new Set([...workers, ...customers].map((r) => r.profile_id).concat(profiles.map((p) => p.id))),
  ];

  // Bookings this number is on, from either side.
  const bookingRows = [];
  if (customerIds.length) bookingRows.push(...(await rest(`bookings?select=id&customer_id=in.${inList(customerIds)}`)));
  if (workerIds.length) bookingRows.push(...(await rest(`bookings?select=id&worker_id=in.${inList(workerIds)}`)));
  const bookingIds = [...new Set(bookingRows.map((b) => b.id))];

  // ---- the ON DELETE RESTRICT chains, deepest first --------------------
  if (bookingIds.length) {
    const payments = await rest(`payments?select=id&booking_id=in.${inList(bookingIds)}`);
    if (payments.length) {
      await wipe('refunds', 'refunds', `payment_id=in.${inList(payments.map((p) => p.id))}`);
    }
    await wipe('payments', 'payments', `booking_id=in.${inList(bookingIds)}`);
    await wipe('claims', 'claims', `booking_id=in.${inList(bookingIds)}`);
    await wipe('support tickets', 'support_tickets', `booking_id=in.${inList(bookingIds)}`);
    await wipe('materials', 'materials', `booking_id=in.${inList(bookingIds)}`);
  }
  if (customerIds.length) {
    await wipe('payments (by customer)', 'payments', `customer_id=in.${inList(customerIds)}`);
    await wipe('claims (by customer)', 'claims', `customer_id=in.${inList(customerIds)}`);
    await wipe('support tickets (by customer)', 'support_tickets', `customer_id=in.${inList(customerIds)}`);
    await wipe('service requests', 'customer_service_requests', `customer_id=in.${inList(customerIds)}`);
  }
  if (workerIds.length) {
    await wipe('claims (by worker)', 'claims', `worker_id=in.${inList(workerIds)}`);
    await wipe('support tickets (by worker)', 'support_tickets', `worker_id=in.${inList(workerIds)}`);
    await wipe('materials (by worker)', 'materials', `worker_id=in.${inList(workerIds)}`);
    await wipe('offers', 'service_request_offers', `worker_id=in.${inList(workerIds)}`);
  }

  // Bookings cascade to events, match candidates, materials, ratings, arrival
  // attempts, worker_locations and the live-tracking rows.
  if (bookingIds.length) await wipe('bookings', 'bookings', `id=in.${inList(bookingIds)}`);

  if (workerIds.length) {
    // payouts before wallet_transactions: payouts.ledger_transaction_id is the
    // only SET NULL in this group and the rest are RESTRICT.
    await wipe('payouts', 'payouts', `worker_id=in.${inList(workerIds)}`);
    await wipe('wallet transactions', 'wallet_transactions', `worker_id=in.${inList(workerIds)}`);
    await wipe('wallets', 'wallets', `worker_id=in.${inList(workerIds)}`);
  }

  // Everything else — workers, customers, gigs, skills, verifications, media,
  // addresses, notifications, push tokens — cascades from the profile.
  if (profileIds.length) await wipe('profiles (cascades the rest)', 'profiles', `id=in.${inList(profileIds)}`);

  if (alsoFirebase) {
    const require = createRequire(path.join(WEB_DIR, 'package.json'));
    const admin = require('firebase-admin');
    if (admin.apps.length === 0) {
      admin.initializeApp({
        credential: admin.credential.cert({
          projectId: env.FIREBASE_ADMIN_PROJECT_ID,
          clientEmail: env.FIREBASE_ADMIN_CLIENT_EMAIL,
          privateKey: (env.FIREBASE_ADMIN_PRIVATE_KEY || '').split('\\n').join('\n'),
        }),
      });
    }
    try {
      const user = await admin.auth().getUserByPhoneNumber(`+91${phone}`);
      if (!confirm) {
        console.log(`   would delete      Firebase user ${user.uid}`);
      } else {
        await admin.auth().deleteUser(user.uid);
        console.log(`   deleted           Firebase user ${user.uid}`);
      }
    } catch {
      console.log('   no Firebase user for this number');
    }
  }
}

console.log(confirm ? '\nDone.' : '\nDry run — nothing was deleted. Re-run with --confirm to apply.');
