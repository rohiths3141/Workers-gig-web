/// The curated vocabulary the on-device matcher scores against.
///
/// The service catalogue in the database is written for a customer reading a
/// listing page: "Wiring, switchboards, fans, lighting and power faults." It
/// is not written for someone typing "bijli nahi aa rahi" or "geyser se paani
/// tapak raha hai" at ten at night. This file is the bridge — the words
/// people actually use for a trade, including Hinglish and the regional
/// English that a catalogue description never contains.
///
/// Terms are keyed by the service *slug*, which is stable in the database
/// (`public.services.slug`, unique, seeded in migration 0012). Anything not
/// covered here still matches through the catalogue-derived index, which is
/// built from the live rows — so a service added tomorrow is matchable today,
/// just with less vocabulary behind it.
library;

/// A term shared by several trades is weaker evidence than a term owned by
/// one. "water" appears under plumbing, AC and appliances; "geyser" appears
/// under exactly one. The lexicon weights them accordingly, so "water" never
/// decides a match on its own.
class ServiceLexicon {
  ServiceLexicon._(this._termsBySlug, this._slugsByTerm);

  /// The vocabulary this app ships with.
  factory ServiceLexicon.builtIn() => _builtIn ??= ServiceLexicon.from(_terms);

  /// Builds a lexicon from an arbitrary term map. Used by tests to check the
  /// weighting rules without depending on the shipped vocabulary.
  factory ServiceLexicon.from(Map<String, Set<String>> termsBySlug) {
    final slugsByTerm = <String, Set<String>>{};
    for (final entry in termsBySlug.entries) {
      for (final term in entry.value) {
        slugsByTerm.putIfAbsent(term, () => <String>{}).add(entry.key);
      }
    }
    return ServiceLexicon._(
      Map.unmodifiable(termsBySlug),
      Map.unmodifiable(slugsByTerm),
    );
  }

  static ServiceLexicon? _builtIn;

  final Map<String, Set<String>> _termsBySlug;
  final Map<String, Set<String>> _slugsByTerm;

  /// Single-word terms for [slug].
  Set<String> wordsFor(String slug) =>
      _termsBySlug[slug]?.where((t) => !t.contains(' ')).toSet() ?? const {};

  /// Multi-word terms for [slug], longest first so "water heater" is tried
  /// before "water".
  List<String> phrasesFor(String slug) {
    final phrases =
        _termsBySlug[slug]?.where((t) => t.contains(' ')).toList() ?? [];
    phrases.sort((a, b) => b.length.compareTo(a.length));
    return phrases;
  }

  bool get isEmpty => _termsBySlug.isEmpty;

  /// How much a match on [term] is worth: 1.0 when only one trade claims it,
  /// falling off as more do.
  double weightOf(String term) {
    final owners = _slugsByTerm[term]?.length ?? 0;
    if (owners == 0) return 0.0;
    return 1.0 / owners;
  }

  /// Every slug this lexicon has vocabulary for.
  Iterable<String> get slugs => _termsBySlug.keys;

  // -------------------------------------------------------------------------
  // The vocabulary itself.
  //
  // A term appearing under two slugs is not a mistake — it is the point.
  // "compressor" genuinely belongs to both AC and refrigeration work, and
  // weightOf() makes it count for half under each rather than forcing a
  // guess at author time.
  // -------------------------------------------------------------------------
  static const _terms = <String, Set<String>>{
    'electrical': {
      'electrician', 'electric', 'electrical', 'electricity', 'bijli',
      'wire', 'wires', 'wiring', 'rewiring', 'cable', 'cabling',
      'switch', 'switches', 'switchboard', 'switchbox', 'socket', 'sockets',
      'plug', 'plugpoint', 'holder', 'extension board',
      'mcb', 'breaker', 'fuse', 'trip', 'tripping', 'tripped',
      'short circuit', 'shortcircuit', 'sparking', 'spark', 'sparks',
      'current', 'voltage', 'power cut', 'powercut', 'no power', 'no current',
      'earthing', 'phase', 'neutral', 'meter', 'submeter',
      'fan', 'ceiling fan', 'exhaust fan', 'pankha', 'regulator',
      'light', 'lights', 'lighting', 'bulb', 'tubelight', 'tube light',
      'chandelier', 'led', 'lamp', 'false ceiling light',
      'inverter', 'stabiliser', 'stabilizer', 'ups', 'changeover',
      'doorbell', 'bell', 'shock', 'electric shock', 'not switching on',
    },
    'plumbing': {
      'plumber', 'plumbing', 'pipe', 'pipes', 'pipeline', 'plumbar',
      'tap', 'taps', 'nal', 'faucet', 'mixer tap', 'shower', 'showerhead',
      'leak', 'leaks', 'leaking', 'leakage', 'drip', 'dripping', 'tapak',
      'seepage', 'overflow', 'overflowing', 'burst pipe',
      'drain', 'drainage', 'drain pipe', 'nali', 'gutter', 'sewage', 'sewer',
      'block', 'blocked', 'blockage', 'clog', 'clogged', 'choke', 'choked',
      'jam', 'jammed', 'backflow',
      'sink', 'washbasin', 'basin', 'wash basin', 'kitchen sink',
      'toilet', 'commode', 'wc', 'flush', 'flush tank', 'cistern', 'bathroom',
      'health faucet', 'jet spray', 'bidet',
      'tank', 'overhead tank', 'water tank', 'sump', 'motor', 'water motor',
      'pump', 'water pump', 'borewell', 'float valve', 'valve',
      'water supply', 'no water', 'water pressure', 'low pressure', 'paani',
    },
    'ac-service': {
      'ac', 'acs', 'air conditioner', 'airconditioner', 'air conditioning',
      'aircon', 'conditioner', 'split ac', 'window ac', 'split unit',
      'indoor unit', 'outdoor unit', 'cassette ac', 'tonnage', 'ton ac',
      'cooling', 'not cooling', 'no cooling', 'cooling less', 'low cooling',
      'not cold', 'blowing hot air', 'hot air',
      'gas refill', 'gas top up', 'gas leak', 'refrigerant', 'freon',
      'ac service', 'ac servicing', 'ac repair', 'ac installation',
      'ac not working', 'ac gas', 'ac cleaning', 'jet service',
      'compressor', 'condenser', 'evaporator', 'coil', 'blower', 'fin',
      'copper pipe', 'drain pipe blocked', 'ice formation', 'icing',
      'swing', 'remote not working', 'ac remote',
    },
    'appliance-repair': {
      'appliance', 'appliances',
      'washing machine', 'washingmachine', 'washer', 'front load', 'top load',
      'not draining', 'not spinning', 'spin', 'drum',
      'fridge', 'refrigerator', 'freezer', 'deep freezer', 'double door',
      // A refrigerator cools, and half the people who say "not cooling"
      // mean one. Claiming the word for air conditioning alone sent every
      // warm fridge to an AC technician.
      'cooling', 'not cooling', 'not cold', 'defrost', 'thermostat',
      'compressor',
      'geyser', 'water heater', 'immersion rod', 'not heating', 'no hot water',
      'heating element', 'heater',
      'microwave', 'oven', 'otg', 'magnetron', 'grill',
      'chimney', 'chimney suction', 'suction', 'hob',
      'dishwasher', 'mixer grinder', 'grinder', 'induction', 'induction stove',
      'toaster', 'kettle', 'iron', 'vacuum cleaner',
      'television', 'tv not working', 'led tv',
      'not starting', 'not turning on', 'making noise', 'noise',
    },
    'carpentry': {
      'carpenter', 'carpentry', 'wood', 'wooden', 'plywood', 'laminate',
      'furniture', 'table', 'chair', 'bed', 'cot', 'sofa frame', 'shelf',
      'shelves', 'shelving', 'rack', 'bookshelf',
      'cupboard', 'wardrobe', 'almirah', 'drawer', 'drawers', 'cabinet',
      'modular kitchen', 'modular', 'partition', 'false ceiling wood',
      'door', 'doors', 'door frame', 'darwaza', 'window frame',
      'hinge', 'hinges', 'kabza', 'latch', 'handle', 'knob',
      'lock', 'locks', 'lock repair', 'key stuck', 'not closing',
      'not aligning', 'alignment', 'creaking', 'broken joint', 'assembly',
      'flat pack', 'polish', 'veneer', 'carpenter work',
    },
    'painting': {
      'paint', 'paints', 'painting', 'painter', 'repaint', 'repainting',
      'whitewash', 'white wash', 'distemper', 'emulsion', 'enamel',
      'putty', 'primer', 'undercoat', 'topcoat', 'coat',
      'texture', 'stencil', 'accent wall', 'feature wall', 'wallpaper',
      'wall', 'walls', 'ceiling paint', 'interior painting',
      'exterior painting', 'touch up', 'touchup',
      'damp', 'dampness', 'damp patch', 'seepage', 'moisture',
      'peeling', 'flaking', 'chipping', 'blistering', 'crack', 'cracks',
      'waterproofing', 'waterproof', 'plaster', 'pop', 'shade card', 'colour',
    },
    'cleaning': {
      'clean', 'cleaning', 'cleaner', 'deep cleaning', 'deep clean',
      'housekeeping', 'safai', 'maid service', 'sanitise', 'sanitize',
      'dirty', 'dust', 'dusty', 'dirt', 'grime', 'stain', 'stains',
      'grease', 'greasy', 'degreasing', 'oil stain',
      'mopping', 'sweeping', 'scrubbing', 'vacuuming', 'shampooing',
      'sofa cleaning', 'carpet cleaning', 'upholstery', 'mattress cleaning',
      'kitchen cleaning', 'bathroom cleaning', 'toilet cleaning',
      'descaling', 'tile cleaning', 'floor cleaning', 'window cleaning',
      'post renovation', 'move in cleaning', 'move out cleaning',
      'spring cleaning', 'full home cleaning',
    },
    'other-home-services': {
      'handyman', 'odd job', 'odd jobs', 'general work', 'misc work',
      'pest', 'pest control', 'cockroach', 'cockroaches', 'kitchen pest',
      'termite', 'termites', 'deemak', 'bedbug', 'bed bugs', 'khatmal',
      'rodent', 'rat', 'rats', 'mice', 'mosquito', 'mosquitoes', 'ants',
      'lizard', 'fumigation', 'spray treatment',
      'cctv', 'camera', 'security camera', 'dvr', 'nvr', 'surveillance',
      'intercom', 'video door phone', 'doorphone',
      'ro', 'ro service', 'water purifier', 'purifier', 'aquaguard',
      'membrane', 'filter change', 'tds', 'uv filter',
      'gas stove', 'stove', 'burner', 'gas leak smell', 'lpg',
      'curtain rod', 'tv mount', 'wall mount', 'drilling', 'drill',
      'bracket', 'hanging', 'mirror fitting',
    },
  };
}
