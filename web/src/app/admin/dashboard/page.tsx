import type { Metadata } from 'next';
import { Suspense } from 'react';
import Link from 'next/link';
import {
  ArrowRight,
  Briefcase,
  CalendarX,
  CircleDollarSign,
  ClipboardList,
  HandCoins,
  Hourglass,
  Inbox,
  LifeBuoy,
  Scale,
  ShieldAlert,
  ShieldCheck,
  Users,
} from 'lucide-react';

import {
  AttentionPanel,
  KpiCard,
  type AttentionItem,
  type Kpi,
} from '@/components/admin/dashboard-overview';
import { PageHeader } from '@/components/admin/page-parts';
import { StatusBadge } from '@/components/shared/status-badge';
import { Card, CardHeader } from '@/components/ui/card';
import { CellStack, DataTable, type Column } from '@/components/ui/data-table';
import { Alert, EmptyState, Skeleton } from '@/components/ui/feedback';
import { guardPage } from '@/lib/auth/page-guard';
import { adminRoutes } from '@/lib/config/routes';
import { loadDashboardStats } from '@/features/dashboard/server/dashboard-stats';
import {
  formatNumber,
  formatRelativeTime,
  platformHour,
  PLATFORM_TIME_ZONE,
} from '@/lib/utils/format';
import type { AdminSession } from '@/lib/auth/admin-session';
import type { BookingRow, WorkerVerificationRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Dashboard' };
export const dynamic = 'force-dynamic';

/**
 * Operational dashboard, in three bands:
 *
 *   1. At a glance — one card per area (jobs, workers, customers, payments),
 *      each a headline figure with the figures that explain it.
 *   2. Needs attention — only the queues that have something in them, most
 *      urgent first; empty queues collapse into one "all clear" line.
 *   3. The oldest verification cases and stuck jobs, row by row.
 *
 * Every number links to the list it counts. No metric appears unless there is
 * a real count behind it that this operator is permitted to see.
 */
export default async function DashboardPage() {
  const { session } = await guardPage('services.read', adminRoutes.dashboard());

  return (
    <>
      <PageHeader
        title={`Good ${timeOfDay()}, ${session.fullName.split(' ')[0]}`}
        description={`${todayLabel()} · What is waiting on you, and how the platform is doing.`}
      />

      <Suspense fallback={<OverviewSkeleton />}>
        <Overview session={session} />
      </Suspense>

      <div className="mt-5 grid gap-5 xl:grid-cols-2">
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
   At a glance + needs attention
   ========================================================================== */

async function Overview({ session }: { session: AdminSession }) {
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

  const value = new Map(metrics.map((metric) => [metric.key, metric.value]));
  const kpis = buildKpis(value);
  const attention = buildAttention(value);

  return (
    <>
      {failed.length > 0 && (
        <Alert tone="warning" title="Some metrics could not be loaded" className="mb-4">
          {failed.join(', ')}. The figures below exclude them — they are not zero, they are
          unknown. Refresh to try again.
        </Alert>
      )}

      {kpis.length > 0 && (
        <div className="grid grid-cols-2 gap-3 sm:gap-4 xl:grid-cols-4">
          {kpis.map((kpi) => (
            <KpiCard key={kpi.key} kpi={kpi} />
          ))}
        </div>
      )}

      {attention.length > 0 && (
        <div className="mt-5">
          <AttentionPanel items={attention} />
        </div>
      )}
    </>
  );
}

/** The headline cards. An area is left out when its main count is unavailable. */
function buildKpis(value: Map<string, number>): Kpi[] {
  const kpis: Kpi[] = [];

  const activeJobs = value.get('bookings.active');
  if (activeJobs !== undefined) {
    const today = value.get('bookings.today');
    kpis.push({
      key: 'jobs',
      label: 'Active jobs',
      icon: ClipboardList,
      href: adminRoutes.bookings(),
      value: activeJobs,
      detail: today !== undefined ? `${formatNumber(today)} created today` : undefined,
    });
  }

  const activeWorkers = value.get('workers.active');
  if (activeWorkers !== undefined) {
    const total = value.get('workers.total');
    const pending = value.get('workers.pending');
    kpis.push({
      key: 'workers',
      label: 'Active workers',
      icon: Briefcase,
      href: `${adminRoutes.workers()}?status=ACTIVE`,
      value: activeWorkers,
      suffix: total !== undefined ? `of ${formatNumber(total)}` : undefined,
      ratio: total ? activeWorkers / total : undefined,
      detail:
        pending !== undefined ? `${formatNumber(pending)} awaiting verification` : undefined,
    });
  }

  const activeCustomers = value.get('customers.active');
  if (activeCustomers !== undefined) {
    kpis.push({
      key: 'customers',
      label: 'Active customers',
      icon: Users,
      href: `${adminRoutes.customers()}?status=ACTIVE`,
      value: activeCustomers,
      detail: 'Accounts in good standing',
    });
  }

  const paymentsInProgress = value.get('payments.pending');
  if (paymentsInProgress !== undefined) {
    kpis.push({
      key: 'payments',
      label: 'Payments in progress',
      icon: CircleDollarSign,
      href: adminRoutes.payments(),
      value: paymentsInProgress,
      detail: 'Pending or processing',
    });
  }

  return kpis;
}

/**
 * Every queue that can need an operator. Warning: work to get through. Danger:
 * something failed or is contested.
 */
const ATTENTION: ReadonlyArray<Omit<AttentionItem, 'count'>> = [
  {
    key: 'bookings.unmatched',
    label: 'Jobs waiting for a worker',
    hint: 'Requested, and nobody has accepted yet',
    icon: Hourglass,
    href: `${adminRoutes.bookings()}?status=REQUESTED`,
    clearLabel: 'No jobs waiting for a worker',
    tone: 'warning',
  },
  {
    key: 'verification.queue',
    label: 'Verification cases to decide',
    hint: 'Identity, qualification and background checks',
    icon: ShieldCheck,
    href: adminRoutes.verification(),
    clearLabel: 'Verification queue empty',
    tone: 'warning',
  },
  {
    key: 'payouts.pending',
    label: 'Payouts to approve',
    hint: 'Workers asking to withdraw their earnings',
    icon: HandCoins,
    href: adminRoutes.payouts(),
    clearLabel: 'No payouts to approve',
    tone: 'warning',
  },
  {
    key: 'support.open',
    label: 'Open support tickets',
    icon: LifeBuoy,
    href: adminRoutes.support(),
    clearLabel: 'No open tickets',
    tone: 'warning',
  },
  {
    key: 'bookings.disputed',
    label: 'Disputed jobs',
    hint: 'A customer or worker has raised a dispute',
    icon: Scale,
    href: `${adminRoutes.bookings()}?status=DISPUTED`,
    clearLabel: 'No disputed jobs',
    tone: 'danger',
  },
  {
    key: 'payments.failed',
    label: 'Failed payments',
    hint: 'Customer payments that did not go through',
    icon: CircleDollarSign,
    href: `${adminRoutes.payments()}?status=FAILED`,
    clearLabel: 'No failed payments',
    tone: 'danger',
  },
  {
    key: 'claims.open',
    label: 'Open damage claims',
    hint: 'Waiting for a review decision',
    icon: ShieldAlert,
    href: adminRoutes.claims(),
    clearLabel: 'No open claims',
    tone: 'danger',
  },
  {
    key: 'verification.expired',
    label: 'Expired verifications',
    hint: 'The worker must renew before taking jobs',
    icon: CalendarX,
    href: `${adminRoutes.verification()}?tab=expired`,
    clearLabel: 'No expired verifications',
    tone: 'danger',
  },
];

function buildAttention(value: Map<string, number>): AttentionItem[] {
  const unassigned = value.get('support.unassigned');

  return ATTENTION.flatMap((item) => {
    const count = value.get(item.key);
    if (count === undefined) return [];

    if (item.key === 'support.open' && unassigned !== undefined) {
      return [{ ...item, count, hint: `${formatNumber(unassigned)} not yet assigned` }];
    }
    return [{ ...item, count }];
  });
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

function OverviewSkeleton() {
  return (
    <>
      <div className="grid grid-cols-2 gap-3 sm:gap-4 xl:grid-cols-4">
        {Array.from({ length: 4 }).map((_, index) => (
          <div key={index} className="rounded-xl border border-ink-200 bg-white p-4 sm:p-5">
            <Skeleton className="size-9 rounded-lg" />
            <Skeleton className="mt-4 h-3.5 w-24" />
            <Skeleton className="mt-2 h-8 w-16" />
            <Skeleton className="mt-3 h-3 w-32" />
          </div>
        ))}
      </div>
      <Card className="mt-5">
        <CardHeader title="Needs attention" />
        <div className="grid gap-3 p-4 md:grid-cols-2">
          {Array.from({ length: 4 }).map((_, index) => (
            <Skeleton key={index} className="h-18 w-full" />
          ))}
        </div>
      </Card>
    </>
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

/** Greeting period in Indian time; the server clock is UTC. */
function timeOfDay(): string {
  const hour = platformHour();
  if (hour < 12) return 'morning';
  if (hour < 17) return 'afternoon';
  return 'evening';
}

/** e.g. "Thursday, 25 September", in Indian time. */
function todayLabel(): string {
  return new Intl.DateTimeFormat('en-IN', {
    weekday: 'long',
    day: 'numeric',
    month: 'long',
    timeZone: PLATFORM_TIME_ZONE,
  }).format(new Date());
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
