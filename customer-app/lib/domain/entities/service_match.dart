import 'service_category.dart';
import 'service_problem.dart';

/// What the matcher concluded about a customer's message.
enum MatchOutcome {
  /// One service is a clear winner. Safe to act on.
  confident,

  /// Two or more services are plausible and too close to separate. The
  /// customer is asked which one, rather than being sent to a guess.
  ambiguous,

  /// The message describes more than one job, for different trades.
  multipleServices,

  /// Real words, but nothing that names a trade the platform offers.
  unmatched,

  /// A message with no describable content: "help", "someone urgently".
  tooVague,

  /// "hi", "hello" — an opener, not a request.
  greeting,
}

/// One service scored against what the customer wrote.
class ServiceMatch {
  const ServiceMatch({
    required this.service,
    required this.score,
    required this.confidence,
    required this.matchedTerms,
    this.closestProblem,
  });

  /// A service the customer picked themselves, after the matcher asked.
  ///
  /// The certainty here comes from them, not from scoring — there is nothing
  /// left to be unsure about, and [matchedTerms] is empty because no term
  /// matched: they simply told us.
  const ServiceMatch.chosen(this.service)
      : score = 0,
        confidence = 1,
        matchedTerms = const [],
        closestProblem = null;

  final ServiceCategory service;

  /// Accumulated evidence. Comparable only within a single match run —
  /// it has no meaning as an absolute number and is never shown to anyone.
  final double score;

  /// 0..1. Combines how much evidence there was with how far ahead of the
  /// runner-up this service finished.
  final double confidence;

  /// The customer's own words that drove this match, in the order they were
  /// written. Shown back to them so the answer can be checked rather than
  /// trusted: "matched on: leaking, sink".
  final List<String> matchedTerms;

  /// The catalogue problem that best fits the message, when one does.
  /// Used to pre-fill the request, never to overwrite what they typed.
  final ServiceProblem? closestProblem;
}

/// The result of matching one message against the catalogue.
class ServiceMatchResult {
  const ServiceMatchResult({
    required this.outcome,
    required this.candidates,
    required this.query,
  });

  const ServiceMatchResult.greeting(this.query)
      : outcome = MatchOutcome.greeting,
        candidates = const [];

  const ServiceMatchResult.tooVague(this.query)
      : outcome = MatchOutcome.tooVague,
        candidates = const [];

  const ServiceMatchResult.unmatched(this.query)
      : outcome = MatchOutcome.unmatched,
        candidates = const [];

  final MatchOutcome outcome;

  /// Ranked best first. Empty for [MatchOutcome.greeting],
  /// [MatchOutcome.tooVague] and [MatchOutcome.unmatched].
  final List<ServiceMatch> candidates;

  /// What the customer typed, unaltered.
  final String query;

  ServiceMatch? get best => candidates.isEmpty ? null : candidates.first;

  bool get hasCandidates => candidates.isNotEmpty;
}
