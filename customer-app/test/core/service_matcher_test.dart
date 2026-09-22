import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_customer/core/nlu/keyword_service_matcher.dart';
import 'package:wervexa_customer/core/nlu/service_lexicon.dart';
import 'package:wervexa_customer/domain/entities/service_category.dart';
import 'package:wervexa_customer/domain/entities/service_match.dart';
import 'package:wervexa_customer/domain/entities/service_problem.dart';

import '../fixtures/catalogue_rows.dart';

/// The assistant's whole value is that it picks the right trade from a
/// sentence a customer wrote without thinking about categories. Every case
/// below is something someone would plausibly type at ten at night with a
/// bucket under a pipe.
///
/// The cost of the two failure modes is not symmetric. Sending a leaking
/// geyser to a painter wastes a visit, a refund and the customer's evening.
/// Asking one clarifying question costs a tap. So the matcher is tested not
/// only on what it gets right, but on whether it declines to guess when it
/// should.
void main() {
  late KeywordServiceMatcher matcher;

  setUp(() => matcher = KeywordServiceMatcher());

  ServiceMatchResult ask(String message) => matcher.match(
        message,
        services: catalogueServices,
        problems: catalogueProblems,
      );

  /// Asserts the matcher picked [slug] and was sure enough to act on it.
  void expectConfident(String message, String slug) {
    final result = ask(message);
    expect(
      result.outcome,
      MatchOutcome.confident,
      reason: '"$message" should have been placed confidently, '
          'but came back as ${result.outcome.name}'
          '${result.best == null ? '' : ' (best: ${result.best!.service.slug}, '
              'confidence ${result.best!.confidence.toStringAsFixed(2)})'}',
    );
    expect(
      result.best!.service.slug,
      slug,
      reason: '"$message" went to ${result.best!.service.name}',
    );
  }

  group('The trade a customer describes is the trade they get', () {
    test('plumbing, in the words people use for it', () {
      expectConfident('water is leaking under my sink', 'plumbing');
      expectConfident('the tap keeps dripping', 'plumbing');
      expectConfident('my washbasin is blocked', 'plumbing');
      expectConfident('flush tank is not working', 'plumbing');
      expectConfident('need a plumber', 'plumbing');
    });

    test('electrical', () {
      expectConfident('the mcb keeps tripping', 'electrical');
      expectConfident('switchboard is sparking', 'electrical');
      expectConfident('ceiling fan is not working', 'electrical');
      expectConfident('need an electrician for new wiring', 'electrical');
      expectConfident('inverter installation', 'electrical');
    });

    test('air conditioning', () {
      expectConfident('ac is not cooling', 'ac-service');
      expectConfident('a/c needs gas refill', 'ac-service');
      expectConfident('air conditioner servicing', 'ac-service');
      expectConfident('split ac installation', 'ac-service');
    });

    test('appliances', () {
      expectConfident('my geyser is not heating', 'appliance-repair');
      expectConfident('washing machine is not draining', 'appliance-repair');
      expectConfident('fridge is not cooling', 'appliance-repair');
      expectConfident('microwave stopped working', 'appliance-repair');
    });

    test('carpentry', () {
      expectConfident('the bedroom door is not closing', 'carpentry');
      expectConfident('need a carpenter for a broken drawer', 'carpentry');
      expectConfident('cupboard hinge is broken', 'carpentry');
    });

    test('painting', () {
      expectConfident('damp patches on the bedroom wall', 'painting');
      expectConfident('want to repaint the whole house', 'painting');
      expectConfident('paint is peeling off', 'painting');
    });

    test('cleaning', () {
      expectConfident('need deep cleaning before we move in', 'cleaning');
      expectConfident('sofa shampooing', 'cleaning');
      expectConfident('kitchen is very greasy', 'cleaning');
    });

    test('everything that does not fit a single trade', () {
      expectConfident('cockroaches in the kitchen', 'other-home-services');
      expectConfident('want cctv camera installation', 'other-home-services');
      expectConfident('ro water purifier service', 'other-home-services');
    });
  });

  group('It survives how people actually type', () {
    test('Hinglish reaches the right trade', () {
      // The catalogue is written in English for a listing page. Nobody
      // describing a power cut at night types "power supply diagnostics".
      expectConfident('bijli nahi aa rahi', 'electrical');
      expectConfident('nal se paani tapak raha hai', 'plumbing');
      expectConfident('deemak lag gaya hai', 'other-home-services');
    });

    test('typos on long words still land', () {
      expectConfident('need a plumbar urgently', 'plumbing');
      expectConfident('refrigerater not cooling', 'appliance-repair');
    });

    test('case and punctuation are irrelevant', () {
      expectConfident('MY A.C. IS NOT COOLING!!!', 'ac-service');
      expectConfident("the geyser isn't heating", 'appliance-repair');
    });
  });

  group('It refuses to guess', () {
    test('a word two trades share does not decide on its own', () {
      // "seepage" is a plumbing symptom and a painting symptom in equal
      // measure. Picking one silently sends half these customers the wrong
      // professional, and they only find out when they arrive.
      final result = ask('seepage problem');

      expect(result.outcome, MatchOutcome.ambiguous);
      expect(
        result.candidates.map((c) => c.service.slug),
        containsAll(<String>['plumbing', 'painting']),
      );
    });

    test('an ambiguous answer still offers something to tap', () {
      final result = ask('seepage problem');
      expect(result.candidates, isNotEmpty);
      expect(result.candidates.length, lessThanOrEqualTo(3));
    });

    test('a message about nothing in the catalogue is not forced into it', () {
      final result = ask('I want to learn the guitar');
      expect(result.outcome, MatchOutcome.unmatched);
      expect(result.candidates, isEmpty);
    });

    test('a greeting is answered as a greeting', () {
      expect(ask('hi').outcome, MatchOutcome.greeting);
      expect(ask('hello there').outcome, MatchOutcome.greeting);
      expect(ask('Good morning sir').outcome, MatchOutcome.greeting);
    });

    test('a message with no problem in it asks for the problem', () {
      expect(ask('please help').outcome, MatchOutcome.tooVague);
      expect(ask('I need someone urgently').outcome, MatchOutcome.tooVague);
      expect(ask('   ').outcome, MatchOutcome.tooVague);
    });

    test('an empty catalogue is reported, not answered', () {
      // A failed catalogue fetch must never arrive as "no service fits your
      // problem" — that is a claim about the platform, not about the network.
      final result = matcher.match(
        'my tap is leaking',
        services: const [],
        problems: const [],
      );
      expect(result.outcome, MatchOutcome.unmatched);
    });
  });

  group('Two problems in one sentence are two jobs', () {
    test('different trades in one message are separated, not averaged', () {
      // Scored as one bag of words this looks like a tie between AC and
      // plumbing — the one answer that is wrong for both.
      final result = ask('my ac is not cooling and the kitchen tap is leaking');

      expect(result.outcome, MatchOutcome.multipleServices);
      expect(
        result.candidates.map((c) => c.service.slug),
        containsAll(<String>['ac-service', 'plumbing']),
      );
    });

    test('a comma separates them too', () {
      final result = ask('fan is not working, sofa needs shampooing');
      expect(result.outcome, MatchOutcome.multipleServices);
      expect(
        result.candidates.map((c) => c.service.slug),
        containsAll(<String>['electrical', 'cleaning']),
      );
    });

    test('one job described at length stays one job', () {
      // The conjunction here joins two symptoms of a single fault. Splitting
      // it would offer the customer two bookings for one broken machine.
      final result =
          ask('the washing machine is not draining and not spinning');
      expect(result.outcome, MatchOutcome.confident);
      expect(result.best!.service.slug, 'appliance-repair');
    });

    test('a trailing pleasantry is not a second job', () {
      final result = ask('my tap is leaking, please come today');
      expect(result.outcome, MatchOutcome.confident);
      expect(result.best!.service.slug, 'plumbing');
    });
  });

  group('What it hands back is usable', () {
    test('the customer words come back exactly as written', () {
      // These are what goes into the service request. A normalised
      // paraphrase would put words in the customer's mouth.
      const written = 'Water is Leaking under my SINK!';
      expect(ask(written).query, written);
    });

    test('it names the catalogue problem when it recognises one', () {
      final result = ask('my geyser is not heating');
      expect(result.best!.closestProblem?.title, 'Geyser not heating');
    });

    test('it offers no problem when none actually fits', () {
      // A weak guess pre-filled into the request form becomes a statement
      // the customer never made.
      final result = ask('need an electrician');
      expect(result.best!.service.slug, 'electrical');
      expect(result.best!.closestProblem, isNull);
    });

    test('the matched words are the customer own, for checking', () {
      final result = ask('water is leaking under my sink');
      expect(result.best!.matchedTerms, isNotEmpty);
      expect(result.best!.matchedTerms, contains('leaking'));
      expect(result.best!.matchedTerms.length, lessThanOrEqualTo(4));
    });

    test('candidates come back ranked, best first', () {
      final result = ask('seepage problem');
      for (var i = 1; i < result.candidates.length; i++) {
        expect(
          result.candidates[i - 1].score,
          greaterThanOrEqualTo(result.candidates[i].score),
        );
      }
    });

    test('confidence stays inside its own bounds', () {
      for (final message in [
        'my tap is leaking',
        'seepage problem',
        'ac not cooling',
        'cockroaches',
      ]) {
        for (final candidate in ask(message).candidates) {
          expect(candidate.confidence, inInclusiveRange(0.0, 1.0),
              reason: 'confidence out of range for "$message"');
        }
      }
    });
  });

  group('It keeps working as the catalogue changes', () {
    test('a service added after this app shipped is still matchable', () {
      // The lexicon is fixed at build time; the catalogue is not. A service
      // the vocabulary has never heard of has to be reachable through its
      // own name and problem list, or every new trade is invisible until
      // the next app release.
      const gardening = ServiceCategory(
        id: 'svc-gardening',
        name: 'Gardening',
        slug: 'gardening',
        description: 'Lawn mowing, hedge trimming and garden maintenance.',
        iconUrl: 'leaf',
        sortOrder: 90,
      );
      const hedgeProblem = ServiceProblem(
        id: 'prb-hedge',
        serviceId: 'svc-gardening',
        title: 'Hedge trimming',
        description: 'Shaping and cutting back overgrown hedges and shrubs.',
      );

      final result = matcher.match(
        'my hedge needs trimming',
        services: [...catalogueServices, gardening],
        problems: [...catalogueProblems, hedgeProblem],
      );

      expect(result.outcome, MatchOutcome.confident);
      expect(result.best!.service.slug, 'gardening');
    });

    test('the index is rebuilt when the catalogue changes under it', () {
      // The index is cached between messages for speed. Caching it past a
      // catalogue change would answer today's question with yesterday's
      // services.
      expectConfident('my tap is leaking', 'plumbing');

      final shortened = catalogueServices
          .where((s) => s.slug != 'plumbing')
          .toList();
      final result = matcher.match(
        'my tap is leaking',
        services: shortened,
        problems: catalogueProblems
            .where((p) => p.serviceId != 'svc-plumbing')
            .toList(),
      );

      expect(result.best?.service.slug, isNot('plumbing'));
    });

    test('the same question gets the same answer every time', () {
      // Matching is a pure function of its inputs, so a disagreement about
      // a match can be reproduced in a test rather than argued about.
      final first = ask('washing machine not draining');
      final second = ask('washing machine not draining');
      final third = KeywordServiceMatcher().match(
        'washing machine not draining',
        services: catalogueServices,
        problems: catalogueProblems,
      );

      expect(first.best!.service.id, second.best!.service.id);
      expect(first.best!.score, second.best!.score);
      expect(first.best!.score, third.best!.score);
    });
  });

  group('Lexicon weighting', () {
    test('a term one trade owns outweighs a term four trades share', () {
      final lexicon = ServiceLexicon.from({
        'alpha': {'shared', 'exclusive'},
        'beta': {'shared'},
        'gamma': {'shared'},
        'delta': {'shared'},
      });

      expect(lexicon.weightOf('exclusive'), 1.0);
      expect(lexicon.weightOf('shared'), 0.25);
      expect(lexicon.weightOf('never-seen'), 0.0);
    });

    test('phrases are kept apart from words, longest phrase first', () {
      final lexicon = ServiceLexicon.from({
        'alpha': {'water', 'water heater', 'hot water heater'},
      });

      expect(lexicon.wordsFor('alpha'), {'water'});
      expect(lexicon.phrasesFor('alpha'),
          ['hot water heater', 'water heater']);
    });

    test('the shipped vocabulary covers every service in the catalogue', () {
      // A service with no curated vocabulary still works, but only through
      // catalogue copy — which is the weaker of the two signals. This is the
      // test that fails when someone adds a service and forgets the words.
      final lexicon = ServiceLexicon.builtIn();
      final uncovered = catalogueServices
          .map((s) => s.slug)
          .where((slug) => !lexicon.slugs.contains(slug))
          .toList();

      expect(uncovered, isEmpty,
          reason: 'No assistant vocabulary for: ${uncovered.join(', ')}');
    });
  });
}
