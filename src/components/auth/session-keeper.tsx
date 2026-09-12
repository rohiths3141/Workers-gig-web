'use client';

import { useEffect, useRef } from 'react';
import { useRouter } from 'next/navigation';
import { onIdTokenChanged } from 'firebase/auth';

import { apiRoutes } from '@/lib/config/routes';
import { firebaseAuth } from '@/lib/firebase/client';

/**
 * Keeps the server's copy of the Firebase ID token current.
 *
 * Firebase ID tokens expire after an hour. The server forwards the stored token
 * to Supabase so Row Level Security applies with the operator's real identity,
 * and it cannot refresh that token itself — only this browser holds the refresh
 * token.
 *
 * Firebase's SDK refreshes proactively and fires `onIdTokenChanged` each time.
 * This component forwards each new token to the server, which verifies it and
 * checks that it belongs to the same session before storing it.
 *
 * Rendered inside the admin layout only. Public pages need no session.
 */
export function SessionKeeper() {
  const router = useRouter();
  const lastSent = useRef<string | null>(null);

  useEffect(() => {
    const auth = firebaseAuth();

    const unsubscribe = onIdTokenChanged(auth, async (user) => {
      if (!user) {
        // Signed out in another tab. Re-render so the server sees no session
        // and redirects to login.
        router.refresh();
        return;
      }

      try {
        const idToken = await user.getIdToken();

        // The listener also fires on events that do not change the token.
        if (idToken === lastSent.current) return;

        const response = await fetch(apiRoutes.sessionRefresh, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ idToken }),
          credentials: 'same-origin',
        });

        if (response.ok) {
          lastSent.current = idToken;
        } else {
          // The server session has gone — revoked, expired, or the account was
          // disabled. Let the server-side guard decide where to send them.
          lastSent.current = null;
          router.refresh();
        }
      } catch {
        // Offline or a transient failure. The SDK will fire again; the existing
        // cookie remains valid until it expires on its own.
      }
    });

    return unsubscribe;
  }, [router]);

  return null;
}
