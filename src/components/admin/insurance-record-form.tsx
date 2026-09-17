'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';

import { Button } from '@/components/ui/button';
import { Alert } from '@/components/ui/feedback';
import { Input, Textarea } from '@/components/ui/form';
import { useToast } from '@/components/ui/toast';
import { apiRoutes } from '@/lib/config/routes';

/** Rupees as typed → integer paise, or null when the text is not a valid amount. */
function toMinor(text: string): number | null {
  const trimmed = text.trim();
  if (!/^\d+(\.\d{1,2})?$/.test(trimmed)) return null;
  const [rupees = '0', paise = ''] = trimmed.split('.');
  return Number(rupees) * 100 + Number(paise.padEnd(2, '0'));
}

/**
 * Records an insurance policy for one worker and marks them insured until the
 * policy ends.
 */
export function InsuranceRecordForm({ workerId }: { workerId: string }) {
  const router = useRouter();
  const toast = useToast();
  const [open, setOpen] = useState(false);
  const [providerName, setProviderName] = useState('');
  const [policyNumber, setPolicyNumber] = useState('');
  const [coverage, setCoverage] = useState('');
  const [premium, setPremium] = useState('');
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');
  const [notes, setNotes] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [pending, setPending] = useState(false);

  if (!open) {
    return (
      <Button variant="outline" size="sm" onClick={() => setOpen(true)} fullWidth>
        Add insurance policy
      </Button>
    );
  }

  const submit = async () => {
    setError(null);
    const coverageAmountMinor = toMinor(coverage);
    const premiumAmountMinor = premium.trim() ? toMinor(premium) : undefined;

    if (providerName.trim().length < 2 || policyNumber.trim().length < 3) {
      return setError('Enter the insurer and the policy number.');
    }
    if (coverageAmountMinor === null || coverageAmountMinor <= 0) {
      return setError('Enter the coverage amount in rupees.');
    }
    if (premiumAmountMinor === null) {
      return setError('Enter the premium in rupees, or leave it blank.');
    }
    if (!startDate || !endDate || endDate <= startDate) {
      return setError('Choose a start date and an end date after it.');
    }

    setPending(true);
    try {
      const response = await fetch(apiRoutes.adminInsurance, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify({
          workerId,
          providerName: providerName.trim(),
          policyNumber: policyNumber.trim(),
          coverageAmountMinor,
          premiumAmountMinor,
          startDate,
          endDate,
          notes: notes.trim() || undefined,
        }),
      });
      const payload: unknown = await response.json().catch(() => null);

      if (!response.ok) {
        const e = (payload as { error?: { message?: string; fieldErrors?: Record<string, string[]> } } | null)?.error;
        setError(e?.fieldErrors ? Object.values(e.fieldErrors).flat().join(' ') : (e?.message ?? 'The policy was not saved.'));
        return;
      }

      toast.success('Insurance policy recorded');
      setOpen(false);
      router.refresh();
    } catch {
      setError('The policy could not be sent. Check your connection and try again.');
    } finally {
      setPending(false);
    }
  };

  return (
    <div className="space-y-3">
      <Input label="Insurer" value={providerName} onChange={(e) => setProviderName(e.target.value)} required />
      <Input label="Policy number" value={policyNumber} onChange={(e) => setPolicyNumber(e.target.value)} required />
      <div className="grid gap-3 sm:grid-cols-2">
        <Input label="Coverage (₹)" inputMode="decimal" value={coverage} onChange={(e) => setCoverage(e.target.value)} required />
        <Input label="Premium (₹)" inputMode="decimal" value={premium} onChange={(e) => setPremium(e.target.value)} hint="Optional" />
        <Input label="Starts" type="date" value={startDate} onChange={(e) => setStartDate(e.target.value)} required />
        <Input label="Ends" type="date" value={endDate} onChange={(e) => setEndDate(e.target.value)} required />
      </div>
      <Textarea label="Notes" rows={2} value={notes} onChange={(e) => setNotes(e.target.value)} hint="Optional. Visible to administrators only." />
      {error && <Alert tone="danger">{error}</Alert>}
      <div className="flex gap-2">
        <Button variant="outline" onClick={() => setOpen(false)} disabled={pending} fullWidth>
          Cancel
        </Button>
        <Button onClick={submit} loading={pending} fullWidth>
          Save policy
        </Button>
      </div>
    </div>
  );
}
