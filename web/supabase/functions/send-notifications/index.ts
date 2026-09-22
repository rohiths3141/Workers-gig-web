// Drains one queued notification and sends it via FCM's HTTP v1 API.
//
// Triggered by trigger_notification_webhook() (migration 0041) right after a
// row is inserted into public.notifications with status = 'QUEUED' and
// channel = 'PUSH'. Never called by a client directly — the webhook secret
// in integration_settings is the only thing that can reach this.
//
// FCM v1 needs an OAuth2 access token, not a static server key (the legacy
// HTTP API is retired). That token comes from a Firebase service account:
// sign a short-lived JWT with the account's private key, exchange it at
// Google's token endpoint, then call FCM with the resulting bearer token.

import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.4";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const WEBHOOK_SHARED_SECRET = Deno.env.get(
  "NOTIFICATION_WEBHOOK_SERVICE_KEY",
);
const FIREBASE_SERVICE_ACCOUNT_JSON = Deno.env.get(
  "FIREBASE_SERVICE_ACCOUNT_JSON",
);

interface ServiceAccount {
  client_email: string;
  private_key: string;
  project_id: string;
}

function base64UrlEncode(data: Uint8Array | string): string {
  const bytes = typeof data === "string" ? new TextEncoder().encode(data) : data;
  let binary = "";
  for (const byte of bytes) binary += String.fromCharCode(byte);
  return btoa(binary).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}

function pemToArrayBuffer(pem: string): ArrayBuffer {
  const contents = pem
    .replace(/-----BEGIN PRIVATE KEY-----/, "")
    .replace(/-----END PRIVATE KEY-----/, "")
    .replace(/\s/g, "");
  const binary = atob(contents);
  const bytes = new Uint8Array(binary.length);
  for (let i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
  return bytes.buffer;
}

async function getAccessToken(account: ServiceAccount): Promise<string> {
  const header = { alg: "RS256", typ: "JWT" };
  const now = Math.floor(Date.now() / 1000);
  const claims = {
    iss: account.client_email,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
    aud: "https://oauth2.googleapis.com/token",
    iat: now,
    exp: now + 3600,
  };

  const unsigned = `${base64UrlEncode(JSON.stringify(header))}.${
    base64UrlEncode(JSON.stringify(claims))
  }`;

  const key = await crypto.subtle.importKey(
    "pkcs8",
    pemToArrayBuffer(account.private_key),
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const signature = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    key,
    new TextEncoder().encode(unsigned),
  );

  const jwt = `${unsigned}.${base64UrlEncode(new Uint8Array(signature))}`;

  const response = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });

  if (!response.ok) {
    throw new Error(`token exchange failed: ${await response.text()}`);
  }
  const data = await response.json();
  return data.access_token as string;
}

Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("METHOD_NOT_ALLOWED", { status: 405 });
  }

  if (WEBHOOK_SHARED_SECRET) {
    const auth = req.headers.get("Authorization");
    if (auth !== `Bearer ${WEBHOOK_SHARED_SECRET}`) {
      return new Response("UNAUTHORIZED", { status: 401 });
    }
  }

  if (!FIREBASE_SERVICE_ACCOUNT_JSON) {
    console.error("FIREBASE_SERVICE_ACCOUNT_JSON not configured");
    return new Response("SERVER_MISCONFIGURED", { status: 500 });
  }

  const { notification_id } = await req.json();
  if (!notification_id) {
    return new Response("INVALID_BODY", { status: 400 });
  }

  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

  const { data: notification, error: fetchError } = await admin
    .from("notifications")
    .select("*")
    .eq("id", notification_id)
    .eq("status", "QUEUED")
    .maybeSingle();

  // Already sent, cancelled, or gone — nothing to do. Not an error: the
  // webhook can legitimately fire more than once for the same row.
  if (fetchError || !notification) {
    return new Response(JSON.stringify({ skipped: true }), { status: 200 });
  }

  const { data: tokens } = await admin
    .from("push_tokens")
    .select("token")
    .eq("profile_id", notification.recipient_profile_id)
    .eq("is_active", true);

  if (!tokens || tokens.length === 0) {
    await admin.from("notifications").update({
      status: "FAILED",
      failed_at: new Date().toISOString(),
      failure_reason: "No active device token for recipient",
    }).eq("id", notification_id);
    return new Response(JSON.stringify({ sent: false, reason: "no_token" }));
  }

  const account: ServiceAccount = JSON.parse(FIREBASE_SERVICE_ACCOUNT_JSON);
  const accessToken = await getAccessToken(account);

  let lastMessageId: string | null = null;
  let lastError: string | null = null;

  for (const { token } of tokens) {
    const response = await fetch(
      `https://fcm.googleapis.com/v1/projects/${account.project_id}/messages:send`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${accessToken}`,
        },
        body: JSON.stringify({
          message: {
            token,
            notification: {
              title: notification.title,
              body: notification.body,
            },
            data: Object.fromEntries(
              Object.entries(notification.payload ?? {}).map(([k, v]) => [
                k,
                String(v),
              ]),
            ),
          },
        }),
      },
    );

    if (response.ok) {
      const body = await response.json();
      lastMessageId = body.name ?? null;
    } else {
      lastError = await response.text();
    }
  }

  if (lastMessageId) {
    await admin.from("notifications").update({
      status: "SENT",
      sent_at: new Date().toISOString(),
      provider: "FCM",
      provider_message_id: lastMessageId,
    }).eq("id", notification_id);
  } else {
    await admin.from("notifications").update({
      status: "FAILED",
      failed_at: new Date().toISOString(),
      failure_reason: lastError?.slice(0, 500) ?? "Unknown FCM failure",
      attempt_count: (notification.attempt_count ?? 0) + 1,
    }).eq("id", notification_id);
  }

  return new Response(JSON.stringify({ sent: Boolean(lastMessageId) }), {
    headers: { "Content-Type": "application/json" },
  });
});
