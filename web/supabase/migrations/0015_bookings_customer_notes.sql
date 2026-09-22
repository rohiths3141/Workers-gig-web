-- ===========================================================================
-- 0015  Add the missing bookings.customer_notes column
-- ===========================================================================
-- customer_create_booking() (0014) has always written to
-- public.bookings.customer_notes, and the customer app reads it back, but no
-- migration ever created the column — a booking write or the read in
-- getMyBookings()/getBooking() fails with "column does not exist" the moment
-- either path is exercised. This adds the column customer_create_booking was
-- already written against.

alter table public.bookings
  add column customer_notes text;

comment on column public.bookings.customer_notes is
  'Optional free-text note the customer leaves at booking time (e.g. gate code, preferred time window). Distinct from problem_description, which describes the work itself.';
