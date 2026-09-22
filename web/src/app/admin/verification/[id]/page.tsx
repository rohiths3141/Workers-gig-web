import type { Metadata } from 'next';
import { notFound } from 'next/navigation';
import Link from 'next/link';
import { CheckCircle2, FileWarning, Fingerprint, XCircle } from 'lucide-react';

import { DocumentPreview } from '@/components/admin/document-preview';
import { ForbiddenPanel, PageHeader } from '@/components/admin/page-parts';
import { VerificationDecisionPanel } from '@/components/admin/verification-decision-panel';
import { StatusBadge } from '@/components/shared/status-badge';
import { Badge } from '@/components/ui/badge';
import { Card, CardBody, CardHeader, Field, FieldGrid } from '@/components/ui/card';
import { Alert, EmptyState } from '@/components/ui/feedback';
import { guardPage } from '@/lib/auth/page-guard';
import { adminRoutes } from '@/lib/config/routes';
import { formatDate, formatDateTime, humaniseEnum } from '@/lib/utils/format';
import { verificationTypeLabel } from '@/lib/utils/labels';
import { MediaPurpose, MediaSensitivity, VerificationStatus, VerificationType } from '@/types/domain';
import type { Json, WorkerVerificationRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Verification case' };
export const dynamic = 'force-dynamic';

type CaseDetail = WorkerVerificationRow & {
  workers: { id: string; full_name: string; worker_code: string; status: string; firebase_uid: string } | null;
};

/** Checks that go stale and should carry an expiry date when approved. */
const EXPIRING_TYPES: string[] = [VerificationType.BACKGROUND_CHECK, VerificationType.INSURANCE, VerificationType.RPL_SKILL];

/**
 * The worker app uploads a document before it submits the check, so uploads
 * are owned by the worker rather than linked to the case. They are matched to
 * the case by the purpose each check type uploads under.
 */
const PURPOSES_BY_TYPE: Partial<Record<string, string[]>> = {
  [VerificationType.IDENTITY_KYC]: [MediaPurpose.WORKER_KYC_DOCUMENT],
  [VerificationType.ADDRESS]: [MediaPurpose.WORKER_KYC_DOCUMENT],
  [VerificationType.ITI_CERTIFICATE]: [MediaPurpose.WORKER_QUALIFICATION],
  [VerificationType.DIPLOMA]: [MediaPurpose.WORKER_QUALIFICATION],
  [VerificationType.RPL_SKILL]: [MediaPurpose.WORKER_RPL_CREDENTIAL],
  [VerificationType.BACKGROUND_CHECK]: [MediaPurpose.WORKER_BACKGROUND_CHECK],
  [VerificationType.INSURANCE]: [MediaPurpose.WORKER_INSURANCE_DOCUMENT],
};

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
  const purposes = PURPOSES_BY_TYPE[record.type] ?? [];
  const ownership =
    purposes.length > 0
      ? `verification_id.eq.${id},and(worker_id.eq.${record.worker_id},purpose.in.(${purposes.join(',')}))`
      : `verification_id.eq.${id}`;
  const { data: documents } = canSeeDocuments
    ? await session.db
        .from('media_assets')
        .select('id, original_file_name, mime_type, sensitivity, created_at')
        .or(ownership)
        .eq('upload_status', 'COMPLETED')
        .is('deleted_at', null)
        .order('created_at', { ascending: false })
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

          {record.type === VerificationType.IDENTITY_KYC && (
            <AadhaarVerificationCard
              details={record.details}
              registeredName={record.workers?.full_name ?? null}
            />
          )}

          <Card>
            <CardHeader title="Documents" description={canSeeDocuments ? 'Each document you open is recorded in the audit trail' : undefined} />
            {!canSeeDocuments ? (
              <CardBody>
                <p className="text-sm text-ink-500">
                  Opening documents requires the <code className="rounded bg-ink-100 px-1 py-0.5 font-mono text-xs">workers.documents.read</code> permission.
                </p>
              </CardBody>
            ) : documents && documents.length > 0 ? (
              <CardBody className="grid gap-4 sm:grid-cols-2">
                {documents.map((doc) => (
                  <DocumentPreview key={doc.id} mediaId={doc.id} fileName={doc.original_file_name} mimeType={doc.mime_type} sensitive={doc.sensitivity === MediaSensitivity.SENSITIVE} />
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
 *
 * Keys displayed in their own dedicated card (Aadhaar / DigiLocker internals)
 * are excluded so the reviewer isn't shown the same data twice.
 */
const DETAIL_KEYS_WITH_DEDICATED_CARD = new Set(['provider_raw_response', 'digilocker']);

function toDisplayEntries(details: Json): Array<[string, string]> {
  if (!details || typeof details !== 'object' || Array.isArray(details)) return [];
  return Object.entries(details)
    .filter(([key]) => !DETAIL_KEYS_WITH_DEDICATED_CARD.has(key))
    .map(([key, value]) => [
      key,
      value === null ? '—' : typeof value === 'object' ? JSON.stringify(value) : String(value),
    ]);
}

// ---------------------------------------------------------------------------
// Aadhaar Identity Check card
// ---------------------------------------------------------------------------

interface ProviderRawResponse {
  uid?: string;
  name?: string;
  dob?: string;
  gender?: string;
  message?: string;
  name_match?: boolean;
}

function AadhaarVerificationCard({
  details,
  registeredName,
}: {
  details: Json;
  registeredName: string | null;
}) {
  const obj = details && typeof details === 'object' && !Array.isArray(details) ? details : null;
  const raw = (obj as Record<string, unknown> | null)?.provider_raw_response as ProviderRawResponse | undefined;
  const dl = (obj as Record<string, unknown> | null)?.digilocker as Record<string, unknown> | undefined;

  if (!raw && !dl) {
    return (
      <Card>
        <CardHeader
          title={
            <span className="flex items-center gap-2">
              <Fingerprint aria-hidden className="size-5 text-ink-400" />
              Aadhaar identity check
            </span>
          }
        />
        <CardBody>
          <p className="text-sm text-ink-500">
            No Aadhaar data has been captured yet. The worker app must complete the DigiLocker
            consent flow and the <code className="rounded bg-ink-100 px-1 py-0.5 font-mono text-xs">/status</code> endpoint
            must be polled to fetch the verified document.
          </p>
        </CardBody>
      </Card>
    );
  }

  const nameMatch = raw?.name_match;
  const genderLabel = raw?.gender === 'M' ? 'Male' : raw?.gender === 'F' ? 'Female' : raw?.gender ?? '—';

  return (
    <Card>
      <CardHeader
        title={
          <span className="flex items-center gap-2">
            <Fingerprint aria-hidden className="size-5 text-brand-600" />
            Aadhaar identity check
          </span>
        }
        description="Data returned by DigiLocker after the worker completed Aadhaar e-KYC"
      />
      <CardBody>
        {raw ? (
          <>
            {/* Name comparison row */}
            <div className="mb-5 rounded-lg border border-ink-200 bg-ink-50/50 p-4">
              <p className="mb-3 text-xs font-medium uppercase tracking-wide text-ink-500">Name comparison</p>
              <div className="grid gap-4 sm:grid-cols-3">
                <div>
                  <p className="text-xs text-ink-500">Registered name</p>
                  <p className="mt-0.5 text-sm font-medium text-ink-900">{registeredName ?? '—'}</p>
                </div>
                <div>
                  <p className="text-xs text-ink-500">Aadhaar name</p>
                  <p className="mt-0.5 text-sm font-medium text-ink-900">{raw.name ?? '—'}</p>
                </div>
                <div>
                  <p className="text-xs text-ink-500">Match</p>
                  <div className="mt-0.5">
                    {nameMatch === true ? (
                      <Badge tone="success" dot>
                        <CheckCircle2 aria-hidden className="size-3.5" /> Match
                      </Badge>
                    ) : nameMatch === false ? (
                      <Badge tone="danger" dot>
                        <XCircle aria-hidden className="size-3.5" /> Mismatch
                      </Badge>
                    ) : (
                      <Badge tone="neutral">Not checked</Badge>
                    )}
                  </div>
                </div>
              </div>
            </div>

            {/* Detail fields */}
            <FieldGrid columns={3}>
              <Field label="Aadhaar UID (masked)" value={raw.uid ?? '—'} />
              <Field label="Date of birth" value={raw.dob ?? '—'} />
              <Field label="Gender" value={genderLabel} />
            </FieldGrid>
          </>
        ) : (
          <p className="text-sm text-ink-500">
            Aadhaar document data has not been fetched yet. The DigiLocker session is active but
            the <code className="rounded bg-ink-100 px-1 py-0.5 font-mono text-xs">/status</code> endpoint
            has not completed the document retrieval.
          </p>
        )}
      </CardBody>

      {/* DigiLocker session reference — collapsible footer */}
      {dl && (
        <footer className="border-t border-ink-200 bg-ink-50/60 px-5 py-3">
          <details className="group">
            <summary className="cursor-pointer text-xs font-medium text-ink-500 hover:text-ink-700">
              DigiLocker session reference
            </summary>
            <div className="mt-2">
              <FieldGrid columns={2}>
                <Field label="Verification ID" value={String(dl.verification_id ?? '—')} />
                <Field label="Reference ID" value={String(dl.reference_id ?? '—')} />
              </FieldGrid>
            </div>
          </details>
        </footer>
      )}
    </Card>
  );
}
