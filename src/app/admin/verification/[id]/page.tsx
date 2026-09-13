import type { Metadata } from 'next';
import { notFound } from 'next/navigation';
import Link from 'next/link';
import { FileWarning } from 'lucide-react';

import { DocumentLink } from '@/components/admin/document-link';
import { ForbiddenPanel, PageHeader } from '@/components/admin/page-parts';
import { VerificationDecisionPanel } from '@/components/admin/verification-decision-panel';
import { StatusBadge } from '@/components/shared/status-badge';
import { Card, CardBody, CardHeader, Field, FieldGrid } from '@/components/ui/card';
import { Alert, EmptyState } from '@/components/ui/feedback';
import { guardPage } from '@/lib/auth/page-guard';
import { adminRoutes } from '@/lib/config/routes';
import { formatDate, formatDateTime, humaniseEnum } from '@/lib/utils/format';
import { verificationTypeLabel } from '@/lib/utils/labels';
import { MediaSensitivity, VerificationStatus, VerificationType } from '@/types/domain';
import type { Json, WorkerVerificationRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Verification case' };
export const dynamic = 'force-dynamic';

type CaseDetail = WorkerVerificationRow & {
  workers: { id: string; full_name: string; worker_code: string; status: string; firebase_uid: string } | null;
};

/** Checks that go stale and should carry an expiry date when approved. */
const EXPIRING_TYPES: string[] = [VerificationType.BACKGROUND_CHECK, VerificationType.INSURANCE, VerificationType.RPL_SKILL];

/**
 * One verification case.
 *
 * The reviewer sees the captured details, opens each document through a
 * permission-checked signed URL (each opening is audited), and records a
 * decision. The database refuses a decision from the worker whose case it is.
 */
export default async function VerificationCasePage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const { session, allowed } = await guardPage('verification.read', adminRoutes.verificationCase(id));
  if (!allowed) return <ForbiddenPanel permission="verification.read" role={session.role} resource="verification cases" />;

  const { data: record } = await session.db
    .from('worker_verifications')
    .select('*, workers(id, full_name, worker_code, status, firebase_uid)')
    .eq('id', id)
    .maybeSingle()
    .overrideTypes<CaseDetail>();

  if (!record) notFound();

  const canSeeDocuments = session.permissions.includes('workers.documents.read');
  const { data: documents } = canSeeDocuments
    ? await session.db
        .from('media_assets')
        .select('id, original_file_name, mime_type, sensitivity, created_at')
        .eq('verification_id', id)
        .eq('upload_status', 'COMPLETED')
        .is('deleted_at', null)
        .order('created_at')
    : { data: null };

  const isDecided = record.status === VerificationStatus.APPROVED || record.status === VerificationStatus.REJECTED;
  const isOwnCase = record.workers?.firebase_uid === session.firebaseUid;
  const details = toDisplayEntries(record.details);

  return (
    <>
      <PageHeader
        title={verificationTypeLabel(record.type)}
        description={
          <span className="flex flex-wrap items-center gap-2">
            <StatusBadge kind="verification" status={record.status} />
            {record.workers && (
              <Link href={adminRoutes.worker(record.workers.id)} className="text-brand-700 hover:underline">
                {record.workers.full_name} · {record.workers.worker_code}
              </Link>
            )}
          </span>
        }
      />

      {isOwnCase && (
        <Alert tone="danger" title="This is your own verification case" className="mb-5">
          You cannot decide a verification case that belongs to your own account. Another reviewer must handle it.
        </Alert>
      )}
      {record.status === VerificationStatus.MORE_INFO_REQUIRED && record.info_requested && (
        <Alert tone="warning" title="Waiting on the worker" className="mb-5">{record.info_requested}</Alert>
      )}
      {record.status === VerificationStatus.REJECTED && record.rejection_reason && (
        <Alert tone="danger" title="Rejected" className="mb-5">{record.rejection_reason}</Alert>
      )}

      <div className="grid gap-5 xl:grid-cols-3">
        <div className="space-y-5 xl:col-span-2">
          <Card>
            <CardHeader title="Case" />
            <CardBody>
              <FieldGrid columns={3}>
                <Field label="Submitted" value={formatDateTime(record.submitted_at)} />
                <Field label="Decided" value={formatDateTime(record.reviewed_at)} />
                <Field label="Expires" value={formatDate(record.expires_at)} />
                <Field label="Provider" value={record.provider ?? '—'} />
                <Field label="Provider reference" value={record.provider_reference ?? '—'} />
                <Field label="Worker status" value={record.workers ? humaniseEnum(record.workers.status) : '—'} />
              </FieldGrid>
              {record.decision_note && (
                <div className="mt-5 border-t border-ink-200 pt-4">
                  <p className="text-xs font-medium uppercase tracking-wide text-ink-500">Reviewer note</p>
                  <p className="mt-1.5 text-sm text-ink-700">{record.decision_note}</p>
                </div>
              )}
            </CardBody>
          </Card>

          <Card>
            <CardHeader title="Submitted details" description="Fields captured by the worker app for this check" />
            {details.length > 0 ? (
              <CardBody>
                <FieldGrid columns={2}>
                  {details.map(([key, value]) => (
                    <Field key={key} label={humaniseEnum(key)} value={value} />
                  ))}
                </FieldGrid>
              </CardBody>
            ) : (
              <EmptyState title="No structured details" description="Only documents were submitted for this check." />
            )}
          </Card>

          <Card>
            <CardHeader title="Documents" description={canSeeDocuments ? 'Each document you open is recorded in the audit trail' : undefined} />
            {!canSeeDocuments ? (
              <CardBody>
                <p className="text-sm text-ink-500">
                  Opening documents requires the <code className="rounded bg-ink-100 px-1 py-0.5 font-mono text-xs">workers.documents.read</code> permission.
                </p>
              </CardBody>
            ) : documents && documents.length > 0 ? (
              <CardBody className="grid gap-2 sm:grid-cols-2">
                {documents.map((doc) => (
                  <DocumentLink key={doc.id} mediaId={doc.id} fileName={doc.original_file_name} mimeType={doc.mime_type} sensitive={doc.sensitivity === MediaSensitivity.SENSITIVE} />
                ))}
              </CardBody>
            ) : (
              <EmptyState icon={<FileWarning aria-hidden className="size-5" />} title="No documents attached" description="Request more information if a document is required for this check." />
            )}
          </Card>
        </div>

        <div>
          <Card className="xl:sticky xl:top-20">
            <CardHeader title="Decide" />
            <CardBody>
              {isOwnCase ? (
                <p className="text-sm text-ink-500">Decisions are disabled on your own case.</p>
              ) : (
                <VerificationDecisionPanel
                  verificationId={record.id}
                  canApprove={session.permissions.includes('verification.approve')}
                  canReject={session.permissions.includes('verification.reject')}
                  canReview={session.permissions.includes('verification.review')}
                  isDecided={isDecided}
                  suggestsExpiry={EXPIRING_TYPES.includes(record.type)}
                  assignedToMe={record.assigned_to === session.adminId}
                />
              )}
            </CardBody>
          </Card>
        </div>
      </div>
    </>
  );
}

/**
 * Flatten the free-form details object into label/value pairs. Nested values are
 * shown as compact JSON rather than dropped, so nothing submitted is hidden.
 */
function toDisplayEntries(details: Json): Array<[string, string]> {
  if (!details || typeof details !== 'object' || Array.isArray(details)) return [];
  return Object.entries(details).map(([key, value]) => [
    key,
    value === null ? '—' : typeof value === 'object' ? JSON.stringify(value) : String(value),
  ]);
}
