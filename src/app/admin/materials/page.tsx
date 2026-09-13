import type { Metadata } from 'next';
import Link from 'next/link';
import { Package } from 'lucide-react';

import { DocumentLink } from '@/components/admin/document-link';
import { ForbiddenPanel, PageHeader } from '@/components/admin/page-parts';
import { StatusBadge } from '@/components/shared/status-badge';
import { Card } from '@/components/ui/card';
import { CellStack, DataTable, type Column } from '@/components/ui/data-table';
import { Alert, EmptyState } from '@/components/ui/feedback';
import { ClearFilters, FilterBar, FilterSelect } from '@/components/ui/filter-bar';
import { Pagination } from '@/components/ui/pagination';
import { asEnumValue, countActiveFilters, flattenSearchParams, parseListParams, rangeFor, type RawSearchParams } from '@/lib/api/list-params';
import { guardPage } from '@/lib/auth/page-guard';
import { adminRoutes } from '@/lib/config/routes';
import { formatDate, formatMoney, humaniseEnum } from '@/lib/utils/format';
import { MaterialStatus } from '@/types/domain';
import type { MaterialRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Materials' };
export const dynamic = 'force-dynamic';

type MaterialListRow = MaterialRow & {
  bookings: { id: string; booking_code: string } | null;
  workers: { id: string; full_name: string } | null;
  media_assets: { id: string; original_file_name: string; mime_type: string } | null;
};

/**
 * Material requests.
 *
 * Lifecycle: requested → customer review → approved/rejected → purchased →
 * actual cost recorded → billed. The database refuses to mark a material billed
 * without both a recorded cost and a receipt on file.
 */
export default async function MaterialsPage({ searchParams }: { searchParams: Promise<RawSearchParams> }) {
  const { session, allowed } = await guardPage('materials.read', adminRoutes.materials());
  if (!allowed) return <ForbiddenPanel permission="materials.read" role={session.role} resource="materials" />;

  const raw = await searchParams;
  const flat = flattenSearchParams(raw);
  const params = parseListParams(raw);
  const [from, to] = rangeFor(params.page, params.pageSize);

  let query = session.db
    .from('materials')
    .select('*, bookings(id, booking_code), workers(id, full_name), media_assets:receipt_media_id(id, original_file_name, mime_type)', { count: 'exact' });

  const status = asEnumValue(flat.status, MaterialStatus);
  if (status) query = query.eq('status', status);
  if (flat.variance === 'over') query = query.not('actual_cost_minor', 'is', null);

  const { data, error, count } = await query.order('created_at', { ascending: false }).range(from, to).overrideTypes<MaterialListRow[]>();

  // Only rows where the actual cost exceeds the approved estimate need attention.
  const rows = flat.variance === 'over' ? (data ?? []).filter((m) => (m.actual_cost_minor ?? 0) > m.estimated_cost_minor) : (data ?? []);

  const columns: ReadonlyArray<Column<MaterialListRow>> = [
    { key: 'material', header: 'Material', cell: (row) => <CellStack primary={row.name} secondary={`${row.quantity} ${row.unit}`} /> },
    { key: 'booking', header: 'Booking', cell: (row) => (row.bookings ? <Link href={adminRoutes.booking(row.bookings.id)} className="text-brand-700 hover:underline">{row.bookings.booking_code}</Link> : '—') },
    { key: 'worker', header: 'Worker', cell: (row) => row.workers?.full_name ?? '—', hideBelow: 'lg' },
    { key: 'estimate', header: 'Estimated', cell: (row) => formatMoney(row.estimated_cost_minor, row.currency), align: 'right', numeric: true, hideBelow: 'sm' },
    {
      key: 'actual',
      header: 'Actual',
      cell: (row) => (
        <span className={row.actual_cost_minor !== null && row.actual_cost_minor > row.estimated_cost_minor ? 'font-medium text-warning-700' : undefined}>
          {formatMoney(row.actual_cost_minor, row.currency)}
        </span>
      ),
      align: 'right',
      numeric: true,
    },
    { key: 'approval', header: 'Customer decision', cell: (row) => (row.customer_decision_at ? formatDate(row.customer_decision_at) : <span className="text-ink-400">Pending</span>), hideBelow: 'xl' },
    { key: 'status', header: 'Status', cell: (row) => <StatusBadge kind="material" status={row.status} /> },
    {
      key: 'receipt',
      header: 'Receipt',
      cell: (row) => (row.media_assets ? <DocumentLink mediaId={row.media_assets.id} fileName={row.media_assets.original_file_name} mimeType={row.media_assets.mime_type} className="max-w-56 p-2" /> : <span className="text-ink-400">None</span>),
      hideBelow: 'lg',
    },
  ];

  const active = countActiveFilters(flat, ['status', 'variance']);

  return (
    <>
      <PageHeader title="Materials" description="Parts and supplies requested during jobs, their approval, recorded cost and billing." />
      <Card>
        <FilterBar>
          <FilterSelect paramName="status" label="Filter by status" allLabel="All statuses" options={Object.values(MaterialStatus).map((value) => ({ value, label: humaniseEnum(value) }))} />
          <FilterSelect paramName="variance" label="Cost variance" allLabel="Any cost" options={[{ value: 'over', label: 'Actual above estimate' }]} />
          <ClearFilters activeCount={active} />
        </FilterBar>
        {error ? (
          <Alert tone="danger" className="m-4">Materials could not be loaded.</Alert>
        ) : (
          <>
            <DataTable
              columns={columns}
              rows={rows}
              rowKey={(row) => row.id}
              caption="Material requests"
              empty={<EmptyState icon={<Package aria-hidden className="size-5" />} title={active > 0 ? 'No materials match these filters' : 'No material requests yet'} description="Workers raise material requests from the worker app during a job." />}
            />
            <Pagination page={params.page} pageSize={params.pageSize} total={count ?? 0} searchParams={flat} basePath={adminRoutes.materials()} />
          </>
        )}
      </Card>
    </>
  );
}
