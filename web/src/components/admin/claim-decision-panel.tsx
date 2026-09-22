'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';

import { Button } from '@/components/ui/button';
import { Alert } from '@/components/ui/feedback';
import { Input, Textarea } from '@/components/ui/form';
import { useToast } from '@/components/ui/toast';
import { apiRoutes } from '@/lib/config/routes';
import { cn } from '@/lib/utils/cn';
import { formatMoney } from '@/lib/utils/format';

type Decision = 'TAKE_REVIEW' | 'REQUEST_INFO' | 'APPROVE' | 'PARTIALLY_APPROVE' | 'REJECT' | 'CLOSE';

/**
 * Claim decision form.
 *
 * The amount is typed in rupees and converted to integer paise before it is
 * sent. The server and the database both refuse an approval above the amount
 * claimed, and a "partial" approval that equals the full amount.
 */
export function ClaimDecisionPanel({
  claimId,
  claimedMinor,
  currency,
  status,
  canReview,
  canApprove,
  canReject,
}: {
  claimId: string;
  claimedMinor: number;
  currency: string;
  status: string;
  canReview: boolean;
  canApprove: boolean;
  canReject: boolean;
}) {
  const router = useRouter();
  const toast = useToast();
  const [decision, setDecision] = useState<Decision | null>(null);
  const [amount, setAmount] = useState('');
  const [text, setText] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [pending, setPending] = useState(false);

  const decided = ['APPROVED', 'PARTIALLY_APPROVED', 'REJECTED'].includes(status);

  const options: Array<{ value: Decision; label: string; show: boolean }> = [
    { value: 'TAKE_REVIEW', label: 'Take under review', show: canReview && status === 'SUBMITTED' },
    { value: 'REQUEST_INFO', label: 'Request more information', show: canReview && !decided },
    { value: 'APPROVE', label: 'Approve in full', show: canApprove && !decided },
    { value: 'PARTIALLY_APPROVE', label: 'Approve part of the amount', show: canApprove && !decided },
    { value: 'REJECT', label: 'Reject', show: canReject && !decided },
    { value: 'CLOSE', label: 'Close claim', show: canReview && decided },
  ];
  const visible = options.filter((o) => o.show);

  if (status === 'CLOSED') return <p className="text-sm text-ink-500">This claim is closed.</p>;
  if (visible.length === 0) return <p className="text-sm text-ink-500">Your permissions do not include a decision at this stage.</p>;

  const toMinor = (value: string): number | null => {
    if (!/^\d+(\.\d{1,2})?$/.test(value.trim())) return null;
    const [rupees = '0', paise = ''] = value.trim().split('.');
    return Number(rupees) * 100 + Number(paise.padEnd(2, '0'));
  };

  const submit = async () => {
    if (!decision) return;
    setError(null);

    let amountMinor: number | undefined;
    if (decision === 'APPROVE') amountMinor = claimedMinor;
    if (decision === 'PARTIALLY_APPROVE') {
      const parsed = toMinor(amount);
      if (parsed === null || parsed <= 0) return setError('Enter the approved amount.');
      if (parsed >= claimedMinor) return setError(`A partial approval must be less than ${formatMoney(claimedMinor, currency)}.`);
      amountMinor = parsed;
    }
    if (decision === 'REJECT' && text.trim().length < 10) return setError('Give a rejection reason of at least 10 characters. The customer sees it.');
    if (decision === 'REQUEST_INFO' && text.trim().length < 5) return setError('Say what information is needed.');

    setPending(true);
    try {
      const response = await fetch(apiRoutes.adminClaimDecision(claimId), {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify({
          decision,
          amountMinor,
          reason: decision === 'REJECT' ? text.trim() : undefined,
          note: decision !== 'REJECT' && text.trim() ? text.trim() : undefined,
        }),
      });
      const payload: unknown = await response.json().catch(() => null);
      if (!response.ok) {
        const e = (payload as { error?: { message?: string; fieldErrors?: Record<string, string[]> } } | null)?.error;
        setError(e?.fieldErrors ? Object.values(e.fieldErrors).flat().join(' ') : (e?.message ?? 'The decision was not saved.'));
        return;
      }
      toast.success('Claim decision recorded');
      setDecision(null);
      setAmount('');
      setText('');
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
            <label key={option.value} className={cn('flex cursor-pointer items-center gap-2.5 rounded-lg border px-3 py-2.5 text-sm', decision === option.value ? 'border-brand-600 bg-brand-50' : 'border-ink-200 hover:bg-ink-50')}>
              <input type="radio" name="claim-decision" checked={decision === option.value} onChange={() => { setDecision(option.value); setError(null); }} />
              {option.label}
            </label>
          ))}
        </div>
      </fieldset>

      {decision === 'APPROVE' && <Alert tone="info">Approves the full claimed amount of {formatMoney(claimedMinor, currency)}.</Alert>}
      {decision === 'PARTIALLY_APPROVE' && (
        <Input label={`Approved amount (${currency})`} inputMode="decimal" value={amount} onChange={(e) => setAmount(e.target.value)} hint={`Less than ${formatMoney(claimedMinor, currency)}`} />
      )}
      {decision && decision !== 'TAKE_REVIEW' && (
        <Textarea
          label={decision === 'REJECT' ? 'Rejection reason (shown to the customer)' : decision === 'REQUEST_INFO' ? 'Information needed' : 'Decision note'}
          value={text}
          onChange={(e) => setText(e.target.value)}
          rows={3}
          required={decision === 'REJECT' || decision === 'REQUEST_INFO'}
        />
      )}

      {error && <Alert tone="danger">{error}</Alert>}

      <Button onClick={submit} disabled={!decision} loading={pending} fullWidth variant={decision === 'REJECT' ? 'danger' : decision === 'APPROVE' || decision === 'PARTIALLY_APPROVE' ? 'success' : 'primary'}>
        {decision ? `Confirm: ${visible.find((o) => o.value === decision)?.label}` : 'Choose a decision'}
      </Button>
    </div>
  );
}
