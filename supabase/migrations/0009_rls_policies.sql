-- ===========================================================================
-- 0009  Row Level Security
-- ---------------------------------------------------------------------------
-- Posture: deny by default, then grant the narrowest thing that works.
--
--   * Every table in public has RLS enabled. A table with no matching policy is
--     invisible, so forgetting a policy fails closed rather than open.
--   * Blanket privileges are revoked from anon and authenticated first. A policy
--     can only permit what a GRANT already allows, so the grants below are the
--     outer boundary and the policies are the inner one.
--   * Almost nothing is directly writable. State changes go through the
--     SECURITY DEFINER operations in 0010, which validate the transition and
--     write the audit log in the same transaction. The few direct UPDATE grants
--     are column-scoped, so a worker can edit their own bio but cannot touch
--     workers.status or workers.is_kyc_verified.
--   * "Admin" is never a role claim from a token. Every admin policy calls
--     public.admin_has_permission(), which reads this database.
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- Start from nothing
-- ---------------------------------------------------------------------------
revoke all on all tables in schema public from anon, authenticated;
revoke all on all sequences in schema public from anon, authenticated;
revoke all on all functions in schema public from anon, authenticated;

alter default privileges in schema public revoke all on tables from anon, authenticated;
alter default privileges in schema public revoke all on functions from anon, authenticated;

-- Re-grant execute on the identity/authorization helpers only.
grant execute on function
  public.firebase_uid,
  public.current_profile_id,
  public.current_admin_id,
  public.is_admin,
  public.current_admin_role,
  public.admin_has_permission,
  public.require_permission
to anon, authenticated;

-- ---------------------------------------------------------------------------
-- Caller resolution helpers
-- ---------------------------------------------------------------------------
create or replace function public.current_worker_id()
returns uuid
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select w.id
  from public.workers w
  join public.profiles p on p.id = w.profile_id
  where w.firebase_uid = public.firebase_uid()
    and p.account_status = 'ACTIVE'
$$;

create or replace function public.current_customer_id()
returns uuid
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select c.id
  from public.customers c
  join public.profiles p on p.id = c.profile_id
  where c.firebase_uid = public.firebase_uid()
    and p.account_status = 'ACTIVE'
$$;

-- True when the caller is the customer or the assigned worker on the booking.
create or replace function public.is_booking_party(p_booking_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select exists (
    select 1
    from public.bookings b
    where b.id = p_booking_id
      and (
        b.customer_id = public.current_customer_id()
        or b.worker_id = public.current_worker_id()
      )
  )
$$;

grant execute on function
  public.current_worker_id,
  public.current_customer_id,
  public.is_booking_party
to authenticated;

-- ---------------------------------------------------------------------------
-- Enable RLS everywhere
-- ---------------------------------------------------------------------------
do $$
declare
  t record;
begin
  for t in
    select tablename
    from pg_tables
    where schemaname = 'public'
  loop
    execute format('alter table public.%I enable row level security', t.tablename);
    -- Applies RLS to the table owner too, so a migration or a poorly scoped
    -- connection cannot quietly read around the policies.
    execute format('alter table public.%I force row level security', t.tablename);
  end loop;
end;
$$;

-- ===========================================================================
-- Public catalogue — the only data the anonymous website may read
-- ===========================================================================
grant select on public.services, public.service_problems, public.faqs to anon, authenticated;

create policy services_public_read on public.services
  for select to anon, authenticated
  using (is_active);

create policy services_admin_read on public.services
  for select to authenticated
  using (public.admin_has_permission('services.read'));

create policy service_problems_public_read on public.service_problems
  for select to anon, authenticated
  using (
    exists (select 1 from public.services s where s.id = service_id and s.is_active)
  );

create policy faqs_public_read on public.faqs
  for select to anon, authenticated
  using (
    is_active
    and (
      service_id is null
      or exists (select 1 from public.services s where s.id = service_id and s.is_active)
    )
  );

-- Public settings only (support email and similar). Secrets are never here.
grant select on public.platform_settings to anon, authenticated;

create policy platform_settings_public_read on public.platform_settings
  for select to anon, authenticated
  using (is_public);

create policy platform_settings_admin_read on public.platform_settings
  for select to authenticated
  using (public.admin_has_permission('settings.read'));

-- ===========================================================================
-- Identity
-- ===========================================================================
grant select on public.profiles to authenticated;
-- A user may correct their own display fields. Role and account_status are not
-- in the grant, so escalation by self-update is impossible.
grant update (display_name, phone, email) on public.profiles to authenticated;

create policy profiles_self_read on public.profiles
  for select to authenticated
  using (firebase_uid = public.firebase_uid());

create policy profiles_self_update on public.profiles
  for update to authenticated
  using (firebase_uid = public.firebase_uid())
  with check (firebase_uid = public.firebase_uid());

create policy profiles_admin_read on public.profiles
  for select to authenticated
  using (
    public.admin_has_permission('customers.read')
    or public.admin_has_permission('workers.read')
    or public.admin_has_permission('admins.read')
  );

grant select on public.admin_users to authenticated;

create policy admin_users_self_read on public.admin_users
  for select to authenticated
  using (firebase_uid = public.firebase_uid());

create policy admin_users_admin_read on public.admin_users
  for select to authenticated
  using (public.admin_has_permission('admins.read'));

grant select on public.permissions, public.role_permissions, public.admin_user_permissions to authenticated;

create policy permissions_admin_read on public.permissions
  for select to authenticated
  using (public.is_admin());

create policy role_permissions_admin_read on public.role_permissions
  for select to authenticated
  using (public.is_admin());

create policy admin_user_permissions_read on public.admin_user_permissions
  for select to authenticated
  using (
    admin_id = public.current_admin_id()
    or public.admin_has_permission('admins.read')
  );

-- ===========================================================================
-- Customers
-- ===========================================================================
grant select on public.customers to authenticated;
grant update (full_name, email, city, state, pincode, address_line, latitude, longitude)
  on public.customers to authenticated;

create policy customers_self_read on public.customers
  for select to authenticated
  using (firebase_uid = public.firebase_uid());

create policy customers_self_update on public.customers
  for update to authenticated
  using (firebase_uid = public.firebase_uid() and status = 'ACTIVE')
  with check (firebase_uid = public.firebase_uid());

create policy customers_admin_read on public.customers
  for select to authenticated
  using (public.admin_has_permission('customers.read'));

-- The assigned worker needs the customer's name to do the job, and nothing else
-- beyond what the booking already carries.
create policy customers_visible_to_assigned_worker on public.customers
  for select to authenticated
  using (
    exists (
      select 1 from public.bookings b
      where b.customer_id = customers.id
        and b.worker_id = public.current_worker_id()
        and b.status not in ('REQUESTED', 'CANCELLED', 'EXPIRED')
    )
  );

-- ===========================================================================
-- Workers
-- ===========================================================================
grant select on public.workers to authenticated;
-- Deliberately excludes status, availability-independent verification flags,
-- rating, jobs_completed and every restriction column.
grant update (bio, experience_years, address_line, city, state, pincode,
              latitude, longitude, service_radius_km, availability, last_active_at)
  on public.workers to authenticated;

create policy workers_self_read on public.workers
  for select to authenticated
  using (firebase_uid = public.firebase_uid());

create policy workers_self_update on public.workers
  for update to authenticated
  using (
    firebase_uid = public.firebase_uid()
    and status in ('ACTIVE', 'INACTIVE', 'REGISTERED', 'VERIFICATION_PENDING')
  )
  with check (firebase_uid = public.firebase_uid());

create policy workers_admin_read on public.workers
  for select to authenticated
  using (public.admin_has_permission('workers.read'));

-- A customer may see a worker who is a candidate for, or assigned to, one of
-- their own bookings.
create policy workers_visible_to_booking_customer on public.workers
  for select to authenticated
  using (
    exists (
      select 1 from public.bookings b
      where b.worker_id = workers.id
        and b.customer_id = public.current_customer_id()
    )
    or exists (
      select 1
      from public.booking_match_candidates mc
      join public.bookings b on b.id = mc.booking_id
      where mc.worker_id = workers.id
        and b.customer_id = public.current_customer_id()
    )
  );

grant select on public.worker_services to authenticated;

create policy worker_services_read on public.worker_services
  for select to authenticated
  using (
    worker_id = public.current_worker_id()
    or public.admin_has_permission('workers.read')
  );

-- ---------------------------------------------------------------------------
-- Public worker card
-- ---------------------------------------------------------------------------
-- The public website and the customer app need a safe projection of an active
-- worker. A view is used rather than a policy because the restriction is
-- column-level: phone, address, coordinates and restriction notes must never
-- leave the platform.
create view public.worker_public_cards
with (security_invoker = false)
as
select
  w.id,
  w.worker_code,
  w.full_name,
  w.primary_service_id,
  w.experience_years,
  w.bio,
  w.city,
  w.state,
  w.rating_avg,
  w.rating_count,
  w.jobs_completed,
  w.is_kyc_verified,
  w.is_qualification_verified,
  w.is_skill_verified,
  w.is_background_verified,
  w.is_insured,
  w.verified_at,
  w.profile_media_id
from public.workers w
where w.status = 'ACTIVE';

comment on view public.worker_public_cards is
  'Safe projection of an active worker. Excludes phone, address, coordinates and moderation fields.';

grant select on public.worker_public_cards to anon, authenticated;

-- ===========================================================================
-- Verification
-- ===========================================================================
grant select on public.worker_verifications to authenticated;

create policy worker_verifications_self_read on public.worker_verifications
  for select to authenticated
  using (worker_id = public.current_worker_id());

create policy worker_verifications_admin_read on public.worker_verifications
  for select to authenticated
  using (public.admin_has_permission('verification.read'));

-- No UPDATE grant at all: an outcome is set only by public.decide_verification().

grant select on public.insurance_policies to authenticated;

create policy insurance_self_read on public.insurance_policies
  for select to authenticated
  using (worker_id = public.current_worker_id());

create policy insurance_admin_read on public.insurance_policies
  for select to authenticated
  using (public.admin_has_permission('insurance.read'));

-- ===========================================================================
-- Bookings
-- ===========================================================================
grant select on public.bookings to authenticated;
-- No INSERT, UPDATE or DELETE. Creation and every transition run through the
-- RPCs in 0010, which enforce the state machine.

create policy bookings_customer_read on public.bookings
  for select to authenticated
  using (customer_id = public.current_customer_id());

create policy bookings_worker_read on public.bookings
  for select to authenticated
  using (worker_id = public.current_worker_id());

create policy bookings_admin_read on public.bookings
  for select to authenticated
  using (public.admin_has_permission('bookings.read'));

grant select on public.booking_events to authenticated;

create policy booking_events_party_read on public.booking_events
  for select to authenticated
  using (public.is_booking_party(booking_id));

create policy booking_events_admin_read on public.booking_events
  for select to authenticated
  using (public.admin_has_permission('bookings.read'));

-- ---------------------------------------------------------------------------
-- Match candidates
-- ---------------------------------------------------------------------------
-- Scores are computed server-side and are never writable by a client. A worker
-- can see only the offers made to them; a customer can see candidates for their
-- own booking.
grant select on public.booking_match_candidates to authenticated;

create policy match_candidates_worker_read on public.booking_match_candidates
  for select to authenticated
  using (worker_id = public.current_worker_id() and was_offered);

create policy match_candidates_customer_read on public.booking_match_candidates
  for select to authenticated
  using (
    exists (
      select 1 from public.bookings b
      where b.id = booking_id and b.customer_id = public.current_customer_id()
    )
  );

create policy match_candidates_admin_read on public.booking_match_candidates
  for select to authenticated
  using (public.admin_has_permission('matching.read'));

-- ===========================================================================
-- Materials
-- ===========================================================================
grant select on public.materials to authenticated;

create policy materials_party_read on public.materials
  for select to authenticated
  using (public.is_booking_party(booking_id));

create policy materials_admin_read on public.materials
  for select to authenticated
  using (public.admin_has_permission('materials.read'));

-- ===========================================================================
-- Ratings
-- ===========================================================================
grant select on public.ratings to anon, authenticated;

create policy ratings_public_read on public.ratings
  for select to anon, authenticated
  using (
    not is_hidden
    and exists (select 1 from public.workers w where w.id = worker_id and w.status = 'ACTIVE')
  );

create policy ratings_party_read on public.ratings
  for select to authenticated
  using (public.is_booking_party(booking_id));

create policy ratings_admin_read on public.ratings
  for select to authenticated
  using (public.admin_has_permission('bookings.read'));

-- ===========================================================================
-- Money
-- ===========================================================================
-- Nothing financial is client-writable anywhere in this section.
grant select on public.payments to authenticated;

create policy payments_customer_read on public.payments
  for select to authenticated
  using (customer_id = public.current_customer_id());

create policy payments_worker_read on public.payments
  for select to authenticated
  using (
    exists (
      select 1 from public.bookings b
      where b.id = booking_id and b.worker_id = public.current_worker_id()
    )
  );

create policy payments_admin_read on public.payments
  for select to authenticated
  using (public.admin_has_permission('payments.read'));

grant select on public.refunds to authenticated;

create policy refunds_admin_read on public.refunds
  for select to authenticated
  using (public.admin_has_permission('payments.read'));

create policy refunds_customer_read on public.refunds
  for select to authenticated
  using (
    exists (
      select 1 from public.payments p
      where p.id = payment_id and p.customer_id = public.current_customer_id()
    )
  );

grant select on public.wallets, public.wallet_transactions to authenticated;

create policy wallets_self_read on public.wallets
  for select to authenticated
  using (worker_id = public.current_worker_id());

create policy wallets_admin_read on public.wallets
  for select to authenticated
  using (public.admin_has_permission('wallets.read'));

create policy wallet_transactions_self_read on public.wallet_transactions
  for select to authenticated
  using (worker_id = public.current_worker_id());

create policy wallet_transactions_admin_read on public.wallet_transactions
  for select to authenticated
  using (public.admin_has_permission('wallets.read'));

grant select on public.payouts to authenticated;

create policy payouts_self_read on public.payouts
  for select to authenticated
  using (worker_id = public.current_worker_id());

create policy payouts_admin_read on public.payouts
  for select to authenticated
  using (public.admin_has_permission('payouts.read'));

-- ===========================================================================
-- Claims
-- ===========================================================================
grant select on public.claims, public.claim_events to authenticated;

create policy claims_customer_read on public.claims
  for select to authenticated
  using (customer_id = public.current_customer_id());

-- A worker can see a claim filed against them — they are a party to it — but
-- the internal decision note is excluded from the worker-facing projection in
-- the application layer.
create policy claims_worker_read on public.claims
  for select to authenticated
  using (worker_id = public.current_worker_id());

create policy claims_admin_read on public.claims
  for select to authenticated
  using (public.admin_has_permission('claims.read'));

create policy claim_events_admin_read on public.claim_events
  for select to authenticated
  using (public.admin_has_permission('claims.read'));

create policy claim_events_party_read on public.claim_events
  for select to authenticated
  using (
    exists (
      select 1 from public.claims c
      where c.id = claim_id
        and (c.customer_id = public.current_customer_id()
             or c.worker_id = public.current_worker_id())
    )
  );

-- ===========================================================================
-- Support
-- ===========================================================================
grant select on public.support_tickets, public.support_messages to authenticated;

create policy support_tickets_requester_read on public.support_tickets
  for select to authenticated
  using (
    customer_id = public.current_customer_id()
    or worker_id = public.current_worker_id()
  );

create policy support_tickets_admin_read on public.support_tickets
  for select to authenticated
  using (public.admin_has_permission('support.read'));

-- Internal staff notes are filtered out for the requester by the policy itself,
-- not by a client-side filter that could be bypassed.
create policy support_messages_requester_read on public.support_messages
  for select to authenticated
  using (
    not is_internal
    and exists (
      select 1 from public.support_tickets t
      where t.id = ticket_id
        and (t.customer_id = public.current_customer_id()
             or t.worker_id = public.current_worker_id())
    )
  );

create policy support_messages_admin_read on public.support_messages
  for select to authenticated
  using (public.admin_has_permission('support.read'));

-- ===========================================================================
-- Notifications
-- ===========================================================================
grant select on public.notifications to authenticated;
-- Marking an in-app notification read is the one field a recipient may set.
grant update (read_at) on public.notifications to authenticated;

create policy notifications_recipient_read on public.notifications
  for select to authenticated
  using (recipient_firebase_uid = public.firebase_uid());

create policy notifications_recipient_mark_read on public.notifications
  for update to authenticated
  using (recipient_firebase_uid = public.firebase_uid() and channel = 'IN_APP')
  with check (recipient_firebase_uid = public.firebase_uid());

create policy notifications_admin_read on public.notifications
  for select to authenticated
  using (public.admin_has_permission('notifications.read'));

grant select, insert, update (is_active, last_seen_at, device_label), delete
  on public.push_tokens to authenticated;

create policy push_tokens_self_all on public.push_tokens
  for all to authenticated
  using (firebase_uid = public.firebase_uid())
  with check (firebase_uid = public.firebase_uid());

-- ===========================================================================
-- Media
-- ===========================================================================
-- Whether a row is visible mirrors whether a signed URL would be minted for it:
-- the owner, the parties to the booking, or an administrator holding the
-- permission named by the purpose rule.
create or replace function public.can_read_media(p_media public.media_assets)
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select
    p_media.deleted_at is null
    and (
      -- Catalogue artwork is genuinely public.
      p_media.sensitivity = 'PUBLIC'
      -- The worker or customer the file belongs to.
      or p_media.worker_id = public.current_worker_id()
      or p_media.customer_id = public.current_customer_id()
      -- Either party to the booking the file documents.
      or (p_media.booking_id is not null and public.is_booking_party(p_media.booking_id))
      -- The person who raised the claim or the ticket.
      or exists (
        select 1 from public.claims c
        where c.id = p_media.claim_id
          and (c.customer_id = public.current_customer_id()
               or c.worker_id = public.current_worker_id())
      )
      or exists (
        select 1 from public.support_tickets t
        where t.id = p_media.support_ticket_id
          and (t.customer_id = public.current_customer_id()
               or t.worker_id = public.current_worker_id())
      )
      -- An administrator holding the permission this purpose requires.
      or exists (
        select 1 from public.media_purpose_rules r
        where r.purpose = p_media.purpose
          and public.admin_has_permission(r.required_permission)
      )
    )
$$;

grant execute on function public.can_read_media(public.media_assets) to authenticated;

grant select on public.media_assets to authenticated;
grant select on public.media_purpose_rules to authenticated;

create policy media_assets_read on public.media_assets
  for select to authenticated
  using (public.can_read_media(media_assets));

-- Catalogue artwork is readable without a session so service pages can render.
grant select on public.media_assets to anon;

create policy media_assets_public_read on public.media_assets
  for select to anon
  using (sensitivity = 'PUBLIC' and deleted_at is null and upload_status = 'COMPLETED');

create policy media_purpose_rules_read on public.media_purpose_rules
  for select to authenticated
  using (true);

-- ===========================================================================
-- Audit trail
-- ===========================================================================
-- Readable by administrators who hold audit_logs.read, and writable by nobody:
-- rows arrive only through public.write_audit_log(), which is SECURITY DEFINER.
grant select on public.audit_logs to authenticated;

create policy audit_logs_admin_read on public.audit_logs
  for select to authenticated
  using (public.admin_has_permission('audit_logs.read'));

-- ===========================================================================
-- Contact messages
-- ===========================================================================
-- Not readable by any client. Submissions arrive through a rate-limited server
-- endpoint using the service role, never straight from the browser.
grant select on public.contact_messages to authenticated;

create policy contact_messages_admin_read on public.contact_messages
  for select to authenticated
  using (public.admin_has_permission('support.read'));

-- ===========================================================================
-- Realtime
-- ===========================================================================
-- Realtime respects RLS, so a subscriber receives only rows their policies
-- already allow. Only the tables the admin console and the apps actually watch
-- are published.
alter publication supabase_realtime add table public.bookings;
alter publication supabase_realtime add table public.booking_events;
alter publication supabase_realtime add table public.worker_verifications;
alter publication supabase_realtime add table public.claims;
alter publication supabase_realtime add table public.support_tickets;
alter publication supabase_realtime add table public.support_messages;
alter publication supabase_realtime add table public.payouts;
alter publication supabase_realtime add table public.payments;
alter publication supabase_realtime add table public.notifications;
alter publication supabase_realtime add table public.materials;
