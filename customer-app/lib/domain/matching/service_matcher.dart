import '../entities/service_category.dart';
import '../entities/service_match.dart';
import '../entities/service_problem.dart';

/// Picks the service that fits what a customer described.
///
/// Deliberately an interface with no I/O in its signature. The shipped
/// implementation runs entirely on the device against the catalogue it is
/// handed, which is what makes the assistant work on a weak connection and
/// cost nothing per message. A server-backed implementation can be dropped
/// in behind this same call without any screen knowing.
///
/// Matching is a pure function of ([message], [services], [problems]). It
/// never fetches, never caches across calls in a way the caller cannot see,
/// and returns the same answer for the same inputs — so a disagreement about
/// a match can be reproduced in a test rather than argued about.
abstract interface class ServiceMatcher {
  ServiceMatchResult match(
    String message, {
    required List<ServiceCategory> services,
    required List<ServiceProblem> problems,
  });
}
