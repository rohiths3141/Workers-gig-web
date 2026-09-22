'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';

import { Button } from '@/components/ui/button';
import { Checkbox, Textarea } from '@/components/ui/form';
import { useToast } from '@/components/ui/toast';
import { apiRoutes } from '@/lib/config/routes';

/**
 * Reply on a ticket. An internal note is stored as such and filtered out for the
 * requester by the database policy, not by this form.
 */
export function SupportReplyForm({ ticketId }: { ticketId: string }) {
  const router = useRouter();
  const toast = useToast();
  const [body, setBody] = useState('');
  const [isInternal, setIsInternal] = useState(false);
  const [pending, setPending] = useState(false);

  const submit = async (event: React.FormEvent) => {
    event.preventDefault();
    if (!body.trim()) return;
    setPending(true);
    try {
      const response = await fetch(apiRoutes.adminSupportMessage(ticketId), {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify({ body: body.trim(), isInternal }),
      });
      const payload: unknown = await response.json().catch(() => null);
      if (!response.ok) {
        toast.error('Message not sent', (payload as { error?: { message?: string } } | null)?.error?.message ?? 'The server refused the message.');
        return;
      }
      toast.success(isInternal ? 'Internal note added' : 'Reply sent');
      setBody('');
      setIsInternal(false);
      router.refresh();
    } catch {
      toast.error('Message not sent', 'Check your connection and try again.');
    } finally {
      setPending(false);
    }
  };

  return (
    <form onSubmit={submit} className="space-y-3">
      <Textarea label={isInternal ? 'Internal note' : 'Reply'} value={body} onChange={(e) => setBody(e.target.value)} rows={4} maxLength={5000} required />
      <Checkbox label="Internal note" hint="Visible to staff only. The requester never sees it." checked={isInternal} onChange={(e) => setIsInternal(e.target.checked)} />
      <div className="flex justify-end">
        <Button type="submit" loading={pending} disabled={!body.trim()} variant={isInternal ? 'secondary' : 'primary'}>
          {isInternal ? 'Add note' : 'Send reply'}
        </Button>
      </div>
    </form>
  );
}
