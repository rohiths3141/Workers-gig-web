import type { Metadata } from 'next';
import { LifeBuoy } from 'lucide-react';

import { ForbiddenPanel, PageHeader } from '@/components/admin/page-parts';
import { StatusBadge } from '@/components/shared/status-badge';
import { Badge, type BadgeTone } from '@/components/ui/badge';
import { Card } from '@/components/ui/card';
import { CellStack, DataTable, type Column } from '@/components/ui/data-table';
import { Alert, EmptyState } from '@/components/ui/feedback';
import { ClearFilters, FilterBar, FilterSelect, SearchInput } from '@/components/ui/filter-bar';
import { Pagination } from '@/components/ui/pagination';
import { asEnumValue, countActiveFilters, flattenSearchParams, parseListParams, rangeFor, sanitiseSearchTerm, type RawSearchParams } from '@/lib/api/list-params';
import { guardPage } from '@/lib/auth/page-guard';
import { adminRoutes } from '@/lib/config/routes';
import { formatRelativeTime, humaniseEnum } from '@/lib/utils/format';
import { SupportCategory, SupportPriority, SupportStatus } from '@/types/domain';
import type { SupportTicketRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Support' };
export const dynamic = 'force-dynamic';

type TicketRow = SupportTicketRow & {
  customers: { full_name: string } | null;
  workers: { full_name: string } | null;
};

const PRIORITY_TONES: Record<string, BadgeTone> = { LOW: 'neutral', MEDIUM: 'info', HIGH: 'warning', URGENT: 'danger' };

export default async function SupportPage({ searchParams }: { searchParams: Promise<RawSearchParams> }) {
  const { session, allowed } = await guardPage('support.read', adminRoutes.support());
  if (!allowed) return <ForbiddenPanel permission="support.read" role={session.role} resource="support" />;

  const raw = await searchParams;
  const flat = flattenSearchParams(raw);
  const params = parseListParams(raw);
  const [from, to] = rangeFor(params.page, params.pageSize);

  let query = session.db.from('support_tickets').select('*, customers(full_name), workers(full_name)', { count: 'exact' });

  const term = sanitiseSearchTerm(params.q);
  if (term) query = query.or(`ticket_code.ilike.%${term}%,subject.ilike.%${term}%`);
  const status = asEnumValue(flat.status, SupportStatus);
  if (status) query = query.eq('status', status);
  else if (!flat.status) query = query.in('status', [SupportStatus.OPEN, SupportStatus.IN_PROGRESS, SupportStatus.WAITING_FOR_USER]);
  const priority = asEnumValue(flat.priority, SupportPriority);
  if (priority) query = query.eq('priority', priority);
  const category = asEnumValue(flat.category, SupportCategory);
  if (category) query = query.eq('category', category);
  if (flat.mine === 'true') query = query.eq('assigned_admin_id', session.adminId);

  const { data, error, count } = await query.order('last_message_at', { ascending: false }).range(from, to).overrideTypes<TicketRow[]>();

  const columns: ReadonlyArray<Column<TicketRow>> = [
    { key: 'ticket', header: 'Ticket', cell: (row) => <CellStack primary={row.subject} secondary={row.ticket_code} /> },
    { key: 'requester', header: 'Requester', cell: (row) => <CellStack primary={row.customers?.full_name ?? row.workers?.full_name ?? '—'} secondary={humaniseEnum(row.requester_type)} />, hideBelow: 'md' },
    { key: 'category', header: 'Category', cell: (row) => humaniseEnum(row.category), hideBelow: 'lg' },
    { key: 'priority', header: 'Priority', cell: (row) => <Badge tone={PRIORITY_TONES[row.priority] ?? 'neutral'}>{humaniseEnum(row.priority)}</Badge>, hideBelow: 'sm' },
    { key: 'assigned', header: 'Assigned', cell: (row) => (row.assigned_admin_id ? (row.assigned_admin_id === session.adminId ? 'You' : 'Assigned') : <span className="text-warning-700">Unassigned</span>), hideBelow: 'lg' },
    { key: 'status', header: 'Status', cell: (row) => <StatusBadge kind="support" status={row.status} /> },
    { key: 'activity', header: 'Last activity', cell: (row) => formatRelativeTime(row.last_message_at), align: 'right', hideBelow: 'xl' },
  ];

  const active = countActiveFilters(flat, ['q', 'status', 'priority', 'category', 'mine']);

  return (
    <>
      <PageHeader title="Support" description="Tickets from customers and workers. Open tickets are shown by default." />
      <Card>
        <FilterBar>
          <SearchInput label="Search tickets" placeholder="Ticket code or subject" className="w-full sm:w-64" />
          <FilterSelect paramName="status" label="Filter by status" allLabel="Open tickets" options={Object.values(SupportStatus).map((value) => ({ value, label: humaniseEnum(value) }))} />
          <FilterSelect paramName="priority" label="Filter by priority" allLabel="Any priority" options={Object.values(SupportPriority).map((value) => ({ value, label: humaniseEnum(value) }))} />
          <FilterSelect paramName="category" label="Filter by category" allLabel="All categories" options={Object.values(SupportCategory).map((value) => ({ value, label: humaniseEnum(value) }))} />
          <FilterSelect paramName="mine" label="Assignment" allLabel="Anyone" options={[{ value: 'true', label: 'Assigned to me' }]} />
          <ClearFilters activeCount={active} />
        </FilterBar>
        {error ? (
          <Alert tone="danger" className="m-4">Tickets could not be loaded.</Alert>
        ) : (
          <>
            <DataTable columns={columns} rows={data ?? []} rowKey={(row) => row.id} rowHref={(row) => adminRoutes.supportTicket(row.id)} caption="Support tickets" empty={<EmptyState icon={<LifeBuoy aria-hidden className="size-5" />} title={active > 0 ? 'No tickets match these filters' : 'No support tickets'} description="Customers and workers raise tickets from the apps." />} />
            <Pagination page={params.page} pageSize={params.pageSize} total={count ?? 0} searchParams={flat} basePath={adminRoutes.support()} />
          </>
        )}
      </Card>
    </>
  );
}
