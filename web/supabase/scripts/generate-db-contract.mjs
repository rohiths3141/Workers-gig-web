/**
 * Extract the database's enum contract from the migrations and write it into
 * both Flutter apps as a test fixture.
 *
 *   node web/supabase/scripts/generate-db-contract.mjs
 *
 * Every Dart enum in the two apps mirrors a Postgres enum, and `_parse` throws
 * on a value it does not recognise. So a value added in SQL and not added in
 * Dart is not a cosmetic drift — it is a crash the first time a row carrying it
 * reaches the app, and nothing in the build catches it.
 *
 * The migrations are the source of truth (they are what `supabase db push`
 * applies), so this reads them rather than the live database: the check then
 * works offline, in CI, and against a migration that has not shipped yet.
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const HERE = path.dirname(fileURLToPath(import.meta.url));
const MIGRATIONS = path.resolve(HERE, '..', 'migrations');
const REPO = path.resolve(HERE, '..', '..', '..');

const files = fs.readdirSync(MIGRATIONS).filter((f) => f.endsWith('.sql')).sort();

/**
 * SQL with comments removed.
 *
 * Needed because these migrations are heavily commented and a comment may
 * contain an apostrophe — `-- customer books a worker's gig` sits inside the
 * booking_source enum — which otherwise swallows the following quoted value and
 * invents a member that does not exist.
 */
const strip = (sql) =>
  sql.replace(/\/\*[\s\S]*?\*\//g, ' ').replace(/--[^\n]*/g, '');

/** enum name -> ordered list of values */
const enums = {};

for (const file of files) {
  const sql = strip(fs.readFileSync(path.join(MIGRATIONS, file), 'utf8'));

  // create type public.<name> as enum ( 'A', 'B', ... );
  const createRe = /create\s+type\s+public\.(\w+)\s+as\s+enum\s*\(([\s\S]*?)\)\s*;/gi;
  for (const m of sql.matchAll(createRe)) {
    const name = m[1];
    const values = [...m[2].matchAll(/'([^']+)'/g)].map((v) => v[1]);
    enums[name] = values;
  }

  // alter type public.<name> add value [if not exists] '<value>';
  const alterRe = /alter\s+type\s+public\.(\w+)\s+add\s+value\s+(?:if\s+not\s+exists\s+)?'([^']+)'/gi;
  for (const m of sql.matchAll(alterRe)) {
    const [, name, value] = m;
    if (!enums[name]) enums[name] = [];
    if (!enums[name].includes(value)) enums[name].push(value);
  }
}

// Some columns are a text column plus a CHECK, not a Postgres enum —
// worker_gigs.pricing_unit is one, and the Dart side models it with the same
// throwing parse, so it needs the same protection.
//
//   constraint worker_gigs_pricing_unit_valid check (
//     pricing_unit in ('PER_JOB', 'PER_HOUR', ...)
//   )
const checks = {};
for (const file of files) {
  const sql = strip(fs.readFileSync(path.join(MIGRATIONS, file), 'utf8'));
  const re = /constraint\s+\w+\s+check\s*\(\s*(\w+)\s+in\s*\(([^)]*)\)/gi;
  for (const m of sql.matchAll(re)) {
    const column = m[1];
    const values = [...m[2].matchAll(/'([^']+)'/g)].map((v) => v[1]);
    if (values.length === 0) continue;
    // Last definition wins, matching the order the migrations apply in.
    checks[column] = values;
  }
}

const names = Object.keys(enums).sort();
const fixture = {
  generatedFrom: 'web/supabase/migrations',
  generatedBy: 'web/supabase/scripts/generate-db-contract.mjs',
  note: 'Regenerate after any migration that adds or changes an enum.',
  enums: Object.fromEntries(names.map((n) => [n, enums[n]])),
  checkConstraints: Object.fromEntries(Object.keys(checks).sort().map((n) => [n, checks[n]])),
};

const json = `${JSON.stringify(fixture, null, 2)}\n`;
for (const app of ['worker-app', 'customer-app']) {
  const dir = path.join(REPO, app, 'test', 'fixtures');
  fs.mkdirSync(dir, { recursive: true });
  fs.writeFileSync(path.join(dir, 'db_enums.json'), json, 'utf8');
  console.log(`wrote ${app}/test/fixtures/db_enums.json`);
}

console.log(`\n${names.length} enum types:`);
for (const n of names) console.log(`  ${n.padEnd(28)} ${enums[n].length} values`);

// ---------------------------------------------------------------------------
// RPC payload keys
// ---------------------------------------------------------------------------
// Several RPCs answer with `jsonb_build_object(...)` rather than a table, so
// what the app receives is a hand-written key list in SQL and a hand-written
// key list in Dart, with nothing checking that they agree. A key the mapper
// reads and the function never sends is a field that is silently always null.
//
// Later migrations replace earlier definitions, so the last one wins.

/** The arguments of each jsonb_build_object(...) call, paren-balanced. */
function buildObjectArgs(body) {
  const calls = [];
  const needle = 'jsonb_build_object';
  let from = 0;
  for (;;) {
    const at = body.indexOf(needle, from);
    if (at === -1) break;
    let i = body.indexOf('(', at);
    if (i === -1) break;
    let depth = 0;
    let inString = false;
    const start = i + 1;
    for (; i < body.length; i += 1) {
      const ch = body[i];
      if (ch === "'") inString = !inString;
      else if (!inString && ch === '(') depth += 1;
      else if (!inString && ch === ')') {
        depth -= 1;
        if (depth === 0) break;
      }
    }
    calls.push(body.slice(start, i));
    from = i + 1;
  }
  return calls;
}

/** Split on commas that are not inside parentheses or a quoted string. */
function topLevelParts(args) {
  const parts = [];
  let depth = 0;
  let inString = false;
  let current = '';
  for (const ch of args) {
    if (ch === "'") inString = !inString;
    if (!inString && ch === '(') depth += 1;
    if (!inString && ch === ')') depth -= 1;
    if (ch === ',' && depth === 0 && !inString) {
      parts.push(current);
      current = '';
      continue;
    }
    current += ch;
  }
  if (current.trim()) parts.push(current);
  return parts;
}

const rpcs = {};
for (const file of files) {
  const sql = strip(fs.readFileSync(path.join(MIGRATIONS, file), 'utf8'));
  const fnRe = /create\s+or\s+replace\s+function\s+public\.(\w+)\s*\(([\s\S]*?)\$\$\s*;/gi;
  for (const m of sql.matchAll(fnRe)) {
    const [, name, body] = m;
    const keys = [];
    for (const args of buildObjectArgs(body)) {
      // jsonb_build_object takes key, value, key, value — only the even
      // positions are keys, which is why a naive scan collected 'INR'.
      topLevelParts(args).forEach((part, index) => {
        if (index % 2 !== 0) return;
        const literal = /^\s*'([a-z0-9_]+)'\s*$/i.exec(part);
        if (literal) keys.push(literal[1]);
      });
    }
    if (keys.length) rpcs[name] = [...new Set(keys)].sort();
  }
}

fixture.rpcPayloadKeys = rpcs;
const jsonWithRpcs = `${JSON.stringify(fixture, null, 2)}\n`;
for (const app of ['worker-app', 'customer-app']) {
  fs.writeFileSync(path.join(REPO, app, 'test', 'fixtures', 'db_enums.json'), jsonWithRpcs, 'utf8');
}
console.log(`\n${Object.keys(rpcs).length} RPCs with a jsonb payload`);
