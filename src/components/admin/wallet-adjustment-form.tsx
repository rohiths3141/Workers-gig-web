'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';

import { Button } from '@/components/ui/button';
import { ConfirmDialog } from '@/components/ui/confirm-dialog';
import { Alert } from '@/components/ui/feedback';
import { Input, Select } from '@/components/ui/form';
import { useToast } from '@/components/ui/toast';
import { apiRoutes } from '@/lib/config/routes';
import { formatMoney } from '@/lib/utils/format';

/**
 * Manual wallet adjustment.
 *
 * Posts a ledger entry; it never sets a balance. The amount is entered in
 * rupees and converted to integer paise here, once, so no float ever reaches
 * the server. The idempotency key is generated when the dialog opens and reused
 * for retries of that same submission, so a double click or a flaky network
 * cannot post the entry twice.
 */
export function WalletAdjustmentForm({ workerId, currency }: { workerId: string; currency: string }) {
  const router = useRouter();
  const toast = useToast();
  const [amount, setAmount] = useState('');
  const [direction, setDirection] = useState<'CREDIT' | 'DEBIT'>('CREDIT');
  const [error, setError] = useState<string | null>(null);
  const [open, setOpen] = useState(false);
  const [pending, setPending] = useState(false);
  const [idempotencyKey, setIdempotencyKey] = useState('');

  const amountMinor = (() => {
    if (!/^\d+(\.\d{1,2})?$/.test(amount.trim())) return null;
    const [rupees = '0', paise = ''] = amount.trim().split('.');
    return Number(rupees) * 100 + Number(paise.padEnd(2, '0'));
  })();

  const review = () => {
    setError(null);
    if (amountMinor === null || amountMinor <= 0) {
      setError('Enter an amount greater than zero, with at most two decimal places.');
      return;
    }
    setIdempotencyKey(crypto.randomUUID());
    setOpen(true);
  };

  const submit = async (reason: string) => {
    if (amountMinor === null) return;
    setPending(true);
    try {
      const response = await fetch(apiRoutes.adminWalletAdjust(workerId), {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify({ amountMinor, direction, reason, idempotencyKey }),
      });
      const payload: unknown = await response.json().catch(() => null);
      if (!response.ok) {
        const e = (payload as { error?: { message?: string } } | null)?.error;
        toast.error('Adjustment not posted', e?.message ?? 'The server refused the adjustment.');
        return;
      }
      toast.success('Ledger entry posted');
      setOpen(false);
      setAmount('');
      router.refresh();
    } catch {
      toast.error('Adjustment not posted', 'Check your connection and try again. Retrying is safe.');
    } finally {
      setPending(false);
    }
  };

  return (
    <div className="space-y-3">
      <div className="grid gap-3 sm:grid-cols-2">
        <Select
          label="Direction"
          value={direction}
          onChange={(event) => setDirection(event.target.value as 'CREDIT' | 'DEBIT')}
          options={[
            { value: 'CREDIT', label: 'Credit (add to balance)' },
            { value: 'DEBIT', label: 'Debit (remove from balance)' },
          ]}
        />
        <Input label={`Amount (${currency})`} inputMode="decimal" placeholder="0.00" value={amount} onChange={(event) => setAmount(event.target.value)} />
      </div>
      {error && <Alert tone="danger">{error}</Alert>}
      <Button variant="outline" onClick={review} fullWidth>
        Review adjustment
      </Button>

      <ConfirmDialog
        open={open}
        onClose={() => !pending && setOpen(false)}
        onConfirm={submit}
        loading={pending}
        tone={direction === 'DEBIT' ? 'danger' : 'primary'}
        title={`${direction === 'CREDIT' ? 'Credit' : 'Debit'} ${formatMoney(amountMinor, currency)}?`}
        description="This posts a permanent ledger entry. It cannot be edited or deleted; a mistake is corrected with a compensating entry."
        confirmLabel="Post entry"
        requireReason
        reasonLabel="Reason for the adjustment"
      />
    </div>
  );
}
