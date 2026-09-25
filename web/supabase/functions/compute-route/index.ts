// Computes a route between two points via the Google Routes API.
//
// Kept server-side deliberately: a Routes API key is a billable API key, and
// the Google Maps API key security guidance is explicit that a key used for
// server-to-server calls should not travel to the client at all. The Flutter
// apps only ever hold the Maps SDK rendering key (restricted by Android
// package name + SHA-1); this function holds the Routes key as a Supabase
// secret and is the only thing that ever calls Google with it.
//
// Callers are expected to throttle themselves (initial route + recompute on
// meaningful deviation/staleness only) — this function does not rate-limit,
// it only requires a signed-in caller so an anonymous one cannot burn the
// quota.
//
// The worker app authenticates with a Firebase ID token, not a Supabase-issued
// one. Supabase honours Firebase tokens for the Data API, Storage and Realtime
// — not for the Edge Functions gateway's verify_jwt, which is why the KYC
// functions the worker app calls already run with it off. So does this one
// (config.toml): the token is verified here instead — signature, issuer,
// audience and expiry — against Google's published signing keys.

import { createRemoteJWKSet, jwtVerify } from "https://esm.sh/jose@5.9.6";

const ROUTES_API_URL =
  "https://routes.googleapis.com/directions/v2:computeRoutes";

const FIREBASE_JWKS = createRemoteJWKSet(
  new URL(
    "https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com",
  ),
);

/**
 * The Firebase project the ID tokens must be minted for. FIREBASE_PROJECT_ID
 * wins when set; otherwise it comes from the service account send-notifications
 * already needs, so no new secret is required to deploy this.
 */
function firebaseProjectId(): string | null {
  const explicit = Deno.env.get("FIREBASE_PROJECT_ID");
  if (explicit) return explicit;
  try {
    const account = JSON.parse(
      Deno.env.get("FIREBASE_SERVICE_ACCOUNT_JSON") ?? "",
    );
    return typeof account.project_id === "string" ? account.project_id : null;
  } catch {
    return null;
  }
}

async function isValidFirebaseToken(
  authHeader: string,
  projectId: string,
): Promise<boolean> {
  const token = authHeader.replace(/^Bearer\s+/i, "");
  try {
    const { payload } = await jwtVerify(token, FIREBASE_JWKS, {
      algorithms: ["RS256"],
      issuer: `https://securetoken.google.com/${projectId}`,
      audience: projectId,
      // Phones with a slightly fast clock mint tokens whose iat is ahead of
      // ours (customer finding C2) — allow a minute either way.
      clockTolerance: 60,
    });
    return typeof payload.sub === "string" && payload.sub.length > 0;
  } catch {
    return false;
  }
}

interface LatLngInput {
  latitude: number;
  longitude: number;
}

interface RequestBody {
  origin: LatLngInput;
  destination: LatLngInput;
}

function isValidLatLng(point: unknown): point is LatLngInput {
  if (typeof point !== "object" || point === null) return false;
  const p = point as Record<string, unknown>;
  return (
    typeof p.latitude === "number" &&
    typeof p.longitude === "number" &&
    p.latitude >= -90 &&
    p.latitude <= 90 &&
    p.longitude >= -180 &&
    p.longitude <= 180
  );
}

Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "METHOD_NOT_ALLOWED" }), {
      status: 405,
    });
  }

  const apiKey = Deno.env.get("GOOGLE_ROUTES_API_KEY");
  const projectId = firebaseProjectId();
  if (!apiKey || !projectId) {
    return new Response(
      JSON.stringify({
        error: !apiKey
          ? "SERVER_MISCONFIGURED: route API key not set"
          : "SERVER_MISCONFIGURED: Firebase project id not set",
      }),
      { status: 500 },
    );
  }

  const authHeader = req.headers.get("Authorization");
  if (!authHeader || !(await isValidFirebaseToken(authHeader, projectId))) {
    return new Response(JSON.stringify({ error: "UNAUTHORIZED" }), {
      status: 401,
    });
  }

  let body: RequestBody;
  try {
    body = await req.json();
  } catch {
    return new Response(JSON.stringify({ error: "INVALID_BODY" }), {
      status: 400,
    });
  }

  if (!isValidLatLng(body.origin) || !isValidLatLng(body.destination)) {
    return new Response(JSON.stringify({ error: "INVALID_COORDINATES" }), {
      status: 400,
    });
  }

  const routesResponse = await fetch(ROUTES_API_URL, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-Goog-Api-Key": apiKey,
      // Request only the fields actually used, per Google's own guidance on
      // keeping Routes API responses (and billing) minimal.
      "X-Goog-FieldMask":
        "routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline",
    },
    body: JSON.stringify({
      origin: { location: { latLng: body.origin } },
      destination: { location: { latLng: body.destination } },
      travelMode: "DRIVE",
      routingPreference: "TRAFFIC_AWARE",
    }),
  });

  if (!routesResponse.ok) {
    const detail = await routesResponse.text();
    return new Response(
      JSON.stringify({ error: "ROUTE_UNAVAILABLE", detail }),
      { status: 502 },
    );
  }

  const data = await routesResponse.json();
  const route = data.routes?.[0];
  if (!route) {
    return new Response(JSON.stringify({ error: "ROUTE_UNAVAILABLE" }), {
      status: 502,
    });
  }

  return new Response(
    JSON.stringify({
      distanceMeters: route.distanceMeters ?? null,
      durationSeconds: route.duration ? parseInt(route.duration, 10) : null,
      encodedPolyline: route.polyline?.encodedPolyline ?? null,
    }),
    { headers: { "Content-Type": "application/json" } },
  );
});
