import type { Metadata } from 'next';
import { notFound } from 'next/navigation';
import Link from 'next/link';
import { FileWarning } from 'lucide-react';

import { ClaimDecisionPanel } from '@/components/admin/claim-decision-panel';
import { DocumentLink } from '@/components/admin/document-link';
import { ForbiddenPanel, PageHeader } from '@/components/admin/page-parts';
import { StatusBadge } from '@/components/shared/status-badge';
import { Card, CardBody, CardHeader, Field, FieldGrid } from '@/components/ui/card';
import { Alert, EmptyState } from '@/components/ui/feedback';
import { guardPage } from '@/lib/auth/page-guard';
import { adminRoutes } from '@/lib/config/routes';
import { formatDateTime, formatMoney, humaniseEnum } from '@/lib/utils/format';
import type { ClaimRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Claim' };
export const dynamic = 'force-dynamic';

type ClaimDetail = ClaimRow & {
  bookings: { id: string; booking_code: string } | null;
  customers: { id: string; full_name: string } | null;
  workers: { id: string; full_name: string } | null;
  insurance_policies: { provider_name: string; policy_number: string } | null;
};

export default async function ClaimDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const { session, allowed } = await guardPage('claims.read', adminRoutes.claim(id));
  if (!allowed) return <ForbiddenPanel permission="claims.read" role={session.role} resource="damage claims" />;

  const { data: claim } = await session.db
    .from('claims')
    .select('*, bookings(id, booking_code), customers(id, full_name), workers(id, full_name), insurance_policies(provider_name, policy_number)')
    .eq('id', id)
    .maybeSingle()
    .overrideTypes<ClaimDetail>();

  if (!claim) notFound();

  const [events, evidence] = await Promise.all([
    session.db.from('claim_events').select('id, from_status, to_status, actor_type, note, created_at').eq('claim_id', id).order('created_at'),
    session.db.from('media_assets').select('id, original_file_name, mime_type, captured_at, created_at').eq('claim_id', id).eq('upload_status', 'COMPLETED').is('deleted_at', null).order('created_at'),
  ]);

  return (
    <>
      <PageHeader title={claim.claim_code} description={<span className="flex flex-wrap items-center gap-2"><StatusBadge kind="claim" status={claim.status} /><span className="text-ink-500">{humaniseEnum(claim.type)}</span></span>} />

      {claim.status === 'MORE_INFORMATION_REQUIRED' && claim.info_requested && <Alert tone="warning" title="Waiting on the customer" className="mb-5">{claim.info_requested}</Alert>}
      {claim.status === 'REJECTED' && claim.rejection_reason && <Alert tone="danger" title="Rejected" className="mb-5">{claim.rejection_reason}</Alert>}

      <div className="grid gap-5 xl:grid-cols-3">
        <div className="space-y-5 xl:col-span-2">
          <Card>
            <CardHeader title="Claim" />
            <CardBody>
              <FieldGrid columns={3}>
                <Field label="Booking" value={claim.bookings ? <Link className="text-brand-700 hover:underline" href={adminRoutes.booking(claim.bookings.id)}>{claim.bookings.booking_code}</Link> : '—'} />
                <Field label="Customer" value={claim.customers ? <Link className="text-brand-700 hover:underline" href={adminRoutes.customer(claim.customers.id)}>{claim.customers.full_name}</Link> : '—'} />
                <Field label="Worker" value={claim.workers ? <Link className="text-brand-700 hover:underline" href={adminRoutes.worker(claim.workers.id)}>{claim.workers.full_name}</Link> : '—'} />
                <Field label="Incident" value={formatDateTime(claim.incident_at)} />
                <Field label="Claimed" value={<span className="font-semibold">{formatMoney(claim.amount_claimed_minor, claim.currency)}</span>} />
                <Field label="Approved" value={formatMoney(claim.amount_approved_minor, claim.currency)} />
              </FieldGrid>
              <div className="mt-5 border-t border-ink-200 pt-4">
                <p className="text-xs font-medium uppercase tracking-wide text-ink-500">Description</p>
                <p className="mt-1.5 text-sm leading-relaxed text-ink-700">{claim.description}</p>
              </div>
            </CardBody>
          </Card>

          <Card>
            <CardHeader title="Evidence" description="Opening a file is recorded in the audit trail" />
            {evidence.data && evidence.data.length > 0 ? (
              <CardBody className="grid gap-2 sm:grid-cols-2">
                {evidence.data.map((file) => (
                  <DocumentLink key={file.id} mediaId={file.id} fileName={file.original_file_name} mimeType={file.mime_type} sensitive />
                ))}
              </CardBody>
            ) : (
              <EmptyState icon={<FileWarning aria-hidden className="size-5" />} title="No evidence uploaded" description="Request more information if evidence is needed to decide." />
            )}
          </Card>

          <Card>
            <CardHeader title="Decision history" />
            {events.data && events.data.length > 0 ? (
              <ol className="divide-y divide-ink-100">
                {events.data.map((event) => (
                  <li key={event.id} className="px-5 py-3">
                    <p className="text-sm font-medium text-ink-900">{humaniseEnum(event.from_status)} → {humaniseEnum(event.to_status)}</p>
                    <p className="text-xs text-ink-500">{formatDateTime(event.created_at)} · {humaniseEnum(event.actor_type).toLowerCase()}</p>
                    {event.note && <p className="mt-1.5 rounded-md bg-ink-50 px-3 py-2 text-sm text-ink-700">{event.note}</p>}
                  </li>
                ))}
              </ol>
            ) : (
              <EmptyState title="No decisions yet" description="The claim has not been reviewed." />
            )}
          </Card>
        </div>

        <div className="space-y-5">
          <Card>
            <CardHeader title="Decide" />
            <CardBody>
              <ClaimDecisionPanel
                claimId={claim.id}
                claimedMinor={claim.amount_claimed_minor}
                currency={claim.currency}
                status={claim.status}
                canReview={session.permissions.includes('claims.review')}
                canApprove={session.permissions.includes('claims.approve')}
                canReject={session.permissions.includes('claims.reject')}
              />
            </CardBody>
          </Card>

          <Card>
            <CardHeader title="Insurance" />
            <CardBody className="space-y-2 text-sm">
              {claim.insurance_policies ? (
                <>
                  <p className="text-ink-700">{claim.insurance_policies.provider_name} · <span className="font-mono text-xs">{claim.insurance_policies.policy_number}</span></p>
                  <p className="text-ink-600">Insurer reference: {claim.insurer_reference ?? '—'}</p>
                  <p className="text-ink-600">Insurer decision: {claim.insurer_decision ?? 'Not recorded'}</p>
                </>
              ) : (
                <p className="text-ink-500">No insurance policy linked to this claim.</p>
              )}
              <p className="border-t border-ink-200 pt-2 text-xs text-ink-500">The platform decision above is separate from any insurer&apos;s coverage decision.</p>
            </CardBody>
          </Card>
        </div>
      </div>
    </>
  );
}
