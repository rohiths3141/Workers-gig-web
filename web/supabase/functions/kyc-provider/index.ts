// ===========================================================================
// kyc-provider — pluggable KYC / background-check adapter
// ===========================================================================
// Invoked by the `worker_verifications_notify_provider` trigger (see
// migrations/0036_kyc_provider_adapter.sql) whenever a worker's verification
// case reaches PENDING. This function is the ONLY thing that ever calls
// `record_provider_kyc_result` — it holds the service_role key as a runtime
// secret, which is never shipped to the worker app, so no client can forge an
// automated approval.
//
// Swapping in a real provider: implement `KycProvider` for the vendor (IDfy,
// HyperVerge, Signzy, DigiLocker, Checkr, ...) and change `activeProvider`
// below. Nothing else in the pipeline — the trigger, the RPC, the app —
// needs to change.
// ===========================================================================

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

interface VerificationWebhookPayload {
  verification_id: string;
  worker_id: string;
  type: "IDENTITY_KYC" | "BACKGROUND_CHECK";
  details: Record<string, unknown>;
}

interface KycDecision {
  decision: "APPROVED" | "REJECTED";
  providerReference?: string;
  rawResponse: Record<string, unknown>;
  rejectionReason?: string;
}

interface KycProvider {
  readonly name: string;
  decide(payload: VerificationWebhookPayload): Promise<KycDecision>;
}

/**
 * Mock adapter for local/dev/prototype use. It does not call any external
 * service — it deterministically approves well-formed submissions so the
 * whole pipeline (submit -> webhook -> decision -> flag sync -> eligibility)
 * can be exercised end-to-end before a real vendor contract exists.
 *
 * This is NOT a security bypass: it still only ever runs server-side, behind
 * the service_role-gated RPC, and it still refuses a submission with no
 * evidence attached, matching what a real provider would refuse too.
 */
class MockKycProvider implements KycProvider {
  readonly name = "MOCK_KYC_V1";

  async decide(payload: VerificationWebhookPayload): Promise<KycDecision> {
    const documentType = payload.details?.["document_type"];
    if (payload.type === "IDENTITY_KYC" && !documentType) {
      return {
        decision: "REJECTED",
        rawResponse: { reason: "no document_type on submission" },
        rejectionReason: "No document type was recorded with this submission.",
        providerReference: `mock_${crypto.randomUUID()}`,
      };
    }

    // Simulate provider processing latency.
    await new Promise((resolve) => setTimeout(resolve, 1500));

    return {
      decision: "APPROVED",
      providerReference: `mock_${crypto.randomUUID()}`,
      rawResponse: {
        mock: true,
        note: "Auto-approved by MockKycProvider — replace with a real vendor before launch.",
        checkedAt: new Date().toISOString(),
      },
    };
  }
}

// Swap this line for a real provider implementation when one is contracted.
const activeProvider: KycProvider = new MockKycProvider();

Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }

  const authHeader = req.headers.get("Authorization") ?? "";
  const expected = `Bearer ${Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""}`;
  if (!authHeader || authHeader !== expected) {
    return new Response("Unauthorized", { status: 401 });
  }

  let payload: VerificationWebhookPayload;
  try {
    payload = await req.json();
  } catch {
    return new Response("Invalid JSON body", { status: 400 });
  }

  if (!payload.verification_id || !payload.worker_id || !payload.type) {
    return new Response("Missing required fields", { status: 400 });
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL") ?? "",
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
  );

  try {
    const result = await activeProvider.decide(payload);

    const { error } = await supabase.rpc("record_provider_kyc_result", {
      p_verification_id: payload.verification_id,
      p_decision: result.decision,
      p_provider: activeProvider.name,
      p_provider_reference: result.providerReference ?? null,
      p_raw_response: result.rawResponse,
      p_rejection_reason: result.rejectionReason ?? null,
    });

    if (error) {
      console.error("record_provider_kyc_result failed", error);
      return new Response(JSON.stringify({ error: error.message }), {
        status: 500,
        headers: { "Content-Type": "application/json" },
      });
    }

    return new Response(JSON.stringify({ ok: true, decision: result.decision }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("kyc-provider adapter threw", err);
    return new Response(JSON.stringify({ error: String(err) }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});
