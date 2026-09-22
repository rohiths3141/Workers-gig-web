import { AdminRole } from '@/types/domain';

/**
 * The permission catalogue.
 *
 * IMPORTANT — what this file is and is not.
 *
 * This is the **UX** copy of the permission model. It decides which navigation
 * items render, which buttons appear, and which pages show a friendly "you do
 * not have access" panel instead of an empty table.
 *
 * It is NOT the authorization decision. The real decision is made twice, on the
 * server, against the database:
 *
 *   1. The route handler calls requireAdmin(permission), which reads the
 *      caller's effective permissions from Supabase.
 *   2. The SECURITY DEFINER function it calls runs require_permission() again
 *      inside the transaction.
 *
 * A user who edits this file in their browser, or calls the API directly, gains
 * nothing. tests/permissions-parity.test.ts asserts that this catalogue matches
 * the one in supabase/migrations/0002 so the UX never offers an action the
 * server will refuse.
 */

export const PERMISSIONS = [
  'workers.read',
  'workers.update',
  'workers.verify',
  'workers.restrict',
  'workers.documents.read',

  'customers.read',
  'customers.update',
  'customers.restrict',

  'bookings.read',
  'bookings.update',
  'bookings.cancel',
  'bookings.reassign',

  'matching.read',
  'matching.rerun',

  'materials.read',
  'materials.update',

  'payments.read',
  'payments.refund',

  'wallets.read',
  'wallets.adjust',

  'payouts.read',
  'payouts.approve',
  'payouts.reject',

  'claims.read',
  'claims.review',
  'claims.approve',
  'claims.reject',

  'insurance.read',
  'insurance.update',

  'verification.read',
  'verification.review',
  'verification.approve',
  'verification.reject',

  'support.read',
  'support.respond',
  'support.assign',

  'notifications.read',
  'notifications.send',

  'media.read',
  'media.read_sensitive',

  'services.read',
  'services.update',

  'audit_logs.read',

  'settings.read',
  'settings.update',

  'admins.read',
  'admins.manage',
] as const;

export type Permission = (typeof PERMISSIONS)[number];

/**
 * Actions that move money, change a verification outcome, or restrict an
 * account. The UI demands a typed reason for these and the server records
 * heightened audit detail.
 */
export const SENSITIVE_PERMISSIONS: readonly Permission[] = [
  'workers.verify',
  'workers.restrict',
  'workers.documents.read',
  'customers.restrict',
  'bookings.update',
  'bookings.cancel',
  'bookings.reassign',
  'materials.update',
  'payments.refund',
  'wallets.adjust',
  'payouts.approve',
  'payouts.reject',
  'claims.approve',
  'claims.reject',
  'insurance.update',
  'verification.approve',
  'verification.reject',
  'notifications.send',
  'media.read_sensitive',
  'settings.update',
  'admins.manage',
];

export function isSensitivePermission(permission: Permission): boolean {
  return SENSITIVE_PERMISSIONS.includes(permission);
}

/**
 * Role to permission mapping. Mirrors public.role_permissions.
 */
export const ROLE_PERMISSIONS: Record<AdminRole, readonly Permission[]> = {
  [AdminRole.SUPER_ADMIN]: PERMISSIONS,

  [AdminRole.ADMIN]: PERMISSIONS.filter(
    (p) => !['admins.manage', 'payouts.approve', 'wallets.adjust', 'settings.update'].includes(p),
  ),

  [AdminRole.VERIFICATION_ADMIN]: [
    'workers.read',
    'workers.verify',
    'workers.documents.read',
    'verification.read',
    'verification.review',
    'verification.approve',
    'verification.reject',
    'insurance.read',
    'insurance.update',
    'media.read',
    'media.read_sensitive',
    'services.read',
    'audit_logs.read',
  ],

  [AdminRole.OPERATIONS_ADMIN]: [
    'workers.read',
    'workers.update',
    'customers.read',
    'bookings.read',
    'bookings.update',
    'bookings.cancel',
    'bookings.reassign',
    'matching.read',
    'matching.rerun',
    'materials.read',
    'materials.update',
    'media.read',
    'services.read',
    'notifications.read',
    'audit_logs.read',
  ],

  [AdminRole.FINANCE_ADMIN]: [
    'workers.read',
    'customers.read',
    'bookings.read',
    'materials.read',
    'media.read',
    'payments.read',
    'payments.refund',
    'wallets.read',
    'wallets.adjust',
    'payouts.read',
    'payouts.approve',
    'payouts.reject',
    'audit_logs.read',
  ],

  [AdminRole.SUPPORT_ADMIN]: [
    'workers.read',
    'customers.read',
    'bookings.read',
    'materials.read',
    'media.read',
    'payments.read',
    'claims.read',
    'claims.review',
    'support.read',
    'support.respond',
    'support.assign',
    'notifications.read',
    'services.read',
  ],
};

/** Human-readable role names for the admin UI. */
export const ROLE_LABELS: Record<AdminRole, string> = {
  [AdminRole.SUPER_ADMIN]: 'Super Admin',
  [AdminRole.ADMIN]: 'Admin',
  [AdminRole.VERIFICATION_ADMIN]: 'Verification Admin',
  [AdminRole.OPERATIONS_ADMIN]: 'Operations Admin',
  [AdminRole.FINANCE_ADMIN]: 'Finance Admin',
  [AdminRole.SUPPORT_ADMIN]: 'Support Admin',
};

export const ROLE_DESCRIPTIONS: Record<AdminRole, string> = {
  [AdminRole.SUPER_ADMIN]: 'Full access, including administrator management and platform settings.',
  [AdminRole.ADMIN]: 'Broad operational access. Cannot manage administrators or approve payouts.',
  [AdminRole.VERIFICATION_ADMIN]: 'Reviews worker identity, qualification and background evidence.',
  [AdminRole.OPERATIONS_ADMIN]: 'Runs day-to-day bookings, matching and material workflows.',
  [AdminRole.FINANCE_ADMIN]: 'Handles payments, refunds, wallets and payouts.',
  [AdminRole.SUPPORT_ADMIN]: 'Answers support tickets and triages damage claims.',
};

/**
 * Does this permission set include the required permission?
 *
 * `permissions` must come from the server-resolved session, never from a value
 * the browser can set.
 */
export function hasPermission(
  permissions: readonly string[] | undefined,
  required: Permission,
): boolean {
  return permissions?.includes(required) ?? false;
}

/** True when the set includes at least one of the required permissions. */
export function hasAnyPermission(
  permissions: readonly string[] | undefined,
  required: readonly Permission[],
): boolean {
  if (!permissions) return false;
  return required.some((p) => permissions.includes(p));
}

/** True when the set includes every one of the required permissions. */
export function hasAllPermissions(
  permissions: readonly string[] | undefined,
  required: readonly Permission[],
): boolean {
  if (!permissions) return false;
  return required.every((p) => permissions.includes(p));
}

/** The permissions a role grants, before per-user grants and revocations. */
export function permissionsForRole(role: AdminRole): readonly Permission[] {
  return ROLE_PERMISSIONS[role] ?? [];
}
