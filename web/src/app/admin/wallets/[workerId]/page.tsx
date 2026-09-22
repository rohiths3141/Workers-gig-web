import type { Metadata } from 'next';
import { notFound } from 'next/navigation';
import Link from 'next/link';

import { ForbiddenPanel, PageHeader, PermissionGuard, StatCard } from '@/components/admin/page-parts';
import { WalletAdjustmentForm } from '@/components/admin/wallet-adjustment-form';
import { Card, CardBody, CardHeader } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { Alert, EmptyState } from '@/components/ui/feedback';
import { Pagination } from '@/components/ui/pagination';
import { flattenSearchParams, parseListParams, rangeFor, type RawSearchParams } from '@/lib/api/list-params';
import { guardPage } from '@/lib/auth/page-guard';
import { adminRoutes } from '@/lib/config/routes';
import { cn } from '@/lib/utils/cn';
import { formatDateTime, formatMoney, humaniseEnum } from '@/lib/utils/format';
import type { WalletRow, WalletTransactionRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Wallet ledger' };
export const dynamic = 'force-dynamic';

type WalletDetail = WalletRow & { workers: { id: string; full_name: string; worker_code: string } | null };

export default async function WalletLedgerPage({ params, searchParams }: { params: Promise<{ workerId: string }>; searchParams: Promise<RawSearchParams> }) {
  const { workerId } = await params;
  const { session, allowed } = await guardPage('wallets.read', adminRoutes.wallet(workerId));
  if (!allowed) return <ForbiddenPanel permission="wallets.read" role={session.role} resource="wallets" />;

  const raw = await searchParams;
  const flat = flattenSearchParams(raw);
  const list = parseListParams(raw);
  const [from, to] = rangeFor(list.page, list.pageSize);

  const { data: wallet } = await session.db
    .from('wallets')
    .select('*, workers(id, full_name, worker_code)')
    .eq('worker_id', workerId)
    .maybeSingle()
    .overrideTypes<WalletDetail>();

  if (!wallet) notFound();

  const { data: entries, error, count } = await session.db
    .from('wallet_transactions')
    .select('*', { count: 'exact' })
    .eq('worker_id', workerId)
    .order('created_at', { ascending: false })
    .range(from, to);

  const columns: ReadonlyArray<Column<WalletTransactionRow>> = [
    { key: 'when', header: 'Date', cell: (row) => formatDateTime(row.created_at) },
    { key: 'type', header: 'Type', cell: (row) => humaniseEnum(row.type) },
    { key: 'description', header: 'Description', cell: (row) => <span className="block max-w-72 truncate" title={row.reason ?? row.description}>{row.description}</span>, hideBelow: 'md' },
    { key: 'by', header: 'Posted by', cell: (row) => humaniseEnum(row.created_by_type), hideBelow: 'lg' },
    { key: 'amount', header: 'Amount', cell: (row) => <span className={cn('font-medium', row.amount_minor > 0 ? 'text-success-700' : 'text-danger-700')}>{row.amount_minor > 0 ? '+' : ''}{formatMoney(row.amount_minor, row.currency)}</span>, align: 'right', numeric: true },
    { key: 'balance', header: 'Balance after', cell: (row) => formatMoney(row.balance_after_minor, row.currency), align: 'right', numeric: true, hideBelow: 'sm' },
  ];

  return (
    <>
      <PageHeader
        title={wallet.workers ? `${wallet.workers.full_name}’s wallet` : 'Wallet'}
        description={wallet.workers && <Link href={adminRoutes.worker(wallet.workers.id)} className="text-brand-700 hover:underline">{wallet.workers.worker_code}</Link>}
      />

      {wallet.is_frozen && <Alert tone="warning" title="Wallet frozen" className="mb-5">{wallet.frozen_reason ?? 'Payouts are on hold.'}</Alert>}

      <div className="grid gap-3 sm:grid-cols-3">
        <StatCard label="Current balance" value={formatMoney(wallet.balance_minor, wallet.currency)} />
        <StatCard label="Total credited" value={formatMoney(wallet.total_credited_minor, wallet.currency)} tone="success" />
        <StatCard label="Total debited" value={formatMoney(wallet.total_debited_minor, wallet.currency)} />
      </div>

      <div className="mt-5 grid gap-5 xl:grid-cols-3">
        <Card className="xl:col-span-2">
          <CardHeader title="Ledger" description="Append-only. Entries cannot be edited or deleted." />
          {error ? (
            <Alert tone="danger" className="m-4">The ledger could not be loaded.</Alert>
          ) : (
            <>
              <DataTable columns={columns} rows={entries ?? []} rowKey={(row) => row.id} caption="Wallet ledger entries" empty={<EmptyState title="No ledger entries" description="Entries are posted when payments are captured, payouts approved, or adjustments made." />} />
              <Pagination page={list.page} pageSize={list.pageSize} total={count ?? 0} searchParams={flat} basePath={adminRoutes.wallet(workerId)} />
            </>
          )}
        </Card>

        <PermissionGuard permissions={session.permissions} required="wallets.adjust">
          <Card>
            <CardHeader title="Manual adjustment" description="Posts a new ledger entry" />
            <CardBody>
              <WalletAdjustmentForm workerId={workerId} currency={wallet.currency} />
            </CardBody>
          </Card>
        </PermissionGuard>
      </div>
    </>
  );
}
