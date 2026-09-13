import type { Metadata } from 'next';
import { Wallet } from 'lucide-react';

import { ForbiddenPanel, PageHeader } from '@/components/admin/page-parts';
import { Badge } from '@/components/ui/badge';
import { Card } from '@/components/ui/card';
import { CellStack, DataTable, type Column } from '@/components/ui/data-table';
import { Alert, EmptyState } from '@/components/ui/feedback';
import { ClearFilters, FilterBar, FilterSelect } from '@/components/ui/filter-bar';
import { Pagination } from '@/components/ui/pagination';
import { countActiveFilters, flattenSearchParams, parseListParams, rangeFor, type RawSearchParams } from '@/lib/api/list-params';
import { guardPage } from '@/lib/auth/page-guard';
import { adminRoutes } from '@/lib/config/routes';
import { formatDateTime, formatMoney } from '@/lib/utils/format';
import type { WalletRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Wallets' };
export const dynamic = 'force-dynamic';

type WalletListRow = WalletRow & { workers: { id: string; full_name: string; worker_code: string } | null };

/**
 * Worker wallets.
 *
 * Every balance shown is derived from the append-only ledger by a database
 * trigger. There is no field anywhere in the admin panel that sets a balance.
 */
export default async function WalletsPage({ searchParams }: { searchParams: Promise<RawSearchParams> }) {
  const { session, allowed } = await guardPage('wallets.read', adminRoutes.wallets());
  if (!allowed) return <ForbiddenPanel permission="wallets.read" role={session.role} resource="wallets" />;

  const raw = await searchParams;
  const flat = flattenSearchParams(raw);
  const params = parseListParams(raw);
  const [from, to] = rangeFor(params.page, params.pageSize);

  let query = session.db.from('wallets').select('*, workers(id, full_name, worker_code)', { count: 'exact' });
  if (flat.frozen === 'true') query = query.eq('is_frozen', true);

  const { data, error, count } = await query.order('balance_minor', { ascending: false }).range(from, to).overrideTypes<WalletListRow[]>();

  const columns: ReadonlyArray<Column<WalletListRow>> = [
    { key: 'worker', header: 'Worker', cell: (row) => <CellStack primary={row.workers?.full_name ?? 'Unknown'} secondary={row.workers?.worker_code} /> },
    { key: 'balance', header: 'Current balance', cell: (row) => <span className="font-medium text-ink-900">{formatMoney(row.balance_minor, row.currency)}</span>, align: 'right', numeric: true },
    { key: 'earned', header: 'Total earnings', cell: (row) => formatMoney(row.total_credited_minor, row.currency), align: 'right', numeric: true, hideBelow: 'md' },
    { key: 'paid', header: 'Total debits', cell: (row) => formatMoney(row.total_debited_minor, row.currency), align: 'right', numeric: true, hideBelow: 'lg' },
    { key: 'state', header: 'State', cell: (row) => (row.is_frozen ? <Badge tone="warning" dot>Frozen</Badge> : <Badge tone="success" dot>Open</Badge>), hideBelow: 'sm' },
    { key: 'last', header: 'Last entry', cell: (row) => formatDateTime(row.last_transaction_at), align: 'right', hideBelow: 'xl' },
  ];

  return (
    <>
      <PageHeader title="Wallets" description="Worker balances derived from the immutable ledger. Open a wallet to see every entry." />
      <Card>
        <FilterBar>
          <FilterSelect paramName="frozen" label="Filter by state" allLabel="All wallets" options={[{ value: 'true', label: 'Frozen only' }]} />
          <ClearFilters activeCount={countActiveFilters(flat, ['frozen'])} />
        </FilterBar>
        {error ? (
          <Alert tone="danger" className="m-4">Wallets could not be loaded.</Alert>
        ) : (
          <>
            <DataTable
              columns={columns}
              rows={data ?? []}
              rowKey={(row) => row.id}
              rowHref={(row) => adminRoutes.wallet(row.worker_id)}
              caption="Worker wallets"
              empty={<EmptyState icon={<Wallet aria-hidden className="size-5" />} title="No wallets" description="A wallet is created automatically when a worker registers." />}
            />
            <Pagination page={params.page} pageSize={params.pageSize} total={count ?? 0} searchParams={flat} basePath={adminRoutes.wallets()} />
          </>
        )}
      </Card>
    </>
  );
}
