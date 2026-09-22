import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_customer/core/nlu/text_normalizer.dart';

/// The same problem, typed four different ways, has to reach the matcher as
/// the same evidence. Everything below is a phrasing a customer actually
/// uses; none of it is hypothetical.
void main() {
  group('Normalisation', () {
    test('"a/c" and "A.C." are the same word as "ac"', () {
      // Punctuation-stripping alone shatters "a/c" into "a" and "c", and
      // both are then dropped as noise — the message loses its subject.
      expect(normalizeText('A/C not cooling').tokens, ['ac', 'not', 'cooling']);
      expect(normalizeText('my a.c. is dead').tokens.first, 'my');
      expect(normalizeText('my a.c. is dead').tokens, contains('ac'));
    });

    test('contractions expand instead of splitting', () {
      expect(normalizeText("fridge isn't cooling").tokens,
          ['fridge', 'is', 'not', 'cooling']);
      expect(normalizeText("geyser doesn't heat").tokens,
          ['geyser', 'does', 'not', 'heat']);
    });

    test('punctuation and repeated spacing are removed', () {
      expect(normalizeText('  TAP   LEAKING!!!  ').normalized, 'tap leaking');
    });

    test('digits survive, because "1.5 ton ac" describes a real unit', () {
      expect(normalizeText('1.5 ton ac').tokens, ['1', '5', 'ton', 'ac']);
    });

    test('the raw message is kept exactly as written', () {
      // What the customer typed is what goes into the service request. A
      // normalised, lowercased paraphrase is not their words.
      const written = 'Water is Leaking under my SINK!';
      expect(normalizeText(written).raw, written);
    });
  });

  group('Content extraction', () {
    test('function words are dropped but the nouns survive', () {
      expect(normalizeText('the tap in my kitchen is leaking').contentTokens,
          ['tap', 'kitchen', 'leaking']);
    });

    test('bigrams are built before function words are dropped', () {
      // "not cooling" and "not heating" are the strongest signals a customer
      // gives. Dropping "not" first would destroy both.
      expect(normalizeText('ac not cooling').bigrams,
          ['ac not', 'not cooling']);
    });

    test('a greeting is recognised as an opener, not a problem', () {
      expect(normalizeText('hi').isGreetingOnly, isTrue);
      expect(normalizeText('Hello there').isGreetingOnly, isTrue);
      expect(normalizeText('hi my tap is leaking').isGreetingOnly, isFalse);
    });

    test('a message with nothing to act on is flagged as such', () {
      // Answering these with a service would be a guess dressed as an answer.
      expect(normalizeText('please help').hasNoContent, isTrue);
      expect(normalizeText('I need someone urgently').hasNoContent, isTrue);
      expect(normalizeText('??').hasNoContent, isTrue);
      expect(normalizeText('my tap drips').hasNoContent, isFalse);
    });
  });

  group('Clause splitting', () {
    test('a conjunction separates two jobs', () {
      expect(
        splitClauses('my ac is not cooling and the tap is leaking'),
        ['my ac is not cooling', 'the tap is leaking'],
      );
    });

    test('commas and full stops separate too', () {
      expect(splitClauses('fan not working, switch is sparking').length, 2);
      expect(splitClauses('Sofa needs cleaning. Also the door creaks.').length, 2);
    });

    test('a single statement stays a single clause', () {
      expect(splitClauses('the geyser is not heating').length, 1);
    });

    test('an empty message still yields one clause, not none', () {
      expect(splitClauses('   ').length, 1);
    });
  });

  group('Token similarity', () {
    test('identical tokens match completely', () {
      expect(tokenSimilarity('geyser', 'geyser'), 1.0);
    });

    test('inflection matches through the shared prefix', () {
      expect(tokenSimilarity('cooling', 'cool'), 0.8);
      expect(tokenSimilarity('leaking', 'leak'), 0.8);
      expect(tokenSimilarity('painting', 'paint'), 0.8);
    });

    test('a typo on a long word still matches', () {
      expect(tokenSimilarity('plumbar', 'plumber'), 0.6);
      expect(tokenSimilarity('refrigerater', 'refrigerator'), greaterThan(0.0));
    });

    test('short words get no edit tolerance at all', () {
      // "tap" and "top", "fan" and "can", "ac" and "as" are each one edit
      // apart and mean entirely different jobs. Tolerance here would send a
      // leaking tap to whoever owns the word "top".
      expect(tokenSimilarity('tap', 'top'), 0.0);
      expect(tokenSimilarity('fan', 'can'), 0.0);
      expect(tokenSimilarity('ac', 'as'), 0.0);
    });

    test('unrelated words do not match', () {
      expect(tokenSimilarity('guitar', 'geyser'), 0.0);
      expect(tokenSimilarity('plumber', 'painter'), 0.0);
    });

    test('a long shared prefix still needs the lengths to be close', () {
      // "water" is a prefix of "waterproofing", but they are not the same
      // subject and must not reinforce each other.
      expect(tokenSimilarity('water', 'waterproofing'), 0.0);
    });
  });

  group('Edit distance', () {
    test('counts substitutions, insertions and deletions', () {
      expect(editDistance('tap', 'tap'), 0);
      expect(editDistance('tap', 'tip'), 1);
      expect(editDistance('geyser', 'geysar'), 1);
      expect(editDistance('ac', 'acs'), 1);
    });

    test('gives up once the ceiling is passed rather than scanning on', () {
      expect(editDistance('a', 'zzzzzzzzzz', ceiling: 2), greaterThan(2));
      expect(editDistance('cleaning', 'plumbing', ceiling: 2), greaterThan(2));
    });

    test('an empty side costs the length of the other', () {
      expect(editDistance('', 'tap'), 3);
      expect(editDistance('tap', ''), 3);
    });
  });
}
