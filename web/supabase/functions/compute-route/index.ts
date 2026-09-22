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
// it only requires a valid Supabase session so an anonymous caller cannot
// burn the quota.

const ROUTES_API_URL =
  "https://routes.googleapis.com/directions/v2:computeRoutes";

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

  // Supabase's gateway already required a valid Authorization header to reach
  // here (verify_jwt stays on for this function, unlike the KYC functions —
  // this one has no Firebase-vs-Supabase mismatch to work around).
  const authHeader = req.headers.get("Authorization");
  if (!authHeader) {
    return new Response(JSON.stringify({ error: "UNAUTHORIZED" }), {
      status: 401,
    });
  }

  const apiKey = Deno.env.get("GOOGLE_ROUTES_API_KEY");
  if (!apiKey) {
    return new Response(
      JSON.stringify({ error: "SERVER_MISCONFIGURED: route API key not set" }),
      { status: 500 },
    );
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
