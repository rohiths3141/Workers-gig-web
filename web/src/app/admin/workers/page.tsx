import type { Metadata } from 'next';
import { Briefcase, Star } from 'lucide-react';

import { ForbiddenPanel, PageHeader } from '@/components/admin/page-parts';
import { StatusBadge } from '@/components/shared/status-badge';
import { Card } from '@/components/ui/card';
import { CellStack, DataTable, type Column } from '@/components/ui/data-table';
import { Alert, EmptyState } from '@/components/ui/feedback';
import { ClearFilters, FilterBar, FilterSelect, SearchInput } from '@/components/ui/filter-bar';
import { Pagination } from '@/components/ui/pagination';
import { guardPage } from '@/lib/auth/page-guard';
import {
  asEnumValue,
  countActiveFilters,
  flattenSearchParams,
  parseListParams,
  rangeFor,
  sanitiseSearchTerm,
  type RawSearchParams,
} from '@/lib/api/list-params';
import { adminRoutes } from '@/lib/config/routes';
import { formatDate, humaniseEnum } from '@/lib/utils/format';
import { WorkerAvailability, WorkerStatus } from '@/types/domain';
import type { WorkerRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Workers' };
export const dynamic = 'force-dynamic';

type WorkerListRow = Pick<
  WorkerRow,
  | 'id'
  | 'worker_code'
  | 'full_name'
  | 'phone'
  | 'status'
  | 'availability'
  | 'city'
  | 'rating_avg'
  | 'rating_count'
  | 'jobs_completed'
  | 'is_kyc_verified'
  | 'is_background_verified'
  | 'is_qualification_verified'
  | 'created_at'
> & {
  services: { name: string } | null;
};

const FILTER_KEYS = ['q', 'status', 'availability', 'service'] as const;

/**
 * Worker list.
 *
 * Search, filter, sort and pagination all run in Postgres. The browser receives
 * one page of rows, never the table. Search covers name, phone and worker code
 * through the trigram indexes declared in migration 0003.
 */
export default async function WorkersPage({
  searchParams,
}: {
  searchParams: Promise<RawSearchParams>;
}) {
  const { session, allowed } = await guardPage('workers.read', adminRoutes.workers());

  if (!allowed) {
    return <ForbiddenPanel permission="workers.read" role={session.role} resource="workers" />;
  }

  const raw = await searchParams;
  const flat = flattenSearchParams(raw);
  const params = parseListParams(raw);
  const [from, to] = rangeFor(params.page, params.pageSize);

  let query = session.db
    .from('workers')
    .select(
      'id, worker_code, full_name, phone, status, availability, city, rating_avg, rating_count, ' +
        'jobs_completed, is_kyc_verified, is_background_verified, is_qualification_verified, ' +
        'created_at, services:primary_service_id(name)',
      { count: 'exact' },
    );

  const term = sanitiseSearchTerm(params.q);
  if (term) {
    query = query.or(
      `full_name.ilike.%${term}%,phone.ilike.%${term}%,worker_code.ilike.%${term}%`,
    );
  }

  // Filter values come from the URL, so each is narrowed to a known enum member
  // before it reaches the query. An unrecognised value drops the filter.
  const status = asEnumValue(flat.status, WorkerStatus);
  const availability = asEnumValue(flat.availability, WorkerAvailability);

  if (status) query = query.eq('status', status);
  if (availability) query = query.eq('availability', availability);
  if (flat.service) query = query.eq('primary_service_id', flat.service);

  const { data, error, count } = await query
    .order('created_at', { ascending: false })
    .range(from, to)
    .overrideTypes<WorkerListRow[]>();

  // The service filter needs the catalogue; read it through the same session so
  // RLS applies consistently.
  const { data: services } = await session.db
    .from('services')
    .select('id, name')
    .eq('is_active', true)
    .order('display_order');

  const columns: ReadonlyArray<Column<WorkerListRow>> = [
    {
      key: 'worker',
      header: 'Worker',
      cell: (row) => <CellStack primary={row.full_name} secondary={row.worker_code} />,
    },
    {
      key: 'trade',
      header: 'Trade',
      cell: (row) => <span className="text-ink-700">{row.services?.name ?? '—'}</span>,
      hideBelow: 'md',
    },
    {
      key: 'status',
      header: 'Status',
      cell: (row) => <StatusBadge kind="worker" status={row.status} />,
    },
    {
      key: 'verification',
      header: 'Verification',
      // Shows exactly which checks this worker holds — never a blanket
      // "verified" badge that implies more than the data supports.
      cell: (row) => (
        <div className="flex flex-wrap gap-1">
          <VerificationPip label="ID" held={row.is_kyc_verified} title="Identity verified" />
          <VerificationPip
            label="BGV"
            held={row.is_background_verified}
            title="Background verified"
          />
          <VerificationPip
            label="Qual"
            held={row.is_qualification_verified}
            title="Qualification verified"
          />
        </div>
      ),
      hideBelow: 'lg',
    },
    {
      key: 'city',
      header: 'City',
      cell: (row) => <span className="text-ink-600">{row.city ?? '—'}</span>,
      hideBelow: 'lg',
    },
    {
      key: 'rating',
      header: 'Rating',
      cell: (row) =>
        row.rating_avg === null ? (
          <span className="text-ink-400">Not rated</span>
        ) : (
          <span className="inline-flex items-center gap-1 text-ink-800">
            <Star aria-hidden className="size-3.5 fill-warning-500 text-warning-500" />
            {row.rating_avg.toFixed(1)}
            <span className="text-ink-400">({row.rating_count})</span>
          </span>
        ),
      align: 'right',
      numeric: true,
      hideBelow: 'sm',
    },
    {
      key: 'jobs',
      header: 'Jobs',
      cell: (row) => row.jobs_completed,
      align: 'right',
      numeric: true,
      hideBelow: 'xl',
    },
    {
      key: 'joined',
      header: 'Joined',
      cell: (row) => <span className="text-ink-500">{formatDate(row.created_at)}</span>,
      align: 'right',
      hideBelow: 'xl',
    },
  ];

  return (
    <>
      <PageHeader
        title="Workers"
        description="Every registered professional, their verification state and their job history."
      />

      <Card>
        <FilterBar>
          <SearchInput
            label="Search workers"
            placeholder="Name, phone or worker code"
            className="w-full sm:w-72"
          />

          <FilterSelect
            paramName="status"
            label="Filter by status"
            allLabel="All statuses"
            options={Object.values(WorkerStatus).map((value) => ({
              value,
              label: humaniseEnum(value),
            }))}
          />

          <FilterSelect
            paramName="availability"
            label="Filter by availability"
            allLabel="Any availability"
            options={Object.values(WorkerAvailability).map((value) => ({
              value,
              label: humaniseEnum(value),
            }))}
          />

          <FilterSelect
            paramName="service"
            label="Filter by trade"
            allLabel="All trades"
            options={(services ?? []).map((service) => ({
              value: service.id,
              label: service.name,
            }))}
          />

          <ClearFilters activeCount={countActiveFilters(flat, FILTER_KEYS)} />
        </FilterBar>

        {error ? (
          <Alert tone="danger" className="m-4">
            Workers could not be loaded. Refresh to try again.
          </Alert>
        ) : (
          <>
            <DataTable
              columns={columns}
              rows={data ?? []}
              rowKey={(row) => row.id}
              rowHref={(row) => adminRoutes.worker(row.id)}
              caption="Registered workers"
              empty={
                <EmptyState
                  icon={<Briefcase aria-hidden className="size-5" />}
                  title={
                    countActiveFilters(flat, FILTER_KEYS) > 0
                      ? 'No workers match these filters'
                      : 'No workers have registered yet'
                  }
                  description={
                    countActiveFilters(flat, FILTER_KEYS) > 0
                      ? 'Clear the filters above to see the full list.'
                      : 'Workers register through the worker app. They appear here as soon as they sign up, before verification.'
                  }
                />
              }
            />

            <Pagination
              page={params.page}
              pageSize={params.pageSize}
              total={count ?? 0}
              searchParams={flat}
              basePath={adminRoutes.workers()}
            />
          </>
        )}
      </Card>
    </>
  );
}

/** Compact verification indicator. Colour is paired with a title and a label. */
function VerificationPip({
  label,
  held,
  title,
}: {
  label: string;
  held: boolean;
  title: string;
}) {
  return (
    <span
      title={held ? title : `${title} — not held`}
      className={
        held
          ? 'rounded bg-success-50 px-1.5 py-0.5 text-[0.625rem] font-semibold uppercase text-success-700'
          : 'rounded bg-ink-100 px-1.5 py-0.5 text-[0.625rem] font-semibold uppercase text-ink-400'
      }
    >
      {label}
      <span className="sr-only">{held ? ' verified' : ' not verified'}</span>
    </span>
  );
}
