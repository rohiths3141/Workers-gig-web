import type { Metadata } from 'next';
import Link from 'next/link';
import { FileSearch } from 'lucide-react';

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
import { InsuranceStatus } from '@/types/domain';
import type { InsurancePolicyRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Insurance' };
export const dynamic = 'force-dynamic';

type PolicyRow = InsurancePolicyRow & {
  workers: { id: string; full_name: string; worker_code: string } | null;
  claims: Array<{ id: string }> | null;
  media_assets: { id: string; original_file_name: string; mime_type: string } | null;
};

/**
 * Insurance policy records.
 *
 * These are records of policies held with external insurers. The platform is
 * not the insurer, and a record here is not a coverage decision.
 */
export default async function InsurancePage({ searchParams }: { searchParams: Promise<RawSearchParams> }) {
  const { session, allowed } = await guardPage('insurance.read', adminRoutes.insurance());
  if (!allowed) return <ForbiddenPanel permission="insurance.read" role={session.role} resource="insurance" />;

  const raw = await searchParams;
  const flat = flattenSearchParams(raw);
  const params = parseListParams(raw);
  const [from, to] = rangeFor(params.page, params.pageSize);

  let query = session.db
    .from('insurance_policies')
    .select('*, workers(id, full_name, worker_code), claims(id), media_assets:document_media_id(id, original_file_name, mime_type)', { count: 'exact' });
  const status = asEnumValue(flat.status, InsuranceStatus);
  if (status) query = query.eq('status', status);

  const { data, error, count } = await query.order('end_date', { ascending: true }).range(from, to).overrideTypes<PolicyRow[]>();

  const columns: ReadonlyArray<Column<PolicyRow>> = [
    { key: 'worker', header: 'Worker', cell: (row) => (row.workers ? <Link href={adminRoutes.worker(row.workers.id)} className="hover:text-brand-700"><CellStack primary={row.workers.full_name} secondary={row.workers.worker_code} /></Link> : '—') },
    { key: 'policy', header: 'Policy', cell: (row) => <CellStack primary={row.provider_name} secondary={row.policy_number} /> },
    { key: 'coverage', header: 'Coverage', cell: (row) => formatMoney(row.coverage_amount_minor, row.currency), align: 'right', numeric: true, hideBelow: 'md' },
    { key: 'start', header: 'Start', cell: (row) => formatDate(row.start_date), hideBelow: 'lg' },
    { key: 'expiry', header: 'Expiry', cell: (row) => formatDate(row.end_date) },
    { key: 'status', header: 'Status', cell: (row) => <StatusBadge kind="insurance" status={row.status} /> },
    { key: 'claims', header: 'Claims', cell: (row) => row.claims?.length ?? 0, align: 'right', numeric: true, hideBelow: 'lg' },
    { key: 'document', header: 'Document', cell: (row) => (row.media_assets ? <DocumentLink mediaId={row.media_assets.id} fileName={row.media_assets.original_file_name} mimeType={row.media_assets.mime_type} sensitive className="max-w-52 p-2" /> : <span className="text-ink-400">None</span>), hideBelow: 'xl' },
  ];

  return (
    <>
      <PageHeader title="Insurance" description="Policy records held by workers with external insurers. Coverage and payout decisions belong to the insurer, not to the platform." />
      <Card>
        <FilterBar>
          <FilterSelect paramName="status" label="Filter by status" allLabel="All statuses" options={Object.values(InsuranceStatus).map((value) => ({ value, label: humaniseEnum(value) }))} />
          <ClearFilters activeCount={countActiveFilters(flat, ['status'])} />
        </FilterBar>
        {error ? (
          <Alert tone="danger" className="m-4">Policies could not be loaded.</Alert>
        ) : (
          <>
            <DataTable columns={columns} rows={data ?? []} rowKey={(row) => row.id} caption="Insurance policy records" empty={<EmptyState icon={<FileSearch aria-hidden className="size-5" />} title="No insurance records" description="Policies appear once a worker submits insurance for verification." />} />
            <Pagination page={params.page} pageSize={params.pageSize} total={count ?? 0} searchParams={flat} basePath={adminRoutes.insurance()} />
          </>
        )}
      </Card>
    </>
  );
}
