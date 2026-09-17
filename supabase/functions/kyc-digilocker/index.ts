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

  // Reuse the real, existing RPC to reach PENDING — it handles the
  // REGISTERED -> VERIFICATION_PENDING transition and idempotent resubmission
  // already; this function does not duplicate that logic.
  const asWorker = callerClient(authHeader);
  const { data: existingCase, error: submitErr } = await asWorker.rpc(
    "worker_submit_verification",
    { p_type: "IDENTITY_KYC", p_details: { method: "digilocker" } },
  );

  let caseId: string;
  if (submitErr) {
    if (submitErr.message?.includes("CONFLICT")) {
      // Already PENDING or already APPROVED — fetch what exists instead of
      // failing the request outright.
      const { data: existing } = await admin
        .from("worker_verifications")
        .select("id, status, details")
        .eq("worker_id", worker.id)
        .eq("type", "IDENTITY_KYC")
        .single();

      if (existing?.status === "APPROVED") {
        return json({ status: "ALREADY_VERIFIED" });
      }
      if (existing?.status === "PENDING" && existing.details?.digilocker?.url) {
        // A consent URL was already issued; hand the same one back rather
        // than starting a second DigiLocker session.
        return json({ status: "PENDING", url: existing.details.digilocker.url });
      }
      caseId = existing?.id;
      if (!caseId) return json({ error: submitErr.message }, 409);
    } else {
      return json({ error: submitErr.message }, 400);
    }
  } else {
    caseId = existingCase.id;
  }

  const redirectionUrl = `${SUPABASE_URL}/functions/v1/kyc-digilocker/return`;

  const mcResponse = await fetch(`${MC_BASE_URL}/aadhaar/digilocker-url`, {
    method: "POST",
    headers: mcHeaders({
      redirection_url: redirectionUrl,
      user_flow: "signup",
    }),
  });

  const mcBody = await mcResponse.json();
  if (mcBody.api_status !== "SUCCESS" || !mcBody.api_data?.url) {
    return json({ error: "Could not start DigiLocker verification. Please try again." }, 502);
  }

  const { url, reference_id, verification_id } = mcBody.api_data;

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
  return new Response(
    `<!doctype html><html><head><meta charset="utf-8" />
     <meta name="viewport" content="width=device-width, initial-scale=1" />
     <title>Verification complete</title></head>
     <body style="font-family:sans-serif;text-align:center;padding:48px 24px;">
       <h2>You're all set</h2>
       <p>You can close this window and return to the Wervexa app.</p>
     </body></html>`,
    { status: 200, headers: { "Content-Type": "text/html" } },
  );
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
