import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers/providers.dart';
import '../../core/errors/result.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/entities/service_category.dart';
import '../../domain/entities/service_match.dart';
import '../../domain/entities/service_problem.dart';
import 'assistant_message.dart';

/// The assistant conversation.
class AssistantState {
  const AssistantState({
    this.entries = const [],
    this.isThinking = false,
  });

  final List<AssistantEntry> entries;

  /// True while a message is being matched. Drives the typing indicator.
  final bool isThinking;

  /// True before the customer has said anything — the screen shows starter
  /// suggestions only while this holds.
  bool get isFresh => entries.whereType<CustomerTurn>().isEmpty;

  AssistantState copyWith({
    List<AssistantEntry>? entries,
    bool? isThinking,
  }) =>
      AssistantState(
        entries: entries ?? this.entries,
        isThinking: isThinking ?? this.isThinking,
      );
}

/// Drives the assistant: takes what the customer wrote, asks the matcher
/// what service it is, and turns the answer into conversation.
///
/// The controller decides nothing about *which* service fits — that is the
/// matcher's job and is tested separately. What it owns is the conversation:
/// when to act on an answer, when to ask, and what to do when the catalogue
/// cannot be reached.
class AssistantController extends StateNotifier<AssistantState> {
  AssistantController(this._ref) : super(const AssistantState()) {
    _append(const AssistantTurn(_opening));
  }

  final Ref _ref;

  static const _log = AppLogger('Assistant');

  static const _opening =
      "Tell me what's wrong, in your own words — and I'll find the right "
      'professional for it.';

  /// The reply lands in the same frame the question does without this, which
  /// reads as a canned response rather than an answer. This is pacing, not
  /// fake work: matching itself finishes in well under a millisecond.
  static const _pacing = Duration(milliseconds: 280);

  /// Matches [raw] and answers it.
  Future<void> send(String raw) async {
    final message = raw.trim();
    if (message.isEmpty || state.isThinking) return;

    _append(CustomerTurn(message));
    await _answer(message);
  }

  /// Re-runs a message whose first attempt failed on the catalogue fetch.
  /// The customer's turn is already in the transcript, so it is not repeated.
  Future<void> retry(String message) async {
    if (state.isThinking) return;
    _ref.invalidate(serviceCategoriesProvider);
    _ref.invalidate(allServiceProblemsProvider);
    await _answer(message);
  }

  /// Every write to [state] after an await is guarded by [mounted]. The
  /// customer can tap back while the assistant is still thinking, which
  /// disposes the notifier mid-flight; writing to it then throws.
  Future<void> _answer(String message) async {
    state = state.copyWith(isThinking: true);

    final _Catalogue catalogue;
    try {
      // Both providers rethrow the AppFailure rather than answering a
      // failure with an empty catalogue — an empty catalogue here would
      // become "no service fits your problem", which is a lie about the
      // platform rather than a report of a network error.
      final services = await _ref.read(serviceCategoriesProvider.future);
      final problems = await _ref.read(allServiceProblemsProvider.future);
      if (!mounted) return;
      catalogue = _Catalogue(services, problems);
    } on AppFailure catch (failure) {
      await _pause();
      if (!mounted) return;
      _append(AssistantTurn(
        '${failure.message} I need the service list to answer that.',
        retryMessage: message,
      ));
      state = state.copyWith(isThinking: false);
      return;
    } catch (error, stackTrace) {
      // Anything the repositories did not map. Without this the typing
      // indicator runs forever and the assistant becomes the one screen in
      // the app with no way out — the exact dead end it exists to avoid.
      _log.error('Assistant could not load the catalogue',
          error: error, stackTrace: stackTrace);
      await _pause();
      if (!mounted) return;
      _append(AssistantTurn(
        'Something went wrong loading the service list.',
        retryMessage: message,
      ));
      state = state.copyWith(isThinking: false);
      return;
    }

    final result = _ref.read(serviceMatcherProvider).match(
          message,
          services: catalogue.services,
          problems: catalogue.problems,
        );

    await _pause();
    if (!mounted) return;
    _respond(result, catalogue);
    state = state.copyWith(isThinking: false);
  }

  void _respond(ServiceMatchResult result, _Catalogue catalogue) {
    switch (result.outcome) {
      case MatchOutcome.greeting:
        _append(const AssistantTurn(
          'Hello. What do you need help with at home? A leaking tap, an AC '
          'that stopped cooling, a switch that sparks — whatever it is, '
          'describe it however you like.',
        ));

      case MatchOutcome.tooVague:
        _append(const AssistantTurn(
          'I can help — I just need to know what the problem is. What is not '
          'working?',
        ));

      case MatchOutcome.confident:
        final best = result.best!;
        _append(AssistantTurn(_confidentReply(best)));
        _append(ServiceOfferTurn(
          match: best,
          customerWords: result.query,
        ));

      case MatchOutcome.multipleServices:
        _append(AssistantTurn(
          'That sounds like ${result.candidates.length} separate jobs — they '
          'need different trades. Here is each one:',
        ));
        for (final match in result.candidates) {
          _append(ServiceOfferTurn(
            match: match,
            customerWords: result.query,
            heading: match.service.name,
          ));
        }

      case MatchOutcome.ambiguous:
        _append(const AssistantTurn(
          "I want to get this right — that could go to more than one trade. "
          'Which is closer?',
        ));
        _append(ServiceChoiceTurn(
          options: result.candidates,
          customerWords: result.query,
        ));

      case MatchOutcome.unmatched:
        _append(const AssistantTurn(
          "I could not place that against the services on the platform. "
          'Pick the closest one and I will take your description across — or '
          'post it as a request and let professionals come to you.',
        ));
        _append(CatalogueChoiceTurn(
          services: catalogue.services,
          customerWords: result.query,
        ));
    }
  }

  String _confidentReply(ServiceMatch match) {
    final name = match.service.name;
    final problem = match.closestProblem;
    if (problem != null) {
      return 'That sounds like $name — most likely "${problem.title}".';
    }
    return 'That sounds like a job for $name.';
  }

  /// Records a service the customer picked after being asked.
  void choose(ServiceCategory service, String customerWords) {
    _append(CustomerTurn(service.name));
    _append(AssistantTurn(
      '${service.name} it is. Your description goes across as you wrote it.',
    ));
    _append(ServiceOfferTurn(
      match: ServiceMatch.chosen(service),
      customerWords: customerWords,
    ));
  }

  /// Records a service the customer picked from a scored shortlist, keeping
  /// the matched problem the matcher already worked out for it.
  void chooseMatch(ServiceMatch match, String customerWords) {
    _append(CustomerTurn(match.service.name));
    _append(AssistantTurn(
      '${match.service.name} it is. Your description goes across as you '
      'wrote it.',
    ));
    _append(ServiceOfferTurn(match: match, customerWords: customerWords));
  }

  /// Clears the conversation back to the opening line.
  void reset() {
    state = const AssistantState(entries: [AssistantTurn(_opening)]);
  }

  void _append(AssistantEntry entry) {
    state = state.copyWith(entries: [...state.entries, entry]);
  }

  Future<void> _pause() => Future<void>.delayed(_pacing);
}

class _Catalogue {
  const _Catalogue(this.services, this.problems);
  final List<ServiceCategory> services;
  final List<ServiceProblem> problems;
}

final assistantControllerProvider =
    StateNotifierProvider.autoDispose<AssistantController, AssistantState>(
  (ref) => AssistantController(ref),
);
