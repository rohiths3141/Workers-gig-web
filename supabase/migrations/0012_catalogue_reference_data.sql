-- ===========================================================================
-- 0012  Service catalogue and FAQ reference data
-- ---------------------------------------------------------------------------
-- This is reference data, not demo data: it is the real catalogue the platform
-- launches with, and it is expected to exist in production. It contains no
-- fabricated workers, bookings, statistics or verification records.
--
-- Development-only fixtures live in supabase/seed/dev_seed.sql and are never
-- applied to production.
-- ===========================================================================

insert into public.services
  (name, slug, short_description, description, icon_key, display_order, required_verifications, seo_title, seo_description)
values
  ('Electrical', 'electrical',
   'Wiring, switchboards, fans, lighting and power faults.',
   'Licensed electricians for household wiring faults, switchboard and MCB work, fan and light installation, inverter and stabiliser setup, and power supply diagnostics. Every electrician on the platform completes identity and background verification before taking jobs, and electrical trades additionally require a trade qualification on file.',
   'zap', 10,
   array['IDENTITY_KYC','BACKGROUND_CHECK','ITI_CERTIFICATE']::public.verification_type[],
   'Electrician Services at Home | Verified Electricians',
   'Book a verified electrician for wiring faults, switchboards, fans, lighting and power issues. Identity and qualification checked before the job.'),

  ('Plumbing', 'plumbing',
   'Leaks, blockages, taps, tanks and bathroom fittings.',
   'Plumbers for leaking taps and pipes, blocked drains, flush tank and mixer repairs, water motor and overhead tank issues, and bathroom fitting installation. Material costs are quoted and approved by you before anything is bought.',
   'droplet', 20,
   array['IDENTITY_KYC','BACKGROUND_CHECK']::public.verification_type[],
   'Plumber Services at Home | Verified Plumbers',
   'Book a verified plumber for leaks, blocked drains, taps, tanks and bathroom fittings. Transparent pricing with material approval before purchase.'),

  ('AC Service', 'ac-service',
   'Servicing, gas refill, installation and cooling faults.',
   'Air conditioner technicians for periodic servicing, cooling performance problems, gas top-up, water leakage, PCB and sensor faults, and installation or relocation of split and window units. Technicians working on refrigerant handling hold a relevant trade qualification.',
   'wind', 30,
   array['IDENTITY_KYC','BACKGROUND_CHECK','ITI_CERTIFICATE']::public.verification_type[],
   'AC Service and Repair at Home | Verified Technicians',
   'Book verified AC technicians for servicing, gas refill, installation and cooling problems. Qualification and background checked.'),

  ('Appliance Repair', 'appliance-repair',
   'Washing machines, refrigerators, microwaves and geysers.',
   'Appliance technicians for washing machine, refrigerator, microwave, geyser, chimney and water purifier faults. Diagnosis first, then a quote you approve before any repair or part replacement goes ahead.',
   'washing-machine', 40,
   array['IDENTITY_KYC','BACKGROUND_CHECK']::public.verification_type[],
   'Home Appliance Repair | Verified Technicians',
   'Book verified technicians for washing machine, fridge, microwave and geyser repair. Diagnosis and quote before any work begins.'),

  ('Carpentry', 'carpentry',
   'Furniture repair, fittings, doors, locks and modular work.',
   'Carpenters for furniture repair and assembly, door and window alignment, lock and hinge replacement, modular kitchen and wardrobe fittings, and custom shelving.',
   'hammer', 50,
   array['IDENTITY_KYC','BACKGROUND_CHECK']::public.verification_type[],
   'Carpenter Services at Home | Verified Carpenters',
   'Book a verified carpenter for furniture repair, door and lock work, and modular fittings.'),

  ('Painting', 'painting',
   'Interior and exterior painting, waterproofing and touch-ups.',
   'Painters for full interior and exterior painting, damp and seepage treatment, waterproofing, texture and accent walls, and small touch-up work. Surface preparation and material quantity are agreed before the job starts.',
   'paintbrush', 60,
   array['IDENTITY_KYC','BACKGROUND_CHECK']::public.verification_type[],
   'House Painting Services | Verified Painters',
   'Book verified painters for interior and exterior painting, waterproofing and damp treatment.'),

  ('Cleaning', 'cleaning',
   'Deep cleaning for homes, kitchens, bathrooms and sofas.',
   'Cleaning professionals for full home deep cleaning, kitchen degreasing, bathroom descaling, sofa and carpet shampooing, and post-renovation cleanup. Equipment and consumables are brought by the professional.',
   'sparkles', 70,
   array['IDENTITY_KYC','BACKGROUND_CHECK']::public.verification_type[],
   'Home Deep Cleaning Services | Verified Professionals',
   'Book verified cleaning professionals for home deep cleaning, kitchen, bathroom and sofa cleaning.'),

  ('Other Home Services', 'other-home-services',
   'Pest control, CCTV, RO service and general handyman work.',
   'Other verified home-service professionals for pest control, CCTV and intercom setup, RO and water purifier servicing, gas stove repair, and general handyman tasks that do not fit a single trade.',
   'wrench', 80,
   array['IDENTITY_KYC','BACKGROUND_CHECK']::public.verification_type[],
   'Other Home Services | Verified Professionals',
   'Book verified professionals for pest control, CCTV, RO servicing and general handyman work.');

-- ---------------------------------------------------------------------------
-- Common problems shown on each service detail page
-- ---------------------------------------------------------------------------
insert into public.service_problems (service_id, title, description, display_order)
select s.id, p.title, p.description, p.display_order
from public.services s
join (values
  ('electrical', 'Frequent MCB tripping', 'A breaker that trips repeatedly usually means an overloaded circuit or a short somewhere in the wiring.', 10),
  ('electrical', 'Switchboard or socket not working', 'Dead sockets, loose switches and sparking switchboards need the circuit isolated before any repair.', 20),
  ('electrical', 'Fan or light installation', 'Ceiling fan, chandelier, false-ceiling light and regulator fitting, including new wiring points.', 30),
  ('electrical', 'Inverter and stabiliser setup', 'Installation, battery connection and changeover wiring for home inverters.', 40),

  ('plumbing', 'Leaking tap or pipe', 'Dripping taps, joint leaks and wall seepage traced back to the failing section.', 10),
  ('plumbing', 'Blocked drain or washbasin', 'Kitchen sink, washbasin and floor trap blockages cleared without damaging the fitting.', 20),
  ('plumbing', 'Flush tank not working', 'Cistern refill, flush valve and float replacement for Indian and Western fittings.', 30),
  ('plumbing', 'Water motor or tank problem', 'Motor not pulling water, overhead tank overflow, and float valve replacement.', 40),

  ('ac-service', 'AC not cooling', 'Weak cooling is usually a dirty filter, a choked coil or low refrigerant. Diagnosis comes before any gas top-up.', 10),
  ('ac-service', 'Water leaking from indoor unit', 'A blocked drain pipe or a tilted indoor unit sends condensate into the room instead of outside.', 20),
  ('ac-service', 'Periodic service', 'Filter, coil and blower cleaning with drainage check, recommended before each summer.', 30),
  ('ac-service', 'Installation or relocation', 'Split and window unit installation, including copper piping, bracket and drain routing.', 40),

  ('appliance-repair', 'Washing machine not draining or spinning', 'Drain pump blockage, belt wear and lid-switch faults are the usual causes.', 10),
  ('appliance-repair', 'Refrigerator not cooling', 'Thermostat, compressor, gas and defrost faults diagnosed before a part is quoted.', 20),
  ('appliance-repair', 'Geyser not heating', 'Heating element, thermostat and safety cutout replacement, with the supply isolated first.', 30),
  ('appliance-repair', 'Microwave or chimney fault', 'Magnetron, control panel, suction and filter problems on kitchen appliances.', 40),

  ('carpentry', 'Door not closing or aligning', 'Hinge, frame and alignment correction for wooden and flush doors.', 10),
  ('carpentry', 'Furniture repair or assembly', 'Broken joints, drawer channels, hinges and flat-pack assembly.', 20),
  ('carpentry', 'Lock or handle replacement', 'Mortise, cylindrical and cupboard lock replacement.', 30),

  ('painting', 'Damp patches and peeling paint', 'Seepage has to be treated at the source before repainting, or it returns in months.', 10),
  ('painting', 'Full home repainting', 'Surface preparation, putty, primer and finish coats with material quantity agreed upfront.', 20),
  ('painting', 'Touch-up and single room', 'Small-area repainting matched to the existing shade.', 30),

  ('cleaning', 'Full home deep cleaning', 'Room-by-room cleaning including fans, grills, windows, floors and bathrooms.', 10),
  ('cleaning', 'Kitchen degreasing', 'Chimney, hob, tiles and cabinet cleaning to remove accumulated grease.', 20),
  ('cleaning', 'Sofa and carpet shampooing', 'Wet shampoo and vacuum extraction for upholstery and carpets.', 30),

  ('other-home-services', 'Pest control', 'Cockroach, termite, bedbug and general pest treatment with follow-up where needed.', 10),
  ('other-home-services', 'CCTV and intercom', 'Camera placement, cabling, DVR configuration and intercom repair.', 20),
  ('other-home-services', 'RO and water purifier service', 'Filter and membrane replacement, TDS check and leak repair.', 30)
) as p(service_slug, title, description, display_order)
  on p.service_slug = s.slug;

-- ---------------------------------------------------------------------------
-- FAQs
-- ---------------------------------------------------------------------------
insert into public.faqs (category, question, answer, display_order) values
  ('Customers', 'How do I book a service?',
   'Open the customer app, choose the service you need, describe the problem and confirm your address and preferred time. The platform matches nearby professionals who hold the right verification for that trade, and you pick one from the shortlist.', 10),
  ('Customers', 'Will I know the price before work starts?',
   'You receive a quote before the job is confirmed. If parts or materials turn out to be needed, the professional raises a separate material request with an estimated cost, and nothing is purchased until you approve it.', 20),
  ('Customers', 'Can I track the job?',
   'Yes. You can see when the professional accepts, starts travelling and arrives, and the job status updates as the work progresses.', 30),
  ('Customers', 'What if I am not satisfied with the work?',
   'You can send the job back for rework instead of approving it, raise a dispute, or open a support ticket. If something was damaged, you can file a damage claim with evidence.', 40),
  ('Customers', 'How do I pay?',
   'Payment is made through the app once the work is approved. The amount covers the labour quoted plus any materials you approved.', 50),

  ('Workers', 'How do I join as a worker?',
   'Register through the worker app with your phone number, then submit your identity documents and any trade qualifications you hold. Your profile becomes eligible for jobs once the required verifications are approved.', 10),
  ('Workers', 'What documents do I need?',
   'A government identity document is required for every trade, along with a background check. Trades involving electrical and refrigerant work additionally require a trade qualification such as an ITI certificate or diploma. An RPL skill certificate can be submitted where you have one.', 20),
  ('Workers', 'How long does verification take?',
   'Each submission is reviewed by a person, not automatically. The time depends on the document type and whether an external check is involved. You can see the status of every submission in the app, including anything that needs correcting.', 30),
  ('Workers', 'When do I get paid?',
   'Completed jobs credit your wallet after the customer payment is confirmed by the payment gateway. You can request a payout from your wallet balance once it clears the holding period.', 40),
  ('Workers', 'What if I do not have a formal certificate?',
   'Some trades do not require one. Where a trade does, Recognition of Prior Learning assessment is the route for experienced workers without formal certification.', 50),

  ('Verification', 'What does a verified badge mean?',
   'Each badge refers to one specific check that was completed and is still current. Identity verified means a government document was checked. Qualification verified means a trade certificate was checked. The badges shown on a profile are exactly the checks that were passed, and nothing is implied beyond them.', 10),
  ('Verification', 'Does every worker have every verification?',
   'No. Identity and background verification are required for all trades. Qualification and skill verification apply where the trade requires them. A profile shows only the checks that worker actually holds.', 20),
  ('Verification', 'Do verifications expire?',
   'Yes. Background checks and time-limited certificates carry an expiry date, and the badge stops applying when they lapse until the check is renewed.', 30),

  ('Bookings', 'Can I cancel a booking?',
   'Yes. Cancellation is available until work begins, and a reason is recorded. Charges may apply depending on how far the job had progressed.', 10),
  ('Bookings', 'What is the arrival code?',
   'A short code you share with the professional when they arrive. It confirms the right person reached the right address before work starts.', 20),

  ('Payments', 'Is my payment secure?',
   'Payments are processed by a payment gateway. The platform records a payment as successful only after the gateway confirms it through a verified webhook, never on the word of the app.', 10),
  ('Payments', 'How are refunds handled?',
   'Refunds are reviewed and issued by the operations team back to the original payment method. You can raise a refund request through support.', 20),

  ('Materials', 'Who buys the materials?',
   'The professional buys them after you approve the estimate. The actual cost with a receipt is recorded against the job, and that is what gets billed.', 10),
  ('Materials', 'What if the actual cost differs from the estimate?',
   'The actual cost is recorded with the receipt. Where it exceeds the approved estimate, the difference is reviewed before it is billed.', 20),

  ('Safety', 'How are workers screened?',
   'Every worker completes identity verification and a background check before becoming eligible for jobs. Trades that carry more risk additionally require a qualification on file.', 10),
  ('Safety', 'What happens if something is damaged?',
   'File a damage claim with photographs and a description. A person reviews the claim and the job evidence. Claims are never approved or rejected automatically.', 20),

  ('Claims', 'How long does a claim take?',
   'A claim is acknowledged when submitted and then reviewed by the trust and safety team. If more information is needed you are asked for it directly, and the outcome with its reasoning is recorded on the claim.', 10),

  ('Insurance', 'Are workers insured?',
   'Where a worker holds a policy, the policy record and its validity are shown on their profile. The platform is not an insurer: coverage and any payout decision rest with the insurance provider, and the claim status on this platform is separate from the provider decision.', 10),

  ('Account', 'How do I delete my account?',
   'Contact support from the app or the contact page. Account deletion is subject to retention obligations on completed bookings, payments and any open claim.', 10),
  ('Account', 'How is my personal data used?',
   'The privacy policy sets out what is collected and why. Identity documents are stored privately, are never shown on the public website, and are accessible only to authorised staff for verification.', 20);
