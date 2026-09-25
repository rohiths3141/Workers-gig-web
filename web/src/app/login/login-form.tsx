'use client';

import { useState, type ReactNode } from 'react';
import { useRouter } from 'next/navigation';
import type { ConfirmationResult } from 'firebase/auth';
import { ArrowLeft, FlaskConical, KeyRound, LogIn, Mail, ShieldAlert, Smartphone } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Alert } from '@/components/ui/feedback';
import { Input } from '@/components/ui/form';
import {
  confirmPhoneOtp,
  establishServerSession,
  resetRecaptcha,
  sendPasswordReset,
  sendPhoneOtp,
  signInWithEmail,
  signInWithGoogle,
  SignInError,
} from '@/lib/firebase/sign-in';
import { signOutEverywhere } from '@/lib/firebase/sign-in';

/**
 * Sign-in form.
 *
 * Three methods: email and password, Google, and a one-time code by SMS. The
 * password is sent to Firebase, never to this server, and a forgotten one is
 * reset through a Firebase-hosted link.
 *
 * What this form cannot do is decide anything. It obtains a Firebase ID token
 * and posts it to the server; the server verifies it, looks up the platform
 * identity, and answers with where the person may go. A user who is signed in
 * but is not an administrator is signed straight back out here, with an honest
 * explanation.
 */

const RECAPTCHA_CONTAINER_ID = 'phone-otp-recaptcha';

// A shape check only, to catch typos before a round trip. Firebase decides
// what is actually a valid address.
const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

type Stage = 'method' | 'reset' | 'phone' | 'otp-sent';

type Pending = 'email' | 'google' | 'reset' | 'send-otp' | 'verify-otp';

export function LoginForm({
  redirectTo,
  demoLogin,
}: {
  redirectTo?: string;
  /** Prototype only: a shared demo account, shown in full on the page. */
  demoLogin?: { email: string; password: string } | null;
}) {
  const router = useRouter();

  const [stage, setStage] = useState<Stage>('method');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [phone, setPhone] = useState('+91');
  const [code, setCode] = useState('');
  const [confirmation, setConfirmation] = useState<ConfirmationResult | null>(null);

  const [pending, setPending] = useState<Pending | null>(null);
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

  const handleEmailSignIn = async (event: React.FormEvent) => {
    event.preventDefault();
    setError(null);
    setNotice(null);

    const trimmed = email.trim();

    if (!EMAIL_PATTERN.test(trimmed)) {
      setError('Enter the email address on your administrator account.');
      return;
    }

    if (!password) {
      setError('Enter your password.');
      return;
    }

    setPending('email');

    try {
      const user = await signInWithEmail(trimmed, password);
      await completeSignIn(user);
    } catch (caught) {
      setPassword('');
      setError(
        caught instanceof SignInError
          ? caught.message
          : 'Sign-in could not be completed. Please try again.',
      );
    } finally {
      setPending(null);
    }
  };

  const handleSendReset = async (event: React.FormEvent) => {
    event.preventDefault();
    setError(null);
    setNotice(null);

    const trimmed = email.trim();

    if (!EMAIL_PATTERN.test(trimmed)) {
      setError('Enter the email address on your administrator account.');
      return;
    }

    setPending('reset');

    try {
      await sendPasswordReset(trimmed);
      // Worded so it does not confirm whether the address has an account.
      setNotice(
        `If an account uses ${trimmed}, a link to set a new password is on its way. ` +
          'Check your inbox and spam folder.',
      );
      setStage('method');
    } catch (caught) {
      setError(
        caught instanceof SignInError
          ? caught.message
          : 'The reset link could not be sent. Please try again.',
      );
    } finally {
      setPending(null);
    }
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

  const goTo = (next: Stage) => {
    setStage(next);
    setError(null);
    setNotice(null);
  };

  const restart = () => {
    resetRecaptcha();
    setConfirmation(null);
    setCode('');
    goTo('method');
  };

  return (
    <div className="space-y-5">
      {error && (
        <Alert tone="danger" title="Sign-in failed">
          {error}
        </Alert>
      )}

      {notice && !error && <Alert tone="info">{notice}</Alert>}

      {stage === 'method' && (
        <>
          {demoLogin && (
            <DemoLoginCard
              {...demoLogin}
              disabled={pending !== null}
              onUse={() => {
                setEmail(demoLogin.email);
                setPassword(demoLogin.password);
                setError(null);
              }}
            />
          )}

          <form onSubmit={handleEmailSignIn} className="space-y-4" noValidate>
            <Input
              label="Email"
              type="email"
              inputMode="email"
              // "username" is what password managers look for on a sign-in form.
              autoComplete="username"
              value={email}
              onChange={(event) => setEmail(event.target.value)}
              placeholder="you@example.com"
              required
            />

            <div className="space-y-1.5">
              <Input
                label="Password"
                type="password"
                autoComplete="current-password"
                value={password}
                onChange={(event) => setPassword(event.target.value)}
                required
              />
              <div className="flex justify-end">
                <button
                  type="button"
                  onClick={() => goTo('reset')}
                  disabled={pending !== null}
                  className="text-sm font-medium text-brand-700 hover:underline disabled:opacity-50"
                >
                  Forgot password?
                </button>
              </div>
            </div>

            <Button
              type="submit"
              loading={pending === 'email'}
              disabled={pending !== null}
              size="lg"
              fullWidth
            >
              <LogIn aria-hidden className="size-4" />
              Sign in
            </Button>
          </form>

          <div className="flex items-center gap-3" aria-hidden>
            <span className="h-px flex-1 bg-ink-200" />
            <span className="text-xs font-medium uppercase tracking-wide text-ink-400">or</span>
            <span className="h-px flex-1 bg-ink-200" />
          </div>

          <div className="space-y-3">
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

            <Button
              onClick={() => goTo('phone')}
              disabled={pending !== null}
              variant="outline"
              size="lg"
              fullWidth
            >
              <Smartphone aria-hidden className="size-4" />
              Continue with mobile number
            </Button>
          </div>
        </>
      )}

      {stage === 'reset' && (
        <form onSubmit={handleSendReset} className="space-y-4" noValidate>
          <p className="text-sm text-ink-600">
            Enter the email address on your administrator account and we will send you a link to
            set a new password.
          </p>

          <Input
            label="Email"
            type="email"
            inputMode="email"
            autoComplete="username"
            value={email}
            onChange={(event) => setEmail(event.target.value)}
            placeholder="you@example.com"
            autoFocus
            required
          />

          <Button
            type="submit"
            loading={pending === 'reset'}
            disabled={pending !== null}
            size="lg"
            fullWidth
          >
            <Mail aria-hidden className="size-4" />
            Send reset link
          </Button>

          <BackButton onClick={restart} disabled={pending !== null}>
            Back to sign in
          </BackButton>
        </form>
      )}

      {stage === 'phone' && (
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
            autoFocus
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

          <BackButton onClick={restart} disabled={pending !== null}>
            Use a different method
          </BackButton>
        </form>
      )}

      {stage === 'otp-sent' && (
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

          <BackButton onClick={restart} disabled={pending !== null}>
            Use a different number or method
          </BackButton>
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

function DemoLoginCard({
  email,
  password,
  disabled,
  onUse,
}: {
  email: string;
  password: string;
  disabled: boolean;
  onUse: () => void;
}) {
  return (
    <section
      aria-labelledby="demo-login-title"
      className="rounded-xl border border-brand-200 bg-brand-50 p-4"
    >
      <h2
        id="demo-login-title"
        className="flex items-center gap-2 text-sm font-semibold text-brand-900"
      >
        <FlaskConical aria-hidden className="size-4" />
        Prototype demo login
      </h2>

      <dl className="mt-3 grid grid-cols-[auto_1fr] gap-x-3 gap-y-1.5 text-sm">
        <dt className="text-ink-600">Email</dt>
        <dd className="break-all font-mono text-ink-900">{email}</dd>
        <dt className="text-ink-600">Password</dt>
        <dd className="break-all font-mono text-ink-900">{password}</dd>
      </dl>

      <Button onClick={onUse} disabled={disabled} variant="outline" size="sm" className="mt-3">
        Fill in demo login
      </Button>
    </section>
  );
}

function BackButton({
  onClick,
  disabled,
  children,
}: {
  onClick: () => void;
  disabled: boolean;
  children: ReactNode;
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      disabled={disabled}
      className="inline-flex items-center gap-1.5 text-sm font-medium text-ink-600 hover:text-brand-700 disabled:opacity-50"
    >
      <ArrowLeft aria-hidden className="size-4" />
      {children}
    </button>
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
