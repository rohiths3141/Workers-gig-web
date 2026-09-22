import type { Metadata } from 'next';
import { Users } from 'lucide-react';

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
import { formatDate, humaniseEnum, maskPhone } from '@/lib/utils/format';
import { CustomerStatus } from '@/types/domain';
import type { CustomerRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Customers' };
export const dynamic = 'force-dynamic';

type CustomerListRow = Pick<
  CustomerRow,
  'id' | 'full_name' | 'phone' | 'status' | 'city' | 'rating_avg' | 'rating_count' | 'created_at'
>;

const FILTER_KEYS = ['q', 'status'] as const;

/**
 * Customer list.
 *
 * Phone numbers are masked in the list — the full number is on the detail page,
 * where the operator has opened a specific record for a reason. Email and
 * address are not shown here at all.
 */
export default async function CustomersPage({ searchParams }: { searchParams: Promise<RawSearchParams> }) {
  const { session, allowed } = await guardPage('customers.read', adminRoutes.customers());
  if (!allowed) return <ForbiddenPanel permission="customers.read" role={session.role} resource="customers" />;

  const raw = await searchParams;
  const flat = flattenSearchParams(raw);
  const params = parseListParams(raw);
  const [from, to] = rangeFor(params.page, params.pageSize);

  let query = session.db
    .from('customers')
    .select('id, full_name, phone, status, city, rating_avg, rating_count, created_at', { count: 'exact' });

  const term = sanitiseSearchTerm(params.q);
  if (term) query = query.or(`full_name.ilike.%${term}%,phone.ilike.%${term}%`);

  const status = asEnumValue(flat.status, CustomerStatus);
  if (status) query = query.eq('status', status);

  const { data, error, count } = await query.order('created_at', { ascending: false }).range(from, to);

  const columns: ReadonlyArray<Column<CustomerListRow>> = [
    { key: 'customer', header: 'Customer', cell: (row) => <CellStack primary={row.full_name} secondary={maskPhone(row.phone)} /> },
    { key: 'status', header: 'Status', cell: (row) => <StatusBadge kind="customer" status={row.status} /> },
    { key: 'city', header: 'City', cell: (row) => row.city ?? '—', hideBelow: 'md' },
    {
      key: 'rating',
      header: 'Rating from workers',
      cell: (row) => (row.rating_avg === null ? <span className="text-ink-400">Not rated</span> : `${row.rating_avg.toFixed(1)} (${row.rating_count})`),
      align: 'right',
      numeric: true,
      hideBelow: 'lg',
    },
    { key: 'joined', header: 'Joined', cell: (row) => formatDate(row.created_at), align: 'right', hideBelow: 'sm' },
  ];

  const active = countActiveFilters(flat, FILTER_KEYS);

  return (
    <>
      <PageHeader title="Customers" description="Customer accounts, their bookings, payments, claims and tickets." />
      <Card>
        <FilterBar>
          <SearchInput label="Search customers" placeholder="Name or phone" className="w-full sm:w-72" />
          <FilterSelect
            paramName="status"
            label="Filter by status"
            allLabel="All statuses"
            options={Object.values(CustomerStatus).map((value) => ({ value, label: humaniseEnum(value) }))}
          />
          <ClearFilters activeCount={active} />
        </FilterBar>

        {error ? (
          <Alert tone="danger" className="m-4">Customers could not be loaded. Refresh to try again.</Alert>
        ) : (
          <>
            <DataTable
              columns={columns}
              rows={data ?? []}
              rowKey={(row) => row.id}
              rowHref={(row) => adminRoutes.customer(row.id)}
              caption="Customer accounts"
              empty={
                <EmptyState
                  icon={<Users aria-hidden className="size-5" />}
                  title={active > 0 ? 'No customers match these filters' : 'No customers yet'}
                  description={active > 0 ? 'Clear the filters to see every customer.' : 'Customers appear here after their first sign-in to the customer app.'}
                />
              }
            />
            <Pagination page={params.page} pageSize={params.pageSize} total={count ?? 0} searchParams={flat} basePath={adminRoutes.customers()} />
          </>
        )}
      </Card>
    </>
  );
}
