'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';

import { Button } from '@/components/ui/button';
import { Alert } from '@/components/ui/feedback';
import { Input, Textarea } from '@/components/ui/form';
import { useToast } from '@/components/ui/toast';
import { apiRoutes } from '@/lib/config/routes';
import { cn } from '@/lib/utils/cn';

/**
 * Verification decision form.
 *
 * Each decision has its own obligation — a rejection needs a reason, a request
 * for information needs to say what is missing, an approval of a time-limited
 * check should carry an expiry — so this is a small form rather than a set of
 * one-click buttons. The server and the database enforce the same obligations.
 *
 * Only the decisions the operator's permissions allow are offered.
 */

type Decision = 'APPROVE' | 'REJECT' | 'REQUEST_INFO' | 'TAKE_REVIEW';

export function VerificationDecisionPanel({
  verificationId,
  canApprove,
  canReject,
  canReview,
  isDecided,
  suggestsExpiry,
  assignedToMe,
}: {
  verificationId: string;
  canApprove: boolean;
  canReject: boolean;
  canReview: boolean;
  isDecided: boolean;
  suggestsExpiry: boolean;
  assignedToMe: boolean;
}) {
  const router = useRouter();
  const toast = useToast();
  const [decision, setDecision] = useState<Decision | null>(null);
  const [text, setText] = useState('');
  const [note, setNote] = useState('');
  const [expiresAt, setExpiresAt] = useState('');
  const [pending, setPending] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const options: Array<{ value: Decision; label: string; show: boolean }> = [
    { value: 'TAKE_REVIEW', label: assignedToMe ? 'Assigned to you' : 'Take for review', show: canReview && !assignedToMe && !isDecided },
    { value: 'APPROVE', label: 'Approve', show: canApprove && !isDecided },
    { value: 'REJECT', label: 'Reject', show: canReject && !isDecided },
    { value: 'REQUEST_INFO', label: 'Request more information', show: canReview && !isDecided },
  ];
  const visible = options.filter((o) => o.show);

  if (isDecided) {
    return <p className="text-sm text-ink-500">This case has been decided. A new submission from the worker opens a new review.</p>;
  }

  if (visible.length === 0) {
    return <p className="text-sm text-ink-500">Your permissions do not include any decision on verification cases.</p>;
  }

  const submit = async () => {
    if (!decision) return;
    setError(null);

    if (decision === 'REJECT' && text.trim().length < 5) return setError('Give a rejection reason of at least 5 characters. The worker sees it.');
    if (decision === 'REQUEST_INFO' && text.trim().length < 5) return setError('Say what the worker needs to provide.');

    setPending(true);
    try {
      const response = await fetch(apiRoutes.adminVerificationDecision(verificationId), {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify({
          decision,
          note: note.trim() || undefined,
          rejectionReason: decision === 'REJECT' ? text.trim() : undefined,
          infoRequested: decision === 'REQUEST_INFO' ? text.trim() : undefined,
          expiresAt: decision === 'APPROVE' && expiresAt ? new Date(`${expiresAt}T23:59:59`).toISOString() : undefined,
        }),
      });
      const payload: unknown = await response.json().catch(() => null);

      if (!response.ok) {
        const e = (payload as { error?: { message?: string; fieldErrors?: Record<string, string[]> } } | null)?.error;
        setError(e?.fieldErrors ? Object.values(e.fieldErrors).flat().join(' ') : (e?.message ?? 'The decision was not saved.'));
        return;
      }

      toast.success('Decision recorded');
      setDecision(null);
      setText('');
      setNote('');
      router.refresh();
    } catch {
      setError('The decision could not be sent. Check your connection and try again.');
    } finally {
      setPending(false);
    }
  };

  return (
    <div className="space-y-4">
      <fieldset>
        <legend className="text-sm font-medium text-ink-800">Decision</legend>
        <div className="mt-2 grid gap-2">
          {visible.map((option) => (
            <label
              key={option.value}
              className={cn(
                'flex cursor-pointer items-center gap-2.5 rounded-lg border px-3 py-2.5 text-sm',
                decision === option.value ? 'border-brand-600 bg-brand-50 text-brand-900' : 'border-ink-200 hover:bg-ink-50',
              )}
            >
              <input
                type="radio"
                name="verification-decision"
                value={option.value}
                checked={decision === option.value}
                onChange={() => {
                  setDecision(option.value);
                  setError(null);
                }}
                className="text-brand-700"
              />
              {option.label}
            </label>
          ))}
        </div>
      </fieldset>

      {decision === 'APPROVE' && (
        <Input
          label="Valid until"
          type="date"
          value={expiresAt}
          onChange={(event) => setExpiresAt(event.target.value)}
          hint={suggestsExpiry ? 'Recommended for this check — it stops counting once it lapses.' : 'Optional. Leave blank if this check does not expire.'}
          min={new Date().toISOString().slice(0, 10)}
        />
      )}

      {(decision === 'REJECT' || decision === 'REQUEST_INFO') && (
        <Textarea
          label={decision === 'REJECT' ? 'Rejection reason (shown to the worker)' : 'What does the worker need to provide?'}
          value={text}
          onChange={(event) => setText(event.target.value)}
          rows={3}
          required
        />
      )}

      {decision && decision !== 'TAKE_REVIEW' && (
        <Textarea label="Internal note" hint="Optional. Visible to administrators only." value={note} onChange={(event) => setNote(event.target.value)} rows={2} />
      )}

      {error && <Alert tone="danger">{error}</Alert>}

      <Button
        onClick={submit}
        disabled={!decision}
        loading={pending}
        variant={decision === 'REJECT' ? 'danger' : decision === 'APPROVE' ? 'success' : 'primary'}
        fullWidth
      >
        {decision ? `Confirm: ${visible.find((o) => o.value === decision)?.label}` : 'Choose a decision'}
      </Button>
    </div>
  );
}
