import '../../domain/entities/service_category.dart';
import '../../domain/entities/service_match.dart';

/// One turn in the assistant conversation.
///
/// Sealed so the screen has to handle every kind it can be handed. A new
/// message type is a compile error at the render site rather than a silently
/// blank bubble.
sealed class AssistantEntry {
  const AssistantEntry();
}

/// What the customer typed or tapped.
final class CustomerTurn extends AssistantEntry {
  const CustomerTurn(this.text);
  final String text;
}

/// Plain prose from the assistant.
final class AssistantTurn extends AssistantEntry {
  const AssistantTurn(this.text, {this.retryMessage});

  final String text;

  /// Set when this turn reports a failure the customer can retry. Holds the
  /// message that failed, so the retry re-asks their question rather than
  /// making them type it again.
  final String? retryMessage;

  bool get isRetryable => retryMessage != null;
}

/// A matched service, offered with a way to act on it.
final class ServiceOfferTurn extends AssistantEntry {
  const ServiceOfferTurn({
    required this.match,
    required this.customerWords,
    this.heading,
  });

  final ServiceMatch match;

  /// The customer's own description, carried through to pre-fill the
  /// request. Their words, not the catalogue's.
  final String customerWords;

  /// Optional label above the card, used when several are offered at once
  /// ("For the AC", "For the tap").
  final String? heading;
}

/// Several services the customer is asked to choose between.
final class ServiceChoiceTurn extends AssistantEntry {
  const ServiceChoiceTurn({
    required this.options,
    required this.customerWords,
  });

  final List<ServiceMatch> options;
  final String customerWords;
}

/// The whole catalogue, offered when nothing matched at all.
final class CatalogueChoiceTurn extends AssistantEntry {
  const CatalogueChoiceTurn({
    required this.services,
    required this.customerWords,
  });

  final List<ServiceCategory> services;
  final String customerWords;
}
