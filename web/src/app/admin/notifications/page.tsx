import type { Metadata } from 'next';
import { Bell } from 'lucide-react';

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
import { formatDateTime, humaniseEnum } from '@/lib/utils/format';
import { NotificationChannel, NotificationStatus } from '@/types/domain';
import type { NotificationRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Notifications' };
export const dynamic = 'force-dynamic';

/**
 * Notification delivery log.
 *
 * Read-only. A status beyond QUEUED is written only by the delivery worker from
 * provider evidence; DELIVERED requires a provider message id, enforced by a
 * database constraint. Nothing here can mark a message delivered.
 */
export default async function NotificationsPage({ searchParams }: { searchParams: Promise<RawSearchParams> }) {
  const { session, allowed } = await guardPage('notifications.read', adminRoutes.notifications());
  if (!allowed) return <ForbiddenPanel permission="notifications.read" role={session.role} resource="notifications" />;

  const raw = await searchParams;
  const flat = flattenSearchParams(raw);
  const params = parseListParams(raw);
  const [from, to] = rangeFor(params.page, params.pageSize);

  let query = session.db.from('notifications').select('*', { count: 'exact' });
  const channel = asEnumValue(flat.channel, NotificationChannel);
  if (channel) query = query.eq('channel', channel);
  const status = asEnumValue(flat.status, NotificationStatus);
  if (status) query = query.eq('status', status);

  const { data, error, count } = await query.order('created_at', { ascending: false }).range(from, to);

  const columns: ReadonlyArray<Column<NotificationRow>> = [
    { key: 'notification', header: 'Notification', cell: (row) => <CellStack primary={row.title} secondary={row.template_key} /> },
    { key: 'recipient', header: 'Recipient', cell: (row) => humaniseEnum(row.recipient_type), hideBelow: 'md' },
    { key: 'channel', header: 'Channel', cell: (row) => humaniseEnum(row.channel) },
    { key: 'status', header: 'Delivery status', cell: (row) => <StatusBadge kind="notification" status={row.status} /> },
    { key: 'sent', header: 'Sent', cell: (row) => formatDateTime(row.sent_at), hideBelow: 'lg' },
    { key: 'delivered', header: 'Delivered', cell: (row) => formatDateTime(row.delivered_at), hideBelow: 'xl' },
    { key: 'failure', header: 'Failure', cell: (row) => (row.failure_reason ? <span className="block max-w-56 truncate text-xs text-danger-600" title={row.failure_reason}>{row.failure_reason}</span> : '—'), hideBelow: 'xl' },
    { key: 'attempts', header: 'Attempts', cell: (row) => row.attempt_count, align: 'right', numeric: true, hideBelow: 'lg' },
  ];

  return (
    <>
      <PageHeader title="Notifications" description="Push, SMS, email and in-app notifications, with delivery status reported by the provider." />
      <Card>
        <FilterBar>
          <FilterSelect paramName="channel" label="Filter by channel" allLabel="All channels" options={Object.values(NotificationChannel).map((value) => ({ value, label: humaniseEnum(value) }))} />
          <FilterSelect paramName="status" label="Filter by status" allLabel="All statuses" options={Object.values(NotificationStatus).map((value) => ({ value, label: humaniseEnum(value) }))} />
          <ClearFilters activeCount={countActiveFilters(flat, ['channel', 'status'])} />
        </FilterBar>
        {error ? (
          <Alert tone="danger" className="m-4">Notifications could not be loaded.</Alert>
        ) : (
          <>
            <DataTable columns={columns} rows={data ?? []} rowKey={(row) => row.id} caption="Notification delivery log" empty={<EmptyState icon={<Bell aria-hidden className="size-5" />} title="No notifications" description="Notifications are queued by backend events such as booking and payment updates." />} />
            <Pagination page={params.page} pageSize={params.pageSize} total={count ?? 0} searchParams={flat} basePath={adminRoutes.notifications()} />
          </>
        )}
      </Card>
    </>
  );
}
