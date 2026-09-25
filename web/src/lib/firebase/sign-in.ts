'use client';

import {
  GoogleAuthProvider,
  RecaptchaVerifier,
  sendPasswordResetEmail,
  signInWithEmailAndPassword,
  signInWithPhoneNumber,
  signInWithPopup,
  signOut,
  type ConfirmationResult,
  type User,
} from 'firebase/auth';

import { firebaseAuth } from '@/lib/firebase/client';
import { apiRoutes } from '@/lib/config/routes';

/**
 * Sign-in.
 *
 * Three methods: email and password, Google, and phone OTP. Passwords are held
 * and checked by Firebase only — this server never receives one, and Firebase
 * rate-limits guessing. Password accounts are for administrators; the mobile
 * apps offer no password sign-in.
 *
 * Every path ends the same way: Firebase returns an ID token, the token is
 * posted to the server, and the server — not the browser — decides what the
 * person is allowed to do. Nothing in this module grants access.
 */

export class SignInError extends Error {
  readonly code: string;

  constructor(code: string, message: string) {
    super(message);
    this.name = 'SignInError';
    this.code = code;
  }
}

/**
 * Firebase error codes mapped to language a person can act on.
 *
 * Deliberately vague where being specific would help an attacker: an OTP that
 * is wrong and an OTP that has expired both say what to do next without
 * confirming whether the number is registered, and an unknown email reads the
 * same as a wrong password.
 */
const WRONG_EMAIL_OR_PASSWORD = 'That email and password do not match. Check them and try again.';

const MESSAGES: Record<string, string> = {
  'auth/invalid-email': 'Enter a valid email address.',
  'auth/missing-email': 'Enter your email address.',
  'auth/missing-password': 'Enter your password.',
  // With email enumeration protection on, Firebase reports both an unknown
  // email and a wrong password as invalid-credential. The older codes are
  // mapped the same way in case that protection is ever turned off.
  'auth/invalid-credential': WRONG_EMAIL_OR_PASSWORD,
  'auth/invalid-login-credentials': WRONG_EMAIL_OR_PASSWORD,
  'auth/wrong-password': WRONG_EMAIL_OR_PASSWORD,
  'auth/user-not-found': WRONG_EMAIL_OR_PASSWORD,
  'auth/operation-not-allowed':
    'This sign-in method is not enabled. Contact the platform administrator.',
  'auth/invalid-phone-number': 'Enter a valid mobile number including the country code.',
  'auth/missing-phone-number': 'Enter your mobile number.',
  'auth/quota-exceeded': 'Too many codes requested right now. Please try again later.',
  'auth/too-many-requests': 'Too many attempts. Wait a few minutes before trying again.',
  'auth/invalid-verification-code': 'That code is not correct. Check it and try again.',
  'auth/code-expired': 'That code has expired. Request a new one.',
  'auth/popup-closed-by-user': 'The Google sign-in window was closed before finishing.',
  'auth/popup-blocked': 'Your browser blocked the sign-in window. Allow pop-ups and try again.',
  'auth/cancelled-popup-request': 'Another sign-in window is already open.',
  'auth/account-exists-with-different-credential':
    'This email is already registered with a different sign-in method.',
  'auth/network-request-failed': 'Network problem. Check your connection and try again.',
  'auth/user-disabled': 'This account has been disabled. Contact support.',
  'auth/unauthorized-domain':
    'This site is not an authorised domain for sign-in. Contact the platform administrator.',
};

function toSignInError(error: unknown): SignInError {
  const code =
    error && typeof error === 'object' && 'code' in error
      ? String((error as { code: unknown }).code)
      : 'auth/unknown';

  return new SignInError(
    code,
    MESSAGES[code] ?? 'Sign-in could not be completed. Please try again.',
  );
}

/* ==========================================================================
   Email and password
   ========================================================================== */

export async function signInWithEmail(email: string, password: string): Promise<User> {
  try {
    const credential = await signInWithEmailAndPassword(firebaseAuth(), email, password);
    return credential.user;
  } catch (error) {
    throw toSignInError(error);
  }
}

/**
 * Email a link to set a new password. Firebase hosts the page the link opens,
 * so no password passes through this site.
 *
 * Resolves whether or not an account uses that address, so the form cannot be
 * used to discover which emails are registered.
 */
export async function sendPasswordReset(email: string): Promise<void> {
  try {
    await sendPasswordResetEmail(firebaseAuth(), email);
  } catch (error) {
    const signInError = toSignInError(error);
    if (signInError.code === 'auth/user-not-found') return;
    throw signInError;
  }
}

/* ==========================================================================
   Google
   ========================================================================== */

export async function signInWithGoogle(): Promise<User> {
  const provider = new GoogleAuthProvider();

  // Always show the account chooser. Without this, a shared machine silently
  // reuses whichever Google account signed in last — a real hazard for an
  // admin console.
  provider.setCustomParameters({ prompt: 'select_account' });

  try {
    const credential = await signInWithPopup(firebaseAuth(), provider);
    return credential.user;
  } catch (error) {
    throw toSignInError(error);
  }
}

/* ==========================================================================
   Phone OTP
   ========================================================================== */

let recaptchaVerifier: RecaptchaVerifier | null = null;

/**
 * Prepare the invisible reCAPTCHA that Firebase requires before it will send an
 * SMS. Kept module-level because Firebase rejects a second verifier bound to
 * the same container.
 */
function getRecaptchaVerifier(containerId: string): RecaptchaVerifier {
  if (recaptchaVerifier) return recaptchaVerifier;

  recaptchaVerifier = new RecaptchaVerifier(firebaseAuth(), containerId, {
    size: 'invisible',
  });

  return recaptchaVerifier;
}

/** Discard the verifier so the next attempt starts from a clean challenge. */
export function resetRecaptcha(): void {
  try {
    recaptchaVerifier?.clear();
  } catch {
    // Already torn down, or the container is gone. Nothing to recover.
  }
  recaptchaVerifier = null;
}

/**
 * Send a one-time code by SMS.
 *
 * @param phoneNumber Must be in E.164 form, e.g. +919876543210.
 * @returns A confirmation handle to pass to `confirmPhoneOtp`.
 */
export async function sendPhoneOtp(
  phoneNumber: string,
  recaptchaContainerId: string,
): Promise<ConfirmationResult> {
  try {
    const verifier = getRecaptchaVerifier(recaptchaContainerId);
    return await signInWithPhoneNumber(firebaseAuth(), phoneNumber, verifier);
  } catch (error) {
    // A failed attempt leaves the challenge spent; rebuild it for the retry.
    resetRecaptcha();
    throw toSignInError(error);
  }
}

export async function confirmPhoneOtp(
  confirmation: ConfirmationResult,
  code: string,
): Promise<User> {
  try {
    const credential = await confirmation.confirm(code);
    return credential.user;
  } catch (error) {
    throw toSignInError(error);
  }
}

/* ==========================================================================
   Server session exchange
   ========================================================================== */

export interface SessionExchangeResult {
  /** True when the server recognised this user as an active administrator. */
  isAdmin: boolean;
  redirectTo: string;
}

interface SessionExchangeResponse extends SessionExchangeResult {
  /**
   * The server has just added the `role: "authenticated"` claim Supabase needs,
   * and the token that was sent predates it. The client must mint a fresh token
   * and exchange again.
   */
  refreshRequired: boolean;
}

async function postIdToken(idToken: string): Promise<SessionExchangeResponse> {
  const response = await fetch(apiRoutes.session, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ idToken }),
    credentials: 'same-origin',
  });

  const payload: unknown = await response.json().catch(() => null);

  if (!response.ok) {
    const message =
      payload && typeof payload === 'object' && 'error' in payload
        ? ((payload as { error: { message?: string } }).error?.message ??
          'Could not start your session.')
        : 'Could not start your session.';

    throw new SignInError('session/exchange-failed', message);
  }

  const data = (payload as { data?: Partial<SessionExchangeResponse> })?.data;

  return {
    isAdmin: data?.isAdmin ?? false,
    redirectTo: data?.redirectTo ?? '/',
    refreshRequired: data?.refreshRequired ?? false,
  };
}

/**
 * Exchange the Firebase ID token for an httpOnly server session.
 *
 * This is the moment authentication becomes authorization. The browser hands
 * over a token; the server verifies it, looks the Firebase UID up in
 * public.admin_users, and answers with what the person may actually do. The
 * client cannot influence that answer.
 */
export async function establishServerSession(user: User): Promise<SessionExchangeResult> {
  // `true` forces a newly minted token. Firebase refuses to create a session
  // cookie from an ID token older than five minutes.
  let result = await postIdToken(await user.getIdToken(true));

  // First sign-in for this account: the server added the Supabase role claim,
  // which only appears in tokens minted after it was set.
  if (result.refreshRequired) {
    result = await postIdToken(await user.getIdToken(true));
  }

  if (result.refreshRequired) {
    throw new SignInError(
      'session/claims-pending',
      'Your account is still being set up. Please try signing in again in a moment.',
    );
  }

  return { isAdmin: result.isAdmin, redirectTo: result.redirectTo };
}

/** Sign out of Firebase and clear the server session cookies. */
export async function signOutEverywhere(): Promise<void> {
  await fetch(apiRoutes.session, { method: 'DELETE', credentials: 'same-origin' }).catch(() => {
    // Even if the server call fails, still drop the client credential below.
  });

  resetRecaptcha();
  await signOut(firebaseAuth());
}
