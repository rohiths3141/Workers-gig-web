import type { Metadata } from 'next';
import Link from 'next/link';
import { Sparkles } from 'lucide-react';

import { ForbiddenPanel, PageHeader } from '@/components/admin/page-parts';
import { ServiceIcon } from '@/components/shared/service-icon';
import { Badge } from '@/components/ui/badge';
import { Alert, EmptyState } from '@/components/ui/feedback';
import { Card } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { guardPage } from '@/lib/auth/page-guard';
import { adminRoutes, publicRoutes } from '@/lib/config/routes';
import { formatMoney } from '@/lib/utils/format';
import { verificationTypeLabel } from '@/lib/utils/labels';
import type { ServiceRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Services' };
export const dynamic = 'force-dynamic';

/**
 * Service catalogue as the platform sees it, including inactive services the
 * public site hides. Catalogue editing is a pending backend contract (see
 * docs/BACKEND_CONTRACTS.md); changes are made through migrations until then.
 */
export default async function AdminServicesPage() {
  const { session, allowed } = await guardPage('services.read', adminRoutes.services());
  if (!allowed) return <ForbiddenPanel permission="services.read" role={session.role} resource="services" />;

  const { data, error } = await session.db.from('services').select('*').order('display_order');

  const columns: ReadonlyArray<Column<ServiceRow>> = [
    {
      key: 'service',
      header: 'Service',
      cell: (row) => (
        <span className="flex items-center gap-2.5">
          <span className="flex size-8 items-center justify-center rounded-lg bg-brand-50 text-brand-700"><ServiceIcon iconKey={row.icon_key} className="size-4" /></span>
          <span>
            <span className="block font-medium text-ink-900">{row.name}</span>
            <Link href={publicRoutes.service(row.slug)} className="block text-xs text-ink-500 hover:text-brand-700">/{row.slug}</Link>
          </span>
        </span>
      ),
    },
    { key: 'checks', header: 'Required checks', cell: (row) => <div className="flex flex-wrap gap-1">{row.required_verifications.map((v) => <Badge key={v}>{verificationTypeLabel(v)}</Badge>)}</div>, hideBelow: 'md' },
    { key: 'fee', header: 'Indicative visit fee', cell: (row) => formatMoney(row.base_visit_fee_minor, row.currency), align: 'right', numeric: true, hideBelow: 'lg' },
    { key: 'order', header: 'Order', cell: (row) => row.display_order, align: 'right', numeric: true, hideBelow: 'sm' },
    { key: 'active', header: 'Status', cell: (row) => (row.is_active ? <Badge tone="success" dot>Active</Badge> : <Badge dot>Hidden</Badge>), align: 'right' },
  ];

  return (
    <>
      <PageHeader title="Services" description="The catalogue that drives the public website, matching and worker trades." />
      {!session.permissions.includes('services.update') ? null : (
        <Alert tone="info" className="mb-4">
          Editing the catalogue from the admin panel is not built yet. Until the service-management endpoint exists, catalogue changes are made by migration.
        </Alert>
      )}
      <Card>
        {error ? (
          <Alert tone="danger" className="m-4">Services could not be loaded.</Alert>
        ) : (
          <DataTable columns={columns} rows={data ?? []} rowKey={(row) => row.id} caption="Service catalogue" empty={<EmptyState icon={<Sparkles aria-hidden className="size-5" />} title="The catalogue is empty" description="Apply migration 0012 to load the launch catalogue." />} />
        )}
      </Card>
    </>
  );
}
