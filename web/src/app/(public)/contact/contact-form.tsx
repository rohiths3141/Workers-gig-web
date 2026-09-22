'use client';

import { useState } from 'react';
import { CheckCircle2 } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Alert } from '@/components/ui/feedback';
import { Input, Textarea } from '@/components/ui/form';
import { apiRoutes } from '@/lib/config/routes';

/**
 * Contact form.
 *
 * Validates in the browser for fast feedback, but the server validates again
 * with its own schema and applies rate limiting — the browser checks are a
 * convenience, never the control.
 */

type FieldName = 'name' | 'email' | 'phone' | 'subject' | 'message';
type Values = Record<FieldName, string>;

const EMPTY: Values = { name: '', email: '', phone: '', subject: '', message: '' };

function validate(values: Values): Partial<Record<FieldName, string>> {
  const errors: Partial<Record<FieldName, string>> = {};
  if (values.name.trim().length < 2) errors.name = 'Enter your name.';
  if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(values.email.trim())) errors.email = 'Enter a valid email address.';
  if (values.phone.trim() && !/^\+?[0-9\s-]{7,20}$/.test(values.phone.trim())) {
    errors.phone = 'Enter a valid phone number, or leave it blank.';
  }
  if (values.subject.trim().length < 3) errors.subject = 'Enter a subject.';
  if (values.message.trim().length < 10) errors.message = 'Tell us a little more — at least 10 characters.';
  return errors;
}

export function ContactForm() {
  const [values, setValues] = useState<Values>(EMPTY);
  const [honeypot, setHoneypot] = useState('');
  const [errors, setErrors] = useState<Partial<Record<FieldName, string>>>({});
  const [formError, setFormError] = useState<string | null>(null);
  const [pending, setPending] = useState(false);
  const [sent, setSent] = useState(false);

  const update = (field: FieldName) => (event: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setValues((current) => ({ ...current, [field]: event.target.value }));
    if (errors[field]) setErrors((current) => ({ ...current, [field]: undefined }));
  };

  const submit = async (event: React.FormEvent) => {
    event.preventDefault();
    setFormError(null);

    const found = validate(values);
    setErrors(found);
    if (Object.keys(found).length > 0) return;

    setPending(true);
    try {
      const response = await fetch(apiRoutes.publicContact, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ ...values, website: honeypot }),
      });
      const payload: unknown = await response.json().catch(() => null);

      if (!response.ok) {
        const error = (payload as { error?: { message?: string; fieldErrors?: Record<string, string[]> } } | null)?.error;
        if (error?.fieldErrors) {
          const mapped: Partial<Record<FieldName, string>> = {};
          for (const [key, messages] of Object.entries(error.fieldErrors)) {
            if (key in EMPTY) mapped[key as FieldName] = messages[0];
          }
          setErrors(mapped);
        }
        setFormError(error?.message ?? 'Your message could not be sent. Please try again.');
        return;
      }

      setSent(true);
      setValues(EMPTY);
    } catch {
      setFormError('Your message could not be sent. Check your connection and try again.');
    } finally {
      setPending(false);
    }
  };

  if (sent) {
    return (
      <div role="status" className="rounded-2xl border border-success-100 bg-success-50 p-8 text-center">
        <CheckCircle2 aria-hidden className="mx-auto size-10 text-success-600" />
        <h2 className="mt-3 text-lg font-semibold text-ink-900">Message received</h2>
        <p className="mt-2 text-sm text-ink-600">
          Thank you. The support team will reply to the email address you gave.
        </p>
        <Button variant="outline" className="mt-5" onClick={() => setSent(false)}>
          Send another message
        </Button>
      </div>
    );
  }

  return (
    <form onSubmit={submit} noValidate className="space-y-4">
      {formError && <Alert tone="danger">{formError}</Alert>}

      <div className="grid gap-4 sm:grid-cols-2">
        <Input label="Name" autoComplete="name" value={values.name} onChange={update('name')} error={errors.name} required maxLength={120} />
        <Input label="Email" type="email" autoComplete="email" value={values.email} onChange={update('email')} error={errors.email} required maxLength={254} />
      </div>

      <div className="grid gap-4 sm:grid-cols-2">
        <Input label="Phone" type="tel" autoComplete="tel" value={values.phone} onChange={update('phone')} error={errors.phone} hint="Optional" maxLength={20} />
        <Input label="Subject" value={values.subject} onChange={update('subject')} error={errors.subject} required maxLength={200} />
      </div>

      <Textarea label="Message" rows={6} value={values.message} onChange={update('message')} error={errors.message} required maxLength={5000} />

      {/* Honeypot: invisible to people and to assistive technology. */}
      <div aria-hidden className="absolute -left-[10000px] top-auto h-px w-px overflow-hidden">
        <label>
          Website
          <input tabIndex={-1} autoComplete="off" value={honeypot} onChange={(event) => setHoneypot(event.target.value)} />
        </label>
      </div>

      <Button type="submit" size="lg" loading={pending}>
        Send message
      </Button>
    </form>
  );
}
