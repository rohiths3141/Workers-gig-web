import type { Metadata } from 'next';
import { CircleDollarSign, ShieldCheck } from 'lucide-react';

import { ForbiddenPanel, PageHeader } from '@/components/admin/page-parts';
import { StatusBadge } from '@/components/shared/status-badge';
import { Card } from '@/components/ui/card';
import { CellStack, DataTable, type Column } from '@/components/ui/data-table';
import { Alert, EmptyState } from '@/components/ui/feedback';
import { ClearFilters, FilterBar, FilterSelect, SearchInput } from '@/components/ui/filter-bar';
import { Pagination } from '@/components/ui/pagination';
import { asEnumValue, countActiveFilters, flattenSearchParams, parseListParams, rangeFor, sanitiseSearchTerm, type RawSearchParams } from '@/lib/api/list-params';
import { guardPage } from '@/lib/auth/page-guard';
import { adminRoutes } from '@/lib/config/routes';
import { formatDateTime, formatMoney, humaniseEnum } from '@/lib/utils/format';
import { PaymentStatus } from '@/types/domain';
import type { PaymentRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Payments' };
export const dynamic = 'force-dynamic';

type PaymentListRow = Pick<PaymentRow, 'id' | 'payment_code' | 'amount_minor' | 'platform_fee_minor' | 'worker_amount_minor' | 'currency' | 'status' | 'gateway' | 'gateway_payment_id' | 'gateway_signature_verified' | 'created_at'> & {
  bookings: { booking_code: string } | null;
  customers: { full_name: string } | null;
};

/**
 * Payments.
 *
 * Read-only. A payment's status is set only by the webhook handler after the
 * gateway signature is verified; the database refuses SUCCESS without that
 * proof, so there is no control here to mark a payment paid.
 */
export default async function PaymentsPage({ searchParams }: { searchParams: Promise<RawSearchParams> }) {
  const { session, allowed } = await guardPage('payments.read', adminRoutes.payments());
  if (!allowed) return <ForbiddenPanel permission="payments.read" role={session.role} resource="payments" />;

  const raw = await searchParams;
  const flat = flattenSearchParams(raw);
  const params = parseListParams(raw);
  const [from, to] = rangeFor(params.page, params.pageSize);

  let query = session.db
    .from('payments')
    .select('id, payment_code, amount_minor, platform_fee_minor, worker_amount_minor, currency, status, gateway, gateway_payment_id, gateway_signature_verified, created_at, bookings(booking_code), customers(full_name)', { count: 'exact' });

  const term = sanitiseSearchTerm(params.q);
  if (term) query = query.or(`payment_code.ilike.%${term}%,gateway_payment_id.ilike.%${term}%`);
  const status = asEnumValue(flat.status, PaymentStatus);
  if (status) query = query.eq('status', status);

  const { data, error, count } = await query.order('created_at', { ascending: false }).range(from, to).overrideTypes<PaymentListRow[]>();

  const columns: ReadonlyArray<Column<PaymentListRow>> = [
    { key: 'payment', header: 'Payment', cell: (row) => <CellStack primary={row.payment_code} secondary={row.bookings?.booking_code} /> },
    { key: 'customer', header: 'Customer', cell: (row) => row.customers?.full_name ?? '—', hideBelow: 'md' },
    { key: 'amount', header: 'Amount', cell: (row) => formatMoney(row.amount_minor, row.currency), align: 'right', numeric: true },
    { key: 'fee', header: 'Platform fee', cell: (row) => formatMoney(row.platform_fee_minor, row.currency), align: 'right', numeric: true, hideBelow: 'lg' },
    { key: 'worker', header: 'Worker amount', cell: (row) => formatMoney(row.worker_amount_minor, row.currency), align: 'right', numeric: true, hideBelow: 'lg' },
    {
      key: 'gateway',
      header: 'Gateway reference',
      cell: (row) => (
        <span className="inline-flex items-center gap-1.5 font-mono text-xs text-ink-600">
          {row.gateway_signature_verified && <ShieldCheck aria-label="Signature verified" className="size-3.5 text-success-600" />}
          {row.gateway_payment_id ?? `${row.gateway} · pending`}
        </span>
      ),
      hideBelow: 'xl',
    },
    { key: 'status', header: 'Status', cell: (row) => <StatusBadge kind="payment" status={row.status} /> },
    { key: 'created', header: 'Created', cell: (row) => formatDateTime(row.created_at), align: 'right', hideBelow: 'sm' },
  ];

  const active = countActiveFilters(flat, ['q', 'status']);

  return (
    <>
      <PageHeader title="Payments" description="Customer payments. A payment is marked successful only after the gateway signature is verified on the server." />
      <Card>
        <FilterBar>
          <SearchInput label="Search payments" placeholder="Payment code or gateway reference" className="w-full sm:w-72" />
          <FilterSelect paramName="status" label="Filter by status" allLabel="All statuses" options={Object.values(PaymentStatus).map((value) => ({ value, label: humaniseEnum(value) }))} />
          <ClearFilters activeCount={active} />
        </FilterBar>
        {error ? (
          <Alert tone="danger" className="m-4">Payments could not be loaded.</Alert>
        ) : (
          <>
            <DataTable
              columns={columns}
              rows={data ?? []}
              rowKey={(row) => row.id}
              rowHref={(row) => adminRoutes.payment(row.id)}
              caption="Payments"
              empty={<EmptyState icon={<CircleDollarSign aria-hidden className="size-5" />} title={active > 0 ? 'No payments match these filters' : 'No payments yet'} description="Payments appear once customers pay for approved work." />}
            />
            <Pagination page={params.page} pageSize={params.pageSize} total={count ?? 0} searchParams={flat} basePath={adminRoutes.payments()} />
          </>
        )}
      </Card>
    </>
  );
}
