-- Fix: The customer_create_booking RPC inserts a booking_event with
-- event_type = 'REQUESTED', but the booking_event_type enum uses
-- 'REQUEST_CREATED'. Add 'REQUESTED' to the enum so the insert succeeds.

alter type public.booking_event_type add value if not exists 'REQUESTED';
