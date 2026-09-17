-- ===========================================================================
-- 0041  Notification fan-out for new customer service requests
-- ---------------------------------------------------------------------------
-- The notifications/push_tokens schema (0007) and the request/offer system
-- (0034) already existed; nothing ever wrote a row into notifications or sent
-- one. This wires the two together for exactly one event — a new request
-- going OPEN — the way the spec's "15 km notification radius, wider public
-- discovery radius" split works: this is the immediate push, not the feed a
-- worker can browse (worker_find_eligible_requests, already built, already
-- goes out to 50 km).
-- ===========================================================================

insert into public.platform_settings (key, value, description, is_public)
values
  ('requests.notification_radius_km', '15'::jsonb,
   'Workers within this radius of a new OPEN request get an immediate push notification.', false)
on conflict (key) do nothing;

-- ---------------------------------------------------------------------------
-- Generic enqueue helper. Idempotent by design: the caller supplies a key
-- that is unique per logical notification, so re-running the same fan-out
-- (e.g. after a retry) never double-sends.
-- ---------------------------------------------------------------------------
create or replace function public.enqueue_notification(
  p_recipient_type public.actor_type,
  p_recipient_profile_id uuid,
  p_recipient_firebase_uid text,
  p_channel        public.notification_channel,
  p_template_key   text,
  p_title          text,
  p_body           text,
  p_payload        jsonb,
  p_idempotency_key text
)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  insert into public.notifications (
    recipient_type, recipient_profile_id, recipient_firebase_uid,
    channel, template_key, title, body, payload, idempotency_key
  )
  values (
    p_recipient_type, p_recipient_profile_id, p_recipient_firebase_uid,
    p_channel, p_template_key, p_title, p_body, p_payload, p_idempotency_key
  )
  on conflict (idempotency_key) do nothing;
end;
$$;

-- Callable only from other SECURITY DEFINER functions, never directly by a
-- client — a worker or customer has no business queuing a notification.
revoke all on function public.enqueue_notification(
  public.actor_type, uuid, text, public.notification_channel, text, text, text, jsonb, text
) from public, anon, authenticated;

-- ---------------------------------------------------------------------------
-- Fan-out: workers within the notification radius, eligible the same way
-- worker_find_eligible_requests already defines eligible (verified, active,
-- matching skill) — this is the immediate-push subset of that same audience,
-- not a separate rulebook.
-- ---------------------------------------------------------------------------
create or replace function public.notify_workers_new_request(p_request_id uuid)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_request public.customer_service_requests%rowtype;
  v_radius_km numeric;
  v_worker record;
begin
  select * into v_request
  from public.customer_service_requests
  where id = p_request_id;

  if not found or v_request.approx_latitude is null or v_request.approx_longitude is null then
    return;
  end if;

  v_radius_km := coalesce(
    (select value::numeric from public.platform_settings
     where key = 'requests.notification_radius_km'),
    15
  );

  for v_worker in
    select w.id, w.profile_id, w.firebase_uid,
           round((earth_distance(
             ll_to_earth(w.latitude, w.longitude),
             ll_to_earth(v_request.approx_latitude, v_request.approx_longitude)
           ) / 1000.0)::numeric, 1) as distance_km
    from public.workers w
    where w.status = 'ACTIVE'
      and w.is_kyc_verified
      and w.is_background_verified
      and w.latitude is not null
      and w.longitude is not null
      and (
        w.primary_service_id = v_request.category_id
        or exists (
          select 1 from public.worker_services ws
          where ws.worker_id = w.id
            and ws.service_id = v_request.category_id
            and ws.is_approved
        )
      )
      and earth_box(ll_to_earth(w.latitude, w.longitude), v_radius_km * 1000)
          @> ll_to_earth(v_request.approx_latitude, v_request.approx_longitude)
      and (earth_distance(
             ll_to_earth(w.latitude, w.longitude),
             ll_to_earth(v_request.approx_latitude, v_request.approx_longitude)
           ) / 1000.0) <= v_radius_km
  loop
    perform public.enqueue_notification(
      'WORKER',
      v_worker.profile_id,
      v_worker.firebase_uid,
      'PUSH',
      'request.new_nearby',
      'New job near you',
      format('%s • %s km away', v_request.title, v_worker.distance_km),
      jsonb_build_object(
        'type', 'service_request',
        'request_id', v_request.id,
        'distance_km', v_worker.distance_km
      ),
      'request:' || v_request.id || ':worker:' || v_worker.id || ':new'
    );
  end loop;
end;
$$;

revoke all on function public.notify_workers_new_request(uuid) from public, anon, authenticated;

-- Hook: fires right after a request is created OPEN. A notification failure
-- must never stop the request itself from being created.
create or replace function public.customer_create_service_request(
  p_category_id      uuid,
  p_title            text,
  p_description      text,
  p_budget_type      public.budget_type default 'NONE',
  p_budget_min_minor bigint default null,
  p_budget_max_minor bigint default null,
  p_schedule_type    public.schedule_type default 'ASAP',
  p_scheduled_date   date default null,
  p_time_window_start time default null,
  p_time_window_end   time default null,
  p_address_line     text default null,
  p_city             text default null,
  p_state            text default null,
  p_pincode          text default null,
  p_latitude         double precision default null,
  p_longitude        double precision default null,
  p_additional_notes text default null
)
returns public.customer_service_requests
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_customer   public.customers%rowtype;
  v_request    public.customer_service_requests%rowtype;
  v_expiry_hrs integer;
  v_expires_at timestamptz;
  v_approx_lat double precision;
  v_approx_lng double precision;
  v_addr       text;
  v_max_active integer;
  v_active_count integer;
begin
  v_customer := public.require_current_customer();

  if not exists (select 1 from public.services where id = p_category_id and is_active) then
    raise exception 'NOT_FOUND: that service category does not exist'
      using errcode = 'P0002';
  end if;

  if length(btrim(coalesce(p_title, ''))) < 6 then
    raise exception 'INVALID: give your request a descriptive title (at least 6 characters)'
      using errcode = '23514';
  end if;

  if length(btrim(coalesce(p_description, ''))) < 10 then
    raise exception 'INVALID: describe what you need done in more detail (at least 10 characters)'
      using errcode = '23514';
  end if;

  v_addr := nullif(btrim(coalesce(p_address_line, '')), '');
  if v_addr is null then
    v_addr := v_customer.address_line;
  end if;
  if v_addr is null or length(btrim(v_addr)) < 5 then
    raise exception 'INVALID: provide the service address'
      using errcode = '23514';
  end if;

  v_max_active := coalesce(
    (select value::integer from public.platform_settings
     where key = 'service_request.max_active_per_customer'), 10);

  select count(*) into v_active_count
  from public.customer_service_requests
  where customer_id = v_customer.id
    and status in ('OPEN', 'RECEIVING_OFFERS', 'WORKER_SELECTED');

  if v_active_count >= v_max_active then
    raise exception 'INVALID: you already have % active service requests. Complete or cancel one before posting a new one.', v_active_count
      using errcode = '23514';
  end if;

  if p_latitude is not null and p_longitude is not null then
    v_approx_lat := round((p_latitude + (random() - 0.5) * 0.01)::numeric, 4);
    v_approx_lng := round((p_longitude + (random() - 0.5) * 0.01)::numeric, 4);
  end if;

  if p_schedule_type = 'ASAP' then
    v_expiry_hrs := coalesce(
      (select value::integer from public.platform_settings
       where key = 'service_request.default_expiry_hours'), 24);
  else
    v_expiry_hrs := coalesce(
      (select value::integer from public.platform_settings
       where key = 'service_request.scheduled_expiry_hours'), 48);
  end if;
  v_expires_at := now() + make_interval(hours => v_expiry_hrs);

  insert into public.customer_service_requests (
    request_code, customer_id, category_id, title, description,
    budget_type, budget_min_minor, budget_max_minor, currency,
    schedule_type, scheduled_date, time_window_start, time_window_end,
    address_line, city, state, pincode, latitude, longitude,
    approx_latitude, approx_longitude, status, expires_at, additional_notes
  )
  values (
    '',
    v_customer.id, p_category_id, btrim(p_title), btrim(p_description),
    p_budget_type, p_budget_min_minor,
    case p_budget_type when 'FIXED' then p_budget_min_minor else p_budget_max_minor end,
    'INR',
    p_schedule_type, p_scheduled_date, p_time_window_start, p_time_window_end,
    btrim(v_addr), coalesce(p_city, v_customer.city), coalesce(p_state, v_customer.state),
    coalesce(p_pincode, v_customer.pincode), p_latitude, p_longitude,
    v_approx_lat, v_approx_lng, 'OPEN', v_expires_at,
    nullif(btrim(coalesce(p_additional_notes, '')), '')
  )
  returning * into v_request;

  begin
    perform public.notify_workers_new_request(v_request.id);
  exception when others then
    raise warning 'request notification fan-out failed for request %: %', v_request.id, sqlerrm;
  end;

  return v_request;
end;
$$;

grant execute on function public.customer_create_service_request(
  uuid, text, text, public.budget_type, bigint, bigint,
  public.schedule_type, date, time, time,
  text, text, text, text, double precision, double precision, text
) to authenticated;

-- ---------------------------------------------------------------------------
-- Delivery trigger: the same non-blocking pg_net webhook pattern as the KYC
-- provider trigger (0036) — a QUEUED row pings an Edge Function to actually
-- call FCM; a webhook failure here never blocks the notification being
-- recorded (the row just stays QUEUED for a retry sweep).
-- ---------------------------------------------------------------------------
insert into public.integration_settings (key, value)
values
  ('notification_webhook_url', null),
  ('notification_webhook_service_key', null)
on conflict (key) do nothing;

create or replace function public.trigger_notification_webhook()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_url text;
  v_key text;
begin
  select value into v_url from public.integration_settings where key = 'notification_webhook_url';
  select value into v_key from public.integration_settings where key = 'notification_webhook_service_key';

  if v_url is null or v_key is null then
    return new;
  end if;

  begin
    perform net.http_post(
      url := v_url,
      headers := jsonb_build_object(
        'Content-Type', 'application/json',
        'Authorization', 'Bearer ' || v_key
      ),
      body := jsonb_build_object('notification_id', new.id)
    );
  exception when others then
    raise warning 'notification webhook failed for notification %: %', new.id, sqlerrm;
  end;

  return new;
end;
$$;

drop trigger if exists notifications_notify_webhook on public.notifications;
create trigger notifications_notify_webhook
  after insert on public.notifications
  for each row
  when (new.status = 'QUEUED' and new.channel = 'PUSH')
  execute function public.trigger_notification_webhook();
