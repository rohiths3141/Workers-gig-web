import 'package:wervexa_customer/domain/entities/service_category.dart';
import 'package:wervexa_customer/domain/entities/service_problem.dart';

/// The platform's real service catalogue, as seeded by migration
/// `0012_catalogue_reference_data.sql`.
///
/// This is reference data, not invented test content: these are the eight
/// services the platform launches with and the problem list each one shows.
/// The matcher is tested against the catalogue it will actually meet, so a
/// test passing here means the behaviour holds in the app.
///
/// `description` carries each service's `short_description`, because that is
/// what [ServiceCategory.fromJson] prefers when both columns are selected.
final catalogueServices = <ServiceCategory>[
  const ServiceCategory(
    id: 'svc-electrical',
    name: 'Electrical',
    slug: 'electrical',
    description: 'Wiring, switchboards, fans, lighting and power faults.',
    iconUrl: 'zap',
    sortOrder: 10,
  ),
  const ServiceCategory(
    id: 'svc-plumbing',
    name: 'Plumbing',
    slug: 'plumbing',
    description: 'Leaks, blockages, taps, tanks and bathroom fittings.',
    iconUrl: 'droplet',
    sortOrder: 20,
  ),
  const ServiceCategory(
    id: 'svc-ac',
    name: 'AC Service',
    slug: 'ac-service',
    description: 'Servicing, gas refill, installation and cooling faults.',
    iconUrl: 'wind',
    sortOrder: 30,
  ),
  const ServiceCategory(
    id: 'svc-appliance',
    name: 'Appliance Repair',
    slug: 'appliance-repair',
    description: 'Washing machines, refrigerators, microwaves and geysers.',
    iconUrl: 'washing-machine',
    sortOrder: 40,
  ),
  const ServiceCategory(
    id: 'svc-carpentry',
    name: 'Carpentry',
    slug: 'carpentry',
    description: 'Furniture repair, fittings, doors, locks and modular work.',
    iconUrl: 'hammer',
    sortOrder: 50,
  ),
  const ServiceCategory(
    id: 'svc-painting',
    name: 'Painting',
    slug: 'painting',
    description: 'Interior and exterior painting, waterproofing and touch-ups.',
    iconUrl: 'paintbrush',
    sortOrder: 60,
  ),
  const ServiceCategory(
    id: 'svc-cleaning',
    name: 'Cleaning',
    slug: 'cleaning',
    description: 'Deep cleaning for homes, kitchens, bathrooms and sofas.',
    iconUrl: 'sparkles',
    sortOrder: 70,
  ),
  const ServiceCategory(
    id: 'svc-other',
    name: 'Other Home Services',
    slug: 'other-home-services',
    description: 'Pest control, CCTV, RO service and general handyman work.',
    iconUrl: 'wrench',
    sortOrder: 80,
  ),
];

final catalogueProblems = <ServiceProblem>[
  _problem('svc-electrical', 'Frequent MCB tripping',
      'A breaker that trips repeatedly usually means an overloaded circuit or a short somewhere in the wiring.'),
  _problem('svc-electrical', 'Switchboard or socket not working',
      'Dead sockets, loose switches and sparking switchboards need the circuit isolated before any repair.'),
  _problem('svc-electrical', 'Fan or light installation',
      'Ceiling fan, chandelier, false-ceiling light and regulator fitting, including new wiring points.'),
  _problem('svc-electrical', 'Inverter and stabiliser setup',
      'Installation, battery connection and changeover wiring for home inverters.'),
  _problem('svc-plumbing', 'Leaking tap or pipe',
      'Dripping taps, joint leaks and wall seepage traced back to the failing section.'),
  _problem('svc-plumbing', 'Blocked drain or washbasin',
      'Kitchen sink, washbasin and floor trap blockages cleared without damaging the fitting.'),
  _problem('svc-plumbing', 'Flush tank not working',
      'Cistern refill, flush valve and float replacement for Indian and Western fittings.'),
  _problem('svc-plumbing', 'Water motor or tank problem',
      'Motor not pulling water, overhead tank overflow, and float valve replacement.'),
  _problem('svc-ac', 'AC not cooling',
      'Weak cooling is usually a dirty filter, a choked coil or low refrigerant. Diagnosis comes before any gas top-up.'),
  _problem('svc-ac', 'Water leaking from indoor unit',
      'A blocked drain pipe or a tilted indoor unit sends condensate into the room instead of outside.'),
  _problem('svc-ac', 'Periodic service',
      'Filter, coil and blower cleaning with drainage check, recommended before each summer.'),
  _problem('svc-ac', 'Installation or relocation',
      'Split and window unit installation, including copper piping, bracket and drain routing.'),
  _problem('svc-appliance', 'Washing machine not draining or spinning',
      'Drain pump blockage, belt wear and lid-switch faults are the usual causes.'),
  _problem('svc-appliance', 'Refrigerator not cooling',
      'Thermostat, compressor, gas and defrost faults diagnosed before a part is quoted.'),
  _problem('svc-appliance', 'Geyser not heating',
      'Heating element, thermostat and safety cutout replacement, with the supply isolated first.'),
  _problem('svc-appliance', 'Microwave or chimney fault',
      'Magnetron, control panel, suction and filter problems on kitchen appliances.'),
  _problem('svc-carpentry', 'Door not closing or aligning',
      'Hinge, frame and alignment correction for wooden and flush doors.'),
  _problem('svc-carpentry', 'Furniture repair or assembly',
      'Broken joints, drawer channels, hinges and flat-pack assembly.'),
  _problem('svc-carpentry', 'Lock or handle replacement',
      'Mortise, cylindrical and cupboard lock replacement.'),
  _problem('svc-painting', 'Damp patches and peeling paint',
      'Seepage has to be treated at the source before repainting, or it returns in months.'),
  _problem('svc-painting', 'Full home repainting',
      'Surface preparation, putty, primer and finish coats with material quantity agreed upfront.'),
  _problem('svc-painting', 'Touch-up and single room',
      'Small-area repainting matched to the existing shade.'),
  _problem('svc-cleaning', 'Full home deep cleaning',
      'Room-by-room cleaning including fans, grills, windows, floors and bathrooms.'),
  _problem('svc-cleaning', 'Kitchen degreasing',
      'Chimney, hob, tiles and cabinet cleaning to remove accumulated grease.'),
  _problem('svc-cleaning', 'Sofa and carpet shampooing',
      'Wet shampoo and vacuum extraction for upholstery and carpets.'),
  _problem('svc-other', 'Pest control',
      'Cockroach, termite, bedbug and general pest treatment with follow-up where needed.'),
  _problem('svc-other', 'CCTV and intercom',
      'Camera placement, cabling, DVR configuration and intercom repair.'),
  _problem('svc-other', 'RO and water purifier service',
      'Filter and membrane replacement, TDS check and leak repair.'),
];

int _problemCounter = 0;

ServiceProblem _problem(String serviceId, String title, String description) =>
    ServiceProblem(
      id: 'prb-${_problemCounter++}',
      serviceId: serviceId,
      title: title,
      description: description,
    );
