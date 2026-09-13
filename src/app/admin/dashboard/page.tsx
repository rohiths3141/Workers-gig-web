import type { Metadata } from 'next';
import { Suspense } from 'react';
import Link from 'next/link';
import { ArrowRight, Inbox } from 'lucide-react';

import { PageHeader, StatCard } from '@/components/admin/page-parts';
import { StatusBadge } from '@/components/shared/status-badge';
import { Card, CardHeader } from '@/components/ui/card';
import { CellStack, DataTable, type Column } from '@/components/ui/data-table';
import { Alert, EmptyState, Skeleton } from '@/components/ui/feedback';
import { guardPage } from '@/lib/auth/page-guard';
import { adminRoutes } from '@/lib/config/routes';
import { loadDashboardStats } from '@/features/dashboard/server/dashboard-stats';
import { formatNumber, formatRelativeTime } from '@/lib/utils/format';
import type { AdminSession } from '@/lib/auth/admin-session';
import type { BookingRow, WorkerVerificationRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Dashboard' };
export const dynamic = 'force-dynamic';

/**
 * Operational dashboard.
 *
 * Every tile answers a question an operator would otherwise have to go looking
 * for: what needs a decision, what is stuck, what failed. There are no
 * decorative charts, and no metric appears unless there is a real count behind
 * it that this operator is permitted to see.
 */
export default async function DashboardPage() {
  const { session } = await guardPage('services.read', adminRoutes.dashboard());

  return (
    <>
      <PageHeader
        title={`Good ${timeOfDay()}, ${session.fullName.split(' ')[0]}`}
        description="Everything currently waiting on an operator, and the state of jobs in flight."
      />

      <Suspense fallback={<MetricsSkeleton />}>
        <Metrics session={session} />
      </Suspense>

      <div className="mt-6 grid gap-5 xl:grid-cols-2">
        {session.permissions.includes('verification.read') && (
          <Suspense fallback={<PanelSkeleton title="Verification queue" />}>
            <VerificationQueuePanel session={session} />
          </Suspense>
        )}

        {session.permissions.includes('bookings.read') && (
          <Suspense fallback={<PanelSkeleton title="Jobs needing attention" />}>
            <AttentionBookingsPanel session={session} />
          </Suspense>
        )}
      </div>
    </>
  );
}

/* ==========================================================================
   Metrics
   ========================================================================== */

async function Metrics({ session }: { session: AdminSession }) {
  const { metrics, failed } = await loadDashboardStats(session);

  if (metrics.length === 0 && failed.length === 0) {
    return (
      <Card>
        <EmptyState
          icon={<Inbox aria-hidden className="size-5" />}
          title="No metrics available for your role"
          description="Your permissions do not currently include any of the dashboard metrics. Use the navigation to open the sections you do have access to."
        />
      </Card>
    );
  }

  return (
    <>
      {failed.length > 0 && (
        <Alert tone="warning" title="Some metrics could not be loaded" className="mb-4">
          {failed.join(', ')}. The figures below exclude them — they are not zero, they are
          unknown. Refresh to try again.
        </Alert>
      )}

      <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
        {metrics.map((metric) => (
          <StatCard
            key={metric.key}
            label={metric.label}
            value={formatNumber(metric.value)}
            hint={metric.hint}
            tone={metric.value === 0 ? 'neutral' : metric.tone}
            href={metric.href}
          />
        ))}
      </div>
    </>
  );
}

/* ==========================================================================
   Verification queue
   ========================================================================== */

type QueueRow = Pick<
  WorkerVerificationRow,
  'id' | 'worker_id' | 'type' | 'status' | 'submitted_at'
> & {
  workers: { full_name: string; worker_code: string } | null;
};

async function VerificationQueuePanel({ session }: { session: AdminSession }) {
  const { data, error } = await session.db
    .from('worker_verifications')
    .select('id, worker_id, type, status, submitted_at, workers(full_name, worker_code)')
    .in('status', ['PENDING', 'UNDER_REVIEW', 'MORE_INFO_REQUIRED'])
    .order('submitted_at', { ascending: true, nullsFirst: false })
    .limit(6)
    .overrideTypes<QueueRow[]>();

  const columns: ReadonlyArray<Column<QueueRow>> = [
    {
      key: 'worker',
      header: 'Worker',
      cell: (row) => (
        <CellStack
          primary={row.workers?.full_name ?? 'Unknown worker'}
          secondary={row.workers?.worker_code}
        />
      ),
    },
    {
      key: 'type',
      header: 'Document',
      cell: (row) => <span className="text-ink-700">{verificationLabel(row.type)}</span>,
      hideBelow: 'sm',
    },
    {
      key: 'status',
      header: 'Status',
      cell: (row) => <StatusBadge kind="verification" status={row.status} />,
    },
    {
      key: 'waiting',
      header: 'Waiting',
      cell: (row) => (
        <span className="text-ink-500">{formatRelativeTime(row.submitted_at)}</span>
      ),
      align: 'right',
      hideBelow: 'md',
    },
  ];

  return (
    <Card>
      <CardHeader
        title="Verification queue"
        description="Oldest submissions first"
        actions={
          <Link
            href={adminRoutes.verification()}
            className="inline-flex items-center gap-1 text-sm font-medium text-brand-700 hover:text-brand-800"
          >
            Open queue
            <ArrowRight aria-hidden className="size-4" />
          </Link>
        }
      />

      {error ? (
        <Alert tone="danger" className="m-4">
          The verification queue could not be loaded.
        </Alert>
      ) : (
        <DataTable
          columns={columns}
          rows={data ?? []}
          rowKey={(row) => row.id}
          rowHref={(row) => adminRoutes.verificationCase(row.id)}
          caption="Verification cases awaiting a decision"
          empty={
            <EmptyState
              title="Nothing waiting for review"
              description="Every submitted verification case has been decided."
            />
          }
        />
      )}
    </Card>
  );
}

/* ==========================================================================
   Jobs needing attention
   ========================================================================== */

type AttentionRow = Pick<
  BookingRow,
  'id' | 'booking_code' | 'status' | 'created_at' | 'city'
> & {
  services: { name: string } | null;
};

async function AttentionBookingsPanel({ session }: { session: AdminSession }) {
  // Requested (nobody accepted yet) and disputed (needs a human decision) are
  // the two states where a job stops moving without an operator.
  const { data, error } = await session.db
    .from('bookings')
    .select('id, booking_code, status, created_at, city, services(name)')
    .in('status', ['REQUESTED', 'DISPUTED', 'PAYMENT_PENDING'])
    .order('created_at', { ascending: true })
    .limit(6)
    .overrideTypes<AttentionRow[]>();

  const columns: ReadonlyArray<Column<AttentionRow>> = [
    {
      key: 'booking',
      header: 'Booking',
      cell: (row) => (
        <CellStack primary={row.booking_code} secondary={row.services?.name ?? undefined} />
      ),
    },
    {
      key: 'status',
      header: 'Status',
      cell: (row) => <StatusBadge kind="booking" status={row.status} />,
    },
    {
      key: 'city',
      header: 'City',
      cell: (row) => <span className="text-ink-600">{row.city ?? '—'}</span>,
      hideBelow: 'md',
    },
    {
      key: 'age',
      header: 'Raised',
      cell: (row) => <span className="text-ink-500">{formatRelativeTime(row.created_at)}</span>,
      align: 'right',
      hideBelow: 'sm',
    },
  ];

  return (
    <Card>
      <CardHeader
        title="Jobs needing attention"
        description="Unmatched, disputed, or waiting on payment"
        actions={
          <Link
            href={adminRoutes.bookings()}
            className="inline-flex items-center gap-1 text-sm font-medium text-brand-700 hover:text-brand-800"
          >
            All bookings
            <ArrowRight aria-hidden className="size-4" />
          </Link>
        }
      />

      {error ? (
        <Alert tone="danger" className="m-4">
          Bookings could not be loaded.
        </Alert>
      ) : (
        <DataTable
          columns={columns}
          rows={data ?? []}
          rowKey={(row) => row.id}
          rowHref={(row) => adminRoutes.booking(row.id)}
          caption="Bookings requiring operator attention"
          empty={
            <EmptyState
              title="Nothing stuck"
              description="No bookings are unmatched, disputed, or waiting on payment."
            />
          }
        />
      )}
    </Card>
  );
}

/* ==========================================================================
   Helpers
   ========================================================================== */

function MetricsSkeleton() {
  return (
    <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
      {Array.from({ length: 8 }).map((_, index) => (
        <div key={index} className="rounded-xl border border-ink-200 bg-white p-4">
          <Skeleton className="h-3 w-24" />
          <Skeleton className="mt-3 h-7 w-16" />
          <Skeleton className="mt-2 h-3 w-32" />
        </div>
      ))}
    </div>
  );
}

function PanelSkeleton({ title }: { title: string }) {
  return (
    <Card>
      <CardHeader title={title} />
      <div className="space-y-3 p-4">
        {Array.from({ length: 5 }).map((_, index) => (
          <Skeleton key={index} className="h-10 w-full" />
        ))}
      </div>
    </Card>
  );
}

function timeOfDay(): string {
  const hour = new Date().getHours();
  if (hour < 12) return 'morning';
  if (hour < 17) return 'afternoon';
  return 'evening';
}

const VERIFICATION_LABELS: Record<string, string> = {
  IDENTITY_KYC: 'Identity (KYC)',
  ADDRESS: 'Address',
  ITI_CERTIFICATE: 'ITI certificate',
  DIPLOMA: 'Diploma',
  RPL_SKILL: 'RPL skill assessment',
  BACKGROUND_CHECK: 'Background check',
  INSURANCE: 'Insurance',
  BANK_ACCOUNT: 'Bank account',
};

function verificationLabel(type: string): string {
  return VERIFICATION_LABELS[type] ?? type;
}
