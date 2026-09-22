import 'dart:math' as math;

import '../../domain/entities/service_category.dart';
import '../../domain/entities/service_match.dart';
import '../../domain/entities/service_problem.dart';
import '../../domain/matching/service_matcher.dart';
import 'service_lexicon.dart';
import 'text_normalizer.dart';

/// Matches a customer's description to a service, entirely on the device.
///
/// Two sources of evidence, deliberately kept separate:
///
///   1. A curated lexicon ([ServiceLexicon]) of the words people actually
///      use for each trade, including Hinglish. High trust, hand-checked,
///      but fixed at build time.
///   2. An index built from the live catalogue rows — service names and
///      descriptions, and every problem title and description. Lower trust
///      per term, but it covers services added to the database after this
///      app shipped, which is the case the lexicon alone cannot survive.
///
/// Both are weighted by how many services claim a term, so a word owned by
/// one trade ("geyser") decides a match and a word shared by four ("water")
/// never does on its own.
///
/// The matcher will say "I am not sure" rather than guess. An assistant that
/// confidently sends a leaking geyser to a painter costs the customer a
/// wasted visit and the platform a refund; asking one clarifying question
/// costs a tap.
final class KeywordServiceMatcher implements ServiceMatcher {
  KeywordServiceMatcher({ServiceLexicon? lexicon})
      : _lexicon = lexicon ?? ServiceLexicon.builtIn();

  final ServiceLexicon _lexicon;

  /// The catalogue index, rebuilt only when the catalogue itself changes.
  _CatalogueIndex? _index;
  String? _indexSignature;

  // ── Tuning ───────────────────────────────────────────────────────────────
  // These are the numbers the behaviour actually turns on, so they are named
  // and gathered here rather than scattered through the scoring code. Every
  // one of them is pinned by a test in test/core/service_matcher_test.dart.

  /// Catalogue evidence counts for rather less than curated evidence: the
  /// catalogue is marketing copy, and its words overlap between trades.
  static const _catalogueWeight = 0.55;

  /// A matched phrase is worth more than the sum of its words. "not cooling"
  /// says something that "not" and "cooling" separately do not.
  static const _phraseBonus = 1.8;

  /// Raw score at which the evidence is treated as sufficient on its own.
  /// Roughly: one unambiguous trade word plus its catalogue echo.
  static const _saturation = 1.6;

  /// Confidence a service gets for evidence alone, before any credit for
  /// beating the runner-up. Set so that a dead heat lands just below
  /// [_confidentThreshold] and therefore asks instead of guessing.
  static const _marginFloor = 0.45;

  /// At or above this, act on the match. Below it, ask.
  static const _confidentThreshold = 0.5;

  /// Below this much raw evidence, there is nothing worth offering at all.
  static const _minimumEvidence = 0.35;

  /// A problem is only offered as a pre-fill if it genuinely resembles the
  /// message. A weak one puts words in the customer's mouth.
  static const _problemFloor = 0.9;

  @override
  ServiceMatchResult match(
    String message, {
    required List<ServiceCategory> services,
    required List<ServiceProblem> problems,
  }) {
    final text = normalizeText(message);

    if (text.isGreetingOnly) return ServiceMatchResult.greeting(text.raw);
    if (text.hasNoContent) return ServiceMatchResult.tooVague(text.raw);
    if (services.isEmpty) return ServiceMatchResult.unmatched(text.raw);

    _ensureIndex(services, problems);

    final ranked = _rank(text, services, problems);

    if (ranked.isEmpty || ranked.first.score < _minimumEvidence) {
      return ServiceMatchResult.unmatched(text.raw);
    }

    // Two jobs in one sentence is a different situation from one job nobody
    // can place. Checked before the confident/ambiguous split, because a
    // message naming two trades will always look ambiguous in aggregate.
    final separate = _separateJobs(message, services, problems);
    if (separate.length >= 2) {
      return ServiceMatchResult(
        outcome: MatchOutcome.multipleServices,
        candidates: separate,
        query: text.raw,
      );
    }

    if (ranked.first.confidence >= _confidentThreshold) {
      return ServiceMatchResult(
        outcome: MatchOutcome.confident,
        candidates: ranked.take(3).toList(),
        query: text.raw,
      );
    }

    return ServiceMatchResult(
      outcome: MatchOutcome.ambiguous,
      candidates: ranked.where((m) => m.score >= _minimumEvidence).take(3).toList(),
      query: text.raw,
    );
  }

  // ── Ranking ──────────────────────────────────────────────────────────────

  List<ServiceMatch> _rank(
    NormalizedText text,
    List<ServiceCategory> services,
    List<ServiceProblem> problems,
  ) {
    final scored = <ServiceCategory, _Evidence>{};
    for (final service in services) {
      final evidence = _scoreService(text, service);
      if (evidence.score > 0) scored[service] = evidence;
    }
    if (scored.isEmpty) return const [];

    final ordered = scored.entries.toList()
      ..sort((a, b) => b.value.score.compareTo(a.value.score));

    final top = ordered.first.value.score;
    final runnerUp = ordered.length > 1 ? ordered[1].value.score : 0.0;

    return [
      for (var i = 0; i < ordered.length; i++)
        ServiceMatch(
          service: ordered[i].key,
          score: ordered[i].value.score,
          // Only the leader's confidence is a statement about the whole
          // message. The rest are scored against the leader, which is what
          // the disambiguation list needs to rank them sensibly.
          confidence: i == 0
              ? _confidenceOf(top, runnerUp)
              : _confidenceOf(ordered[i].value.score, top),
          matchedTerms: ordered[i].value.terms,
          closestProblem: _closestProblem(
            text,
            problems.where((p) => p.serviceId == ordered[i].key.id).toList(),
          ),
        ),
    ];
  }

  double _confidenceOf(double top, double other) {
    if (top <= 0) return 0.0;
    final evidence = math.min(1.0, top / _saturation);
    final margin =
        other <= 0 ? 1.0 : ((top - other) / top).clamp(0.0, 1.0).toDouble();
    return evidence * (_marginFloor + (1 - _marginFloor) * margin);
  }

  _Evidence _scoreService(NormalizedText text, ServiceCategory service) {
    var score = 0.0;
    final terms = <String>[];

    // ── Curated phrases ──
    // Checked against the normalised string with word boundaries, so
    // "no cooling" matches "there is no cooling" but not "casino coolingx".
    for (final phrase in _lexicon.phrasesFor(service.slug)) {
      if (_containsPhrase(text.normalized, phrase)) {
        score += _lexicon.weightOf(phrase) * _phraseBonus;
        terms.add(phrase);
      }
    }

    // ── Curated words ──
    // Best match per query token, not the sum over every synonym it
    // resembles: one word of evidence should count once.
    final words = _lexicon.wordsFor(service.slug);
    for (final token in _distinct(text.contentTokens)) {
      var best = 0.0;
      String? bestTerm;
      for (final word in words) {
        final similarity = tokenSimilarity(token, word);
        if (similarity > best) {
          best = similarity;
          bestTerm = word;
        }
        if (best == 1.0) break;
      }
      if (bestTerm != null && best > 0) {
        score += _lexicon.weightOf(bestTerm) * best;
        terms.add(token);
      }
    }

    // ── Live catalogue ──
    final index = _index;
    if (index != null) {
      for (final token in _distinct(text.contentTokens)) {
        final hit = index.bestFor(token, service.id);
        if (hit > 0) {
          score += hit * _catalogueWeight;
          terms.add(token);
        }
      }
    }

    return _Evidence(score, _distinct(terms).take(4).toList());
  }

  /// The catalogue problem that best fits the message, or null when none
  /// fits well enough to be worth putting in front of the customer.
  ServiceProblem? _closestProblem(
    NormalizedText text,
    List<ServiceProblem> candidates,
  ) {
    if (candidates.isEmpty) return null;

    ServiceProblem? best;
    var bestScore = 0.0;

    for (final problem in candidates) {
      final title = normalizeText(problem.title).contentTokens.toSet();
      final detail =
          normalizeText(problem.description ?? '').contentTokens.toSet();

      var score = 0.0;
      for (final token in _distinct(text.contentTokens)) {
        var titleHit = 0.0;
        for (final t in title) {
          titleHit = math.max(titleHit, tokenSimilarity(token, t));
          if (titleHit == 1.0) break;
        }
        var detailHit = 0.0;
        for (final d in detail) {
          detailHit = math.max(detailHit, tokenSimilarity(token, d));
          if (detailHit == 1.0) break;
        }
        // A word in the problem's own title is a far better signal than one
        // buried in its explanatory copy.
        score += titleHit + detailHit * 0.3;
      }

      if (score > bestScore) {
        bestScore = score;
        best = problem;
      }
    }

    return bestScore >= _problemFloor ? best : null;
  }

  /// Clause-by-clause matching, used to tell "two jobs" from "one unclear
  /// job". Returns the confident matches from distinct services, best first,
  /// or an empty list when the message is about one thing.
  List<ServiceMatch> _separateJobs(
    String message,
    List<ServiceCategory> services,
    List<ServiceProblem> problems,
  ) {
    final clauses = splitClauses(message);
    if (clauses.length < 2) return const [];

    final byService = <String, ServiceMatch>{};
    for (final clause in clauses) {
      final text = normalizeText(clause);
      if (text.hasNoContent) continue;

      final ranked = _rank(text, services, problems);
      if (ranked.isEmpty) continue;

      final top = ranked.first;
      if (top.confidence < _confidentThreshold) continue;

      final existing = byService[top.service.id];
      if (existing == null || top.confidence > existing.confidence) {
        byService[top.service.id] = top;
      }
    }

    if (byService.length < 2) return const [];

    final ordered = byService.values.toList()
      ..sort((a, b) => b.confidence.compareTo(a.confidence));
    return ordered;
  }

  // ── Catalogue index ──────────────────────────────────────────────────────

  void _ensureIndex(
    List<ServiceCategory> services,
    List<ServiceProblem> problems,
  ) {
    final signature =
        '${services.length}:${problems.length}:${services.map((s) => s.id).join(",")}';
    if (_indexSignature == signature && _index != null) return;

    _index = _CatalogueIndex.build(services, problems);
    _indexSignature = signature;
  }

  static bool _containsPhrase(String haystack, String phrase) {
    final at = haystack.indexOf(phrase);
    if (at < 0) return false;
    final startsClean = at == 0 || haystack[at - 1] == ' ';
    final end = at + phrase.length;
    final endsClean = end == haystack.length || haystack[end] == ' ';
    return startsClean && endsClean;
  }

  static List<String> _distinct(List<String> input) {
    final seen = <String>{};
    return [
      for (final item in input)
        if (seen.add(item)) item,
    ];
  }
}

class _Evidence {
  const _Evidence(this.score, this.terms);
  final double score;
  final List<String> terms;
}

/// Tokens from the live catalogue, weighted by how many services use them.
///
/// This is what lets a service the app has never heard of still be matched:
/// its own name and its own problem titles become its vocabulary.
class _CatalogueIndex {
  _CatalogueIndex._(this._tokensByService, this._documentFrequency, this._total);

  factory _CatalogueIndex.build(
    List<ServiceCategory> services,
    List<ServiceProblem> problems,
  ) {
    final tokensByService = <String, Set<String>>{};

    for (final service in services) {
      final tokens = <String>{}
        ..addAll(normalizeText(service.name).contentTokens)
        ..addAll(normalizeText(service.slug.replaceAll('-', ' ')).contentTokens)
        ..addAll(normalizeText(service.description).contentTokens);
      tokensByService[service.id] = tokens;
    }

    for (final problem in problems) {
      final bucket = tokensByService[problem.serviceId];
      if (bucket == null) continue;
      bucket
        ..addAll(normalizeText(problem.title).contentTokens)
        ..addAll(normalizeText(problem.description ?? '').contentTokens);
    }

    final documentFrequency = <String, int>{};
    for (final tokens in tokensByService.values) {
      for (final token in tokens) {
        documentFrequency[token] = (documentFrequency[token] ?? 0) + 1;
      }
    }

    return _CatalogueIndex._(
      tokensByService,
      documentFrequency,
      math.max(1, services.length),
    );
  }

  final Map<String, Set<String>> _tokensByService;
  final Map<String, int> _documentFrequency;
  final int _total;

  /// 1.0 for a token only one service uses, falling to 0.0 for one they all
  /// use. A word every service's copy contains distinguishes nothing.
  double _inverseFrequency(String token) {
    final frequency = _documentFrequency[token];
    if (frequency == null || frequency <= 0) return 0.0;
    if (_total <= 1) return 1.0;
    return math.log(_total / frequency) / math.log(_total);
  }

  /// Best weighted match for [token] within [serviceId]'s vocabulary.
  double bestFor(String token, String serviceId) {
    final tokens = _tokensByService[serviceId];
    if (tokens == null || tokens.isEmpty) return 0.0;

    // Exact hit is by far the common case; take it without scanning.
    if (tokens.contains(token)) return _inverseFrequency(token);

    // Fuzzy matching on a three-letter token matches half the catalogue.
    if (token.length < 4) return 0.0;

    var best = 0.0;
    for (final candidate in tokens) {
      final similarity = tokenSimilarity(token, candidate);
      if (similarity <= 0) continue;
      final weighted = similarity * _inverseFrequency(candidate);
      if (weighted > best) best = weighted;
    }
    return best;
  }
}
