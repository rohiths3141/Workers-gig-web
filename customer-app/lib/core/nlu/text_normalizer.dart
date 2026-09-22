/// Text preparation for the on-device service matcher.
///
/// Everything here is deterministic and offline. A customer describing a
/// problem writes "AC is not cooling", "a/c not cooling!!", "ac nt cooling"
/// and "my A.C. isn't cooling" — all four have to reach the matcher as the
/// same evidence, or the same problem gets a different answer depending on
/// how someone happens to type.
library;

import 'dart:math' as math;

/// Words that carry no signal about which trade is needed.
///
/// Bigrams are built *before* this list is applied, because "not cooling"
/// and "not heating" are two of the strongest signals a customer ever gives
/// and both would be destroyed by dropping "not" first.
const _stopWords = <String>{
  // English function words
  'a', 'an', 'the', 'is', 'are', 'was', 'were', 'am', 'be', 'been', 'being',
  'i', 'me', 'my', 'mine', 'we', 'our', 'ours', 'you', 'your', 'yours',
  'it', 'its', 'this', 'that', 'these', 'those', 'there', 'here',
  'in', 'on', 'at', 'to', 'of', 'for', 'from', 'with', 'by', 'into', 'onto',
  'and', 'or', 'but', 'so', 'then', 'than', 'as', 'if', 'when', 'while',
  'do', 'does', 'did', 'done', 'has', 'have', 'had', 'get', 'got', 'getting',
  'can', 'could', 'would', 'should', 'will', 'shall', 'may', 'might', 'must',
  'some', 'any', 'all', 'very', 'too', 'just', 'also', 'again', 'still',
  'please', 'pls', 'plz', 'kindly', 'thanks', 'thank', 'sir', 'madam', 'ji',
  'need', 'needs', 'needed', 'want', 'wants', 'wanted', 'help',
  'required', 'require', 'someone', 'somebody', 'anyone', 'person',
  'today', 'tomorrow',
  // Filler nouns. "problem" and "issue" name no trade, but they are unusual
  // enough in catalogue copy that leaving them in let a single stray
  // occurrence in one problem title break a genuine tie.
  'problem', 'problems', 'issue', 'issues', 'thing', 'something',
  'urgent', 'urgently', 'asap', 'soon', 'now', 'immediately', 'quickly',
  'house', 'home', 'flat', 'room', 'place',
  // Hinglish function words — customers mix languages inside one sentence.
  'hai', 'hain', 'ho', 'hua', 'hui', 'raha', 'rahi', 'rha', 'rhi',
  'ka', 'ki', 'ke', 'ko', 'se', 'mein', 'mera', 'meri', 'mere',
  'kya', 'nahi', 'nahin', 'nai', 'karo', 'karna', 'kar', 'chahiye', 'bhai',
};

/// Greetings and acknowledgements: a conversation opener, not a problem.
const _greetings = <String>{
  'hi', 'hii', 'hiii', 'hello', 'helo', 'hey', 'heya', 'yo', 'hola',
  'namaste', 'namaskar', 'vanakkam', 'salaam', 'salam', 'adaab',
  'good', 'morning', 'afternoon', 'evening', 'goodmorning', 'goodevening',
  'ok', 'okay', 'yes', 'yeah', 'yep', 'sure', 'hmm', 'hmmm',
};

/// A customer's message reduced to the parts a matcher can score.
class NormalizedText {
  const NormalizedText({
    required this.raw,
    required this.normalized,
    required this.tokens,
    required this.contentTokens,
    required this.bigrams,
    required this.trigrams,
  });

  /// Exactly what the customer typed. Kept so their own words — not the
  /// matcher's paraphrase — are what ends up in the service request.
  final String raw;

  /// Lowercased, punctuation-stripped, whitespace-collapsed.
  final String normalized;

  /// Every token, stop words included, in order.
  final List<String> tokens;

  /// Tokens that carry signal: stop words, greetings and bare numbers gone.
  final List<String> contentTokens;

  /// Adjacent token pairs, built before stop-word removal.
  final List<String> bigrams;

  /// Adjacent token triples, built before stop-word removal.
  final List<String> trigrams;

  /// True when the message is only a greeting or an acknowledgement.
  ///
  /// "hi", "hello there" and "good morning sir" all qualify: a greeting is
  /// present and nothing else in the message describes anything. Requiring
  /// *every* token to be a greeting would miss all but the bare "hi", since
  /// people pad them with function words.
  bool get isGreetingOnly =>
      contentTokens.isEmpty && tokens.any(_greetings.contains);

  /// True when nothing in the message describes anything.
  ///
  /// "help", "i need someone urgently" and "?" all land here: real messages,
  /// but with no noun to match a trade against.
  bool get hasNoContent => contentTokens.isEmpty;
}

/// Characters that survive normalisation. Digits stay because "1.5 ton ac"
/// and "3 phase" are real descriptions of real jobs.
final _nonWord = RegExp('[^a-z0-9]+');
final _whitespace = RegExp(r'\s+');
final _bareNumber = RegExp(r'^\d+$');

/// Contractions and abbreviations expanded before tokenising, so they do not
/// shatter into useless fragments.
const _expansions = <String, String>{
  'a/c': 'ac',
  'a.c.': 'ac',
  'a.c': 'ac',
  "isn't": 'is not',
  'isnt': 'is not',
  "doesn't": 'does not',
  'doesnt': 'does not',
  "won't": 'will not',
  "can't": 'can not',
  'cant': 'can not',
  "don't": 'do not',
  'dont': 'do not',
  "aren't": 'are not',
  'arent': 'are not',
  "wasn't": 'was not',
  "hasn't": 'has not',
  "haven't": 'have not',
  "it's": 'it is',
  "there's": 'there is',
};

/// Prepares a customer message for matching.
NormalizedText normalizeText(String raw) {
  var working = raw.toLowerCase();
  for (final entry in _expansions.entries) {
    working = working.replaceAll(entry.key, entry.value);
  }

  final normalized =
      working.replaceAll(_nonWord, ' ').trim().replaceAll(_whitespace, ' ');

  final tokens = normalized.isEmpty ? <String>[] : normalized.split(' ');

  final contentTokens = tokens
      .where((t) =>
          t.length > 1 &&
          !_stopWords.contains(t) &&
          !_greetings.contains(t) &&
          !_bareNumber.hasMatch(t))
      .toList();

  final bigrams = <String>[
    for (var i = 0; i + 1 < tokens.length; i++) '${tokens[i]} ${tokens[i + 1]}',
  ];

  final trigrams = <String>[
    for (var i = 0; i + 2 < tokens.length; i++)
      '${tokens[i]} ${tokens[i + 1]} ${tokens[i + 2]}',
  ];

  return NormalizedText(
    raw: raw.trim(),
    normalized: normalized,
    tokens: tokens,
    contentTokens: contentTokens,
    bigrams: bigrams,
    trigrams: trigrams,
  );
}

/// Splits a message into independent clauses.
///
/// "my ac is not cooling and the tap is leaking" is two jobs, not one
/// ambiguous job. Without this the matcher sees a single bag of words, finds
/// strong evidence for two trades, and calls it a tie — which is the one
/// answer that is wrong for both of them.
final _clauseBreak = RegExp(r'[,;.!?]+|\band\b|\balso\b|\bplus\b|&');

List<String> splitClauses(String raw) {
  final parts = raw
      .toLowerCase()
      .split(_clauseBreak)
      .map((p) => p.trim())
      .where((p) => p.isNotEmpty)
      .toList();
  return parts.isEmpty ? [raw.trim()] : parts;
}

/// How well two tokens match, from 1.0 (identical) down to 0.0 (unrelated).
///
/// Three tolerances, each deliberately narrow:
///   - a shared prefix covers inflection ("cool" / "cooling", "leak" /
///     "leaking") without a stemmer, which would turn "wiring" into "wir";
///   - one edit covers a slip on a reasonably long word ("plumbar");
///   - two edits are allowed only on long words, where a coincidental
///     two-edit collision is genuinely unlikely.
///
/// Short words get no edit tolerance at all: "tap" and "top", "fan" and
/// "can", "ac" and "as" are each one edit apart and mean different jobs.
double tokenSimilarity(String query, String term) {
  if (query == term) return 1.0;

  final shorter = query.length <= term.length ? query : term;
  final longer = query.length <= term.length ? term : query;

  if (shorter.length >= 4 &&
      longer.startsWith(shorter) &&
      longer.length - shorter.length <= 3) {
    return 0.8;
  }

  if (shorter.length < 5) return 0.0;

  final distance = editDistance(query, term, ceiling: 2);
  if (distance == 1) return 0.6;
  // Two edits are allowed only on a genuinely long word. At eight letters
  // they are not rare enough: "trimming" and "tripping" are two edits apart,
  // and that one collision was enough to put a hedge in front of an
  // electrician.
  if (distance == 2 && shorter.length >= 10) return 0.4;
  return 0.0;
}

/// Levenshtein distance, abandoned early once it exceeds [ceiling].
int editDistance(String a, String b, {int ceiling = 3}) {
  if ((a.length - b.length).abs() > ceiling) return ceiling + 1;
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;

  var previous = List<int>.generate(b.length + 1, (i) => i);
  var current = List<int>.filled(b.length + 1, 0);

  for (var i = 1; i <= a.length; i++) {
    current[0] = i;
    var rowBest = current[0];
    for (var j = 1; j <= b.length; j++) {
      final substitution = previous[j - 1] + (a[i - 1] == b[j - 1] ? 0 : 1);
      current[j] = math.min(
        math.min(current[j - 1] + 1, previous[j] + 1),
        substitution,
      );
      rowBest = math.min(rowBest, current[j]);
    }
    if (rowBest > ceiling) return ceiling + 1;
    final swap = previous;
    previous = current;
    current = swap;
  }

  return previous[b.length];
}
