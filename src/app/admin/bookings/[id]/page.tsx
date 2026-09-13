import type { Metadata } from 'next';
import { notFound } from 'next/navigation';
import Link from 'next/link';

import { ActionButton } from '@/components/admin/action-button';
import { BookingTimeline } from '@/components/admin/booking-timeline';
import { ForbiddenPanel, PageHeader, PermissionGuard } from '@/components/admin/page-parts';
import { StatusBadge } from '@/components/shared/status-badge';
import { Card, CardBody, CardHeader, Field, FieldGrid } from '@/components/ui/card';
import { Alert, EmptyState } from '@/components/ui/feedback';
import { guardPage } from '@/lib/auth/page-guard';
import { adminRoutes, apiRoutes } from '@/lib/config/routes';
import { formatDateTime, formatMoney, humaniseEnum } from '@/lib/utils/format';
import { BookingStatus } from '@/types/domain';
import type { BookingEventRow, BookingRow, BookingTransitionRow, MaterialRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Booking' };
export const dynamic = 'force-dynamic';

type BookingDetail = BookingRow & {
  customers: { id: string; full_name: string; phone: string } | null;
  workers: { id: string; full_name: string; worker_code: string } | null;
  services: { name: string } | null;
};

/**
 * Booking detail.
 *
 * The actions offered are read from public.booking_transitions for the current
 * status, so the UI can only propose moves the state machine permits. The
 * database validates the move again when it arrives.
 */
export default async function BookingDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const { session, allowed } = await guardPage('bookings.read', adminRoutes.booking(id));
  if (!allowed) return <ForbiddenPanel permission="bookings.read" role={session.role} resource="bookings" />;

  const { data: booking } = await session.db
    .from('bookings')
    .select('*, customers(id, full_name, phone), workers(id, full_name, worker_code), services(name)')
    .eq('id', id)
    .maybeSingle()
    .overrideTypes<BookingDetail>();

  if (!booking) notFound();

  const [events, transitions, materials, payments] = await Promise.all([
    session.db.from('booking_events').select('id, event_type, from_status, to_status, actor_type, note, created_at').eq('booking_id', id).order('created_at', { ascending: true }),
    session.db.from('booking_transitions').select('*').eq('from_status', booking.status),
    session.permissions.includes('materials.read')
      ? session.db.from('materials').select('id, name, quantity, unit, estimated_cost_minor, actual_cost_minor, currency, status').eq('booking_id', id).order('created_at')
      : Promise.resolve({ data: null }),
    session.permissions.includes('payments.read')
      ? session.db.from('payments').select('id, payment_code, status, amount_minor, currency, created_at').eq('booking_id', id).order('created_at', { ascending: false })
      : Promise.resolve({ data: null }),
  ]);

  const canUpdate = session.permissions.includes('bookings.update');
  const canCancel = session.permissions.includes('bookings.cancel');
  const available = ((transitions.data ?? []) as BookingTransitionRow[]).filter(
    (t) => (t.to_status === BookingStatus.CANCELLED ? canCancel : canUpdate),
  );

  return (
    <>
      <PageHeader
        title={booking.booking_code}
        description={
          <span className="flex flex-wrap items-center gap-2">
            <StatusBadge kind="booking" status={booking.status} />
            <span className="text-ink-500">{booking.services?.name}</span>
          </span>
        }
      />

      {booking.status === BookingStatus.DISPUTED && booking.dispute_reason && (
        <Alert tone="danger" title="Disputed" className="mb-5">{booking.dispute_reason}</Alert>
      )}
      {booking.status === BookingStatus.CANCELLED && booking.cancellation_reason && (
        <Alert tone="warning" title={`Cancelled by ${humaniseEnum(booking.cancelled_by_type).toLowerCase()}`} className="mb-5">{booking.cancellation_reason}</Alert>
      )}

      <div className="grid gap-5 xl:grid-cols-3">
        <div className="space-y-5 xl:col-span-2">
          <Card>
            <CardHeader title="Job" />
            <CardBody>
              <FieldGrid columns={3}>
                <Field label="Customer" value={booking.customers ? <Link className="text-brand-700 hover:underline" href={adminRoutes.customer(booking.customers.id)}>{booking.customers.full_name}</Link> : '—'} />
                <Field label="Worker" value={booking.workers ? <Link className="text-brand-700 hover:underline" href={adminRoutes.worker(booking.workers.id)}>{booking.workers.full_name}</Link> : 'Unassigned'} />
                <Field label="Scheduled" value={formatDateTime(booking.scheduled_at)} />
                <Field label="Address" value={[booking.address_line, booking.city, booking.pincode].filter(Boolean).join(', ')} className="sm:col-span-2" />
                <Field label="Arrival verified" value={booking.arrival_verified_at ? formatDateTime(booking.arrival_verified_at) : 'Not yet'} />
                <Field label="Created" value={formatDateTime(booking.created_at)} />
              </FieldGrid>
              <div className="mt-5 border-t border-ink-200 pt-4">
                <p className="text-xs font-medium uppercase tracking-wide text-ink-500">Problem description</p>
                <p className="mt-1.5 text-sm leading-relaxed text-ink-700">{booking.problem_description}</p>
              </div>
            </CardBody>
          </Card>

          <Card>
            <CardHeader title="Timeline" description="Events recorded by the server, oldest first" />
            <BookingTimeline events={(events.data ?? []) as Array<Pick<BookingEventRow, 'id' | 'event_type' | 'from_status' | 'to_status' | 'actor_type' | 'note' | 'created_at'>>} />
          </Card>

          <PermissionGuard permissions={session.permissions} required="materials.read">
            <Card>
              <CardHeader title="Materials" />
              {materials.data && materials.data.length > 0 ? (
                <ul className="divide-y divide-ink-100">
                  {(materials.data as Array<Pick<MaterialRow, 'id' | 'name' | 'quantity' | 'unit' | 'estimated_cost_minor' | 'actual_cost_minor' | 'currency' | 'status'>>).map((m) => (
                    <li key={m.id} className="flex flex-wrap items-center gap-3 px-5 py-3">
                      <span className="min-w-0 flex-1">
                        <span className="block text-sm font-medium text-ink-900">{m.name}</span>
                        <span className="block text-xs text-ink-500">{m.quantity} {m.unit} · estimate {formatMoney(m.estimated_cost_minor, m.currency)} · actual {formatMoney(m.actual_cost_minor, m.currency)}</span>
                      </span>
                      <StatusBadge kind="material" status={m.status} />
                    </li>
                  ))}
                </ul>
              ) : (
                <EmptyState title="No materials requested" />
              )}
            </Card>
          </PermissionGuard>
        </div>

        <div className="space-y-5">
          <Card>
            <CardHeader title="Amounts" />
            <CardBody>
              <FieldGrid columns={2}>
                <Field label="Quoted" value={formatMoney(booking.quoted_amount_minor, booking.currency)} />
                <Field label="Labour" value={formatMoney(booking.labour_amount_minor, booking.currency)} />
                <Field label="Materials" value={formatMoney(booking.material_amount_minor, booking.currency)} />
                <Field label="Platform fee" value={formatMoney(booking.platform_fee_minor, booking.currency)} />
                <Field label="Worker amount" value={formatMoney(booking.worker_amount_minor, booking.currency)} />
                <Field label="Final" value={<span className="font-semibold">{formatMoney(booking.final_amount_minor, booking.currency)}</span>} />
              </FieldGrid>
            </CardBody>
          </Card>

          <PermissionGuard permissions={session.permissions} required="payments.read">
            <Card>
              <CardHeader title="Payments" />
              {payments.data && payments.data.length > 0 ? (
                <ul className="divide-y divide-ink-100">
                  {payments.data.map((p) => (
                    <li key={p.id}>
                      <Link href={adminRoutes.payment(p.id)} className="flex items-center gap-3 px-5 py-3 hover:bg-brand-50/40">
                        <span className="min-w-0 flex-1 text-sm">
                          <span className="block font-medium text-ink-900">{formatMoney(p.amount_minor, p.currency)}</span>
                          <span className="block text-xs text-ink-500">{p.payment_code}</span>
                        </span>
                        <StatusBadge kind="payment" status={p.status} />
                      </Link>
                    </li>
                  ))}
                </ul>
              ) : (
                <EmptyState title="No payments yet" />
              )}
            </Card>
          </PermissionGuard>

          {(canUpdate || canCancel) && (
            <Card>
              <CardHeader title="Change status" description="Allowed moves from the current status" />
              <CardBody className="space-y-2">
                {available.length === 0 ? (
                  <p className="text-sm text-ink-500">No further transitions are possible from {humaniseEnum(booking.status).toLowerCase()}.</p>
                ) : (
                  available.map((t) => (
                    <ActionButton
                      key={t.to_status}
                      endpoint={apiRoutes.adminBookingTransition(booking.id)}
                      payload={{ status: t.to_status }}
                      label={`Move to ${humaniseEnum(t.to_status).toLowerCase()}`}
                      variant={t.to_status === BookingStatus.CANCELLED ? 'danger' : 'outline'}
                      tone={t.to_status === BookingStatus.CANCELLED ? 'danger' : 'primary'}
                      fullWidth
                      confirmTitle={`Move ${booking.booking_code} to ${humaniseEnum(t.to_status).toLowerCase()}?`}
                      confirmDescription={
                        t.allowed_actors.includes('ADMIN')
                          ? t.description
                          : `${t.description}. This move is normally made by ${t.allowed_actors.map((a) => humaniseEnum(a).toLowerCase()).join(' or ')}, so it will be recorded as an administrative override.`
                      }
                      requireReason
                      reasonLabel="Reason for this change"
                      successMessage={`Booking moved to ${humaniseEnum(t.to_status).toLowerCase()}`}
                    />
                  ))
                )}
              </CardBody>
            </Card>
          )}
        </div>
      </div>
    </>
  );
}
