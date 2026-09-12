'use client';

import { getApp, getApps, initializeApp, type FirebaseApp } from 'firebase/app';
import {
  browserLocalPersistence,
  getAuth,
  setPersistence,
  type Auth,
} from 'firebase/auth';

import { publicEnv } from '@/lib/config/env';

/**
 * Firebase client SDK — the browser half of authentication.
 *
 * This module signs the user in and obtains an ID token. It does not decide
 * anything. The ID token is immediately exchanged for an httpOnly session
 * cookie at /api/auth/session, where the server verifies it with the Admin SDK
 * and resolves the caller's platform identity and permissions from Supabase.
 *
 * Consequences of that design, on purpose:
 *   - No ID token is kept in localStorage or sessionStorage, so a cross-site
 *     scripting bug cannot read a bearer credential out of the page.
 *   - The browser never learns whether it is an administrator by inspecting a
 *     token claim. It learns it because the server said so.
 */

let app: FirebaseApp | null = null;
let auth: Auth | null = null;

export function firebaseApp(): FirebaseApp {
  if (app) return app;

  const { firebase } = publicEnv();

  app = getApps().length
    ? getApp()
    : initializeApp({
        apiKey: firebase.apiKey,
        authDomain: firebase.authDomain,
        projectId: firebase.projectId,
        storageBucket: firebase.storageBucket,
        messagingSenderId: firebase.messagingSenderId,
        appId: firebase.appId,
      });

  return app;
}

export function firebaseAuth(): Auth {
  if (auth) return auth;

  auth = getAuth(firebaseApp());

  // Local persistence keeps the Firebase refresh token available so the SDK can
  // mint a fresh ID token when the server session cookie needs renewing. The
  // session cookie itself remains httpOnly and out of reach of scripts.
  void setPersistence(auth, browserLocalPersistence);

  return auth;
}
