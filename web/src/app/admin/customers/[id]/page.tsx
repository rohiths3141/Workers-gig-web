import type { Metadata } from 'next';
import { notFound } from 'next/navigation';
import Link from 'next/link';

import { ActionButton } from '@/components/admin/action-button';
import { ForbiddenPanel, PageHeader, PermissionGuard, StatCard } from '@/components/admin/page-parts';
import { StatusBadge } from '@/components/shared/status-badge';
import { Card, CardBody, CardHeader, Field, FieldGrid } from '@/components/ui/card';
import { Alert, EmptyState } from '@/components/ui/feedback';
import { guardPage } from '@/lib/auth/page-guard';
import { adminRoutes, apiRoutes } from '@/lib/config/routes';
import { formatDate, formatDateTime, formatMoney, formatNumber, humaniseEnum } from '@/lib/utils/format';
import { CustomerStatus } from '@/types/domain';

export const metadata: Metadata = { title: 'Customer' };
export const dynamic = 'force-dynamic';

/**
 * Customer detail.
 *
 * Each related section is fetched only when the operator holds the permission
 * for it; a Support admin sees tickets and bookings but not payment history.
 */
export default async function CustomerDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const { session, allowed } = await guardPage('customers.read', adminRoutes.customer(id));
  if (!allowed) return <ForbiddenPanel permission="customers.read" role={session.role} resource="customers" />;

  const can = (permission: string) => session.permissions.includes(permission);

  const { data: customer } = await session.db
    .from('customers')
    .select('id, full_name, phone, email, status, city, state, pincode, rating_avg, rating_count, restriction_reason, restricted_at, created_at')
    .eq('id', id)
    .maybeSingle();

  if (!customer) notFound();

  const empty = Promise.resolve({ data: null, count: null });

  const [bookings, payments, claims, tickets] = await Promise.all([
    can('bookings.read')
      ? session.db.from('bookings').select('id, booking_code, status, created_at, final_amount_minor, currency', { count: 'exact' }).eq('customer_id', id).order('created_at', { ascending: false }).limit(8)
      : empty,
    can('payments.read')
      ? session.db.from('payments').select('id, payment_code, status, amount_minor, currency, created_at', { count: 'exact' }).eq('customer_id', id).order('created_at', { ascending: false }).limit(8)
      : empty,
    can('claims.read')
      ? session.db.from('claims').select('id, claim_code, status, type, amount_claimed_minor, currency, created_at', { count: 'exact' }).eq('customer_id', id).order('created_at', { ascending: false }).limit(5)
      : empty,
    can('support.read')
      ? session.db.from('support_tickets').select('id, ticket_code, subject, status, created_at', { count: 'exact' }).eq('customer_id', id).order('created_at', { ascending: false }).limit(5)
      : empty,
  ]);

  const restricted = customer.status !== CustomerStatus.ACTIVE;

  return (
    <>
      <PageHeader
        title={customer.full_name}
        description={<StatusBadge kind="customer" status={customer.status} />}
        actions={
          <PermissionGuard permissions={session.permissions} required="customers.restrict">
            {restricted ? (
              <ActionButton
                endpoint={apiRoutes.adminCustomerStatus(customer.id)}
                payload={{ status: CustomerStatus.ACTIVE }}
                label="Reinstate customer"
                variant="success"
                tone="success"
                confirmTitle="Reinstate this customer?"
                confirmDescription="They can book services again immediately."
                confirmLabel="Reinstate"
                requireReason
                successMessage="Customer reinstated"
              />
            ) : (
              <>
                <ActionButton
                  endpoint={apiRoutes.adminCustomerStatus(customer.id)}
                  payload={{ status: CustomerStatus.RESTRICTED }}
                  label="Restrict"
                  variant="outline"
                  tone="danger"
                  confirmTitle="Restrict this customer?"
                  confirmDescription="They will not be able to create new bookings. Existing bookings continue."
                  confirmLabel="Restrict"
                  requireReason
                  successMessage="Customer restricted"
                />
                <ActionButton
                  endpoint={apiRoutes.adminCustomerStatus(customer.id)}
                  payload={{ status: CustomerStatus.SUSPENDED }}
                  label="Suspend"
                  variant="danger"
                  tone="danger"
                  confirmTitle="Suspend this customer?"
                  confirmDescription="Suspension blocks the account from booking and from using the app."
                  confirmLabel="Suspend"
                  requireReason
                  successMessage="Customer suspended"
                />
              </>
            )}
          </PermissionGuard>
        }
      />

      {restricted && customer.restriction_reason && (
        <Alert tone="danger" title={`Account ${humaniseEnum(customer.status).toLowerCase()}`} className="mb-5">
          {customer.restriction_reason}
          {customer.restricted_at && <span className="mt-1 block text-xs opacity-80">Applied {formatDateTime(customer.restricted_at)}</span>}
        </Alert>
      )}

      <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
        <StatCard label="Bookings" value={bookings.count === null ? '—' : formatNumber(bookings.count)} hint={can('bookings.read') ? undefined : 'Requires bookings.read'} />
        <StatCard label="Payments" value={payments.count === null ? '—' : formatNumber(payments.count)} hint={can('payments.read') ? undefined : 'Requires payments.read'} />
        <StatCard label="Claims" value={claims.count === null ? '—' : formatNumber(claims.count)} tone={(claims.count ?? 0) > 0 ? 'warning' : 'neutral'} />
        <StatCard
          label="Reliability rating"
          value={customer.rating_avg === null ? 'Not rated' : customer.rating_avg.toFixed(1)}
          hint={customer.rating_count > 0 ? `From ${customer.rating_count} worker rating${customer.rating_count === 1 ? '' : 's'}` : 'Rated by workers after jobs'}
        />
      </div>

      <div className="mt-5 grid gap-5 xl:grid-cols-2">
        <Card>
          <CardHeader title="Profile" />
          <CardBody>
            <FieldGrid columns={2}>
              <Field label="Phone" value={<span className="tabular">{customer.phone}</span>} />
              <Field label="Email" value={customer.email ?? '—'} />
              <Field label="Location" value={[customer.city, customer.state, customer.pincode].filter(Boolean).join(', ') || '—'} />
              <Field label="Joined" value={formatDate(customer.created_at)} />
            </FieldGrid>
          </CardBody>
        </Card>

        <RelatedList
          title="Recent bookings"
          permission="bookings.read"
          allowed={can('bookings.read')}
          rows={(bookings.data ?? []).map((b) => ({
            id: b.id,
            href: adminRoutes.booking(b.id),
            primary: b.booking_code,
            secondary: formatDate(b.created_at),
            trailing: <StatusBadge kind="booking" status={b.status} />,
          }))}
          emptyText="No bookings yet."
        />

        <RelatedList
          title="Recent payments"
          permission="payments.read"
          allowed={can('payments.read')}
          rows={(payments.data ?? []).map((p) => ({
            id: p.id,
            href: adminRoutes.payment(p.id),
            primary: `${p.payment_code} · ${formatMoney(p.amount_minor, p.currency)}`,
            secondary: formatDate(p.created_at),
            trailing: <StatusBadge kind="payment" status={p.status} />,
          }))}
          emptyText="No payments yet."
        />

        <RelatedList
          title="Claims"
          permission="claims.read"
          allowed={can('claims.read')}
          rows={(claims.data ?? []).map((c) => ({
            id: c.id,
            href: adminRoutes.claim(c.id),
            primary: `${c.claim_code} · ${humaniseEnum(c.type)}`,
            secondary: formatMoney(c.amount_claimed_minor, c.currency),
            trailing: <StatusBadge kind="claim" status={c.status} />,
          }))}
          emptyText="No claims filed."
        />

        <RelatedList
          title="Support tickets"
          permission="support.read"
          allowed={can('support.read')}
          rows={(tickets.data ?? []).map((t) => ({
            id: t.id,
            href: adminRoutes.supportTicket(t.id),
            primary: t.subject,
            secondary: `${t.ticket_code} · ${formatDate(t.created_at)}`,
            trailing: <StatusBadge kind="support" status={t.status} />,
          }))}
          emptyText="No support tickets."
        />
      </div>
    </>
  );
}

function RelatedList({
  title,
  permission,
  allowed,
  rows,
  emptyText,
}: {
  title: string;
  permission: string;
  allowed: boolean;
  rows: Array<{ id: string; href: string; primary: string; secondary: string; trailing: React.ReactNode }>;
  emptyText: string;
}) {
  return (
    <Card>
      <CardHeader title={title} />
      {!allowed ? (
        <CardBody>
          <p className="text-sm text-ink-500">
            Requires the <code className="rounded bg-ink-100 px-1 py-0.5 font-mono text-xs">{permission}</code> permission.
          </p>
        </CardBody>
      ) : rows.length === 0 ? (
        <EmptyState title={emptyText} />
      ) : (
        <ul className="divide-y divide-ink-100">
          {rows.map((row) => (
            <li key={row.id}>
              <Link href={row.href} className="flex items-center gap-3 px-5 py-3 hover:bg-brand-50/40">
                <span className="min-w-0 flex-1">
                  <span className="block truncate text-sm font-medium text-ink-900">{row.primary}</span>
                  <span className="block truncate text-xs text-ink-500">{row.secondary}</span>
                </span>
                {row.trailing}
              </Link>
            </li>
          ))}
        </ul>
      )}
    </Card>
  );
}
