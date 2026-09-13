import type { Metadata } from 'next';
import { notFound } from 'next/navigation';
import Link from 'next/link';
import { Lock } from 'lucide-react';

import { ActionButton } from '@/components/admin/action-button';
import { DocumentLink } from '@/components/admin/document-link';
import { ForbiddenPanel, PageHeader, PermissionGuard } from '@/components/admin/page-parts';
import { SupportReplyForm } from '@/components/admin/support-reply-form';
import { StatusBadge } from '@/components/shared/status-badge';
import { Card, CardBody, CardHeader, Field, FieldGrid } from '@/components/ui/card';
import { EmptyState } from '@/components/ui/feedback';
import { guardPage } from '@/lib/auth/page-guard';
import { adminRoutes, apiRoutes } from '@/lib/config/routes';
import { cn } from '@/lib/utils/cn';
import { formatDateTime, humaniseEnum } from '@/lib/utils/format';
import { SupportStatus } from '@/types/domain';
import type { SupportMessageRow, SupportTicketRow } from '@/types/database.types';

export const metadata: Metadata = { title: 'Support ticket' };
export const dynamic = 'force-dynamic';

type TicketDetail = SupportTicketRow & {
  customers: { id: string; full_name: string } | null;
  workers: { id: string; full_name: string } | null;
  bookings: { id: string; booking_code: string } | null;
};

type MessageRow = SupportMessageRow & { admin_users: { full_name: string } | null };

export default async function SupportTicketPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const { session, allowed } = await guardPage('support.read', adminRoutes.supportTicket(id));
  if (!allowed) return <ForbiddenPanel permission="support.read" role={session.role} resource="support" />;

  const { data: ticket } = await session.db
    .from('support_tickets')
    .select('*, customers(id, full_name), workers(id, full_name), bookings(id, booking_code)')
    .eq('id', id)
    .maybeSingle()
    .overrideTypes<TicketDetail>();

  if (!ticket) notFound();

  const [messages, attachments] = await Promise.all([
    session.db.from('support_messages').select('*, admin_users:author_admin_id(full_name)').eq('ticket_id', id).order('created_at').overrideTypes<MessageRow[]>(),
    session.db.from('media_assets').select('id, original_file_name, mime_type').eq('support_ticket_id', id).eq('upload_status', 'COMPLETED').is('deleted_at', null),
  ]);

  const requester = ticket.customers ?? ticket.workers;
  const requesterHref = ticket.customers ? adminRoutes.customer(ticket.customers.id) : ticket.workers ? adminRoutes.worker(ticket.workers.id) : null;
  const closed = ticket.status === SupportStatus.CLOSED;

  const statusAction = (status: SupportStatus, label: string, variant: 'outline' | 'success' = 'outline') => (
    <ActionButton
      key={status}
      endpoint={apiRoutes.adminSupportStatus(ticket.id)}
      payload={{ status }}
      label={label}
      variant={variant}
      fullWidth
      confirmTitle={`${label}?`}
      confirmDescription={`The ticket moves to ${humaniseEnum(status).toLowerCase()}.`}
      successMessage={`Ticket ${humaniseEnum(status).toLowerCase()}`}
    />
  );

  return (
    <>
      <PageHeader title={ticket.subject} description={<span className="flex flex-wrap items-center gap-2"><span className="font-mono text-xs text-ink-500">{ticket.ticket_code}</span><StatusBadge kind="support" status={ticket.status} /></span>} />

      <div className="grid gap-5 xl:grid-cols-3">
        <div className="space-y-5 xl:col-span-2">
          <Card>
            <CardHeader title="Conversation" />
            {messages.data && messages.data.length > 0 ? (
              <ol className="space-y-3 p-5">
                {messages.data.map((message) => {
                  const fromStaff = message.author_type === 'ADMIN';
                  return (
                    <li key={message.id} className={cn('rounded-lg border p-3.5', message.is_internal ? 'border-warning-100 bg-warning-50' : fromStaff ? 'border-brand-100 bg-brand-50/50' : 'border-ink-200 bg-white')}>
                      <p className="flex flex-wrap items-center gap-2 text-xs text-ink-500">
                        <span className="font-medium text-ink-800">{fromStaff ? (message.admin_users?.full_name ?? 'Staff') : humaniseEnum(message.author_type)}</span>
                        <time dateTime={message.created_at}>{formatDateTime(message.created_at)}</time>
                        {message.is_internal && <span className="inline-flex items-center gap-1 font-medium text-warning-700"><Lock aria-hidden className="size-3" />Internal note</span>}
                      </p>
                      <p className="mt-1.5 whitespace-pre-wrap text-sm leading-relaxed text-ink-800">{message.body}</p>
                    </li>
                  );
                })}
              </ol>
            ) : (
              <EmptyState title="No messages yet" />
            )}

            {!closed && (
              <PermissionGuard permissions={session.permissions} required="support.respond">
                <div className="border-t border-ink-200 p-5">
                  <SupportReplyForm ticketId={ticket.id} />
                </div>
              </PermissionGuard>
            )}
          </Card>
        </div>

        <div className="space-y-5">
          <Card>
            <CardHeader title="Details" />
            <CardBody>
              <FieldGrid columns={2}>
                <Field label="Requester" value={requester && requesterHref ? <Link className="text-brand-700 hover:underline" href={requesterHref}>{requester.full_name}</Link> : '—'} />
                <Field label="Type" value={humaniseEnum(ticket.requester_type)} />
                <Field label="Category" value={humaniseEnum(ticket.category)} />
                <Field label="Priority" value={humaniseEnum(ticket.priority)} />
                <Field label="Booking" value={ticket.bookings ? <Link className="text-brand-700 hover:underline" href={adminRoutes.booking(ticket.bookings.id)}>{ticket.bookings.booking_code}</Link> : '—'} />
                <Field label="Assigned" value={ticket.assigned_admin_id ? (ticket.assigned_admin_id === session.adminId ? 'You' : 'Another admin') : 'Unassigned'} />
                <Field label="Created" value={formatDateTime(ticket.created_at)} />
                <Field label="First response" value={formatDateTime(ticket.first_response_at)} />
              </FieldGrid>
            </CardBody>
          </Card>

          {attachments.data && attachments.data.length > 0 && (
            <Card>
              <CardHeader title="Attachments" />
              <CardBody className="space-y-2">
                {attachments.data.map((file) => <DocumentLink key={file.id} mediaId={file.id} fileName={file.original_file_name} mimeType={file.mime_type} sensitive />)}
              </CardBody>
            </Card>
          )}

          <PermissionGuard permissions={session.permissions} required="support.respond">
            <Card>
              <CardHeader title="Status" />
              <CardBody className="space-y-2">
                {ticket.status !== SupportStatus.WAITING_FOR_USER && !closed && statusAction(SupportStatus.WAITING_FOR_USER, 'Mark waiting for user')}
                {ticket.status !== SupportStatus.RESOLVED && !closed && statusAction(SupportStatus.RESOLVED, 'Mark resolved', 'success')}
                {!closed && statusAction(SupportStatus.CLOSED, 'Close ticket')}
                {closed && statusAction(SupportStatus.OPEN, 'Reopen ticket')}
              </CardBody>
            </Card>
          </PermissionGuard>
        </div>
      </div>
    </>
  );
}
