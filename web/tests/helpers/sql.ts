import { readFileSync, readdirSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

/** Helpers for asserting the TypeScript layer against the SQL migrations. */

const here = dirname(fileURLToPath(import.meta.url));
export const WEB_ROOT = join(here, '..', '..');
export const MIGRATIONS_DIR = join(WEB_ROOT, 'supabase', 'migrations');

export function readMigration(prefix: string): string {
  const file = readdirSync(MIGRATIONS_DIR).find((f) => f.startsWith(prefix));
  if (!file) throw new Error(`Migration ${prefix} not found`);
  return readFileSync(join(MIGRATIONS_DIR, file), 'utf8');
}

export function allMigrations(): string {
  return readdirSync(MIGRATIONS_DIR)
    .filter((f) => f.endsWith('.sql'))
    .sort()
    .map((f) => readFileSync(join(MIGRATIONS_DIR, f), 'utf8'))
    .join('\n');
}

/** Remove `--` line comments so assertions only see executable SQL. */
export function stripSqlComments(sql: string): string {
  return sql
    .split('\n')
    .map((line) => {
      const index = line.indexOf('--');
      return index === -1 ? line : line.slice(0, index);
    })
    .join('\n');
}

/** Body of `create or replace function public.<name>(...) ... $$;`. */
export function functionBody(sql: string, name: string): string {
  const start = sql.indexOf(`create or replace function public.${name}(`);
  if (start === -1) throw new Error(`Function ${name} not found`);
  const open = sql.indexOf('$$', start);
  const close = sql.indexOf('$$', open + 2);
  return sql.slice(open + 2, close);
}

export function sourceFiles(dir = join(WEB_ROOT, 'src')): Array<{ path: string; content: string }> {
  const out: Array<{ path: string; content: string }> = [];
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const path = join(dir, entry.name);
    if (entry.isDirectory()) out.push(...sourceFiles(path));
    else if (/\.(ts|tsx)$/.test(entry.name)) out.push({ path, content: readFileSync(path, 'utf8') });
  }
  return out;
}
