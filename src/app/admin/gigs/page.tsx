import type { Metadata } from 'next';
import Link from 'next/link';
import { ListChecks } from 'lucide-react';

import { ActionButton } from '@/components/admin/action-button';
import { ForbiddenPanel, PageHeader } from '@/components/admin/page-parts';
import { Badge, type BadgeTone } from '@/components/ui/badge';
import { Card } from '@/components/ui/card';
import { CellStack, DataTable, type Column } from '@/components/ui/data-table';
import { Alert, EmptyState } from '@/components/ui/feedback';
import { Pagination } from '@/components/ui/pagination';
import { flattenSearchParams, parseListParams, rangeFor, type RawSearchParams } from '@/lib/api/list-params';
import { guardPage } from '@/lib/auth/page-guard';
import { adminRoutes, apiRoutes } from '@/lib/config/routes';
import { cn } from '@/lib/utils/cn';
import { formatDate, formatMoney, formatRelativeTime, humaniseEnum } from '@/lib/utils/format';
import type { GigStatus, WorkerGigRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Gig review' };
export const dynamic = 'force-dynamic';

const TABS: Array<{ key: string; label: string; status: GigStatus }> = [
  { key: 'pending', label: 'Pending review', status: 'PENDING_REVIEW' },
  { key: 'active', label: 'Active', status: 'ACTIVE' },
  { key: 'rejected', label: 'Rejected', status: 'REJECTED' },
];

const STATUS_TONES: Record<GigStatus, BadgeTone> = {
  DRAFT: 'neutral',
  PENDING_REVIEW: 'warning',
  ACTIVE: 'success',
  PAUSED: 'neutral',
  REJECTED: 'danger',
  ARCHIVED: 'neutral',
};

type GigQueueRow = Pick<
  WorkerGigRow,
  | 'id' | 'title' | 'description' | 'status' | 'price_minor' | 'currency' | 'pricing_unit'
  | 'estimated_duration_minutes' | 'submitted_at' | 'reviewed_at' | 'rejection_reason'
> & {
  workers: { id: string; full_name: string; worker_code: string } | null;
  services: { name: string } | null;
};

/**
 * Gig review queue.
 *
 * While gigs.require_review is on, a gig a worker publishes waits here in
 * PENDING_REVIEW and is invisible to customers until an operator approves it.
 */
export default async function GigReviewPage({ searchParams }: { searchParams: Promise<RawSearchParams> }) {
  const { session, allowed } = await guardPage('verification.read', adminRoutes.gigs());
  if (!allowed) return <ForbiddenPanel permission="verification.read" role={session.role} resource="gig review" />;

  const raw = await searchParams;
  const flat = flattenSearchParams(raw);
  const params = parseListParams(raw);
  const [from, to] = rangeFor(params.page, params.pageSize);
  const tab = TABS.find((t) => t.key === flat.tab) ?? TABS[0]!;
  const isPending = tab.status === 'PENDING_REVIEW';

  const { data, error, count } = await session.db
    .from('worker_gigs')
    .select(
      'id, title, description, status, price_minor, currency, pricing_unit, estimated_duration_minutes, submitted_at, reviewed_at, rejection_reason, workers(id, full_name, worker_code), services(name)',
      { count: 'exact' },
    )
    .eq('status', tab.status)
    .order(isPending ? 'submitted_at' : 'reviewed_at', { ascending: isPending, nullsFirst: false })
    .range(from, to)
    .overrideTypes<GigQueueRow[]>();

  const canApprove = session.permissions.includes('verification.approve');
  const canReject = session.permissions.includes('verification.reject');

  const columns: Column<GigQueueRow>[] = [
    {
      key: 'gig',
      header: 'Gig',
      cell: (row) => (
        <div className="min-w-0">
          <p className="font-medium text-ink-900">{row.title}</p>
          {row.description && <p className="mt-0.5 line-clamp-2 text-xs text-ink-500">{row.description}</p>}
          {row.rejection_reason && <p className="mt-1 text-xs text-danger-600">{row.rejection_reason}</p>}
        </div>
      ),
    },
    {
      key: 'worker',
      header: 'Worker',
      cell: (row) =>
        row.workers ? (
          <Link href={adminRoutes.worker(row.workers.id)} className="hover:underline">
            <CellStack primary={row.workers.full_name} secondary={row.workers.worker_code} />
          </Link>
        ) : (
          'Unknown'
        ),
      hideBelow: 'md',
    },
    { key: 'service', header: 'Service', cell: (row) => row.services?.name ?? '—', hideBelow: 'lg' },
    {
      key: 'price',
      header: 'Price',
      cell: (row) => (
        <CellStack
          primary={formatMoney(row.price_minor, row.currency)}
          secondary={`${humaniseEnum(row.pricing_unit)} · ${row.estimated_duration_minutes} min`}
        />
      ),
      align: 'right',
    },
    {
      key: 'when',
      header: isPending ? 'Waiting' : 'Decided',
      cell: (row) => (isPending ? formatRelativeTime(row.submitted_at) : formatDate(row.reviewed_at)),
      align: 'right',
      hideBelow: 'sm',
    },
    isPending
      ? {
          key: 'actions',
          header: 'Decision',
          align: 'right',
          cell: (row) => (
            <div className="flex justify-end gap-2">
              {canApprove && (
                <ActionButton
                  endpoint={apiRoutes.adminGigDecision(row.id)}
                  payload={{ decision: 'APPROVE' }}
                  label="Approve"
                  variant="success"
                  tone="success"
                  confirmTitle={`Approve "${row.title}"?`}
                  confirmDescription="The gig goes live immediately and customers nearby can book it."
                  confirmLabel="Approve"
                  successMessage="Gig approved"
                />
              )}
              {canReject && (
                <ActionButton
                  endpoint={apiRoutes.adminGigDecision(row.id)}
                  payload={{ decision: 'REJECT' }}
                  label="Reject"
                  variant="outline"
                  tone="danger"
                  confirmTitle={`Reject "${row.title}"?`}
                  confirmDescription="The worker sees the reason in the app and can edit and resubmit."
                  confirmLabel="Reject"
                  requireReason
                  reasonLabel="Reason (shown to the worker)"
                  minReasonLength={5}
                  successMessage="Gig rejected"
                />
              )}
            </div>
          ),
        }
      : {
          key: 'status',
          header: 'Status',
          align: 'right',
          cell: (row) => <Badge tone={STATUS_TONES[row.status]}>{humaniseEnum(row.status)}</Badge>,
        },
  ];

  return (
    <>
      <PageHeader
        title="Gig review"
        description="Services workers publish. A gig stays hidden from customers until it is approved here."
      />

      <Card>
        <nav aria-label="Gig review tabs" className="scroll-x border-b border-ink-200">
          <ul className="flex min-w-max gap-1 px-3">
            {TABS.map((t) => (
              <li key={t.key}>
                <Link
                  href={`${adminRoutes.gigs()}?tab=${t.key}`}
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

        {error ? (
          <Alert tone="danger" className="m-4">The gigs could not be loaded. Refresh to try again.</Alert>
        ) : (
          <>
            <DataTable
              columns={columns}
              rows={data ?? []}
              rowKey={(row) => row.id}
              caption={`${tab.label} gigs`}
              empty={
                <EmptyState
                  icon={<ListChecks aria-hidden className="size-5" />}
                  title={isPending ? 'No gigs waiting for review' : `No ${tab.label.toLowerCase()} gigs`}
                  description={isPending ? 'Gigs workers publish from the app appear here.' : 'Gigs appear here once decided.'}
                />
              }
            />
            <Pagination page={params.page} pageSize={params.pageSize} total={count ?? 0} searchParams={flat} basePath={adminRoutes.gigs()} />
          </>
        )}
      </Card>
    </>
  );
}
