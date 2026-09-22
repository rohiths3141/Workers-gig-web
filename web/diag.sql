SELECT g.id, g.status, g.service_id, g.pricing_unit, g.title,
       w.status as w_status, w.full_name,
       s.name as service_name,
       s.id as s_id
FROM public.worker_gigs g
JOIN public.workers w ON w.id = g.worker_id
JOIN public.services s ON s.id = g.service_id
ORDER BY g.created_at DESC
LIMIT 10;
