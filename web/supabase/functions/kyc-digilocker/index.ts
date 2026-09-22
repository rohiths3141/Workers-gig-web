// ===========================================================================
// kyc-digilocker — real identity verification via MessageCentral's DigiLocker
// e-KYC product
// ===========================================================================
// Three routes, all under this one function:
//
//   POST .../kyc-digilocker/init
//     Caller: the worker app, with the worker's own Supabase/Firebase JWT
//     forwarded automatically by supabase-js/supabase_flutter. Creates (or
//     re-fetches) the worker's PENDING IDENTITY_KYC case, asks MessageCentral
//     for a DigiLocker consent URL, stores the reference, and returns the URL
//     for the app to open.
//
//   POST .../kyc-digilocker/status
//     Caller: the worker app, polling after the worker returns from the
//     DigiLocker consent screen. Asks MessageCentral whether the consent
//     journey finished; if it has, fetches the verified document and decides
//     APPROVED/REJECTED via record_provider_kyc_result() (0036) — using the
//     service_role key, which never leaves this function.
//
//   GET  .../kyc-digilocker/return
//     The `redirection_url` MessageCentral sends the worker's browser to once
//     the DigiLocker journey completes. Just a static "you can go back to the
//     app" page; it carries no secret and does no writes.
//
// Nobody but this function ever calls record_provider_kyc_result for
// IDENTITY_KYC. A worker cannot self-approve: the decision is made from what
// MessageCentral's government-backed DigiLocker journey actually returned.
// ===========================================================================

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const MC_BASE_URL = "https://ekyc.messagecentral.com/ekycbusiness/api/v1";
const MC_API_KEY = Deno.env.get("MESSAGECENTRAL_API_KEY") ?? "";
const MC_CUSTOMER_ID = Deno.env.get("MESSAGECENTRAL_CUSTOMER_ID") ?? "";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
const ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY") ?? "";

function serviceClient() {
  return createClient(SUPABASE_URL, SERVICE_ROLE_KEY);
}

/** A worker's own JWT, forwarded as-is, so RLS-scoped RPCs run as them. */
function callerClient(authHeader: string) {
  return createClient(SUPABASE_URL, ANON_KEY, {
    global: { headers: { Authorization: authHeader } },
  });
}

/**
 * Supabase's gateway already verified this JWT's signature before invoking
 * this function (verify_jwt is on by default) — the same trust boundary
 * public.firebase_uid() relies on in migration 0031. Decoding the payload
 * here (no signature check) to read `sub` mirrors that, not a new one.
 */
function firebaseUidFromJwt(authHeader: string): string | null {
  try {
    const token = authHeader.replace(/^Bearer\s+/i, "");
    const payload = token.split(".")[1];
    const json = JSON.parse(atob(payload.replace(/-/g, "+").replace(/_/g, "/")));
    return typeof json.sub === "string" ? json.sub : null;
  } catch {
    return null;
  }
}

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

function mcHeaders(extra: Record<string, string>) {
  return {
    api_key: `Bearer ${MC_API_KEY}`,
    customer_id: MC_CUSTOMER_ID,
    ...extra,
  };
}

/** Loose, tolerant name match — DigiLocker returns the name exactly as UIDAI
 * holds it (often uppercase, with initials expanded differently), so an exact
 * string match would reject good matches. This is intentionally permissive in
 * one direction only: it can pass a genuine match through slightly different
 * formatting, but a name sharing almost no tokens is still rejected. */
function namesLikelyMatch(registered: string, fromAadhaar: string): boolean {
  const normalize = (s: string) =>
    s.toUpperCase().replace(/[^A-Z\s]/g, "").split(/\s+/).filter(Boolean);
  const a = new Set(normalize(registered));
  const b = normalize(fromAadhaar);
  if (a.size === 0 || b.length === 0) return false;
  const overlap = b.filter((token) => a.has(token)).length;
  return overlap / Math.min(a.size, b.length) >= 0.5;
}

async function handleInit(authHeader: string): Promise<Response> {
  const uid = firebaseUidFromJwt(authHeader);
  if (!uid) return json({ error: "Unauthorized" }, 401);

  const admin = serviceClient();
  const { data: worker, error: workerErr } = await admin
    .from("workers")
    .select("id, full_name")
    .eq("firebase_uid", uid)
    .single();

  if (workerErr || !worker) return json({ error: "Worker not found" }, 404);

  // A consent URL already issued for an open case is handed back as-is
  // rather than starting a second DigiLocker session.
  const { data: existing } = await admin
    .from("worker_verifications")
    .select("id, status, details")
    .eq("worker_id", worker.id)
    .eq("type", "IDENTITY_KYC")
    .maybeSingle();

  if (existing?.status === "APPROVED") {
    return json({ status: "ALREADY_VERIFIED" });
  }
  if (existing?.status === "PENDING" && existing.details?.digilocker?.url) {
    return json({ status: "PENDING", url: existing.details.digilocker.url });
  }

  // Ask the provider for a consent URL *before* opening the case. Opening it
  // first meant a provider outage still left a PENDING identity case behind,
  // which counted as "KYC submitted" and let onboarding complete with no
  // identity check ever started.
  const redirectionUrl = `${SUPABASE_URL}/functions/v1/kyc-digilocker/return`;

  let mcBody: { api_status?: string; api_data?: { url?: string; reference_id?: string; verification_id?: string }; message?: string } = {};
  try {
    const mcResponse = await fetch(`${MC_BASE_URL}/aadhaar/digilocker-url`, {
      method: "POST",
      headers: mcHeaders({
        redirection_url: redirectionUrl,
        user_flow: "signup",
      }),
    });
    mcBody = await mcResponse.json();
  } catch (e) {
    console.error("DigiLocker provider unreachable", e);
  }
  if (mcBody.api_status !== "SUCCESS" || !mcBody.api_data?.url) {
    console.error("DigiLocker provider refused", mcBody);
    return json({ error: "DigiLocker verification is unavailable right now. Please try again later." }, 502);
  }

  const { url, reference_id, verification_id } = mcBody.api_data;

  // Reuse the real, existing RPC to reach PENDING — it handles the
  // REGISTERED -> VERIFICATION_PENDING transition and idempotent resubmission
  // already; this function does not duplicate that logic.
  const asWorker = callerClient(authHeader);
  const { data: submitted, error: submitErr } = await asWorker.rpc(
    "worker_submit_verification",
    { p_type: "IDENTITY_KYC", p_details: { method: "digilocker" } },
  );

  let caseId: string | undefined;
  if (submitErr) {
    if (!submitErr.message?.includes("CONFLICT") || !existing?.id) {
      return json({ error: submitErr.message }, submitErr.message?.includes("CONFLICT") ? 409 : 400);
    }
    caseId = existing.id;
  } else {
    caseId = submitted.id;
  }

  // Store the provider's own ids so the status route can poll the same
  // session. service_role bypasses RLS; there is no client update grant on
  // worker_verifications by design (0009) — only this trusted function
  // writes here.
  await admin
    .from("worker_verifications")
    .update({
      details: {
        method: "digilocker",
        digilocker: { url, reference_id, verification_id },
      },
    })
    .eq("id", caseId);

  return json({ status: "PENDING", url });
}

async function handleStatus(authHeader: string): Promise<Response> {
  const uid = firebaseUidFromJwt(authHeader);
  if (!uid) return json({ error: "Unauthorized" }, 401);

  const admin = serviceClient();
  const { data: worker } = await admin
    .from("workers")
    .select("id, full_name")
    .eq("firebase_uid", uid)
    .single();
  if (!worker) return json({ error: "Worker not found" }, 404);

  const { data: kycCase } = await admin
    .from("worker_verifications")
    .select("id, status, details")
    .eq("worker_id", worker.id)
    .eq("type", "IDENTITY_KYC")
    .single();

  if (!kycCase) return json({ error: "No verification in progress" }, 404);
  if (kycCase.status === "APPROVED") return json({ status: "APPROVED" });
  if (kycCase.status === "REJECTED") {
    return json({ status: "REJECTED", reason: kycCase.details?.rejection_reason });
  }

  const dl = kycCase.details?.digilocker;
  if (!dl?.reference_id || !dl?.verification_id) {
    return json({ error: "No DigiLocker session on file. Start again." }, 409);
  }

  const statusResponse = await fetch(`${MC_BASE_URL}/aadhaar/url-status`, {
    method: "GET",
    headers: mcHeaders({
      reference_id: String(dl.reference_id),
      digilocker_request_id: dl.verification_id,
    }),
  });
  const statusBody = await statusResponse.json();
  const providerStatus: string = statusBody.api_data?.status ?? "PENDING";

  if (providerStatus === "PENDING") {
    return json({ status: "PENDING" });
  }

  if (["FAILED", "EXPIRED", "REJECTED"].includes(providerStatus)) {
    const reason = "DigiLocker verification did not complete. Please try again.";
    await admin.rpc("record_provider_kyc_result", {
      p_verification_id: kycCase.id,
      p_decision: "REJECTED",
      p_provider: "MESSAGECENTRAL_DIGILOCKER",
      p_provider_reference: dl.verification_id,
      p_raw_response: { provider_status: providerStatus },
      p_rejection_reason: reason,
    });
    return json({ status: "REJECTED", reason });
  }

  // Consent completed — fetch the verified document.
  const docResponse = await fetch(`${MC_BASE_URL}/aadhaar/get-document`, {
    method: "GET",
    headers: mcHeaders({
      reference_id: String(dl.reference_id),
      digilocker_request_id: dl.verification_id,
    }),
  });
  const docBody = await docResponse.json();
  const doc = docBody.api_data;

  if (docBody.api_status !== "SUCCESS" || doc?.status !== "SUCCESS") {
    const reason = "We could not confirm your Aadhaar details. Please try again.";
    await admin.rpc("record_provider_kyc_result", {
      p_verification_id: kycCase.id,
      p_decision: "REJECTED",
      p_provider: "MESSAGECENTRAL_DIGILOCKER",
      p_provider_reference: dl.verification_id,
      p_raw_response: { message: doc?.message ?? "document fetch failed" },
      p_rejection_reason: reason,
    });
    return json({ status: "REJECTED", reason });
  }

  const nameMatches = namesLikelyMatch(worker.full_name ?? "", doc.name ?? "");

  // Deliberately excludes doc.photo_link (biometric photo) and doc.xml_file
  // (raw UIDAI XML) — we keep only enough to prove a decision was made, not
  // the sensitive source material itself.
  const rawResponse = {
    uid: doc.uid,
    name: doc.name,
    dob: doc.dob,
    gender: doc.gender,
    message: doc.message,
    name_match: nameMatches,
  };

  if (!nameMatches) {
    const reason = "The name on your Aadhaar does not match your registered name. Contact support.";
    await admin.rpc("record_provider_kyc_result", {
      p_verification_id: kycCase.id,
      p_decision: "REJECTED",
      p_provider: "MESSAGECENTRAL_DIGILOCKER",
      p_provider_reference: dl.verification_id,
      p_raw_response: rawResponse,
      p_rejection_reason: reason,
    });
    return json({ status: "REJECTED", reason });
  }

  await admin.rpc("record_provider_kyc_result", {
    p_verification_id: kycCase.id,
    p_decision: "APPROVED",
    p_provider: "MESSAGECENTRAL_DIGILOCKER",
    p_provider_reference: dl.verification_id,
    p_raw_response: rawResponse,
  });

  return json({ status: "APPROVED" });
}

function handleReturn(): Response {
  const html = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Verification Complete — Wervexa</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
      background: linear-gradient(135deg, #0f172a 0%, #1e293b 40%, #0f766e 100%);
      color: #f1f5f9;
      padding: 24px;
      overflow: hidden;
    }

    /* Subtle animated background circles */
    body::before, body::after {
      content: "";
      position: fixed;
      border-radius: 50%;
      opacity: 0.08;
      animation: float 8s ease-in-out infinite;
    }
    body::before {
      width: 400px; height: 400px;
      background: #14b8a6;
      top: -100px; right: -100px;
    }
    body::after {
      width: 300px; height: 300px;
      background: #6366f1;
      bottom: -80px; left: -80px;
      animation-delay: -4s;
      animation-direction: reverse;
    }

    @keyframes float {
      0%, 100% { transform: translate(0, 0) scale(1); }
      50% { transform: translate(30px, 20px) scale(1.05); }
    }

    .card {
      position: relative;
      max-width: 420px;
      width: 100%;
      background: rgba(255, 255, 255, 0.06);
      backdrop-filter: blur(24px);
      -webkit-backdrop-filter: blur(24px);
      border: 1px solid rgba(255, 255, 255, 0.1);
      border-radius: 24px;
      padding: 48px 32px 40px;
      text-align: center;
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3), 0 0 0 1px rgba(255,255,255,0.05) inset;
      animation: cardIn 0.6s cubic-bezier(0.16, 1, 0.3, 1) both;
    }

    @keyframes cardIn {
      from { opacity: 0; transform: translateY(30px) scale(0.95); }
      to   { opacity: 1; transform: translateY(0) scale(1); }
    }

    /* Animated checkmark circle */
    .check-wrap {
      width: 88px; height: 88px;
      margin: 0 auto 28px;
      position: relative;
      animation: popIn 0.5s 0.3s cubic-bezier(0.16, 1, 0.3, 1) both;
    }

    @keyframes popIn {
      from { opacity: 0; transform: scale(0.5); }
      to   { opacity: 1; transform: scale(1); }
    }

    .check-wrap svg { width: 100%; height: 100%; }

    .check-circle {
      fill: none;
      stroke: #14b8a6;
      stroke-width: 3;
      stroke-dasharray: 260;
      stroke-dashoffset: 260;
      animation: drawCircle 0.6s 0.5s ease-out forwards;
    }

    @keyframes drawCircle {
      to { stroke-dashoffset: 0; }
    }

    .check-mark {
      fill: none;
      stroke: #14b8a6;
      stroke-width: 4;
      stroke-linecap: round;
      stroke-linejoin: round;
      stroke-dasharray: 50;
      stroke-dashoffset: 50;
      animation: drawCheck 0.4s 1s ease-out forwards;
    }

    @keyframes drawCheck {
      to { stroke-dashoffset: 0; }
    }

    /* Glow behind the check */
    .check-wrap::after {
      content: "";
      position: absolute;
      inset: -12px;
      border-radius: 50%;
      background: radial-gradient(circle, rgba(20,184,166,0.25) 0%, transparent 70%);
      animation: glowPulse 2.5s ease-in-out infinite;
      z-index: -1;
    }

    @keyframes glowPulse {
      0%, 100% { opacity: 0.6; transform: scale(1); }
      50% { opacity: 1; transform: scale(1.08); }
    }

    h1 {
      font-size: 1.75rem;
      font-weight: 700;
      letter-spacing: -0.02em;
      margin-bottom: 12px;
      background: linear-gradient(135deg, #f0fdfa, #5eead4);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
      animation: fadeUp 0.5s 0.4s ease both;
    }

    .subtitle {
      font-size: 1rem;
      line-height: 1.6;
      color: #94a3b8;
      margin-bottom: 32px;
      animation: fadeUp 0.5s 0.5s ease both;
    }

    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(12px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    .divider {
      height: 1px;
      background: linear-gradient(90deg, transparent, rgba(255,255,255,0.12), transparent);
      margin-bottom: 24px;
      animation: fadeUp 0.5s 0.6s ease both;
    }

    .hint {
      font-size: 0.85rem;
      color: #64748b;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      animation: fadeUp 0.5s 0.7s ease both;
    }

    .hint svg {
      width: 16px; height: 16px;
      stroke: #64748b;
      flex-shrink: 0;
    }

    .brand {
      margin-top: 40px;
      font-size: 0.75rem;
      color: #475569;
      letter-spacing: 0.08em;
      text-transform: uppercase;
      animation: fadeUp 0.5s 0.8s ease both;
    }
  </style>
</head>
<body>
  <div class="card">
    <div class="check-wrap">
      <svg viewBox="0 0 88 88">
        <circle class="check-circle" cx="44" cy="44" r="40" />
        <polyline class="check-mark" points="28 46 38 56 60 34" />
      </svg>
    </div>

    <h1>You&rsquo;re All Set!</h1>
    <p class="subtitle">
      Your identity has been verified successfully.<br/>
      You can now close this window.
    </p>

    <div class="divider"></div>

    <p class="hint">
      <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M15 18l-6-6 6-6"/>
      </svg>
      Return to the <strong>&nbsp;Wervexa&nbsp;</strong> app to continue
    </p>

    <p class="brand">Powered by Wervexa</p>
  </div>
</body>
</html>`;

  return new Response(html, {
    status: 200,
    headers: { "Content-Type": "text/html; charset=utf-8" },
  });
}

Deno.serve(async (req) => {
  const url = new URL(req.url);
  const path = url.pathname.replace(/^\/kyc-digilocker\/?/, "");

  if (path === "return" && req.method === "GET") {
    return handleReturn();
  }

  if (req.method !== "POST") {
    return json({ error: "Method not allowed" }, 405);
  }

  const authHeader = req.headers.get("Authorization") ?? "";
  if (!authHeader) return json({ error: "Unauthorized" }, 401);

  if (path === "init") return handleInit(authHeader);
  if (path === "status") return handleStatus(authHeader);

  return json({ error: "Not found" }, 404);
});

