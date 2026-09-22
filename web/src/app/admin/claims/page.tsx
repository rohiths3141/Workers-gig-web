import type { Metadata } from 'next';
import { ShieldAlert } from 'lucide-react';

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
import { formatDate, formatMoney, humaniseEnum } from '@/lib/utils/format';
import { ClaimStatus, ClaimType } from '@/types/domain';
import type { ClaimRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Damage claims' };
export const dynamic = 'force-dynamic';

type ClaimListRow = Pick<ClaimRow, 'id' | 'claim_code' | 'type' | 'status' | 'incident_at' | 'amount_claimed_minor' | 'amount_approved_minor' | 'currency' | 'created_at'> & {
  bookings: { booking_code: string } | null;
  customers: { full_name: string } | null;
  workers: { full_name: string } | null;
  media_assets: Array<{ id: string }> | null;
};

export default async function ClaimsPage({ searchParams }: { searchParams: Promise<RawSearchParams> }) {
  const { session, allowed } = await guardPage('claims.read', adminRoutes.claims());
  if (!allowed) return <ForbiddenPanel permission="claims.read" role={session.role} resource="damage claims" />;

  const raw = await searchParams;
  const flat = flattenSearchParams(raw);
  const params = parseListParams(raw);
  const [from, to] = rangeFor(params.page, params.pageSize);

  let query = session.db
    .from('claims')
    .select('id, claim_code, type, status, incident_at, amount_claimed_minor, amount_approved_minor, currency, created_at, bookings(booking_code), customers(full_name), workers(full_name), media_assets(id)', { count: 'exact' });

  const term = sanitiseSearchTerm(params.q);
  if (term) query = query.ilike('claim_code', `%${term}%`);
  const status = asEnumValue(flat.status, ClaimStatus);
  if (status) query = query.eq('status', status);
  const type = asEnumValue(flat.type, ClaimType);
  if (type) query = query.eq('type', type);

  const { data, error, count } = await query.order('created_at', { ascending: false }).range(from, to).overrideTypes<ClaimListRow[]>();

  const columns: ReadonlyArray<Column<ClaimListRow>> = [
    { key: 'claim', header: 'Claim', cell: (row) => <CellStack primary={row.claim_code} secondary={row.bookings?.booking_code} /> },
    { key: 'customer', header: 'Customer', cell: (row) => row.customers?.full_name ?? '—', hideBelow: 'md' },
    { key: 'worker', header: 'Worker', cell: (row) => row.workers?.full_name ?? '—', hideBelow: 'lg' },
    { key: 'type', header: 'Type', cell: (row) => humaniseEnum(row.type), hideBelow: 'sm' },
    { key: 'incident', header: 'Incident', cell: (row) => formatDate(row.incident_at), hideBelow: 'xl' },
    { key: 'claimed', header: 'Claimed', cell: (row) => formatMoney(row.amount_claimed_minor, row.currency), align: 'right', numeric: true },
    { key: 'evidence', header: 'Evidence', cell: (row) => `${row.media_assets?.length ?? 0} file${row.media_assets?.length === 1 ? '' : 's'}`, align: 'right', hideBelow: 'lg' },
    { key: 'status', header: 'Status', cell: (row) => <StatusBadge kind="claim" status={row.status} /> },
  ];

  const active = countActiveFilters(flat, ['q', 'status', 'type']);

  return (
    <>
      <PageHeader title="Damage claims" description="Every claim is decided by a person with a recorded reason. There is no automatic approval." />
      <Card>
        <FilterBar>
          <SearchInput label="Search claims" placeholder="Claim code" className="w-full sm:w-56" />
          <FilterSelect paramName="status" label="Filter by status" allLabel="All statuses" options={Object.values(ClaimStatus).map((value) => ({ value, label: humaniseEnum(value) }))} />
          <FilterSelect paramName="type" label="Filter by type" allLabel="All types" options={Object.values(ClaimType).map((value) => ({ value, label: humaniseEnum(value) }))} />
          <ClearFilters activeCount={active} />
        </FilterBar>
        {error ? (
          <Alert tone="danger" className="m-4">Claims could not be loaded.</Alert>
        ) : (
          <>
            <DataTable
              columns={columns}
              rows={data ?? []}
              rowKey={(row) => row.id}
              rowHref={(row) => adminRoutes.claim(row.id)}
              caption="Damage claims"
              empty={<EmptyState icon={<ShieldAlert aria-hidden className="size-5" />} title={active > 0 ? 'No claims match these filters' : 'No claims found'} description="Customers file damage claims from a booking in the customer app." />}
            />
            <Pagination page={params.page} pageSize={params.pageSize} total={count ?? 0} searchParams={flat} basePath={adminRoutes.claims()} />
          </>
        )}
      </Card>
    </>
  );
}
