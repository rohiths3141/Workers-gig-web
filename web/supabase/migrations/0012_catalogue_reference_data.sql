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

-- Text values are dollar-quoted ($txt$...$txt$) so no apostrophe or quote in
-- the copy can end a string early, whatever tool this script is pasted into.
-- Every insert is idempotent, so re-running the file is safe.

insert into public.services
  (name, slug, short_description, description, icon_key, display_order, required_verifications, seo_title, seo_description)
values
  ('Electrical', 'electrical',
   $txt$Wiring, switchboards, fans, lighting and power faults.$txt$,
   $txt$Licensed electricians for household wiring faults, switchboard and MCB work, fan and light installation, inverter and stabiliser setup, and power supply diagnostics. Every electrician on the platform completes identity and background verification before taking jobs, and electrical trades additionally require a trade qualification on file.$txt$,
   'zap', 10,
   array['IDENTITY_KYC','BACKGROUND_CHECK','ITI_CERTIFICATE']::public.verification_type[],
   $txt$Electrician Services at Home | Verified Electricians$txt$,
   $txt$Book a verified electrician for wiring faults, switchboards, fans, lighting and power issues. Identity and qualification checked before the job.$txt$),
  ('Plumbing', 'plumbing',
   $txt$Leaks, blockages, taps, tanks and bathroom fittings.$txt$,
   $txt$Plumbers for leaking taps and pipes, blocked drains, flush tank and mixer repairs, water motor and overhead tank issues, and bathroom fitting installation. Material costs are quoted and approved by you before anything is bought.$txt$,
   'droplet', 20,
   array['IDENTITY_KYC','BACKGROUND_CHECK']::public.verification_type[],
   $txt$Plumber Services at Home | Verified Plumbers$txt$,
   $txt$Book a verified plumber for leaks, blocked drains, taps, tanks and bathroom fittings. Transparent pricing with material approval before purchase.$txt$),
  ($txt$AC Service$txt$, 'ac-service',
   $txt$Servicing, gas refill, installation and cooling faults.$txt$,
   $txt$Air conditioner technicians for periodic servicing, cooling performance problems, gas top-up, water leakage, PCB and sensor faults, and installation or relocation of split and window units. Technicians working on refrigerant handling hold a relevant trade qualification.$txt$,
   'wind', 30,
   array['IDENTITY_KYC','BACKGROUND_CHECK','ITI_CERTIFICATE']::public.verification_type[],
   $txt$AC Service and Repair at Home | Verified Technicians$txt$,
   $txt$Book verified AC technicians for servicing, gas refill, installation and cooling problems. Qualification and background checked.$txt$),
  ($txt$Appliance Repair$txt$, 'appliance-repair',
   $txt$Washing machines, refrigerators, microwaves and geysers.$txt$,
   $txt$Appliance technicians for washing machine, refrigerator, microwave, geyser, chimney and water purifier faults. Diagnosis first, then a quote you approve before any repair or part replacement goes ahead.$txt$,
   'washing-machine', 40,
   array['IDENTITY_KYC','BACKGROUND_CHECK']::public.verification_type[],
   $txt$Home Appliance Repair | Verified Technicians$txt$,
   $txt$Book verified technicians for washing machine, fridge, microwave and geyser repair. Diagnosis and quote before any work begins.$txt$),
  ('Carpentry', 'carpentry',
   $txt$Furniture repair, fittings, doors, locks and modular work.$txt$,
   $txt$Carpenters for furniture repair and assembly, door and window alignment, lock and hinge replacement, modular kitchen and wardrobe fittings, and custom shelving.$txt$,
   'hammer', 50,
   array['IDENTITY_KYC','BACKGROUND_CHECK']::public.verification_type[],
   $txt$Carpenter Services at Home | Verified Carpenters$txt$,
   $txt$Book a verified carpenter for furniture repair, door and lock work, and modular fittings.$txt$),
  ('Painting', 'painting',
   $txt$Interior and exterior painting, waterproofing and touch-ups.$txt$,
   $txt$Painters for full interior and exterior painting, damp and seepage treatment, waterproofing, texture and accent walls, and small touch-up work. Surface preparation and material quantity are agreed before the job starts.$txt$,
   'paintbrush', 60,
   array['IDENTITY_KYC','BACKGROUND_CHECK']::public.verification_type[],
   $txt$House Painting Services | Verified Painters$txt$,
   $txt$Book verified painters for interior and exterior painting, waterproofing and damp treatment.$txt$),
  ('Cleaning', 'cleaning',
   $txt$Deep cleaning for homes, kitchens, bathrooms and sofas.$txt$,
   $txt$Cleaning professionals for full home deep cleaning, kitchen degreasing, bathroom descaling, sofa and carpet shampooing, and post-renovation cleanup. Equipment and consumables are brought by the professional.$txt$,
   'sparkles', 70,
   array['IDENTITY_KYC','BACKGROUND_CHECK']::public.verification_type[],
   $txt$Home Deep Cleaning Services | Verified Professionals$txt$,
   $txt$Book verified cleaning professionals for home deep cleaning, kitchen, bathroom and sofa cleaning.$txt$),
  ($txt$Other Home Services$txt$, 'other-home-services',
   $txt$Pest control, CCTV, RO service and general handyman work.$txt$,
   $txt$Other verified home-service professionals for pest control, CCTV and intercom setup, RO and water purifier servicing, gas stove repair, and general handyman tasks that do not fit a single trade.$txt$,
   'wrench', 80,
   array['IDENTITY_KYC','BACKGROUND_CHECK']::public.verification_type[],
   $txt$Other Home Services | Verified Professionals$txt$,
   $txt$Book verified professionals for pest control, CCTV, RO servicing and general handyman work.$txt$)
on conflict (slug) do nothing;

-- ---------------------------------------------------------------------------
-- Common problems shown on each service detail page
-- ---------------------------------------------------------------------------
insert into public.service_problems (service_id, title, description, display_order)
select s.id, p.title, p.description, p.display_order
from public.services s
join (values
  ('electrical', $txt$Frequent MCB tripping$txt$, $txt$A breaker that trips repeatedly usually means an overloaded circuit or a short somewhere in the wiring.$txt$, 10),
  ('electrical', $txt$Switchboard or socket not working$txt$, $txt$Dead sockets, loose switches and sparking switchboards need the circuit isolated before any repair.$txt$, 20),
  ('electrical', $txt$Fan or light installation$txt$, $txt$Ceiling fan, chandelier, false-ceiling light and regulator fitting, including new wiring points.$txt$, 30),
  ('electrical', $txt$Inverter and stabiliser setup$txt$, $txt$Installation, battery connection and changeover wiring for home inverters.$txt$, 40),
  ('plumbing', $txt$Leaking tap or pipe$txt$, $txt$Dripping taps, joint leaks and wall seepage traced back to the failing section.$txt$, 10),
  ('plumbing', $txt$Blocked drain or washbasin$txt$, $txt$Kitchen sink, washbasin and floor trap blockages cleared without damaging the fitting.$txt$, 20),
  ('plumbing', $txt$Flush tank not working$txt$, $txt$Cistern refill, flush valve and float replacement for Indian and Western fittings.$txt$, 30),
  ('plumbing', $txt$Water motor or tank problem$txt$, $txt$Motor not pulling water, overhead tank overflow, and float valve replacement.$txt$, 40),
  ('ac-service', $txt$AC not cooling$txt$, $txt$Weak cooling is usually a dirty filter, a choked coil or low refrigerant. Diagnosis comes before any gas top-up.$txt$, 10),
  ('ac-service', $txt$Water leaking from indoor unit$txt$, $txt$A blocked drain pipe or a tilted indoor unit sends condensate into the room instead of outside.$txt$, 20),
  ('ac-service', $txt$Periodic service$txt$, $txt$Filter, coil and blower cleaning with drainage check, recommended before each summer.$txt$, 30),
  ('ac-service', $txt$Installation or relocation$txt$, $txt$Split and window unit installation, including copper piping, bracket and drain routing.$txt$, 40),
  ('appliance-repair', $txt$Washing machine not draining or spinning$txt$, $txt$Drain pump blockage, belt wear and lid-switch faults are the usual causes.$txt$, 10),
  ('appliance-repair', $txt$Refrigerator not cooling$txt$, $txt$Thermostat, compressor, gas and defrost faults diagnosed before a part is quoted.$txt$, 20),
  ('appliance-repair', $txt$Geyser not heating$txt$, $txt$Heating element, thermostat and safety cutout replacement, with the supply isolated first.$txt$, 30),
  ('appliance-repair', $txt$Microwave or chimney fault$txt$, $txt$Magnetron, control panel, suction and filter problems on kitchen appliances.$txt$, 40),
  ('carpentry', $txt$Door not closing or aligning$txt$, $txt$Hinge, frame and alignment correction for wooden and flush doors.$txt$, 10),
  ('carpentry', $txt$Furniture repair or assembly$txt$, $txt$Broken joints, drawer channels, hinges and flat-pack assembly.$txt$, 20),
  ('carpentry', $txt$Lock or handle replacement$txt$, $txt$Mortise, cylindrical and cupboard lock replacement.$txt$, 30),
  ('painting', $txt$Damp patches and peeling paint$txt$, $txt$Seepage has to be treated at the source before repainting, or it returns in months.$txt$, 10),
  ('painting', $txt$Full home repainting$txt$, $txt$Surface preparation, putty, primer and finish coats with material quantity agreed upfront.$txt$, 20),
  ('painting', $txt$Touch-up and single room$txt$, $txt$Small-area repainting matched to the existing shade.$txt$, 30),
  ('cleaning', $txt$Full home deep cleaning$txt$, $txt$Room-by-room cleaning including fans, grills, windows, floors and bathrooms.$txt$, 10),
  ('cleaning', $txt$Kitchen degreasing$txt$, $txt$Chimney, hob, tiles and cabinet cleaning to remove accumulated grease.$txt$, 20),
  ('cleaning', $txt$Sofa and carpet shampooing$txt$, $txt$Wet shampoo and vacuum extraction for upholstery and carpets.$txt$, 30),
  ('other-home-services', $txt$Pest control$txt$, $txt$Cockroach, termite, bedbug and general pest treatment with follow-up where needed.$txt$, 10),
  ('other-home-services', $txt$CCTV and intercom$txt$, $txt$Camera placement, cabling, DVR configuration and intercom repair.$txt$, 20),
  ('other-home-services', $txt$RO and water purifier service$txt$, $txt$Filter and membrane replacement, TDS check and leak repair.$txt$, 30)
) as p(service_slug, title, description, display_order)
  on p.service_slug = s.slug
where not exists (
  select 1 from public.service_problems existing
  where existing.service_id = s.id and existing.title = p.title
);

-- ---------------------------------------------------------------------------
-- FAQs
-- ---------------------------------------------------------------------------
insert into public.faqs (category, question, answer, display_order)
select v.category, v.question, v.answer, v.display_order
from (values
  ('Customers', $txt$How do I book a service?$txt$,
   $txt$Open the customer app, choose the service you need, describe the problem and confirm your address and preferred time. The platform matches nearby professionals who hold the right verification for that trade, and you pick one from the shortlist.$txt$, 10),
  ('Customers', $txt$Will I know the price before work starts?$txt$,
   $txt$You receive a quote before the job is confirmed. If parts or materials turn out to be needed, the professional raises a separate material request with an estimated cost, and nothing is purchased until you approve it.$txt$, 20),
  ('Customers', $txt$Can I track the job?$txt$,
   $txt$Yes. You can see when the professional accepts, starts travelling and arrives, and the job status updates as the work progresses.$txt$, 30),
  ('Customers', $txt$What if I am not satisfied with the work?$txt$,
   $txt$You can send the job back for rework instead of approving it, raise a dispute, or open a support ticket. If something was damaged, you can file a damage claim with evidence.$txt$, 40),
  ('Customers', $txt$How do I pay?$txt$,
   $txt$Payment is made through the app once the work is approved. The amount covers the labour quoted plus any materials you approved.$txt$, 50),
  ('Workers', $txt$How do I join as a worker?$txt$,
   $txt$Register through the worker app with your phone number, then submit your identity documents and any trade qualifications you hold. Your profile becomes eligible for jobs once the required verifications are approved.$txt$, 10),
  ('Workers', $txt$What documents do I need?$txt$,
   $txt$A government identity document is required for every trade, along with a background check. Trades involving electrical and refrigerant work additionally require a trade qualification such as an ITI certificate or diploma. An RPL skill certificate can be submitted where you have one.$txt$, 20),
  ('Workers', $txt$How long does verification take?$txt$,
   $txt$Each submission is reviewed by a person, not automatically. The time depends on the document type and whether an external check is involved. You can see the status of every submission in the app, including anything that needs correcting.$txt$, 30),
  ('Workers', $txt$When do I get paid?$txt$,
   $txt$Completed jobs credit your wallet after the customer payment is confirmed by the payment gateway. You can request a payout from your wallet balance once it clears the holding period.$txt$, 40),
  ('Workers', $txt$What if I do not have a formal certificate?$txt$,
   $txt$Some trades do not require one. Where a trade does, Recognition of Prior Learning assessment is the route for experienced workers without formal certification.$txt$, 50),
  ('Verification', $txt$What does a verified badge mean?$txt$,
   $txt$Each badge refers to one specific check that was completed and is still current. Identity verified means a government document was checked. Qualification verified means a trade certificate was checked. The badges shown on a profile are exactly the checks that were passed, and nothing is implied beyond them.$txt$, 10),
  ('Verification', $txt$Does every worker have every verification?$txt$,
   $txt$No. Identity and background verification are required for all trades. Qualification and skill verification apply where the trade requires them. A profile shows only the checks that worker actually holds.$txt$, 20),
  ('Verification', $txt$Do verifications expire?$txt$,
   $txt$Yes. Background checks and time-limited certificates carry an expiry date, and the badge stops applying when they lapse until the check is renewed.$txt$, 30),
  ('Bookings', $txt$Can I cancel a booking?$txt$,
   $txt$Yes. Cancellation is available until work begins, and a reason is recorded. Charges may apply depending on how far the job had progressed.$txt$, 10),
  ('Bookings', $txt$What is the arrival code?$txt$,
   $txt$A short code you share with the professional when they arrive. It confirms the right person reached the right address before work starts.$txt$, 20),
  ('Payments', $txt$Is my payment secure?$txt$,
   $txt$Payments are processed by a payment gateway. The platform records a payment as successful only after the gateway confirms it through a verified webhook, never on the word of the app.$txt$, 10),
  ('Payments', $txt$How are refunds handled?$txt$,
   $txt$Refunds are reviewed and issued by the operations team back to the original payment method. You can raise a refund request through support.$txt$, 20),
  ('Materials', $txt$Who buys the materials?$txt$,
   $txt$The professional buys them after you approve the estimate. The actual cost with a receipt is recorded against the job, and that is what gets billed.$txt$, 10),
  ('Materials', $txt$What if the actual cost differs from the estimate?$txt$,
   $txt$The actual cost is recorded with the receipt. Where it exceeds the approved estimate, the difference is reviewed before it is billed.$txt$, 20),
  ('Safety', $txt$How are workers screened?$txt$,
   $txt$Every worker completes identity verification and a background check before becoming eligible for jobs. Trades that carry more risk additionally require a qualification on file.$txt$, 10),
  ('Safety', $txt$What happens if something is damaged?$txt$,
   $txt$File a damage claim with photographs and a description. A person reviews the claim and the job evidence. Claims are never approved or rejected automatically.$txt$, 20),
  ('Claims', $txt$How long does a claim take?$txt$,
   $txt$A claim is acknowledged when submitted and then reviewed by the trust and safety team. If more information is needed you are asked for it directly, and the outcome with its reasoning is recorded on the claim.$txt$, 10),
  ('Insurance', $txt$Are workers insured?$txt$,
   $txt$Where a worker holds a policy, the policy record and its validity are shown on their profile. The platform is not an insurer: coverage and any payout decision rest with the insurance provider, and the claim status on this platform is separate from the provider decision.$txt$, 10),
  ('Account', $txt$How do I delete my account?$txt$,
   $txt$Contact support from the app or the contact page. Account deletion is subject to retention obligations on completed bookings, payments and any open claim.$txt$, 10),
  ('Account', $txt$How is my personal data used?$txt$,
   $txt$The privacy policy sets out what is collected and why. Identity documents are stored privately, are never shown on the public website, and are accessible only to authorised staff for verification.$txt$, 20)
) as v(category, question, answer, display_order)
where not exists (
  select 1 from public.faqs f
  where f.service_id is null and f.question = v.question
);
