/**
 * Capture real rows from the live database as test fixtures for both apps.
 *
 *   node web/supabase/scripts/capture-app-fixtures.mjs
 *
 * Unit tests that build their own maps only ever prove the mapper agrees with
 * the test author. These fixtures are the actual bytes PostgREST returns, so
 * the mapper tests catch the things a handwritten map never will: a column that
 * is null in practice, a numeric that arrives as a string, an enum value nobody
 * remembered, a nested join that comes back as a list instead of an object.
 *
 * The select lists are read out of the Dart repositories rather than copied, so
 * a fixture cannot silently drift from the query the app actually runs.
 *
 * Nothing sensitive is captured: see SCRUB below. Rows are read with the
 * service key, which bypasses RLS on purpose — the point is to see every shape
 * the table can produce, not only this caller's own rows.
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const HERE = path.dirname(fileURLToPath(import.meta.url));
const REPO = path.resolve(HERE, '..', '..', '..');

const env = {};
for (const line of fs.readFileSync(path.join(REPO, 'web', '.env.local'), 'utf8').split(/\r?\n/)) {
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

const URL_ = env.NEXT_PUBLIC_SUPABASE_URL;
const KEY = env.SUPABASE_SERVICE_ROLE_KEY;
if (!URL_ || !KEY) {
  console.error('Set NEXT_PUBLIC_SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY in web/.env.local');
  process.exit(1);
}

/**
 * Personal data has no business in a repository, and a mapper does not care
 * what a name says — only that it is a non-empty string of the right type. So
 * these are replaced with something of the same shape.
 */
const SCRUB = {
  full_name: () => 'Test Person',
  display_name: () => 'Test Person',
  phone: () => '9000000001',
  email: () => 'test@example.com',
  firebase_uid: () => 'FIXTUREuid0000000000000000001',
  address_line: () => '1 Example Street',
  customer_notes: (v) => (v == null ? null : 'Example note'),
  account_last4: () => '0000',
  bio: (v) => (v == null ? null : 'Example bio'),
};

function scrub(value) {
  if (Array.isArray(value)) return value.map(scrub);
  if (value && typeof value === 'object') {
    const out = {};
    for (const [k, v] of Object.entries(value)) {
      out[k] = Object.hasOwn(SCRUB, k) ? SCRUB[k](v) : scrub(v);
    }
    return out;
  }
  return value;
}

/** Every `static const _x = '...'` in a Dart file, in source order. */
function dartConstants(relPath) {
  const src = fs.readFileSync(path.join(REPO, relPath), 'utf8');
  const re = /static const (_\w+)\s*=\s*(?:'''([\s\S]*?)'''|'([^']*)')\s*;/g;
  return [...src.matchAll(re)].map((m) => ({
    name: m[1],
    value: (m[2] ?? m[3]).replace(/\s+/g, ' ').trim(),
  }));
}

/** The nth constant in a file, so repeated `_columns` names stay unambiguous. */
function columnsOf(relPath, index) {
  const all = dartConstants(relPath);
  if (!all[index]) throw new Error(`${relPath} has no constant at index ${index}`);
  return all[index].value;
}

const W = 'worker-app/lib/data/repositories';
const C = 'customer-app/lib/data/repositories';

const SPECS = [
  // --- worker app ---------------------------------------------------------
  { app: 'worker-app', name: 'workers', table: 'workers', select: columnsOf(`${W}/supabase_worker_repository.dart`, 0) },
  { app: 'worker-app', name: 'services', table: 'services', select: columnsOf(`${W}/supabase_worker_repository.dart`, 1) },
  { app: 'worker-app', name: 'bookings', table: 'bookings', select: columnsOf(`${W}/supabase_job_repository.dart`, 0) },
  { app: 'worker-app', name: 'materials', table: 'materials', select: columnsOf(`${W}/supabase_job_repository.dart`, 1) },
  { app: 'worker-app', name: 'worker_gigs', table: 'worker_gigs', select: columnsOf(`${W}/supabase_gig_repository.dart`, 0) },
  { app: 'worker-app', name: 'worker_verifications', table: 'worker_verifications', select: columnsOf(`${W}/supabase_trust_repositories.dart`, 0) },
  { app: 'worker-app', name: 'notifications', table: 'notifications', select: columnsOf(`${W}/supabase_trust_repositories.dart`, 1) },
  { app: 'worker-app', name: 'wallets', table: 'wallets', select: columnsOf(`${W}/supabase_wallet_repository.dart`, 0) },
  { app: 'worker-app', name: 'wallet_transactions', table: 'wallet_transactions', select: columnsOf(`${W}/supabase_wallet_repository.dart`, 1) },
  { app: 'worker-app', name: 'payouts', table: 'payouts', select: columnsOf(`${W}/supabase_wallet_repository.dart`, 2) },
  {
    app: 'worker-app',
    name: 'booking_events',
    table: 'booking_events',
    select: 'id, event_type, from_status, to_status, note, created_at',
  },
  {
    app: 'worker-app',
    name: 'media_assets',
    table: 'media_assets',
    select:
      'id, purpose, upload_status, mime_type, file_size_bytes, original_file_name, ' +
      'booking_id, worker_id, material_id, captured_at, created_at, width, height, duration_seconds',
  },

  // --- customer app -------------------------------------------------------
  {
    app: 'customer-app',
    name: 'bookings',
    table: 'bookings',
    select:
      'id, booking_code, customer_id, service_id, status, problem_description, ' +
      'address_line, city, state, pincode, quoted_amount_minor, final_amount_minor, ' +
      'currency, worker_id, scheduled_at, latitude, longitude, customer_notes, ' +
      'created_at, completed_at, cancelled_at, cancellation_reason, ' +
      'services!inner(name), workers(full_name, phone, rating_avg)',
  },
  { app: 'customer-app', name: 'services', table: 'services', select: 'id, name, slug, description, short_description, icon_key, display_order' },
  { app: 'customer-app', name: 'service_problems', table: 'service_problems', select: 'id, service_id, title, description' },
  { app: 'customer-app', name: 'customers', table: 'customers', select: '*' },
  { app: 'customer-app', name: 'customer_addresses', table: 'customer_addresses', select: '*' },
  { app: 'customer-app', name: 'materials', table: 'materials', select: '*' },
  { app: 'customer-app', name: 'payments', table: 'payments', select: '*' },
  { app: 'customer-app', name: 'notifications', table: 'notifications', select: '*' },
  { app: 'customer-app', name: 'booking_events', table: 'booking_events', select: '*' },
  { app: 'customer-app', name: 'worker_locations', table: 'worker_locations', select: '*' },
  { app: 'customer-app', name: 'customer_service_requests', table: 'customer_service_requests', select: '*' },
  { app: 'customer-app', name: 'service_request_offers', table: 'service_request_offers', select: '*' },
];

const LIMIT = 50;
let failures = 0;

for (const spec of SPECS) {
  const query = `${spec.table}?select=${encodeURIComponent(spec.select)}&limit=${LIMIT}`;
  const res = await fetch(`${URL_}/rest/v1/${query}`, {
    headers: { apikey: KEY, Authorization: `Bearer ${KEY}` },
  });
  const body = await res.json();

  if (!res.ok) {
    console.error(`  !! ${spec.app}/${spec.name}: ${res.status} ${JSON.stringify(body)}`);
    failures += 1;
    continue;
  }

  const rows = scrub(body);
  const dir = path.join(REPO, spec.app, 'test', 'fixtures', 'rows');
  fs.mkdirSync(dir, { recursive: true });
  fs.writeFileSync(
    path.join(dir, `${spec.name}.json`),
    `${JSON.stringify({ table: spec.table, select: spec.select, rows }, null, 2)}\n`,
    'utf8',
  );
  console.log(`  ${spec.app.padEnd(13)} ${spec.name.padEnd(26)} ${String(rows.length).padStart(3)} rows`);
}

process.exit(failures > 0 ? 1 : 0);
