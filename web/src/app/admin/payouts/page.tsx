import type { Metadata } from 'next';
import Link from 'next/link';
import { HandCoins } from 'lucide-react';

import { ActionButton } from '@/components/admin/action-button';
import { ForbiddenPanel, PageHeader } from '@/components/admin/page-parts';
import { StatusBadge } from '@/components/shared/status-badge';
import { Card } from '@/components/ui/card';
import { CellStack, DataTable, type Column } from '@/components/ui/data-table';
import { Alert, EmptyState } from '@/components/ui/feedback';
import { ClearFilters, FilterBar, FilterSelect } from '@/components/ui/filter-bar';
import { Pagination } from '@/components/ui/pagination';
import { asEnumValue, countActiveFilters, flattenSearchParams, parseListParams, rangeFor, type RawSearchParams } from '@/lib/api/list-params';
import { guardPage } from '@/lib/auth/page-guard';
import { adminRoutes, apiRoutes } from '@/lib/config/routes';
import { formatDateTime, formatMoney, humaniseEnum } from '@/lib/utils/format';
import { PayoutStatus } from '@/types/domain';
import type { PayoutRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Payouts' };
export const dynamic = 'force-dynamic';

type PayoutListRow = PayoutRow & {
  workers: { id: string; full_name: string; worker_code: string } | null;
  wallets: { balance_minor: number; is_frozen: boolean } | null;
};

/**
 * Payout requests.
 *
 * Approval debits the wallet and moves the payout in one database transaction
 * with a derived idempotency key, so an approval cannot pay twice. The current
 * wallet balance is shown beside each request so an operator never approves
 * blind.
 */
export default async function PayoutsPage({ searchParams }: { searchParams: Promise<RawSearchParams> }) {
  const { session, allowed } = await guardPage('payouts.read', adminRoutes.payouts());
  if (!allowed) return <ForbiddenPanel permission="payouts.read" role={session.role} resource="payouts" />;

  const raw = await searchParams;
  const flat = flattenSearchParams(raw);
  const params = parseListParams(raw);
  const [from, to] = rangeFor(params.page, params.pageSize);

  // Default to the work queue: requests awaiting a decision.
  const status = asEnumValue(flat.status, PayoutStatus) ?? (flat.status === 'all' ? undefined : PayoutStatus.REQUESTED);

  let query = session.db.from('payouts').select('*, workers(id, full_name, worker_code), wallets(balance_minor, is_frozen)', { count: 'exact' });
  if (status) query = query.eq('status', status);

  const { data, error, count } = await query.order('requested_at', { ascending: status === PayoutStatus.REQUESTED }).range(from, to).overrideTypes<PayoutListRow[]>();

  const canApprove = session.permissions.includes('payouts.approve');
  const canReject = session.permissions.includes('payouts.reject');

  const columns: ReadonlyArray<Column<PayoutListRow>> = [
    { key: 'payout', header: 'Payout', cell: (row) => <CellStack primary={row.payout_code} secondary={formatDateTime(row.requested_at)} /> },
    { key: 'worker', header: 'Worker', cell: (row) => (row.workers ? <Link href={adminRoutes.wallet(row.workers.id)} className="hover:text-brand-700"><CellStack primary={row.workers.full_name} secondary={row.workers.worker_code} /></Link> : '—') },
    { key: 'amount', header: 'Amount', cell: (row) => <span className="font-medium text-ink-900">{formatMoney(row.amount_minor, row.currency)}</span>, align: 'right', numeric: true },
    {
      key: 'balance',
      header: 'Wallet balance',
      cell: (row) => (row.wallets ? <span className={row.wallets.balance_minor < row.amount_minor ? 'text-danger-700' : undefined}>{formatMoney(row.wallets.balance_minor, row.currency)}{row.wallets.is_frozen ? ' · frozen' : ''}</span> : '—'),
      align: 'right',
      numeric: true,
      hideBelow: 'md',
    },
    { key: 'account', header: 'Account', cell: (row) => (row.account_last4 ? `${row.bank_name ?? 'Bank'} ••${row.account_last4}` : '—'), hideBelow: 'xl' },
    { key: 'status', header: 'Status', cell: (row) => <StatusBadge kind="payout" status={row.status} /> },
    {
      key: 'actions',
      header: <span className="sr-only">Actions</span>,
      align: 'right',
      cell: (row) =>
        row.status === PayoutStatus.REQUESTED ? (
          <div className="flex justify-end gap-2">
            {canReject && (
              <ActionButton
                endpoint={apiRoutes.adminPayoutDecision(row.id)}
                payload={{ decision: 'REJECT' }}
                label="Reject"
                variant="outline"
                tone="danger"
                confirmTitle={`Reject ${row.payout_code}?`}
                confirmDescription="The worker keeps the balance and can request again. The reason is shown to them."
                confirmLabel="Reject payout"
                requireReason
                minReasonLength={5}
                successMessage="Payout rejected"
              />
            )}
            {canApprove && (
              <ActionButton
                endpoint={apiRoutes.adminPayoutDecision(row.id)}
                payload={{ decision: 'APPROVE' }}
                label="Approve"
                variant="success"
                tone="success"
                disabled={Boolean(row.wallets && (row.wallets.is_frozen || row.wallets.balance_minor < row.amount_minor))}
                confirmTitle={`Approve ${formatMoney(row.amount_minor, row.currency)} to ${row.workers?.full_name ?? 'this worker'}?`}
                confirmDescription="The amount is debited from the wallet immediately and the payout moves to processing for disbursement."
                confirmLabel="Approve payout"
                successMessage="Payout approved"
              />
            )}
          </div>
        ) : row.decision_reason ? (
          <span className="block max-w-48 truncate text-xs text-ink-500" title={row.decision_reason}>{row.decision_reason}</span>
        ) : null,
    },
  ];

  return (
    <>
      <PageHeader title="Payouts" description="Worker withdrawal requests. Approval debits the ledger and cannot be applied twice." />
      <Card>
        <FilterBar>
          <FilterSelect
            paramName="status"
            label="Filter by status"
            allLabel="Awaiting decision"
            options={[...Object.values(PayoutStatus).filter((s) => s !== PayoutStatus.REQUESTED).map((value) => ({ value, label: humaniseEnum(value) })), { value: 'all', label: 'All payouts' }]}
          />
          <ClearFilters activeCount={countActiveFilters(flat, ['status'])} />
        </FilterBar>
        {error ? (
          <Alert tone="danger" className="m-4">Payouts could not be loaded.</Alert>
        ) : (
          <>
            <DataTable
              columns={columns}
              rows={data ?? []}
              rowKey={(row) => row.id}
              caption="Payout requests"
              empty={<EmptyState icon={<HandCoins aria-hidden className="size-5" />} title={status === PayoutStatus.REQUESTED ? 'No payout requests' : 'No payouts in this state'} description="Workers request payouts from their wallet in the worker app." />}
            />
            <Pagination page={params.page} pageSize={params.pageSize} total={count ?? 0} searchParams={flat} basePath={adminRoutes.payouts()} />
          </>
        )}
      </Card>
    </>
  );
}
