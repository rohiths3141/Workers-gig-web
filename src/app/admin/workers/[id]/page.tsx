import type { Metadata } from 'next';
import { notFound } from 'next/navigation';
import Link from 'next/link';
import { FileWarning, ShieldCheck, Star } from 'lucide-react';

import { ActionButton } from '@/components/admin/action-button';
import { DocumentLink } from '@/components/admin/document-link';
import { InsuranceRecordForm } from '@/components/admin/insurance-record-form';
import {
  ForbiddenPanel,
  PageHeader,
  PageSection,
  PermissionGuard,
  StatCard,
} from '@/components/admin/page-parts';
import { StatusBadge } from '@/components/shared/status-badge';
import { Badge } from '@/components/ui/badge';
import { Card, CardBody, CardHeader, Field, FieldGrid } from '@/components/ui/card';
import { Alert, EmptyState } from '@/components/ui/feedback';
import { guardPage } from '@/lib/auth/page-guard';
import { adminRoutes, apiRoutes } from '@/lib/config/routes';
import {
  formatDate,
  formatDateTime,
  formatMoney,
  formatNumber,
  humaniseEnum,
} from '@/lib/utils/format';
import { MediaSensitivity, WorkerStatus } from '@/types/domain';
import type { WorkerRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Worker' };
export const dynamic = 'force-dynamic';

/**
 * Shape of the detail query.
 *
 * Declared explicitly because the hand-written Database type carries no
 * relationship metadata, so the embedded `services` join cannot be inferred.
 * Regenerating the types with `npm run db:types` removes the need for this.
 */
type WorkerDetail = Pick<
  WorkerRow,
  | 'id' | 'worker_code' | 'full_name' | 'phone' | 'email' | 'status' | 'availability'
  | 'experience_years' | 'bio' | 'city' | 'state' | 'pincode' | 'address_line'
  | 'service_radius_km' | 'rating_avg' | 'rating_count' | 'jobs_completed' | 'jobs_cancelled'
  | 'is_kyc_verified' | 'is_qualification_verified' | 'is_skill_verified'
  | 'is_background_verified' | 'is_insured' | 'verified_at' | 'restriction_reason'
  | 'restricted_at' | 'last_active_at' | 'created_at' | 'profile_media_id'
> & {
  services: { name: string; slug: string } | null;
};

/**
 * Worker detail.
 *
 * Brings together everything an operator needs to make a decision about one
 * worker: who they are, which checks they hold, what they have done, what they
 * are owed, and what evidence is on file.
 *
 * Documents are listed but not loaded. Each opens through a permission-checked,
 * short-lived signed URL, and opening a sensitive one is recorded.
 */
export default async function WorkerDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const { session, allowed } = await guardPage('workers.read', adminRoutes.worker(id));

  if (!allowed) {
    return <ForbiddenPanel permission="workers.read" role={session.role} resource="workers" />;
  }

  const { data: worker, error } = await session.db
    .from('workers')
    .select(
      'id, worker_code, full_name, phone, email, status, availability, experience_years, bio, city, state, pincode, address_line, service_radius_km, rating_avg, rating_count, jobs_completed, jobs_cancelled, is_kyc_verified, is_qualification_verified, is_skill_verified, is_background_verified, is_insured, verified_at, restriction_reason, restricted_at, last_active_at, created_at, profile_media_id, services:primary_service_id(name, slug)',
    )
    .eq('id', id)
    .maybeSingle()
    .overrideTypes<WorkerDetail>();

  if (error || !worker) {
    notFound();
  }

  // Everything else in parallel — the page should not build itself in stages.
  const [verifications, wallet, documents, recentRatings, activeBookings] = await Promise.all([
    session.db
      .from('worker_verifications')
      .select('id, type, status, submitted_at, reviewed_at, expires_at, rejection_reason, info_requested')
      .eq('worker_id', id)
      .order('type'),

    session.permissions.includes('wallets.read')
      ? session.db
          .from('wallets')
          .select('balance_minor, total_credited_minor, total_debited_minor, currency, is_frozen, frozen_reason')
          .eq('worker_id', id)
          .maybeSingle()
      : Promise.resolve({ data: null, error: null }),

    session.permissions.includes('workers.documents.read')
      ? session.db
          .from('media_assets')
          .select('id, original_file_name, mime_type, purpose, sensitivity, created_at')
          .eq('worker_id', id)
          .is('deleted_at', null)
          .eq('upload_status', 'COMPLETED')
          .order('created_at', { ascending: false })
          .limit(40)
      : Promise.resolve({ data: null, error: null }),

    session.db
      .from('ratings')
      .select('id, rating, comment, created_at, is_hidden')
      .eq('worker_id', id)
      .eq('rater_type', 'CUSTOMER')
      .order('created_at', { ascending: false })
      .limit(5),

    session.permissions.includes('bookings.read')
      ? session.db
          .from('bookings')
          .select('id, booking_code, status, scheduled_at', { count: 'exact', head: true })
          .eq('worker_id', id)
          .in('status', ['ACCEPTED', 'CONFIRMED', 'TRAVELING', 'ARRIVED', 'IN_PROGRESS'])
      : Promise.resolve({ count: null }),
  ]);

  const backgroundCheck = verifications.data?.find((v) => v.type === 'BACKGROUND_CHECK');
  const bankAccount = verifications.data?.find((v) => v.type === 'BANK_ACCOUNT');
  const isBankVerified =
    bankAccount?.status === 'APPROVED' &&
    (!bankAccount.expires_at || new Date(bankAccount.expires_at) > new Date());
  const canOpenBackgroundCheck =
    !backgroundCheck ||
    !(
      ['PENDING', 'UNDER_REVIEW'].includes(backgroundCheck.status) ||
      (backgroundCheck.status === 'APPROVED' &&
        (!backgroundCheck.expires_at || new Date(backgroundCheck.expires_at) > new Date()))
    );

  const isRestricted = (
    [
      WorkerStatus.RESTRICTED,
      WorkerStatus.SUSPENDED,
      WorkerStatus.DEACTIVATED,
      WorkerStatus.REJECTED,
    ] as string[]
  ).includes(worker.status);

  return (
    <>
      <PageHeader
        title={worker.full_name}
        description={
          <span className="flex flex-wrap items-center gap-2">
            <span className="font-mono text-xs text-ink-500">{worker.worker_code}</span>
            <StatusBadge kind="worker" status={worker.status} />
            <Badge tone={worker.availability === 'AVAILABLE' ? 'success' : 'neutral'}>
              {humaniseEnum(worker.availability)}
            </Badge>
          </span>
        }
        actions={
          <PermissionGuard permissions={session.permissions} required="workers.restrict">
            {isRestricted ? (
              <ActionButton
                endpoint={apiRoutes.adminWorkerStatus(worker.id)}
                payload={{ status: WorkerStatus.ACTIVE }}
                label="Reinstate worker"
                variant="success"
                tone="success"
                confirmTitle="Reinstate this worker?"
                confirmDescription="They become eligible to receive jobs again immediately. The reason is recorded in the audit trail."
                confirmLabel="Reinstate"
                requireReason
                reasonLabel="Why is this account being reinstated?"
                successMessage="Worker reinstated"
              />
            ) : (
              <>
                <ActionButton
                  endpoint={apiRoutes.adminWorkerStatus(worker.id)}
                  payload={{ status: WorkerStatus.RESTRICTED }}
                  label="Restrict"
                  variant="outline"
                  tone="danger"
                  confirmTitle="Restrict this worker?"
                  confirmDescription="They stop receiving new jobs. Jobs already in progress are not cancelled."
                  confirmLabel="Restrict"
                  requireReason
                  reasonLabel="Why is this account being restricted?"
                  successMessage="Worker restricted"
                />
                <ActionButton
                  endpoint={apiRoutes.adminWorkerStatus(worker.id)}
                  payload={{ status: WorkerStatus.SUSPENDED }}
                  label="Suspend"
                  variant="danger"
                  tone="danger"
                  confirmTitle="Suspend this worker?"
                  confirmDescription="Suspension removes them from matching entirely and sets their availability offline."
                  confirmLabel="Suspend"
                  requireReason
                  reasonLabel="Why is this account being suspended?"
                  successMessage="Worker suspended"
                />
              </>
            )}
          </PermissionGuard>
        }
      />

      {isRestricted && worker.restriction_reason && (
        <Alert tone="danger" title={`Account ${humaniseEnum(worker.status).toLowerCase()}`} className="mb-5">
          {worker.restriction_reason}
          {worker.restricted_at && (
            <span className="mt-1 block text-xs opacity-80">
              Applied {formatDateTime(worker.restricted_at)}
            </span>
          )}
        </Alert>
      )}

      {/* ---- Summary tiles ------------------------------------------- */}
      <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
        <StatCard label="Jobs completed" value={formatNumber(worker.jobs_completed)} />
        <StatCard
          label="Jobs cancelled"
          value={formatNumber(worker.jobs_cancelled)}
          tone={worker.jobs_cancelled > 0 ? 'warning' : 'neutral'}
        />
        <StatCard
          label="Active jobs"
          value={formatNumber(activeBookings.count ?? 0)}
          hint={session.permissions.includes('bookings.read') ? undefined : 'Requires bookings.read'}
        />
        <StatCard
          label="Rating"
          value={worker.rating_avg === null ? 'Not rated' : worker.rating_avg.toFixed(1)}
          hint={
            worker.rating_count > 0
              ? `From ${formatNumber(worker.rating_count)} rating${worker.rating_count === 1 ? '' : 's'}`
              : 'No ratings yet'
          }
        />
      </div>

      <div className="mt-5 grid gap-5 xl:grid-cols-3">
        <div className="space-y-5 xl:col-span-2">
          {/* ---- Profile ---------------------------------------------- */}
          <Card>
            <CardHeader title="Profile" />
            <CardBody>
              <FieldGrid columns={3}>
                <Field label="Trade" value={worker.services?.name ?? 'Not set'} />
                <Field label="Experience" value={`${worker.experience_years} years`} />
                <Field label="Phone" value={<span className="tabular">{worker.phone}</span>} />
                <Field label="Email" value={worker.email ?? '—'} />
                <Field
                  label="Location"
                  value={[worker.city, worker.state, worker.pincode].filter(Boolean).join(', ') || '—'}
                />
                <Field label="Travel radius" value={`${worker.service_radius_km} km`} />
                <Field label="Registered" value={formatDate(worker.created_at)} />
                <Field label="Last active" value={formatDateTime(worker.last_active_at)} />
                <Field
                  label="Verified since"
                  value={worker.verified_at ? formatDate(worker.verified_at) : 'Not fully verified'}
                />
              </FieldGrid>

              {worker.bio && (
                <div className="mt-5 border-t border-ink-200 pt-4">
                  <p className="text-xs font-medium uppercase tracking-wide text-ink-500">About</p>
                  <p className="mt-1.5 text-sm leading-relaxed text-ink-700">{worker.bio}</p>
                </div>
              )}

              {/* The full address is shown only to operators who can act on it. */}
              {worker.address_line && session.permissions.includes('workers.update') && (
                <div className="mt-4 border-t border-ink-200 pt-4">
                  <p className="text-xs font-medium uppercase tracking-wide text-ink-500">
                    Address
                  </p>
                  <p className="mt-1.5 text-sm text-ink-700">{worker.address_line}</p>
                </div>
              )}
            </CardBody>
          </Card>

          {/* ---- Verification ----------------------------------------- */}
          <Card>
            <CardHeader
              title="Verification"
              description="Each check is decided individually and can expire."
              actions={
                <div className="flex items-center gap-3">
                  <PermissionGuard permissions={session.permissions} required="verification.review">
                    {canOpenBackgroundCheck && (
                      <ActionButton
                        endpoint={apiRoutes.adminWorkerBackgroundCheck(worker.id)}
                        label="Start background check"
                        variant="outline"
                        confirmTitle="Start a background check?"
                        confirmDescription="Opens a background-check case for this worker. It goes to the verification provider, or appears in the verification queue for a decision."
                        confirmLabel="Start check"
                        successMessage="Background check opened"
                      />
                    )}
                  </PermissionGuard>
                  <PermissionGuard permissions={session.permissions} required="verification.read">
                    <Link
                      href={`${adminRoutes.verification()}?worker=${worker.id}`}
                      className="text-sm font-medium text-brand-700 hover:text-brand-800"
                    >
                      Open in queue
                    </Link>
                  </PermissionGuard>
                </div>
              }
            />

            {verifications.data && verifications.data.length > 0 ? (
              <ul className="divide-y divide-ink-100">
                {verifications.data.map((record) => (
                  <li key={record.id} className="flex flex-wrap items-center gap-3 px-5 py-3">
                    <div className="min-w-0 flex-1">
                      <p className="text-sm font-medium text-ink-900">
                        {VERIFICATION_LABELS[record.type] ?? humaniseEnum(record.type)}
                      </p>
                      <p className="mt-0.5 text-xs text-ink-500">
                        {record.reviewed_at
                          ? `Decided ${formatDate(record.reviewed_at)}`
                          : record.submitted_at
                            ? `Submitted ${formatDate(record.submitted_at)}`
                            : 'Not submitted'}
                        {record.expires_at && ` · Expires ${formatDate(record.expires_at)}`}
                      </p>

                      {record.rejection_reason && (
                        <p className="mt-1 text-xs text-danger-600">{record.rejection_reason}</p>
                      )}
                      {record.info_requested && (
                        <p className="mt-1 text-xs text-warning-700">
                          Requested: {record.info_requested}
                        </p>
                      )}
                    </div>

                    <StatusBadge kind="verification" status={record.status} />

                    <PermissionGuard permissions={session.permissions} required="verification.read">
                      <Link
                        href={adminRoutes.verificationCase(record.id)}
                        className={
                          ['PENDING', 'UNDER_REVIEW', 'MORE_INFO_REQUIRED'].includes(record.status)
                            ? 'rounded-lg bg-brand-700 px-3 py-1.5 text-sm font-medium text-white hover:bg-brand-800'
                            : 'text-sm font-medium text-brand-700 hover:text-brand-800'
                        }
                      >
                        {['PENDING', 'UNDER_REVIEW', 'MORE_INFO_REQUIRED'].includes(record.status)
                          ? 'Review'
                          : 'View'}
                      </Link>
                    </PermissionGuard>
                  </li>
                ))}
              </ul>
            ) : (
              <EmptyState
                icon={<ShieldCheck aria-hidden className="size-5" />}
                title="No verification records"
                description="This worker has not submitted any documents yet. They submit them from the worker app."
              />
            )}
          </Card>

          {/* ---- Ratings ---------------------------------------------- */}
          <Card>
            <CardHeader title="Recent ratings" description="Most recent customer ratings" />

            {recentRatings.data && recentRatings.data.length > 0 ? (
              <ul className="divide-y divide-ink-100">
                {recentRatings.data.map((rating) => (
                  <li key={rating.id} className="px-5 py-3">
                    <div className="flex items-center gap-2">
                      <span className="inline-flex items-center gap-1 text-sm font-medium text-ink-900">
                        <Star aria-hidden className="size-3.5 fill-warning-500 text-warning-500" />
                        {rating.rating}/5
                      </span>
                      <span className="text-xs text-ink-500">{formatDate(rating.created_at)}</span>
                      {rating.is_hidden && <Badge tone="warning">Hidden</Badge>}
                    </div>

                    {rating.comment && (
                      <p className="mt-1.5 text-sm leading-relaxed text-ink-600">
                        {rating.comment}
                      </p>
                    )}
                  </li>
                ))}
              </ul>
            ) : (
              <EmptyState
                title="No ratings yet"
                description="Ratings appear here once customers rate completed jobs."
              />
            )}
          </Card>
        </div>

        {/* ---- Side column ------------------------------------------- */}
        <div className="space-y-5">
          {/* Earnings */}
          <PermissionGuard
            permissions={session.permissions}
            required="wallets.read"
            fallback={
              <Card>
                <CardHeader title="Earnings" />
                <CardBody>
                  <p className="text-sm text-ink-500">
                    Viewing wallet balances requires the{' '}
                    <code className="rounded bg-ink-100 px-1 py-0.5 font-mono text-xs">
                      wallets.read
                    </code>{' '}
                    permission.
                  </p>
                </CardBody>
              </Card>
            }
          >
            <Card>
              <CardHeader
                title="Earnings"
                actions={
                  <Link
                    href={adminRoutes.wallet(worker.id)}
                    className="text-sm font-medium text-brand-700 hover:text-brand-800"
                  >
                    Ledger
                  </Link>
                }
              />
              <CardBody>
                {wallet.data ? (
                  <>
                    {wallet.data.is_frozen && (
                      <Alert tone="warning" title="Wallet frozen" className="mb-4">
                        {wallet.data.frozen_reason ?? 'Payouts are on hold for this worker.'}
                      </Alert>
                    )}

                    <FieldGrid columns={2}>
                      <Field
                        label="Balance"
                        value={
                          <span className="text-base font-semibold tabular">
                            {formatMoney(wallet.data.balance_minor, wallet.data.currency)}
                          </span>
                        }
                      />
                      <Field
                        label="Total earned"
                        value={
                          <span className="tabular">
                            {formatMoney(wallet.data.total_credited_minor, wallet.data.currency)}
                          </span>
                        }
                      />
                      <Field
                        label="Total paid out"
                        value={
                          <span className="tabular">
                            {formatMoney(wallet.data.total_debited_minor, wallet.data.currency)}
                          </span>
                        }
                      />
                    </FieldGrid>
                  </>
                ) : (
                  <p className="text-sm text-ink-500">No wallet found for this worker.</p>
                )}
              </CardBody>
            </Card>
          </PermissionGuard>

          {/* Documents */}
          <Card>
            <CardHeader
              title="Documents"
              description={
                session.permissions.includes('workers.documents.read')
                  ? 'Opening a document is recorded'
                  : undefined
              }
            />

            {!session.permissions.includes('workers.documents.read') ? (
              <CardBody>
                <p className="text-sm text-ink-500">
                  Identity and qualification documents require the{' '}
                  <code className="rounded bg-ink-100 px-1 py-0.5 font-mono text-xs">
                    workers.documents.read
                  </code>{' '}
                  permission.
                </p>
              </CardBody>
            ) : documents.data && documents.data.length > 0 ? (
              <CardBody className="space-y-2">
                {documents.data.map((doc) => (
                  <DocumentLink
                    key={doc.id}
                    mediaId={doc.id}
                    fileName={doc.original_file_name}
                    mimeType={doc.mime_type}
                    sensitive={doc.sensitivity === MediaSensitivity.SENSITIVE}
                  />
                ))}
              </CardBody>
            ) : (
              <EmptyState
                icon={<FileWarning aria-hidden className="size-5" />}
                title="No documents on file"
                description="Documents are uploaded from the worker app and stored in Supabase Storage."
              />
            )}
          </Card>

          <PermissionGuard permissions={session.permissions} required="insurance.update">
            <Card>
              <CardHeader
                title="Insurance"
                description={
                  worker.is_insured
                    ? 'Insured. Recording a new policy replaces the current cover.'
                    : 'Not insured. Record the policy once it has been arranged.'
                }
              />
              <CardBody>
                <InsuranceRecordForm workerId={worker.id} />
              </CardBody>
            </Card>
          </PermissionGuard>

          <PageSection title="Verification summary">
            <Card>
              <CardBody className="space-y-2.5">
                {[
                  ['Identity (KYC)', worker.is_kyc_verified],
                  ['Background check', worker.is_background_verified],
                  ['Qualification', worker.is_qualification_verified],
                  ['Insurance', worker.is_insured],
                  ['Bank account', isBankVerified],
                ].map(([label, held]) => (
                  <div key={String(label)} className="flex items-center justify-between gap-3">
                    <span className="text-sm text-ink-700">{label}</span>
                    <Badge tone={held ? 'success' : 'neutral'} dot>
                      {held ? 'Verified' : 'Not held'}
                    </Badge>
                  </div>
                ))}
              </CardBody>
            </Card>
          </PageSection>
        </div>
      </div>
    </>
  );
}

const VERIFICATION_LABELS: Record<string, string> = {
  IDENTITY_KYC: 'Identity (KYC)',
  ADDRESS: 'Address',
  ITI_CERTIFICATE: 'ITI certificate',
  DIPLOMA: 'Diploma',
  RPL_SKILL: 'RPL skill assessment',
  BACKGROUND_CHECK: 'Background check',
  INSURANCE: 'Insurance',
  BANK_ACCOUNT: 'Bank account',
};
