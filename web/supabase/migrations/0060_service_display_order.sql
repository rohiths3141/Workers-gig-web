-- Trade lists came out in an arbitrary order ("Other Home Services" first,
-- "Electrical" last) in the worker app's main-trade sheet and on the customer
-- home screen.
--
-- The catalogue seed in 0012 carries the intended order, but it inserts with
-- `on conflict (slug) do nothing`, so any environment whose services rows
-- already existed kept `display_order` at its column default of 100. With
-- every row equal, the index order (display_order, name) degenerates and the
-- list is effectively unordered.
--
-- Set the order explicitly by slug. Idempotent, and it touches nothing else.

update public.services as s
set display_order = v.display_order
from (values
  ('electrical', 10),
  ('plumbing', 20),
  ('ac-service', 30),
  ('appliance-repair', 40),
  ('carpentry', 50),
  ('painting', 60),
  ('cleaning', 70),
  ('other-home-services', 80)
) as v(slug, display_order)
where s.slug = v.slug
  and s.display_order is distinct from v.display_order;

-- Anything added later that still sits on the default keeps a stable place
-- after the eight above rather than mixing in among them.
update public.services
set display_order = 900
where display_order = 100
  and slug not in (
    'electrical', 'plumbing', 'ac-service', 'appliance-repair',
    'carpentry', 'painting', 'cleaning', 'other-home-services'
  );
