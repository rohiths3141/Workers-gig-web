import { describe, expect, it } from 'vitest';

import {
  hasAllPermissions,
  hasAnyPermission,
  hasPermission,
  PERMISSIONS,
  ROLE_PERMISSIONS,
} from '@/lib/permissions/permissions';
import { AdminRole } from '@/types/domain';

import { readMigration, stripSqlComments } from './helpers/sql';

/**
 * The UX permission catalogue must match the database, which is where the real
 * decision is made. If they drift, the UI either hides actions an operator may
 * take or offers actions the server will refuse.
 */

const sql = stripSqlComments(readMigration('0002'));

function sqlPermissionKeys(): string[] {
  const block = sql.slice(sql.indexOf('insert into public.permissions'), sql.indexOf('create table public.role_permissions'));
  return [...block.matchAll(/\(\s*'([a-z_]+\.[a-z_.]+)',/g)].map((m) => m[1]!);
}

function sqlRolePermissions(): Record<string, string[]> {
  const all = sqlPermissionKeys();
  const excluded = [...(/where key not in \(([^)]*)\)/.exec(sql)?.[1] ?? '').matchAll(/'([^']+)'/g)].map((m) => m[1]!);
  const result: Record<string, string[]> = {
    SUPER_ADMIN: all,
    ADMIN: all.filter((key) => !excluded.includes(key)),
  };
  for (const match of sql.matchAll(/\('(VERIFICATION_ADMIN|OPERATIONS_ADMIN|FINANCE_ADMIN|SUPPORT_ADMIN)',\s*'([a-z_.]+)'\)/g)) {
    (result[match[1]!] ??= []).push(match[2]!);
  }
  return result;
}

describe('permission catalogue parity', () => {
  it('declares the same permissions as the database', () => {
    expect([...PERMISSIONS].sort()).toEqual(sqlPermissionKeys().sort());
  });

  const database = sqlRolePermissions();
  for (const role of Object.values(AdminRole)) {
    it(`${role} grants match role_permissions`, () => {
      expect([...ROLE_PERMISSIONS[role]].sort()).toEqual([...(database[role] ?? [])].sort());
    });
  }
});

describe('role separation', () => {
  it('only SUPER_ADMIN can manage administrators', () => {
    for (const role of Object.values(AdminRole)) {
      expect(ROLE_PERMISSIONS[role].includes('admins.manage')).toBe(role === AdminRole.SUPER_ADMIN);
    }
  });

  it('support admins cannot approve claims, payouts or verification', () => {
    const support = ROLE_PERMISSIONS[AdminRole.SUPPORT_ADMIN];
    for (const p of ['claims.approve', 'claims.reject', 'payouts.approve', 'verification.approve', 'wallets.adjust'] as const) {
      expect(support.includes(p)).toBe(false);
    }
  });

  it('verification admins cannot touch money', () => {
    const verification = ROLE_PERMISSIONS[AdminRole.VERIFICATION_ADMIN];
    expect(verification.some((p) => p.startsWith('payouts.') || p.startsWith('payments.') || p.startsWith('wallets.'))).toBe(false);
  });

  it('ADMIN cannot unilaterally move money out', () => {
    expect(ROLE_PERMISSIONS[AdminRole.ADMIN].includes('payouts.approve')).toBe(false);
    expect(ROLE_PERMISSIONS[AdminRole.ADMIN].includes('wallets.adjust')).toBe(false);
  });
});

describe('permission checks', () => {
  it('denies when the permission set is missing', () => {
    expect(hasPermission(undefined, 'workers.read')).toBe(false);
    expect(hasAnyPermission(undefined, ['workers.read'])).toBe(false);
    expect(hasAllPermissions(undefined, ['workers.read'])).toBe(false);
  });

  it('a customer or worker session carries no admin permissions', () => {
    // A non-admin resolves to no admin session, i.e. an empty permission list.
    expect(hasPermission([], 'workers.read')).toBe(false);
  });

  it('requires every permission for hasAllPermissions', () => {
    expect(hasAllPermissions(['claims.read'], ['claims.read', 'claims.approve'])).toBe(false);
    expect(hasAnyPermission(['claims.read'], ['claims.read', 'claims.approve'])).toBe(true);
  });
});
