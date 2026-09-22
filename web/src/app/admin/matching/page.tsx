import type { Metadata } from 'next';
import Link from 'next/link';
import { Target } from 'lucide-react';

import { ActionButton } from '@/components/admin/action-button';
import { ForbiddenPanel, PageHeader, PermissionGuard } from '@/components/admin/page-parts';
import { StatusBadge } from '@/components/shared/status-badge';
import { Badge } from '@/components/ui/badge';
import { Card, CardHeader } from '@/components/ui/card';
import { CellStack, DataTable, type Column } from '@/components/ui/data-table';
import { Alert, EmptyState } from '@/components/ui/feedback';
import { flattenSearchParams, type RawSearchParams } from '@/lib/api/list-params';
import { guardPage } from '@/lib/auth/page-guard';
import { adminRoutes, apiRoutes } from '@/lib/config/routes';
import { cn } from '@/lib/utils/cn';
import { formatDistanceKm, formatRelativeTime, formatScore } from '@/lib/utils/format';
import type { BookingMatchCandidateRow, BookingRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Matching' };
export const dynamic = 'force-dynamic';

type OpenBooking = Pick<BookingRow, 'id' | 'booking_code' | 'status' | 'city' | 'created_at'> & {
  services: { name: string } | null;
  booking_match_candidates: Array<{ id: string }> | null;
};

type CandidateRow = BookingMatchCandidateRow & {
  workers: { id: string; full_name: string; worker_code: string } | null;
};

/**
 * Matching console.
 *
 * Shows the candidates the server-side engine produced and the score behind
 * each factor, so an operator can see why a worker ranked where they did. The
 * scores are read-only here; the only action is asking the engine to run
 * again against current database state.
 */
export default async function MatchingPage({ searchParams }: { searchParams: Promise<RawSearchParams> }) {
  const { session, allowed } = await guardPage('matching.read', adminRoutes.matching());
  if (!allowed) return <ForbiddenPanel permission="matching.read" role={session.role} resource="matching" />;

  const flat = flattenSearchParams(await searchParams);
  const selectedId = flat.booking && /^[0-9a-f-]{36}$/i.test(flat.booking) ? flat.booking : undefined;

  const { data: open, error } = await session.db
    .from('bookings')
    .select('id, booking_code, status, city, created_at, services(name), booking_match_candidates(id)')
    .in('status', ['REQUESTED', 'ACCEPTED'])
    .order('created_at', { ascending: true })
    .limit(50)
    .overrideTypes<OpenBooking[]>();

  const selected = selectedId ?? open?.[0]?.id;

  const { data: candidates } = selected
    ? await session.db
        .from('booking_match_candidates')
        .select('*, workers(id, full_name, worker_code)')
        .eq('booking_id', selected)
        .order('rank', { ascending: true })
        .overrideTypes<CandidateRow[]>()
    : { data: null };

  const factor = (label: string, pick: (row: CandidateRow) => number): Column<CandidateRow> => ({
    key: label,
    header: label,
    cell: (row) => <ScoreCell value={pick(row)} />,
    align: 'right',
    numeric: true,
    hideBelow: 'lg',
  });

  const columns: ReadonlyArray<Column<CandidateRow>> = [
    { key: 'rank', header: '#', cell: (row) => row.rank, numeric: true, width: 'w-10' },
    {
      key: 'worker',
      header: 'Candidate',
      cell: (row) =>
        row.workers ? (
          <Link href={adminRoutes.worker(row.workers.id)} className="hover:text-brand-700">
            <CellStack primary={row.workers.full_name} secondary={row.workers.worker_code} />
          </Link>
        ) : (
          'Unknown'
        ),
    },
    { key: 'distance', header: 'Distance', cell: (row) => formatDistanceKm(row.distance_km), align: 'right', numeric: true },
    factor('Trade', (r) => r.trade_match_score),
    factor('Skill', (r) => r.skill_score),
    factor('Qualification', (r) => r.qualification_score),
    factor('KYC', (r) => r.kyc_score),
    factor('BGV', (r) => r.background_score),
    factor('Insurance', (r) => r.insurance_score),
    factor('Availability', (r) => r.availability_score),
    { key: 'total', header: 'Overall', cell: (row) => <span className="font-semibold text-ink-900">{formatScore(row.total_score)}</span>, align: 'right', numeric: true },
    {
      key: 'response',
      header: 'Offer',
      cell: (row) => (row.response ? <Badge tone={row.response === 'ACCEPTED' ? 'success' : 'neutral'}>{row.response.toLowerCase()}</Badge> : row.was_offered ? <Badge tone="info">Offered</Badge> : <span className="text-ink-400">Not offered</span>),
      align: 'right',
      hideBelow: 'md',
    },
  ];

  const selectedBooking = open?.find((b) => b.id === selected);

  return (
    <>
      <PageHeader
        title="Matching"
        description="Candidates are scored by the server from verified database state. Identity and background verification are hard requirements, not scored preferences."
      />

      {error && <Alert tone="danger" className="mb-4">Open bookings could not be loaded.</Alert>}

      <div className="grid gap-5 xl:grid-cols-4">
        <Card className="xl:col-span-1">
          <CardHeader title="Awaiting a worker" description="Oldest first" />
          {open && open.length > 0 ? (
            <ul className="max-h-[36rem] divide-y divide-ink-100 overflow-y-auto">
              {open.map((b) => (
                <li key={b.id}>
                  <Link
                    href={`${adminRoutes.matching()}?booking=${b.id}`}
                    aria-current={b.id === selected ? 'true' : undefined}
                    className={cn('block px-4 py-3 text-sm hover:bg-brand-50/40', b.id === selected && 'bg-brand-50')}
                  >
                    <span className="flex items-center justify-between gap-2">
                      <span className="font-medium text-ink-900">{b.booking_code}</span>
                      <span className="text-xs text-ink-500">{b.booking_match_candidates?.length ?? 0} candidates</span>
                    </span>
                    <span className="mt-0.5 block text-xs text-ink-500">
                      {b.services?.name} · {b.city ?? 'No city'} · {formatRelativeTime(b.created_at)}
                    </span>
                  </Link>
                </li>
              ))}
            </ul>
          ) : (
            <EmptyState title="Nothing to match" description="No bookings are waiting for a worker." />
          )}
        </Card>

        <Card className="xl:col-span-3">
          <CardHeader
            title={selectedBooking ? `Candidates for ${selectedBooking.booking_code}` : 'Candidates'}
            description={selectedBooking ? <StatusBadge kind="booking" status={selectedBooking.status} /> : undefined}
            actions={
              selected && (
                <PermissionGuard permissions={session.permissions} required="matching.rerun">
                  <ActionButton
                    endpoint={apiRoutes.adminMatching(selected)}
                    payload={{}}
                    label="Re-run matching"
                    variant="outline"
                    confirmTitle="Re-run the matching engine?"
                    confirmDescription="Candidates that have not been offered the job are rescored from current verification, availability, rating and distance. Offers already made are kept."
                    confirmLabel="Re-run"
                    successMessage="Matching re-run"
                  />
                </PermissionGuard>
              )
            }
          />
          {!selected ? (
            <EmptyState icon={<Target aria-hidden className="size-5" />} title="Select a booking" description="Choose a booking on the left to see its candidates." />
          ) : (
            <DataTable
              columns={columns}
              rows={candidates ?? []}
              rowKey={(row) => row.id}
              caption="Match candidates with factor scores"
              empty={
                <EmptyState
                  icon={<Target aria-hidden className="size-5" />}
                  title="No eligible candidates"
                  description="No active, identity- and background-verified worker with this trade is within range. Re-run matching after more workers are verified or become available."
                />
              }
            />
          )}
        </Card>
      </div>
    </>
  );
}

function ScoreCell({ value }: { value: number }) {
  return (
    <span className={cn(value >= 0.8 ? 'text-success-700' : value >= 0.4 ? 'text-ink-700' : 'text-danger-600')}>
      {formatScore(value)}
    </span>
  );
}
