import type { Metadata } from 'next';
import { ScrollText } from 'lucide-react';

import { ForbiddenPanel, PageHeader } from '@/components/admin/page-parts';
import { Badge } from '@/components/ui/badge';
import { Card } from '@/components/ui/card';
import { CellStack, DataTable, type Column } from '@/components/ui/data-table';
import { Alert, EmptyState } from '@/components/ui/feedback';
import { ClearFilters, FilterBar, FilterSelect, SearchInput } from '@/components/ui/filter-bar';
import { Pagination } from '@/components/ui/pagination';
import { countActiveFilters, flattenSearchParams, parseListParams, rangeFor, sanitiseSearchTerm, type RawSearchParams } from '@/lib/api/list-params';
import { guardPage } from '@/lib/auth/page-guard';
import { adminRoutes } from '@/lib/config/routes';
import { ROLE_LABELS } from '@/lib/permissions/permissions';
import { formatDateTime } from '@/lib/utils/format';
import type { AuditLogRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Audit logs' };
export const dynamic = 'force-dynamic';

const RESOURCE_TYPES = ['booking', 'worker', 'customer', 'worker_verification', 'payout', 'wallet', 'claim', 'support_ticket', 'media_asset'];

/**
 * Audit trail.
 *
 * Append-only: a database trigger refuses UPDATE and DELETE for every role,
 * including the service role. This page only reads.
 */
export default async function AuditLogsPage({ searchParams }: { searchParams: Promise<RawSearchParams> }) {
  const { session, allowed } = await guardPage('audit_logs.read', adminRoutes.auditLogs());
  if (!allowed) return <ForbiddenPanel permission="audit_logs.read" role={session.role} resource="the audit trail" />;

  const raw = await searchParams;
  const flat = flattenSearchParams(raw);
  const params = parseListParams(raw);
  const [from, to] = rangeFor(params.page, params.pageSize);

  let query = session.db.from('audit_logs').select('*', { count: 'exact' });
  const term = sanitiseSearchTerm(params.q);
  if (term) query = query.or(`action.ilike.%${term}%,resource_id.ilike.%${term}%,actor_email.ilike.%${term}%`);
  if (flat.resource && RESOURCE_TYPES.includes(flat.resource)) query = query.eq('resource_type', flat.resource);
  if (flat.outcome === 'SUCCESS' || flat.outcome === 'FAILURE') query = query.eq('outcome', flat.outcome);

  const { data, error, count } = await query.order('created_at', { ascending: false }).range(from, to);

  const columns: ReadonlyArray<Column<AuditLogRow>> = [
    { key: 'when', header: 'Time', cell: (row) => <span className="whitespace-nowrap">{formatDateTime(row.created_at)}</span> },
    { key: 'actor', header: 'Admin', cell: (row) => <CellStack primary={row.actor_email ?? row.actor_type} secondary={row.actor_role ? ROLE_LABELS[row.actor_role] : undefined} /> },
    { key: 'action', header: 'Action', cell: (row) => <span className="font-mono text-xs">{row.action}</span> },
    { key: 'resource', header: 'Resource', cell: (row) => <CellStack primary={row.resource_type} secondary={row.resource_id ?? undefined} />, hideBelow: 'md' },
    { key: 'reason', header: 'Reason', cell: (row) => (row.reason ? <span className="block max-w-64 truncate" title={row.reason}>{row.reason}</span> : '—'), hideBelow: 'lg' },
    {
      key: 'change',
      header: 'Before / after',
      cell: (row) =>
        row.before_state || row.after_state ? (
          <details>
            <summary className="cursor-pointer text-xs text-brand-700">View</summary>
            <pre className="mt-2 max-w-md overflow-x-auto rounded bg-ink-50 p-2 text-[0.6875rem] leading-relaxed text-ink-700">{JSON.stringify({ before: row.before_state, after: row.after_state }, null, 2)}</pre>
          </details>
        ) : (
          '—'
        ),
      hideBelow: 'xl',
    },
    { key: 'ip', header: 'IP', cell: (row) => <span className="font-mono text-xs text-ink-500">{row.ip_address ?? '—'}</span>, hideBelow: 'xl' },
    { key: 'outcome', header: 'Outcome', cell: (row) => <Badge tone={row.outcome === 'SUCCESS' ? 'success' : 'danger'} dot>{row.outcome === 'SUCCESS' ? 'Success' : 'Failure'}</Badge>, align: 'right' },
  ];

  const active = countActiveFilters(flat, ['q', 'resource', 'outcome']);

  return (
    <>
      <PageHeader title="Audit logs" description="Every sensitive administrative action, with before and after state. The trail is append-only and cannot be edited by anyone." />
      <Card>
        <FilterBar>
          <SearchInput label="Search audit logs" placeholder="Action, resource id or admin email" className="w-full sm:w-72" />
          <FilterSelect paramName="resource" label="Filter by resource" allLabel="All resources" options={RESOURCE_TYPES.map((value) => ({ value, label: value.replace(/_/g, ' ') }))} />
          <FilterSelect paramName="outcome" label="Filter by outcome" allLabel="Any outcome" options={[{ value: 'SUCCESS', label: 'Success' }, { value: 'FAILURE', label: 'Failure' }]} />
          <ClearFilters activeCount={active} />
        </FilterBar>
        {error ? (
          <Alert tone="danger" className="m-4">The audit trail could not be loaded.</Alert>
        ) : (
          <>
            <DataTable columns={columns} rows={data ?? []} rowKey={(row) => String(row.id)} caption="Audit log entries" empty={<EmptyState icon={<ScrollText aria-hidden className="size-5" />} title={active > 0 ? 'No entries match these filters' : 'No audit entries yet'} description="Entries are written automatically by every sensitive operation." />} />
            <Pagination page={params.page} pageSize={params.pageSize} total={count ?? 0} searchParams={flat} basePath={adminRoutes.auditLogs()} />
          </>
        )}
      </Card>
    </>
  );
}
