import 'server-only';

import type { AdminSession } from '@/lib/auth/admin-session';
import { logger } from '@/lib/logging/logger';
import { startOfPlatformDay } from '@/lib/utils/format';
import { ACTIVE_BOOKING_STATUSES } from '@/types/domain';

/**
 * Dashboard metrics.
 *
 * Two rules govern this module.
 *
 *   1. Every number is a real count from the database. A metric the operator
 *      cannot read is omitted entirely rather than shown as a placeholder, and
 *      a genuine zero is displayed as 0. Nothing is invented to make the
 *      dashboard look populated.
 *
 *   2. Counts are fetched with `head: true`, so Postgres returns the count
 *      without the rows. The dashboard never pulls records into the server just
 *      to call `.length` on them.
 *
 * Queries run through the operator's own RLS-scoped client, so a count can
 * never include rows they are not entitled to see.
 *
 * This module only counts. How each number is labelled, grouped and linked is
 * the dashboard page's business, and the page looks metrics up by `key` — the
 * order of `metrics` is whichever query finished first.
 */

export interface DashboardMetric {
  key: string;
  /** Used to name the metric if it fails to load. */
  label: string;
  value: number;
}

export interface DashboardStats {
  metrics: DashboardMetric[];
  /** Metrics that could not be loaded, so the UI can say so honestly. */
  failed: string[];
}

export async function loadDashboardStats(session: AdminSession): Promise<DashboardStats> {
  const { db, permissions } = session;
  const can = (permission: string) => permissions.includes(permission);

  const metrics: DashboardMetric[] = [];
  const failed: string[] = [];

  /** Run one count, recording a failure rather than throwing the page away. */
  const count = async (
    key: string,
    label: string,
    build: () => PromiseLike<{ count: number | null; error: { message: string } | null }>,
  ) => {
    try {
      const { count: value, error } = await build();

      if (error) {
        logger.error('Dashboard metric failed', { key, error: error.message });
        failed.push(label);
        return;
      }

      metrics.push({ key, label, value: value ?? 0 });
    } catch (error) {
      logger.error('Dashboard metric threw', {
        key,
        error: error instanceof Error ? error.message : 'unknown',
      });
      failed.push(label);
    }
  };

  // Midnight in India, not on the (UTC) server.
  const today = startOfPlatformDay();
  const tasks: Array<Promise<void>> = [];

  // ---- People ----------------------------------------------------------
  if (can('workers.read')) {
    tasks.push(
      count('workers.total', 'Total workers', () =>
        db.from('workers').select('*', { count: 'exact', head: true }),
      ),
      count(
        'workers.active',
        'Active workers',
        () =>
          db
            .from('workers')
            .select('*', { count: 'exact', head: true })
            .eq('status', 'ACTIVE'),
      ),
      count(
        'workers.pending',
        'Awaiting verification',
        () =>
          db
            .from('workers')
            .select('*', { count: 'exact', head: true })
            .eq('status', 'VERIFICATION_PENDING'),
      ),
    );
  }

  if (can('customers.read')) {
    tasks.push(
      count(
        'customers.active',
        'Active customers',
        () =>
          db
            .from('customers')
            .select('*', { count: 'exact', head: true })
            .eq('status', 'ACTIVE'),
      ),
    );
  }

  // ---- Verification ----------------------------------------------------
  if (can('verification.read')) {
    tasks.push(
      count(
        'verification.queue',
        'Verification queue',
        () =>
          db
            .from('worker_verifications')
            .select('*', { count: 'exact', head: true })
            .in('status', ['PENDING', 'UNDER_REVIEW', 'MORE_INFO_REQUIRED']),
      ),
      count(
        'verification.expired',
        'Expired verifications',
        () =>
          db
            .from('worker_verifications')
            .select('*', { count: 'exact', head: true })
            .eq('status', 'EXPIRED'),
      ),
    );
  }

  // ---- Operations ------------------------------------------------------
  if (can('bookings.read')) {
    tasks.push(
      count(
        'bookings.active',
        'Active jobs',
        () =>
          db
            .from('bookings')
            .select('*', { count: 'exact', head: true })
            .in('status', [...ACTIVE_BOOKING_STATUSES]),
      ),
      count('bookings.today', 'Jobs created today', () =>
        db
          .from('bookings')
          .select('*', { count: 'exact', head: true })
          .gte('created_at', today),
      ),
      count(
        'bookings.unmatched',
        'Awaiting a worker',
        () =>
          db
            .from('bookings')
            .select('*', { count: 'exact', head: true })
            .eq('status', 'REQUESTED'),
      ),
      count(
        'bookings.disputed',
        'Disputed jobs',
        () =>
          db
            .from('bookings')
            .select('*', { count: 'exact', head: true })
            .eq('status', 'DISPUTED'),
      ),
    );
  }

  // ---- Finance ---------------------------------------------------------
  if (can('payments.read')) {
    tasks.push(
      count(
        'payments.pending',
        'Payments in flight',
        () =>
          db
            .from('payments')
            .select('*', { count: 'exact', head: true })
            .in('status', ['PENDING', 'PROCESSING']),
      ),
      count(
        'payments.failed',
        'Failed payments',
        () =>
          db
            .from('payments')
            .select('*', { count: 'exact', head: true })
            .eq('status', 'FAILED'),
      ),
    );
  }

  if (can('payouts.read')) {
    tasks.push(
      count(
        'payouts.pending',
        'Payouts to review',
        () =>
          db
            .from('payouts')
            .select('*', { count: 'exact', head: true })
            .eq('status', 'REQUESTED'),
      ),
    );
  }

  // ---- Trust and safety ------------------------------------------------
  if (can('claims.read')) {
    tasks.push(
      count(
        'claims.open',
        'Open claims',
        () =>
          db
            .from('claims')
            .select('*', { count: 'exact', head: true })
            .in('status', ['SUBMITTED', 'UNDER_REVIEW', 'MORE_INFORMATION_REQUIRED']),
      ),
    );
  }

  if (can('support.read')) {
    tasks.push(
      count(
        'support.open',
        'Open tickets',
        () =>
          db
            .from('support_tickets')
            .select('*', { count: 'exact', head: true })
            .in('status', ['OPEN', 'IN_PROGRESS', 'WAITING_FOR_USER']),
      ),
      count(
        'support.unassigned',
        'Unassigned tickets',
        () =>
          db
            .from('support_tickets')
            .select('*', { count: 'exact', head: true })
            .is('assigned_admin_id', null)
            .in('status', ['OPEN', 'IN_PROGRESS']),
      ),
    );
  }

  // One round of parallel counts rather than a waterfall.
  await Promise.all(tasks);

  return { metrics, failed };
}
