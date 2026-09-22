import type { Metadata } from 'next';
import { notFound } from 'next/navigation';
import Link from 'next/link';
import { ShieldCheck, ShieldX } from 'lucide-react';

import { ForbiddenPanel, PageHeader } from '@/components/admin/page-parts';
import { StatusBadge } from '@/components/shared/status-badge';
import { Card, CardBody, CardHeader, Field, FieldGrid } from '@/components/ui/card';
import { Alert, EmptyState } from '@/components/ui/feedback';
import { guardPage } from '@/lib/auth/page-guard';
import { adminRoutes } from '@/lib/config/routes';
import { formatDateTime, formatMoney } from '@/lib/utils/format';
import type { PaymentRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Payment' };
export const dynamic = 'force-dynamic';

type PaymentDetail = PaymentRow & {
  bookings: { id: string; booking_code: string } | null;
  customers: { id: string; full_name: string } | null;
};

/**
 * Payment detail.
 *
 * Shows whether the gateway signature was verified and when. The raw gateway
 * payload is deliberately not rendered: it can carry payer details that the
 * operator does not need to see.
 */
export default async function PaymentDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const { session, allowed } = await guardPage('payments.read', adminRoutes.payment(id));
  if (!allowed) return <ForbiddenPanel permission="payments.read" role={session.role} resource="payments" />;

  const [{ data: payment }, { data: refunds }] = await Promise.all([
    session.db
      .from('payments')
      .select('id, payment_code, booking_id, customer_id, amount_minor, platform_fee_minor, worker_amount_minor, material_amount_minor, currency, status, method, gateway, gateway_order_id, gateway_payment_id, gateway_signature_verified, gateway_verified_at, failure_code, failure_reason, refunded_amount_minor, initiated_at, captured_at, failed_at, created_at, updated_at, idempotency_key, gateway_payload, bookings(id, booking_code), customers(id, full_name)')
      .eq('id', id)
      .maybeSingle()
      .overrideTypes<PaymentDetail>(),
    session.db.from('refunds').select('id, amount_minor, currency, reason, status, created_at, completed_at, failure_reason').eq('payment_id', id).order('created_at', { ascending: false }),
  ]);

  if (!payment) notFound();

  return (
    <>
      <PageHeader title={payment.payment_code} description={<StatusBadge kind="payment" status={payment.status} />} />

      {payment.status === 'FAILED' && (
        <Alert tone="danger" title="Payment failed" className="mb-5">
          {payment.failure_reason}
          {payment.failure_code && <span className="ml-1 font-mono text-xs">({payment.failure_code})</span>}
        </Alert>
      )}

      <div className="grid gap-5 xl:grid-cols-3">
        <div className="space-y-5 xl:col-span-2">
          <Card>
            <CardHeader title="Amounts" />
            <CardBody>
              <FieldGrid columns={3}>
                <Field label="Total" value={<span className="text-base font-semibold tabular">{formatMoney(payment.amount_minor, payment.currency)}</span>} />
                <Field label="Platform fee" value={formatMoney(payment.platform_fee_minor, payment.currency)} />
                <Field label="Worker amount" value={formatMoney(payment.worker_amount_minor, payment.currency)} />
                <Field label="Materials" value={formatMoney(payment.material_amount_minor, payment.currency)} />
                <Field label="Refunded" value={formatMoney(payment.refunded_amount_minor, payment.currency)} />
                <Field label="Method" value={payment.method ?? '—'} />
              </FieldGrid>
            </CardBody>
          </Card>

          <Card>
            <CardHeader title="Refunds" />
            {refunds && refunds.length > 0 ? (
              <ul className="divide-y divide-ink-100">
                {refunds.map((refund) => (
                  <li key={refund.id} className="flex flex-wrap items-start gap-3 px-5 py-3">
                    <span className="min-w-0 flex-1">
                      <span className="block text-sm font-medium text-ink-900">{formatMoney(refund.amount_minor, refund.currency)}</span>
                      <span className="block text-xs text-ink-500">{refund.reason} · {formatDateTime(refund.created_at)}</span>
                      {refund.failure_reason && <span className="block text-xs text-danger-600">{refund.failure_reason}</span>}
                    </span>
                    <StatusBadge kind="payment" status={refund.status} />
                  </li>
                ))}
              </ul>
            ) : (
              <EmptyState title="No refunds" description="Issuing refunds requires the payment gateway refund integration, which is listed as a pending backend contract." />
            )}
          </Card>
        </div>

        <div className="space-y-5">
          <Card>
            <CardHeader title="Gateway" />
            <CardBody>
              <div className={payment.gateway_signature_verified ? 'mb-4 flex items-center gap-2 text-sm font-medium text-success-700' : 'mb-4 flex items-center gap-2 text-sm font-medium text-ink-500'}>
                {payment.gateway_signature_verified ? <ShieldCheck aria-hidden className="size-4" /> : <ShieldX aria-hidden className="size-4" />}
                {payment.gateway_signature_verified ? `Signature verified ${formatDateTime(payment.gateway_verified_at)}` : 'Not verified by the gateway'}
              </div>
              <FieldGrid columns={2}>
                <Field label="Gateway" value={payment.gateway} />
                <Field label="Order reference" value={<span className="font-mono text-xs">{payment.gateway_order_id ?? '—'}</span>} />
                <Field label="Payment reference" value={<span className="font-mono text-xs">{payment.gateway_payment_id ?? '—'}</span>} className="sm:col-span-2" />
              </FieldGrid>
            </CardBody>
          </Card>

          <Card>
            <CardHeader title="Related" />
            <CardBody>
              <FieldGrid columns={2}>
                <Field label="Booking" value={payment.bookings ? <Link href={adminRoutes.booking(payment.bookings.id)} className="text-brand-700 hover:underline">{payment.bookings.booking_code}</Link> : '—'} />
                <Field label="Customer" value={payment.customers ? <Link href={adminRoutes.customer(payment.customers.id)} className="text-brand-700 hover:underline">{payment.customers.full_name}</Link> : '—'} />
                <Field label="Initiated" value={formatDateTime(payment.initiated_at)} />
                <Field label="Captured" value={formatDateTime(payment.captured_at)} />
              </FieldGrid>
            </CardBody>
          </Card>
        </div>
      </div>
    </>
  );
}
