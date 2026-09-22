'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import type { ConfirmationResult } from 'firebase/auth';
import { ArrowLeft, KeyRound, ShieldAlert, Smartphone } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Alert } from '@/components/ui/feedback';
import { Input } from '@/components/ui/form';
import {
  confirmPhoneOtp,
  establishServerSession,
  resetRecaptcha,
  sendPhoneOtp,
  signInWithGoogle,
  SignInError,
} from '@/lib/firebase/sign-in';
import { signOutEverywhere } from '@/lib/firebase/sign-in';

/**
 * Sign-in form.
 *
 * Two methods: Google, and a one-time code by SMS. No password field exists
 * anywhere, so there is no password to guess, reuse or reset.
 *
 * What this form cannot do is decide anything. It obtains a Firebase ID token
 * and posts it to the server; the server verifies it, looks up the platform
 * identity, and answers with where the person may go. A user who is signed in
 * but is not an administrator is signed straight back out here, with an honest
 * explanation.
 */

const RECAPTCHA_CONTAINER_ID = 'phone-otp-recaptcha';

type Stage = 'method' | 'otp-sent';

export function LoginForm({ redirectTo }: { redirectTo?: string }) {
  const router = useRouter();

  const [stage, setStage] = useState<Stage>('method');
  const [phone, setPhone] = useState('+91');
  const [code, setCode] = useState('');
  const [confirmation, setConfirmation] = useState<ConfirmationResult | null>(null);

  const [pending, setPending] = useState<'google' | 'send-otp' | 'verify-otp' | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [notice, setNotice] = useState<string | null>(null);

  /**
   * Shared tail of every successful sign-in: exchange the token for a server
   * session, then route on the server's answer.
   */
  const completeSignIn = async (user: Parameters<typeof establishServerSession>[0]) => {
    const result = await establishServerSession(user);

    if (!result.isAdmin) {
      // Authenticated, but not an administrator. Do not leave a half-useful
      // session behind, and say plainly what happened.
      await signOutEverywhere();
      setError(
        'This account is not an administrator on this platform. ' +
          'Customers and workers use the mobile apps to sign in.',
      );
      setStage('method');
      return;
    }

    // A full navigation rather than a client-side push, so the admin layout
    // re-runs its own server-side authorization from scratch.
    const destination = redirectTo ?? result.redirectTo;
    router.replace(destination);
    router.refresh();
  };

  const handleGoogle = async () => {
    setError(null);
    setNotice(null);
    setPending('google');

    try {
      const user = await signInWithGoogle();
      await completeSignIn(user);
    } catch (caught) {
      setError(
        caught instanceof SignInError
          ? caught.message
          : 'Google sign-in could not be completed. Please try again.',
      );
    } finally {
      setPending(null);
    }
  };

  const handleSendOtp = async (event: React.FormEvent) => {
    event.preventDefault();
    setError(null);
    setNotice(null);

    const trimmed = phone.trim();

    // Firebase requires E.164. Catching it here avoids spending a reCAPTCHA
    // challenge and an SMS quota on an obviously malformed number.
    if (!/^\+[1-9]\d{7,14}$/.test(trimmed)) {
      setError('Enter your mobile number in international format, for example +919876543210.');
      return;
    }

    setPending('send-otp');

    try {
      const result = await sendPhoneOtp(trimmed, RECAPTCHA_CONTAINER_ID);
      setConfirmation(result);
      setStage('otp-sent');
      setNotice(`A 6-digit code has been sent to ${trimmed}.`);
    } catch (caught) {
      setError(
        caught instanceof SignInError
          ? caught.message
          : 'The code could not be sent. Please try again.',
      );
    } finally {
      setPending(null);
    }
  };

  const handleVerifyOtp = async (event: React.FormEvent) => {
    event.preventDefault();
    setError(null);

    if (!confirmation) {
      setError('That code request has expired. Please request a new code.');
      setStage('method');
      return;
    }

    setPending('verify-otp');

    try {
      const user = await confirmPhoneOtp(confirmation, code.trim());
      await completeSignIn(user);
    } catch (caught) {
      setError(
        caught instanceof SignInError
          ? caught.message
          : 'That code could not be verified. Please try again.',
      );
    } finally {
      setPending(null);
    }
  };

  const restart = () => {
    resetRecaptcha();
    setConfirmation(null);
    setCode('');
    setStage('method');
    setError(null);
    setNotice(null);
  };

  return (
    <div className="space-y-5">
      {error && (
        <Alert tone="danger" title="Sign-in failed">
          {error}
        </Alert>
      )}

      {notice && !error && <Alert tone="info">{notice}</Alert>}

      {stage === 'method' ? (
        <>
          <Button
            onClick={handleGoogle}
            loading={pending === 'google'}
            disabled={pending !== null}
            variant="outline"
            size="lg"
            fullWidth
          >
            <GoogleMark />
            Continue with Google
          </Button>

          <div className="flex items-center gap-3" aria-hidden>
            <span className="h-px flex-1 bg-ink-200" />
            <span className="text-xs font-medium uppercase tracking-wide text-ink-400">or</span>
            <span className="h-px flex-1 bg-ink-200" />
          </div>

          <form onSubmit={handleSendOtp} className="space-y-4" noValidate>
            <Input
              label="Mobile number"
              type="tel"
              inputMode="tel"
              autoComplete="tel"
              value={phone}
              onChange={(event) => setPhone(event.target.value)}
              placeholder="+919876543210"
              hint="Include your country code. We will send a 6-digit code by SMS."
              required
            />

            <Button
              type="submit"
              loading={pending === 'send-otp'}
              disabled={pending !== null}
              size="lg"
              fullWidth
            >
              <Smartphone aria-hidden className="size-4" />
              Send code
            </Button>
          </form>
        </>
      ) : (
        <form onSubmit={handleVerifyOtp} className="space-y-4" noValidate>
          <Input
            label="6-digit code"
            type="text"
            inputMode="numeric"
            // Lets the browser and mobile keyboards offer the SMS code directly.
            autoComplete="one-time-code"
            pattern="[0-9]{6}"
            maxLength={6}
            value={code}
            onChange={(event) => setCode(event.target.value.replace(/\D/g, ''))}
            placeholder="000000"
            className="text-center text-lg tracking-[0.5em]"
            autoFocus
            required
          />

          <Button
            type="submit"
            loading={pending === 'verify-otp'}
            disabled={pending !== null || code.length !== 6}
            size="lg"
            fullWidth
          >
            <KeyRound aria-hidden className="size-4" />
            Verify and sign in
          </Button>

          <button
            type="button"
            onClick={restart}
            disabled={pending !== null}
            className="inline-flex items-center gap-1.5 text-sm font-medium text-ink-600 hover:text-brand-700 disabled:opacity-50"
          >
            <ArrowLeft aria-hidden className="size-4" />
            Use a different number or method
          </button>
        </form>
      )}

      {/* Firebase mounts the invisible reCAPTCHA challenge here. It must exist
          in the DOM before the first OTP request. */}
      <div id={RECAPTCHA_CONTAINER_ID} />

      <p className="flex gap-2 border-t border-ink-200 pt-4 text-xs leading-relaxed text-ink-500">
        <ShieldAlert aria-hidden className="mt-0.5 size-3.5 shrink-0" />
        Administrator access is granted individually and every action is recorded in an audit trail.
        Signing in does not by itself grant any access.
      </p>
    </div>
  );
}

/** Google's mark, inlined so no third-party image request is made. */
function GoogleMark() {
  return (
    <svg aria-hidden viewBox="0 0 18 18" className="size-4">
      <path
        fill="#4285F4"
        d="M17.64 9.2c0-.64-.06-1.25-.16-1.84H9v3.48h4.84a4.14 4.14 0 0 1-1.8 2.72v2.26h2.92c1.7-1.57 2.68-3.88 2.68-6.62Z"
      />
      <path
        fill="#34A853"
        d="M9 18c2.43 0 4.47-.8 5.96-2.18l-2.92-2.26c-.81.54-1.84.86-3.04.86-2.34 0-4.32-1.58-5.03-3.7H.96v2.33A9 9 0 0 0 9 18Z"
      />
      <path
        fill="#FBBC05"
        d="M3.97 10.72a5.41 5.41 0 0 1 0-3.44V4.95H.96a9 9 0 0 0 0 8.1l3.01-2.33Z"
      />
      <path
        fill="#EA4335"
        d="M9 3.58c1.32 0 2.5.46 3.44 1.35l2.58-2.58C13.46.9 11.43 0 9 0A9 9 0 0 0 .96 4.95l3.01 2.33C4.68 5.16 6.66 3.58 9 3.58Z"
      />
    </svg>
  );
}
