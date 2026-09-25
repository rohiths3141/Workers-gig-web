import type { Metadata } from 'next';
import { Check } from 'lucide-react';

import { ForbiddenPanel, PageHeader, PermissionGuard } from '@/components/admin/page-parts';
import { Badge } from '@/components/ui/badge';
import { Card, CardBody, CardHeader, Field, FieldGrid } from '@/components/ui/card';
import { Alert, EmptyState } from '@/components/ui/feedback';
import { guardPage } from '@/lib/auth/page-guard';
import { adminRoutes } from '@/lib/config/routes';
import { PERMISSIONS, ROLE_DESCRIPTIONS, ROLE_LABELS } from '@/lib/permissions/permissions';
import { formatDateTime } from '@/lib/utils/format';
import { AdminRole } from '@/types/domain';

export const metadata: Metadata = { title: 'Settings' };
export const dynamic = 'force-dynamic';

const SIGN_IN_PROVIDER_LABELS: Record<string, string> = {
  password: 'Email and password',
  'google.com': 'Google',
  phone: 'Phone OTP',
};

/**
 * Settings.
 *
 * Read views of the operator's own account, administrator accounts, the role
 * matrix as stored in the database, and operational settings. Write paths for
 * administrator management and settings changes are pending backend contracts
 * and are labelled as such rather than offered as buttons that do nothing.
 *
 * No secret is displayed: keys and credentials live only in the deployment
 * environment, never in platform_settings.
 */
export default async function SettingsPage() {
  const { session, allowed } = await guardPage('settings.read', adminRoutes.settings());
  if (!allowed) return <ForbiddenPanel permission="settings.read" role={session.role} resource="settings" />;

  const can = (p: string) => session.permissions.includes(p);

  const [settings, admins, rolePermissions] = await Promise.all([
    session.db.from('platform_settings').select('key, value, description, is_public, updated_at').order('key'),
    can('admins.read') ? session.db.from('admin_users').select('id, full_name, email, role, is_active, last_login_at').order('created_at') : Promise.resolve({ data: null }),
    session.db.from('role_permissions').select('role, permission'),
  ]);

  const matrix = new Map<string, Set<string>>();
  for (const row of rolePermissions.data ?? []) {
    if (!matrix.has(row.role)) matrix.set(row.role, new Set());
    matrix.get(row.role)!.add(row.permission);
  }
  const roles = Object.values(AdminRole);

  return (
    <>
      <PageHeader title="Settings" description="Your account, administrators, roles and platform configuration." />

      <div className="space-y-5">
        <div className="grid gap-5 lg:grid-cols-2">
          <Card>
            <CardHeader title="Profile" />
            <CardBody>
              <FieldGrid columns={2}>
                <Field label="Name" value={session.fullName} />
                <Field label="Email" value={session.email} />
                <Field label="Role" value={ROLE_LABELS[session.role]} />
                <Field label="Permissions" value={`${session.permissions.length} of ${PERMISSIONS.length}`} />
              </FieldGrid>
            </CardBody>
          </Card>

          <Card>
            <CardHeader title="Security" />
            <CardBody className="space-y-3 text-sm text-ink-700">
              <FieldGrid columns={2}>
                <Field label="Sign-in provider" value={session.user.signInProvider ? (SIGN_IN_PROVIDER_LABELS[session.user.signInProvider] ?? session.user.signInProvider) : '—'} />
                <Field label="Session started" value={formatDateTime(new Date(session.user.authTime * 1000))} />
              </FieldGrid>
              <p className="text-xs text-ink-500">Sessions are httpOnly cookies verified on every request. Signing out revokes your sessions on all devices. Passwords are held by Firebase and never reach this server.</p>
            </CardBody>
          </Card>
        </div>

        <PermissionGuard permissions={session.permissions} required="admins.read">
          <Card>
            <CardHeader title="Admin users" description={can('admins.manage') ? 'Creating and re-roling administrators is a pending backend contract; use the bootstrap script meanwhile.' : undefined} />
            {admins.data && admins.data.length > 0 ? (
              <ul className="divide-y divide-ink-100">
                {admins.data.map((admin) => (
                  <li key={admin.id} className="flex flex-wrap items-center gap-3 px-5 py-3">
                    <span className="min-w-0 flex-1">
                      <span className="block text-sm font-medium text-ink-900">{admin.full_name}{admin.id === session.adminId && <span className="ml-2 text-xs text-ink-500">(you)</span>}</span>
                      <span className="block text-xs text-ink-500">{admin.email} · last sign-in {formatDateTime(admin.last_login_at)}</span>
                    </span>
                    <Badge tone="brand">{ROLE_LABELS[admin.role]}</Badge>
                    {!admin.is_active && <Badge tone="danger">Disabled</Badge>}
                  </li>
                ))}
              </ul>
            ) : (
              <EmptyState title="No administrators visible" />
            )}
          </Card>
        </PermissionGuard>

        <Card>
          <CardHeader title="Roles & permissions" description="Read from the database. Per-user grants and revocations adjust these defaults." />
          <div className="scroll-x">
            <table className="w-full min-w-max text-sm">
              <caption className="sr-only">Permissions granted to each role</caption>
              <thead>
                <tr className="border-b border-ink-200 bg-ink-50/60">
                  <th scope="col" className="px-4 py-2.5 text-left text-xs font-semibold uppercase tracking-wide text-ink-600">Permission</th>
                  {roles.map((role) => (
                    <th key={role} scope="col" className="px-3 py-2.5 text-center text-xs font-semibold text-ink-600" title={ROLE_DESCRIPTIONS[role]}>{ROLE_LABELS[role]}</th>
                  ))}
                </tr>
              </thead>
              <tbody className="divide-y divide-ink-100">
                {PERMISSIONS.map((permission) => (
                  <tr key={permission}>
                    <th scope="row" className="px-4 py-2 text-left font-mono text-xs font-normal text-ink-700">{permission}</th>
                    {roles.map((role) => (
                      <td key={role} className="px-3 py-2 text-center">
                        {matrix.get(role)?.has(permission) ? <Check aria-label="Granted" className="mx-auto size-4 text-success-600" /> : <span className="sr-only">Not granted</span>}
                      </td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </Card>

        <Card>
          <CardHeader title="Platform configuration" description={can('settings.update') ? 'Editing is a pending backend contract. Values are changed by migration until then.' : 'Operational thresholds. No secrets are stored here.'} />
          {settings.error ? (
            <Alert tone="danger" className="m-4">Settings could not be loaded.</Alert>
          ) : (
            <dl className="divide-y divide-ink-100">
              {(settings.data ?? []).map((setting) => (
                <div key={setting.key} className="grid gap-1 px-5 py-3 sm:grid-cols-3 sm:gap-4">
                  <dt className="font-mono text-xs text-ink-800">{setting.key}{setting.is_public && <Badge className="ml-2">Public</Badge>}</dt>
                  <dd className="text-sm text-ink-600 sm:col-span-1">{setting.description}</dd>
                  <dd className="font-mono text-sm text-ink-900 sm:text-right">{JSON.stringify(setting.value)}</dd>
                </div>
              ))}
            </dl>
          )}
        </Card>

        <Card>
          <CardHeader title="Notification configuration" />
          <CardBody>
            <p className="text-sm text-ink-600">Push, SMS and email providers are configured in the notification delivery service, not in this panel. Provider credentials are never stored in the database. The delivery log is under Notifications.</p>
          </CardBody>
        </Card>
      </div>
    </>
  );
}
