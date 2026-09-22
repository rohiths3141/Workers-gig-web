-- ===========================================================================
-- Worker App contract tests
-- ---------------------------------------------------------------------------
-- Exercises the trusted operations the Worker App depends on, against a real
-- database, asserting that each one REFUSES what it must refuse. Every check
-- here corresponds to a defect in the previous Worker/Captain application.
--
-- Run against a database with migrations 0001-0013 applied:
--
--   createdb wervexa_test
--   psql -d wervexa_test -c 'create publication supabase_realtime'
--   for f in supabase/migrations/0*.sql; do psql -d wervexa_test -f "$f"; done
--   psql -d wervexa_test -f supabase/tests/worker_contracts_test.sql
--
-- A raised exception fails the run: any line reading "TEST FAILED" means a
-- guard that should have refused did not. The identity is simulated with
-- `set request.firebase_uid`, which is the trusted-backend path in
-- public.firebase_uid(); a real client reaches it through a verified Firebase
-- ID token instead, and cannot set that GUC through PostgREST.
-- ===========================================================================

\set ON_ERROR_STOP on
\pset pager off

-- Seed: a worker who has done nothing yet.
insert into public.profiles (id, firebase_uid, role, phone, display_name)
values ('11111111-1111-1111-1111-111111111111', 'firebase-worker-arun', 'WORKER', '9000000001', 'Arun');
insert into public.workers (profile_id, firebase_uid, full_name, phone, worker_code)
values ('11111111-1111-1111-1111-111111111111', 'firebase-worker-arun', 'Arun Kumar', '9000000001', 'WKR-TEST-1');

set request.firebase_uid = 'firebase-worker-arun';

\echo '--- 1. eligibility of a brand-new worker (expect eligible=false, several reasons) ---'
select jsonb_pretty(public.worker_eligibility());

\echo '--- 2. going AVAILABLE must be refused, with a reason ---'
do $$
begin
  perform public.worker_set_availability('AVAILABLE');
  raise exception 'TEST FAILED: an ineligible worker was allowed to go available';
exception when insufficient_privilege then
  raise notice 'PASS refused: %', sqlerrm;
end $$;

\echo '--- 3. going OFFLINE is always allowed ---'
select public.worker_set_availability('OFFLINE') -> 'availability' as availability;

\echo '--- 4. BUSY cannot be chosen by hand ---'
do $$
begin
  perform public.worker_set_availability('BUSY');
  raise exception 'TEST FAILED: BUSY was settable by the client';
exception when check_violation then
  raise notice 'PASS refused: %', sqlerrm;
end $$;

\echo '--- 5. a gig under a trade the worker is not approved for is refused ---'
do $$
declare v_service uuid;
begin
  select id into v_service from public.services where slug = 'electrical';
  perform public.worker_upsert_gig(null, v_service, 'Switchboard Repair', 'desc',
                                   39900, 'PER_JOB', 60, null, true);
  raise exception 'TEST FAILED: gig created under an unapproved trade';
exception when insufficient_privilege then
  raise notice 'PASS refused: %', sqlerrm;
end $$;

\echo '--- 6. worker requests two trades; they arrive UNAPPROVED ---'
select (public.worker_request_service((select id from public.services where slug='electrical'))).is_approved as electrical_approved,
       (public.worker_request_service((select id from public.services where slug='painting'))).is_approved  as painting_approved;

\echo '--- 7. admin approves both trades (simulating operations) ---'
reset request.firebase_uid;
update public.worker_services set is_approved = true
 where worker_id = (select id from public.workers where worker_code='WKR-TEST-1');
set request.firebase_uid = 'firebase-worker-arun';

\echo '--- 8. MULTI-GIG: one worker publishes four gigs across two trades ---'
select public.worker_upsert_gig(null, (select id from public.services where slug='electrical'),
       'Switchboard Repair', 'Repair of switchboards', 39900, 'PER_JOB', 60, null, true) is not null as gig1;
select public.worker_upsert_gig(null, (select id from public.services where slug='electrical'),
       'Full House Rewiring', 'Rewiring', 1499900, 'PER_JOB', 2880, null, true) is not null as gig2;
select public.worker_upsert_gig(null, (select id from public.services where slug='painting'),
       'Interior Wall Painting', '2BHK interior', 250000, 'PER_JOB', 2880, 20, true) is not null as gig3;
select public.worker_upsert_gig(null, (select id from public.services where slug='painting'),
       'Single Room Repaint', 'One room', 80000, 'PER_JOB', 480, null, true) is not null as gig4;

select count(*) as total_gigs, count(distinct service_id) as distinct_trades
from public.worker_gigs
where worker_id = (select id from public.workers where worker_code='WKR-TEST-1');

\echo '--- 9. a duplicate gig title under the same trade is refused ---'
do $$
begin
  perform public.worker_upsert_gig(null, (select id from public.services where slug='painting'),
          'Single Room Repaint', 'dupe', 90000, 'PER_JOB', 480, null, true);
  raise exception 'TEST FAILED: duplicate gig title accepted';
exception when unique_violation then
  raise notice 'PASS refused: %', sqlerrm;
end $$;

\echo '--- 10. worker cannot set their own gig to REJECTED ---'
do $$
declare v_gig uuid;
begin
  select id into v_gig from public.worker_gigs
   where worker_id = (select id from public.workers where worker_code='WKR-TEST-1') limit 1;
  perform public.worker_set_gig_status(v_gig, 'REJECTED');
  raise exception 'TEST FAILED: worker rejected their own gig';
exception when insufficient_privilege then
  raise notice 'PASS refused: %', sqlerrm;
end $$;

\echo '--- 11. worker cannot self-approve a verification ---'
do $$
begin
  perform public.worker_submit_verification('IDENTITY_KYC', '{}'::jsonb);
  raise exception 'TEST FAILED: KYC submitted with no document';
exception when check_violation then
  raise notice 'PASS refused (no document uploaded): %', sqlerrm;
end $$;

select count(*) as approved_verifications_a_worker_can_create
from public.worker_verifications
where worker_id = (select id from public.workers where worker_code='WKR-TEST-1')
  and status = 'APPROVED';
-- A second worker, so the race has two contenders.
insert into public.profiles (id, firebase_uid, role, phone, display_name)
values ('22222222-2222-2222-2222-222222222222', 'firebase-worker-bala', 'WORKER', '9000000002', 'Bala');
insert into public.workers (profile_id, firebase_uid, full_name, phone, worker_code, status)
values ('22222222-2222-2222-2222-222222222222', 'firebase-worker-bala', 'Bala S', '9000000002', 'WKR-TEST-2', 'ACTIVE');

insert into public.profiles (id, firebase_uid, role, phone, display_name)
values ('33333333-3333-3333-3333-333333333333', 'firebase-customer-1', 'CUSTOMER', '9000000003', 'Meena');
insert into public.customers (profile_id, firebase_uid, full_name, phone)
values ('33333333-3333-3333-3333-333333333333', 'firebase-customer-1', 'Meena R', '9000000003');

update public.workers set status='ACTIVE' where worker_code='WKR-TEST-1';

-- A booking, offered to both workers.
insert into public.bookings (id, customer_id, service_id, problem_description, address_line, arrival_code, booking_code)
values ('44444444-4444-4444-4444-444444444444',
        (select id from public.customers where phone='9000000003'),
        (select id from public.services where slug='electrical'),
        'Switchboard sparking', '12 Anna Nagar', '482913', 'BK-TEST-1');

insert into public.booking_match_candidates
  (booking_id, worker_id, distance_km, trade_match_score, skill_score, qualification_score,
   kyc_score, background_score, insurance_score, availability_score, rating_score,
   proximity_score, total_score, rank, was_offered, offered_at)
select '44444444-4444-4444-4444-444444444444', w.id, 3.2, 1, 1, 1, 1, 1, 1, 1, 0.7, 0.9, 0.95,
       row_number() over (order by w.worker_code), true, now()
from public.workers w where w.worker_code in ('WKR-TEST-1','WKR-TEST-2');

\echo '--- 12. worker A accepts the job ---'
set request.firebase_uid = 'firebase-worker-arun';
select (public.worker_accept_offer('44444444-4444-4444-4444-444444444444')).status as status_after_accept;

\echo '--- 13. worker B accepts the SAME job: must lose cleanly ---'
set request.firebase_uid = 'firebase-worker-bala';
do $$
begin
  perform public.worker_accept_offer('44444444-4444-4444-4444-444444444444');
  raise exception 'TEST FAILED: two workers both accepted the same booking';
exception when unique_violation then
  raise notice 'PASS refused: %', sqlerrm;
end $$;

\echo '--- 14. worker B cannot drive a booking that is not theirs ---'
do $$
begin
  perform public.worker_advance_booking('44444444-4444-4444-4444-444444444444', 'TRAVELING');
  raise exception 'TEST FAILED: a stranger advanced the booking';
exception when no_data_found then
  raise notice 'PASS refused: %', sqlerrm;
end $$;

set request.firebase_uid = 'firebase-worker-arun';

\echo '--- 15. worker cannot skip straight to COMPLETED ---'
do $$
begin
  perform public.worker_advance_booking('44444444-4444-4444-4444-444444444444', 'COMPLETED');
  raise exception 'TEST FAILED: worker jumped to COMPLETED';
exception when insufficient_privilege then
  raise notice 'PASS refused: %', sqlerrm;
end $$;

\echo '--- 16. customer confirms; worker travels and arrives ---'
select (public.transition_booking('44444444-4444-4444-4444-444444444444','CONFIRMED','CUSTOMER')).status;
select (public.worker_advance_booking('44444444-4444-4444-4444-444444444444','TRAVELING')).status;
select (public.worker_advance_booking('44444444-4444-4444-4444-444444444444','ARRIVED')).status;

\echo '--- 17. WRONG arrival code must NOT verify (the old app''s worst bug) ---'
select public.worker_verify_arrival('44444444-4444-4444-4444-444444444444', '000000') as wrong_code_result;

\echo '--- 18. work cannot start while arrival is unverified ---'
do $$
begin
  perform public.worker_advance_booking('44444444-4444-4444-4444-444444444444', 'IN_PROGRESS');
  raise exception 'TEST FAILED: work started without a verified arrival';
exception when check_violation then
  raise notice 'PASS refused: %', sqlerrm;
end $$;

\echo '--- 19. CORRECT arrival code verifies ---'
select public.worker_verify_arrival('44444444-4444-4444-4444-444444444444', '482913') as right_code_result;
select (public.worker_advance_booking('44444444-4444-4444-4444-444444444444','IN_PROGRESS')).status;

\echo '--- 20. completion is refused without after-work evidence ---'
do $$
begin
  perform public.worker_advance_booking('44444444-4444-4444-4444-444444444444', 'AWAITING_APPROVAL');
  raise exception 'TEST FAILED: job completed with no evidence';
exception when check_violation then
  raise notice 'PASS refused: %', sqlerrm;
end $$;

\echo '--- 21. arrival attempts were recorded (1 failed, 1 successful) ---'
select was_successful, count(*) from public.booking_arrival_attempts group by 1 order by 1;

\echo '--- 22. registration: a Firebase user creates their worker profile ---'
reset request.firebase_uid;
set request.firebase_uid = 'firebase-worker-new';
insert into public.profiles (firebase_uid, role, phone, display_name)
values ('firebase-worker-new', 'WORKER', '9000000009', 'Devi')
on conflict do nothing;
select (public.worker_create_profile('Devi Lakshmi', '+91 90000 00009')).status as new_worker_status;

\echo '--- 23. registering twice is harmless (retry after a dropped connection) ---'
select (public.worker_create_profile('Devi Lakshmi', '9000000009')).worker_code
     = (public.worker_create_profile('Devi Lakshmi', '9000000009')).worker_code
  as idempotent;

\echo '--- 24. a new worker is REGISTERED, not verified, and has no gigs ---'
select status, is_kyc_verified, is_background_verified, availability
from public.workers where firebase_uid = 'firebase-worker-new';

\echo '--- 25. earnings summary for a worker with no ledger reads zero, not null ---'
select jsonb_pretty(public.worker_earnings_summary());

\echo '--- 26. earnings are zero until a payment is verified (the job reached IN_PROGRESS only) ---'
set request.firebase_uid = 'firebase-worker-arun';
select jsonb_pretty(public.worker_earnings_summary());

\echo '--- 27. gigs submitted for review are NOT live (gigs.require_review is on) ---'
reset request.firebase_uid;
select status, count(*) from public.worker_gigs
 where worker_id = (select id from public.workers where worker_code='WKR-TEST-1')
 group by status order by 1;

\echo '--- 28. matching: prepare two eligible, available, verified workers ---'
update public.workers set is_kyc_verified = true, is_background_verified = true,
       status='ACTIVE', availability='AVAILABLE', latitude=13.0827, longitude=80.2707,
       primary_service_id = (select id from public.services where slug='electrical')
 where worker_code in ('WKR-TEST-1','WKR-TEST-2');

insert into public.bookings (id, customer_id, service_id, problem_description, address_line, booking_code, latitude, longitude)
values ('55555555-5555-5555-5555-555555555555',
        (select id from public.customers where phone='9000000003'),
        (select id from public.services where slug='electrical'),
        'Fan not working', '9 T Nagar', 'BK-TEST-2', 13.0830, 80.2710);

\echo '--- 29. NEGATIVE: neither worker has a live gig, so nobody matches ---'
select count(*) as candidates_with_no_live_gig
from public.run_matching('55555555-5555-5555-5555-555555555555');

\echo '--- 30. operations approves WKR-TEST-1''s electrical gigs ---'
update public.worker_gigs
   set status = 'ACTIVE',
       reviewed_at = now(),
       reviewed_by = (select id from public.admin_users limit 1)
 where worker_id = (select id from public.workers where worker_code='WKR-TEST-1')
   and service_id = (select id from public.services where slug='electrical');

select w.worker_code,
       public.worker_has_live_gig(w.id, (select id from public.services where slug='electrical')) as has_live_gig
from public.workers w where w.worker_code in ('WKR-TEST-1','WKR-TEST-2') order by 1;

\echo '--- 31. POSITIVE: the worker with the live gig now matches; the other does not ---'
select w.worker_code, mc.rank,
       (mc.scoring_snapshot->>'gig_gate_applied')::boolean as gate_applied,
       (mc.scoring_snapshot->>'gig_price_minor')::bigint as gig_price_minor
from public.run_matching('55555555-5555-5555-5555-555555555555') mc
join public.workers w on w.id = mc.worker_id
order by mc.rank;

\echo '--- 32. pausing every gig removes the worker from matching again ---'
set request.firebase_uid = 'firebase-worker-arun';
select count(*) as paused from (
  select public.worker_set_gig_status(id, 'PAUSED')
  from public.worker_gigs
  where worker_id = (select id from public.workers where worker_code='WKR-TEST-1')
    and status = 'ACTIVE'
) p;
reset request.firebase_uid;
select count(*) as candidates_after_pausing_all_gigs
from public.run_matching('55555555-5555-5555-5555-555555555555');

\echo '--- 33. a paused, already-reviewed gig can be resumed by the worker ---'
set request.firebase_uid = 'firebase-worker-arun';
select (public.worker_set_gig_status(
          (select id from public.worker_gigs
            where worker_id = (select id from public.workers where worker_code='WKR-TEST-1')
              and status = 'PAUSED' limit 1),
          'ACTIVE')).status as resumed_status;

\echo '--- 34. a gig that never cleared review cannot be resumed into ACTIVE ---'
do $$
declare v_gig uuid;
begin
  select id into v_gig from public.worker_gigs
   where worker_id = (select id from public.workers where worker_code='WKR-TEST-1')
     and reviewed_at is null and status = 'PENDING_REVIEW' limit 1;
  if v_gig is null then
    raise notice 'SKIP: no unreviewed gig to test with';
    return;
  end if;
  perform public.worker_set_gig_status(v_gig, 'PAUSED');
  perform public.worker_set_gig_status(v_gig, 'ACTIVE');
  raise exception 'TEST FAILED: an unreviewed gig was made live by the worker';
exception when check_violation then
  raise notice 'PASS refused: %', sqlerrm;
end $$;
