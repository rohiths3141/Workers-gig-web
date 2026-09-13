import 'server-only';

import { cert, getApps, initializeApp, type App } from 'firebase-admin/app';
import { getAuth, type Auth, type DecodedIdToken } from 'firebase-admin/auth';
import { getStorage, type Storage } from 'firebase-admin/storage';

import { serverEnv } from '@/lib/config/env';

/**
 * Firebase Admin SDK — the trusted half of authentication and storage.
 *
 * Guarded by `server-only`: importing this from a client component is a build
 * error, not a runtime surprise. The service account private key never reaches
 * the browser.
 *
 * Responsibilities:
 *   - Verify Firebase ID tokens and session cookies.
 *   - Mint httpOnly session cookies for the web surfaces.
 *   - Sign short-lived URLs for objects in Firebase Storage, only after the
 *     caller's ownership or permission has been checked against Supabase.
 */

const ADMIN_APP_NAME = 'sevasetu-admin';

function adminApp(): App {
  const existing = getApps().find((a) => a.name === ADMIN_APP_NAME);
  if (existing) return existing;

  const { firebaseAdmin } = serverEnv();

  return initializeApp(
    {
      credential: cert({
        projectId: firebaseAdmin.projectId,
        clientEmail: firebaseAdmin.clientEmail,
        privateKey: firebaseAdmin.privateKey,
      }),
      storageBucket: firebaseAdmin.storageBucket,
    },
    ADMIN_APP_NAME,
  );
}

export function adminAuth(): Auth {
  return getAuth(adminApp());
}

export function adminStorage(): Storage {
  return getStorage(adminApp());
}

export function storageBucket() {
  return adminStorage().bucket(serverEnv().firebaseAdmin.storageBucket);
}

// ---------------------------------------------------------------------------
// Token verification
// ---------------------------------------------------------------------------

export interface VerifiedFirebaseUser {
  uid: string;
  email: string | null;
  emailVerified: boolean;
  phoneNumber: string | null;
  displayName: string | null;
  /** Seconds since epoch at which the credential was issued. */
  authTime: number;
  signInProvider: string | null;
  /**
   * Whether the token carries `role: "authenticated"`. Supabase maps this claim
   * to the Postgres role; without it a forwarded token is treated as anonymous
   * and every RLS policy written for authenticated users denies.
   */
  hasSupabaseRole: boolean;
}

function toVerifiedUser(decoded: DecodedIdToken): VerifiedFirebaseUser {
  return {
    uid: decoded.uid,
    email: typeof decoded.email === 'string' ? decoded.email : null,
    emailVerified: decoded.email_verified === true,
    phoneNumber: typeof decoded.phone_number === 'string' ? decoded.phone_number : null,
    displayName: typeof decoded.name === 'string' ? decoded.name : null,
    authTime: decoded.auth_time,
    signInProvider: decoded.firebase?.sign_in_provider ?? null,
    hasSupabaseRole: decoded.role === 'authenticated',
  };
}

/**
 * Verify a Firebase ID token presented by a client.
 *
 * `checkRevoked` costs a round trip to Firebase but catches a token belonging
 * to a user who has since been disabled or had their sessions revoked, so it is
 * always on for the login exchange.
 */
export async function verifyIdToken(
  idToken: string,
  checkRevoked = true,
): Promise<VerifiedFirebaseUser> {
  const decoded = await adminAuth().verifyIdToken(idToken, checkRevoked);
  return toVerifiedUser(decoded);
}

/** Verify the httpOnly session cookie carried by an admin panel request. */
export async function verifySessionCookie(
  sessionCookie: string,
  checkRevoked = true,
): Promise<VerifiedFirebaseUser> {
  const decoded = await adminAuth().verifySessionCookie(sessionCookie, checkRevoked);
  return toVerifiedUser(decoded);
}

/**
 * Exchange a freshly minted ID token for a session cookie.
 *
 * Firebase refuses to mint a session cookie from an ID token older than five
 * minutes, which is the property that makes the cookie meaningful: it can only
 * be created moments after a real authentication event.
 */
export async function createSessionCookie(
  idToken: string,
  expiresInMs: number,
): Promise<string> {
  return adminAuth().createSessionCookie(idToken, { expiresIn: expiresInMs });
}

/**
 * Invalidate every refresh token for a user, which also invalidates session
 * cookies once `checkRevoked` is applied. Used on sign-out from all devices and
 * when an administrator account is disabled.
 */
export async function revokeUserSessions(uid: string): Promise<void> {
  await adminAuth().revokeRefreshTokens(uid);
}

/**
 * Give a Firebase user the `role: "authenticated"` custom claim.
 *
 * Supabase Third-Party Auth assigns the Postgres role from this claim, and
 * Firebase does not issue it by default. Existing custom claims are preserved,
 * because setCustomUserClaims replaces the whole claim set.
 *
 * Only the Admin SDK can set claims, so a client cannot grant itself this or any
 * other claim. It confers nothing beyond what RLS allows an ordinary signed-in
 * user; administrator status is still decided by public.admin_users.
 */
export async function ensureSupabaseRoleClaim(uid: string): Promise<void> {
  const record = await adminAuth().getUser(uid);
  const existing = record.customClaims ?? {};

  if (existing.role === 'authenticated') return;

  await adminAuth().setCustomUserClaims(uid, { ...existing, role: 'authenticated' });
}

// ---------------------------------------------------------------------------
// Storage
// ---------------------------------------------------------------------------

/**
 * A short-lived, read-only URL for one object.
 *
 * Callers must have already established that the requester is entitled to the
 * object. This function performs no authorization of its own — see
 * features/media/server/media-access.ts, which is the only place that should
 * call it.
 */
export async function signedDownloadUrl(
  objectPath: string,
  expiresInSeconds: number,
): Promise<string> {
  const [url] = await storageBucket()
    .file(objectPath)
    .getSignedUrl({
      version: 'v4',
      action: 'read',
      expires: Date.now() + expiresInSeconds * 1000,
    });

  return url;
}

/**
 * A short-lived, single-purpose upload URL.
 *
 * The content type is bound into the signature, so the client cannot upload a
 * different kind of file than the one that was authorized.
 */
export async function signedUploadUrl(
  objectPath: string,
  contentType: string,
  expiresInSeconds: number,
): Promise<string> {
  const [url] = await storageBucket()
    .file(objectPath)
    .getSignedUrl({
      version: 'v4',
      action: 'write',
      contentType,
      expires: Date.now() + expiresInSeconds * 1000,
    });

  return url;
}

/** Confirm an object actually exists and report its true size and type. */
export async function objectMetadata(
  objectPath: string,
): Promise<{ exists: boolean; size: number | null; contentType: string | null }> {
  const file = storageBucket().file(objectPath);
  const [exists] = await file.exists();

  if (!exists) {
    return { exists: false, size: null, contentType: null };
  }

  const [metadata] = await file.getMetadata();

  return {
    exists: true,
    size: metadata.size ? Number(metadata.size) : null,
    contentType: metadata.contentType ?? null,
  };
}
