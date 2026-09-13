import type { Metadata } from 'next';
import { ClipboardList } from 'lucide-react';

import { ForbiddenPanel, PageHeader } from '@/components/admin/page-parts';
import { StatusBadge } from '@/components/shared/status-badge';
import { Card } from '@/components/ui/card';
import { CellStack, DataTable, type Column } from '@/components/ui/data-table';
import { Alert, EmptyState } from '@/components/ui/feedback';
import { ClearFilters, FilterBar, FilterSelect, SearchInput } from '@/components/ui/filter-bar';
import { Pagination } from '@/components/ui/pagination';
import {
  asEnumValue,
  countActiveFilters,
  flattenSearchParams,
  parseListParams,
  rangeFor,
  sanitiseSearchTerm,
  type RawSearchParams,
} from '@/lib/api/list-params';
import { guardPage } from '@/lib/auth/page-guard';
import { adminRoutes } from '@/lib/config/routes';
import { formatDateTime, formatMoney, humaniseEnum } from '@/lib/utils/format';
import { BookingStatus } from '@/types/domain';
import type { BookingRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Bookings' };
export const dynamic = 'force-dynamic';

type BookingListRow = Pick<
  BookingRow,
  'id' | 'booking_code' | 'status' | 'scheduled_at' | 'city' | 'final_amount_minor' | 'quoted_amount_minor' | 'currency' | 'created_at'
> & {
  customers: { full_name: string } | null;
  workers: { full_name: string } | null;
  services: { name: string } | null;
  payments: Array<{ status: string }> | null;
};

const FILTER_KEYS = ['q', 'status', 'service'] as const;

export default async function BookingsPage({ searchParams }: { searchParams: Promise<RawSearchParams> }) {
  const { session, allowed } = await guardPage('bookings.read', adminRoutes.bookings());
  if (!allowed) return <ForbiddenPanel permission="bookings.read" role={session.role} resource="bookings" />;

  const raw = await searchParams;
  const flat = flattenSearchParams(raw);
  const params = parseListParams(raw);
  const [from, to] = rangeFor(params.page, params.pageSize);

  let query = session.db
    .from('bookings')
    .select(
      'id, booking_code, status, scheduled_at, city, final_amount_minor, quoted_amount_minor, currency, created_at, customers(full_name), workers(full_name), services(name), payments(status)',
      { count: 'exact' },
    );

  const term = sanitiseSearchTerm(params.q);
  if (term) query = query.or(`booking_code.ilike.%${term}%,city.ilike.%${term}%`);

  const status = asEnumValue(flat.status, BookingStatus);
  if (status) query = query.eq('status', status);
  if (flat.service) query = query.eq('service_id', flat.service);

  const [{ data, error, count }, { data: services }] = await Promise.all([
    query.order('created_at', { ascending: false }).range(from, to).overrideTypes<BookingListRow[]>(),
    session.db.from('services').select('id, name').order('display_order'),
  ]);

  const columns: ReadonlyArray<Column<BookingListRow>> = [
    { key: 'booking', header: 'Booking', cell: (row) => <CellStack primary={row.booking_code} secondary={row.services?.name ?? undefined} /> },
    { key: 'customer', header: 'Customer', cell: (row) => row.customers?.full_name ?? '—', hideBelow: 'md' },
    { key: 'worker', header: 'Worker', cell: (row) => row.workers?.full_name ?? <span className="text-ink-400">Unassigned</span>, hideBelow: 'lg' },
    { key: 'status', header: 'Status', cell: (row) => <StatusBadge kind="booking" status={row.status} /> },
    { key: 'scheduled', header: 'Scheduled', cell: (row) => formatDateTime(row.scheduled_at), hideBelow: 'xl' },
    { key: 'city', header: 'Location', cell: (row) => row.city ?? '—', hideBelow: 'xl' },
    {
      key: 'payment',
      header: 'Payment',
      cell: (row) => {
        const latest = row.payments?.at(-1)?.status;
        return latest ? <StatusBadge kind="payment" status={latest} /> : <span className="text-ink-400">None</span>;
      },
      hideBelow: 'lg',
    },
    { key: 'amount', header: 'Amount', cell: (row) => formatMoney(row.final_amount_minor ?? row.quoted_amount_minor, row.currency), align: 'right', numeric: true, hideBelow: 'sm' },
    { key: 'created', header: 'Created', cell: (row) => formatDateTime(row.created_at), align: 'right', hideBelow: 'xl' },
  ];

  const active = countActiveFilters(flat, FILTER_KEYS);

  return (
    <>
      <PageHeader title="Bookings" description="Every job from request to close. Status changes happen only through the booking state machine." />
      <Card>
        <FilterBar>
          <SearchInput label="Search bookings" placeholder="Booking code or city" className="w-full sm:w-64" />
          <FilterSelect
            paramName="status"
            label="Filter by status"
            allLabel="All statuses"
            options={Object.values(BookingStatus).map((value) => ({ value, label: humaniseEnum(value) }))}
          />
          <FilterSelect
            paramName="service"
            label="Filter by service"
            allLabel="All services"
            options={(services ?? []).map((service) => ({ value: service.id, label: service.name }))}
          />
          <ClearFilters activeCount={active} />
        </FilterBar>

        {error ? (
          <Alert tone="danger" className="m-4">Bookings could not be loaded. Refresh to try again.</Alert>
        ) : (
          <>
            <DataTable
              columns={columns}
              rows={data ?? []}
              rowKey={(row) => row.id}
              rowHref={(row) => adminRoutes.booking(row.id)}
              caption="Bookings"
              empty={
                <EmptyState
                  icon={<ClipboardList aria-hidden className="size-5" />}
                  title={active > 0 ? 'No bookings match these filters' : 'No bookings yet'}
                  description={active > 0 ? 'Clear the filters to see all bookings.' : 'Bookings appear here as soon as customers request a service in the app.'}
                />
              }
            />
            <Pagination page={params.page} pageSize={params.pageSize} total={count ?? 0} searchParams={flat} basePath={adminRoutes.bookings()} />
          </>
        )}
      </Card>
    </>
  );
}
