import type { Metadata } from 'next';
import Link from 'next/link';
import { ShieldCheck } from 'lucide-react';

import { ForbiddenPanel, PageHeader } from '@/components/admin/page-parts';
import { StatusBadge } from '@/components/shared/status-badge';
import { Card } from '@/components/ui/card';
import { CellStack, DataTable, type Column } from '@/components/ui/data-table';
import { Alert, EmptyState } from '@/components/ui/feedback';
import { FilterBar, FilterSelect } from '@/components/ui/filter-bar';
import { Pagination } from '@/components/ui/pagination';
import { flattenSearchParams, parseListParams, rangeFor, type RawSearchParams } from '@/lib/api/list-params';
import { guardPage } from '@/lib/auth/page-guard';
import { adminRoutes } from '@/lib/config/routes';
import { cn } from '@/lib/utils/cn';
import { formatDate, formatRelativeTime } from '@/lib/utils/format';
import { VERIFICATION_TYPE_LABELS, verificationTypeLabel } from '@/lib/utils/labels';
import { VerificationStatus, VerificationType, type VerificationStatus as VerificationStatusType } from '@/types/domain';
import type { WorkerVerificationRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Verification queue' };
export const dynamic = 'force-dynamic';

/** The five queue tabs and the statuses each one covers. */
const TABS: Array<{ key: string; label: string; statuses: VerificationStatusType[] }> = [
  { key: 'pending', label: 'Pending', statuses: [VerificationStatus.PENDING] },
  { key: 'review', label: 'Requires review', statuses: [VerificationStatus.UNDER_REVIEW, VerificationStatus.MORE_INFO_REQUIRED] },
  { key: 'approved', label: 'Approved', statuses: [VerificationStatus.APPROVED] },
  { key: 'rejected', label: 'Rejected', statuses: [VerificationStatus.REJECTED] },
  { key: 'expired', label: 'Expired', statuses: [VerificationStatus.EXPIRED] },
];

type QueueRow = Pick<WorkerVerificationRow, 'id' | 'type' | 'status' | 'submitted_at' | 'reviewed_at' | 'expires_at' | 'assigned_to'> & {
  workers: { id: string; full_name: string; worker_code: string } | null;
};

export default async function VerificationQueuePage({ searchParams }: { searchParams: Promise<RawSearchParams> }) {
  const { session, allowed } = await guardPage('verification.read', adminRoutes.verification());
  if (!allowed) return <ForbiddenPanel permission="verification.read" role={session.role} resource="the verification queue" />;

  const raw = await searchParams;
  const flat = flattenSearchParams(raw);
  const params = parseListParams(raw);
  const [from, to] = rangeFor(params.page, params.pageSize);
  const tab = TABS.find((t) => t.key === flat.tab) ?? TABS[0]!;

  let query = session.db
    .from('worker_verifications')
    .select('id, type, status, submitted_at, reviewed_at, expires_at, assigned_to, workers(id, full_name, worker_code)', { count: 'exact' })
    .in('status', tab.statuses);

  const type = flat.type && (Object.values(VerificationType) as string[]).includes(flat.type) ? (flat.type as VerificationType) : undefined;
  if (type) query = query.eq('type', type);
  if (flat.worker && /^[0-9a-f-]{36}$/i.test(flat.worker)) query = query.eq('worker_id', flat.worker);

  // Oldest first for work still to do; newest first for decided cases.
  const oldestFirst = tab.key === 'pending' || tab.key === 'review';
  const { data, error, count } = await query
    .order(oldestFirst ? 'submitted_at' : 'reviewed_at', { ascending: oldestFirst, nullsFirst: false })
    .range(from, to)
    .overrideTypes<QueueRow[]>();

  const columns: ReadonlyArray<Column<QueueRow>> = [
    { key: 'worker', header: 'Worker', cell: (row) => <CellStack primary={row.workers?.full_name ?? 'Unknown'} secondary={row.workers?.worker_code} /> },
    { key: 'type', header: 'Check', cell: (row) => verificationTypeLabel(row.type) },
    { key: 'status', header: 'Status', cell: (row) => <StatusBadge kind="verification" status={row.status} /> },
    {
      key: 'assigned',
      header: 'Reviewer',
      cell: (row) => (row.assigned_to ? (row.assigned_to === session.adminId ? 'You' : 'Assigned') : <span className="text-ink-400">Unassigned</span>),
      hideBelow: 'lg',
    },
    {
      key: 'when',
      header: oldestFirst ? 'Waiting' : 'Decided',
      cell: (row) => (oldestFirst ? formatRelativeTime(row.submitted_at) : formatDate(row.reviewed_at)),
      align: 'right',
      hideBelow: 'sm',
    },
    { key: 'expires', header: 'Expires', cell: (row) => formatDate(row.expires_at), align: 'right', hideBelow: 'xl' },
  ];

  const tabHref = (key: string) => {
    const next = new URLSearchParams();
    next.set('tab', key);
    if (flat.type) next.set('type', flat.type);
    if (flat.worker) next.set('worker', flat.worker);
    return `${adminRoutes.verification()}?${next.toString()}`;
  };

  return (
    <>
      <PageHeader
        title="Verification queue"
        description="Identity, qualification, skill, background and insurance checks. Every decision is attributed and audited; nothing is approved automatically."
      />

      <Card>
        <nav aria-label="Queue tabs" className="scroll-x border-b border-ink-200">
          <ul className="flex min-w-max gap-1 px-3">
            {TABS.map((t) => (
              <li key={t.key}>
                <Link
                  href={tabHref(t.key)}
                  aria-current={t.key === tab.key ? 'page' : undefined}
                  className={cn(
                    'block border-b-2 px-3 py-3 text-sm font-medium',
                    t.key === tab.key ? 'border-brand-700 text-brand-800' : 'border-transparent text-ink-500 hover:text-ink-900',
                  )}
                >
                  {t.label}
                </Link>
              </li>
            ))}
          </ul>
        </nav>

        <FilterBar>
          <FilterSelect
            paramName="type"
            label="Filter by check"
            allLabel="All checks"
            options={Object.entries(VERIFICATION_TYPE_LABELS).map(([value, label]) => ({ value, label }))}
          />
          {flat.worker && (
            <Link href={tabHref(tab.key).replace(/&?worker=[^&]*/, '')} className="text-sm text-brand-700 hover:underline">
              Showing one worker — clear
            </Link>
          )}
        </FilterBar>

        {error ? (
          <Alert tone="danger" className="m-4">The queue could not be loaded. Refresh to try again.</Alert>
        ) : (
          <>
            <DataTable
              columns={columns}
              rows={data ?? []}
              rowKey={(row) => row.id}
              rowHref={(row) => adminRoutes.verificationCase(row.id)}
              caption={`${tab.label} verification cases`}
              empty={
                <EmptyState
                  icon={<ShieldCheck aria-hidden className="size-5" />}
                  title={oldestFirst ? 'No pending verification' : `No ${tab.label.toLowerCase()} cases`}
                  description={oldestFirst ? 'New submissions from the worker app appear here automatically.' : 'Cases appear here once decided.'}
                />
              }
            />
            <Pagination page={params.page} pageSize={params.pageSize} total={count ?? 0} searchParams={flat} basePath={adminRoutes.verification()} />
          </>
        )}
      </Card>
    </>
  );
}
