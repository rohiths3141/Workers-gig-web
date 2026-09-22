/**
 * Profile the real shape of production data, without copying any of it.
 *
 *   node web/supabase/scripts/profile-app-data.mjs
 *
 * Unit tests that build their own maps only prove the mapper agrees with the
 * test author. What breaks in the field is the other thing: a column that is
 * null in practice but not in anyone's head, a numeric that arrives as a
 * string, a nested join that comes back null when the row has no worker yet, a
 * status nobody remembered.
 *
 * So this reads the live tables through each app's own select list and records
 * only the *shape*: which JSON types each column actually takes, whether it is
 * ever null, and — for short code-like columns only — which values occur. Free
 * text, names, phone numbers, emails, addresses and anything else that could
 * identify a person are recorded as "a nullable string" and nothing more.
 *
 * The result is a fixture with no personal data in it that still describes
 * production faithfully enough to catch real mapper bugs.
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
 * Columns whose values are never recorded, only their type and nullability.
 *
 * Identifiers, anything free-text a person typed, anything locating them, and
 * the opaque jsonb blobs. When in doubt a column belongs here: the tests need
 * the shape, never the content.
 */
const NEVER_RECORD_VALUES = new Set([
  'id', 'worker_id', 'customer_id', 'booking_id', 'service_id', 'gig_id',
  'material_id', 'profile_id', 'firebase_uid', 'reference_id', 'wallet_id',
  'full_name', 'display_name', 'phone', 'email', 'bio',
  'address_line', 'city', 'state', 'pincode', 'latitude', 'longitude',
  'problem_description', 'description', 'short_description', 'customer_notes',
  'note', 'body', 'title', 'subject', 'comment', 'name', 'label',
  'cancellation_reason', 'rejection_reason', 'customer_rejection_reason',
  'failure_reason', 'frozen_reason', 'restriction_reason', 'decision_reason',
  'info_requested', 'details', 'payload', 'metadata',
  'original_file_name', 'account_last4', 'bank_name', 'worker_code',
  'booking_code', 'payout_code', 'template_key', 'slug', 'icon_key',
]);

/** Short, code-like strings are safe to record and are what mappers branch on. */
const looksLikeCode = (v) =>
  typeof v === 'string' && v.length <= 40 && /^[A-Z0-9_]+$/.test(v);

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
const TIMESTAMP = /^\d{4}-\d{2}-\d{2}[T ]\d{2}:\d{2}:\d{2}/;

/**
 * What a string column *is*, so a test can synthesise a valid value for it
 * without ever seeing the real one. A mapper that calls `DateTime.parse` needs
 * a timestamp, not the word "text".
 */
function formatOf(v) {
  if (typeof v !== 'string') return null;
  if (UUID.test(v)) return 'uuid';
  if (TIMESTAMP.test(v)) return 'timestamp';
  if (looksLikeCode(v)) return 'code';
  return 'text';
}

const typeOf = (v) => {
  if (v === null || v === undefined) return 'null';
  if (Array.isArray(v)) return 'array';
  return typeof v; // string | number | boolean | object
};

function profileRows(rows) {
  /** column -> { types:Set, nullable:bool, values:Set, nested:profile } */
  const cols = {};

  for (const row of rows) {
    for (const [key, value] of Object.entries(row)) {
      const c = (cols[key] ??= { types: new Set(), nullable: false, values: new Set(), formats: new Set(), nested: null });
      const t = typeOf(value);
      if (t === 'null') {
        c.nullable = true;
        continue;
      }
      c.types.add(t);
      const fmt = formatOf(value);
      if (fmt) c.formats.add(fmt);

      if (t === 'object') {
        c.nested = profileRows([value], );
      } else if (t === 'array') {
        if (value.length && typeOf(value[0]) === 'object') c.nested = profileRows(value);
        else for (const v of value) if (looksLikeCode(v)) c.values.add(v);
      } else if (!NEVER_RECORD_VALUES.has(key) && looksLikeCode(value)) {
        c.values.add(value);
      }
    }
  }

  // A column absent from some rows behaves like a nullable one to a mapper.
  for (const [key, c] of Object.entries(cols)) {
    if (rows.some((r) => !Object.hasOwn(r, key))) c.nullable = true;
  }

  return Object.fromEntries(
    Object.entries(cols)
      .sort(([a], [b]) => a.localeCompare(b))
      .map(([key, c]) => [
        key,
        {
          types: [...c.types].sort(),
          nullable: c.nullable,
          ...(c.formats.size ? { formats: [...c.formats].sort() } : {}),
          ...(c.values.size ? { values: [...c.values].sort().slice(0, 25) } : {}),
          ...(c.nested ? { nested: c.nested } : {}),
        },
      ]),
  );
}

function dartConstants(relPath) {
  const src = fs.readFileSync(path.join(REPO, relPath), 'utf8');
  const re = /static const (_\w+)\s*=\s*(?:'''([\s\S]*?)'''|'([^']*)')\s*;/g;
  return [...src.matchAll(re)].map((m) => (m[2] ?? m[3]).replace(/\s+/g, ' ').trim());
}

function columnsOf(relPath, index) {
  const all = dartConstants(relPath);
  if (!all[index]) throw new Error(`${relPath} has no constant at index ${index}`);
  return all[index];
}

const W = 'worker-app/lib/data/repositories';

const SPECS = [
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
  { app: 'worker-app', name: 'booking_events', table: 'booking_events', select: 'id, event_type, from_status, to_status, note, created_at' },
  {
    app: 'worker-app', name: 'media_assets', table: 'media_assets',
    select:
      'id, purpose, upload_status, mime_type, file_size_bytes, original_file_name, ' +
      'booking_id, worker_id, material_id, captured_at, created_at, width, height, duration_seconds',
  },

  {
    app: 'customer-app', name: 'bookings', table: 'bookings',
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

const out = { 'worker-app': {}, 'customer-app': {} };
let failures = 0;

for (const spec of SPECS) {
  const res = await fetch(
    `${URL_}/rest/v1/${spec.table}?select=${encodeURIComponent(spec.select)}&limit=200`,
    { headers: { apikey: KEY, Authorization: `Bearer ${KEY}` } },
  );
  const body = await res.json();

  if (!res.ok) {
    console.error(`  !! ${spec.app}/${spec.name}: ${res.status} ${JSON.stringify(body)}`);
    failures += 1;
    continue;
  }

  out[spec.app][spec.name] = {
    table: spec.table,
    select: spec.select,
    rowsProfiled: body.length,
    columns: profileRows(body),
  };
  console.log(`  ${spec.app.padEnd(13)} ${spec.name.padEnd(26)} ${String(body.length).padStart(3)} rows profiled`);
}

for (const app of ['worker-app', 'customer-app']) {
  const dir = path.join(REPO, app, 'test', 'fixtures');
  fs.mkdirSync(dir, { recursive: true });
  fs.writeFileSync(
    path.join(dir, 'live_shapes.json'),
    `${JSON.stringify(
      {
        note:
          'Shape of real production data: types, nullability and code-like values only. ' +
          'No names, phone numbers, addresses or free text. Regenerate with ' +
          'web/supabase/scripts/profile-app-data.mjs.',
        capturedAt: new Date().toISOString().slice(0, 10),
        queries: out[app],
      },
      null,
      2,
    )}\n`,
    'utf8',
  );
  console.log(`wrote ${app}/test/fixtures/live_shapes.json`);
}

process.exit(failures > 0 ? 1 : 0);
