import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers/providers.dart';
import '../../app/theme/app_colors.dart';
import '../../domain/entities/service_category.dart';
import '../../shared/widgets/service_icon.dart';
import 'assistant_controller.dart';
import 'assistant_message.dart';

/// The assistant: describe a problem in plain words, get the right service.
///
/// The screen deliberately never dead-ends. Every answer it gives — a
/// confident match, a question, or an admission that it could not place the
/// message — ends with something the customer can tap to keep going.
class AssistantScreen extends ConsumerStatefulWidget {
  const AssistantScreen({super.key});

  @override
  ConsumerState<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends ConsumerState<AssistantScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final _inputFocus = FocusNode();

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    _inputFocus.dispose();
    super.dispose();
  }

  void _send([String? preset]) {
    final text = preset ?? _input.text;
    if (text.trim().isEmpty) return;
    _input.clear();
    ref.read(assistantControllerProvider.notifier).send(text);
  }

  /// Keeps the newest turn in view. Posted to the next frame because the
  /// list has not been laid out with the new entry yet when state changes.
  void _scrollToLatest() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(assistantControllerProvider, (_, __) => _scrollToLatest());
    final state = ref.watch(assistantControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Row(
          children: [
            _AssistantAvatar(size: 32),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Service Assistant',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  'Finds the right trade for your problem',
                  style: TextStyle(fontSize: 11, color: AppColors.inkSecondary),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Start over',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              _input.clear();
              ref.read(assistantControllerProvider.notifier).reset();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                itemCount: state.entries.length + (state.isThinking ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.entries.length) {
                    return const _ThinkingBubble();
                  }
                  return _EntryView(entry: state.entries[index]);
                },
              ),
            ),
            if (state.isFresh) const _StarterSuggestions(),
            _Composer(
              controller: _input,
              focusNode: _inputFocus,
              enabled: !state.isThinking,
              onSend: _send,
            ),
          ],
        ),
      ),
    );
  }
}

/// Renders one conversation turn. The switch is exhaustive over the sealed
/// [AssistantEntry], so a new turn type cannot be added without a view.
class _EntryView extends StatelessWidget {
  const _EntryView({required this.entry});

  final AssistantEntry entry;

  @override
  Widget build(BuildContext context) {
    return switch (entry) {
      CustomerTurn(:final text) => _CustomerBubble(text: text),
      AssistantTurn turn => _AssistantBubble(turn: turn),
      ServiceOfferTurn turn => _ServiceOfferCard(turn: turn),
      ServiceChoiceTurn turn => _ServiceChoiceList(turn: turn),
      CatalogueChoiceTurn turn => _CatalogueChoiceGrid(turn: turn),
    };
  }
}

// ─── Bubbles ────────────────────────────────────────────────────────────────

class _CustomerBubble extends StatelessWidget {
  const _CustomerBubble({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 48),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.35),
        ),
      ),
    );
  }
}

class _AssistantBubble extends ConsumerWidget {
  const _AssistantBubble({required this.turn});
  final AssistantTurn turn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _AssistantAvatar(size: 28),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    turn.text,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  if (turn.isRetryable) ...[
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => ref
                          .read(assistantControllerProvider.notifier)
                          .retry(turn.retryMessage!),
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: const Text('Try again'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThinkingBubble extends StatefulWidget {
  const _ThinkingBubble();

  @override
  State<_ThinkingBubble> createState() => _ThinkingBubbleState();
}

class _ThinkingBubbleState extends State<_ThinkingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const _AssistantAvatar(size: 28),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (context, _) => Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  // Each dot lags the one before it by a third of a cycle.
                  final phase = (_pulse.value + i / 3) % 1.0;
                  final lift = (phase < 0.5 ? phase : 1 - phase) * 2;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Opacity(
                      opacity: 0.35 + lift * 0.65,
                      child: const CircleAvatar(
                        radius: 3.5,
                        backgroundColor: AppColors.inkSecondary,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssistantAvatar extends StatelessWidget {
  const _AssistantAvatar({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.primarySurface,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.auto_awesome_rounded,
        size: size * 0.55,
        color: AppColors.primary,
      ),
    );
  }
}

// ─── Match cards ────────────────────────────────────────────────────────────

/// A matched service with the two ways to act on it.
///
/// Both routes carry the customer's own description across. Matching the
/// service is only half the job: an assistant that identifies "Plumbing" and
/// then drops someone onto an empty form has saved them nothing.
class _ServiceOfferCard extends ConsumerWidget {
  const _ServiceOfferCard({required this.turn});
  final ServiceOfferTurn turn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = turn.match.service;
    final catalogue = ref.watch(serviceCategoriesProvider).valueOrNull;
    final accent = serviceAccentAt(
      catalogue?.indexWhere((s) => s.id == service.id) ?? -1,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 14, right: 12, left: 36),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(serviceIconFor(service.slug),
                      color: accent, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      if (service.description.isNotEmpty)
                        Text(
                          service.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.inkSecondary,
                            height: 1.3,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (turn.match.closestProblem != null) ...[
              const SizedBox(height: 12),
              _Pill(
                icon: Icons.task_alt_rounded,
                label: turn.match.closestProblem!.title,
                color: AppColors.success,
                background: AppColors.successSurface,
              ),
            ],
            if (turn.match.matchedTerms.isNotEmpty) ...[
              const SizedBox(height: 8),
              // Shown so the customer can check the reasoning instead of
              // taking it on trust — and correct it in one tap if it is wrong.
              Text(
                'Matched on: ${turn.match.matchedTerms.join(', ')}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.inkTertiary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _findWorkers(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 44),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: const Text('Find workers',
                        style: TextStyle(fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _postRequest(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 44),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: const Text('Post a request',
                        style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _findWorkers(BuildContext context) {
    final service = turn.match.service;
    context.push(
      '/service-request/${service.id}?name=${Uri.encodeComponent(service.name)}',
      // Their words, verbatim. The matcher's reading of the problem is a
      // label for the card, not a replacement for what they actually said.
      extra: {'presetDescription': turn.customerWords},
    );
  }

  void _postRequest(BuildContext context) {
    final service = turn.match.service;
    context.push('/post-request', extra: {
      'category_id': service.id,
      'category_name': service.name,
      // Only set when the matcher actually recognised the problem. A title
      // invented from a guess would be a statement the customer never made.
      'title': turn.match.closestProblem?.title,
      'description': turn.customerWords,
    });
  }
}

/// The shortlist shown when the matcher will not pick for the customer.
class _ServiceChoiceList extends ConsumerWidget {
  const _ServiceChoiceList({required this.turn});
  final ServiceChoiceTurn turn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14, left: 36, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final option in turn.options)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ChoiceTile(
                service: option.service,
                subtitle: option.closestProblem?.title,
                onTap: () => ref
                    .read(assistantControllerProvider.notifier)
                    .chooseMatch(option, turn.customerWords),
              ),
            ),
        ],
      ),
    );
  }
}

/// The whole catalogue, offered when nothing matched.
class _CatalogueChoiceGrid extends ConsumerWidget {
  const _CatalogueChoiceGrid({required this.turn});
  final CatalogueChoiceTurn turn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14, left: 36, right: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final service in turn.services)
            ActionChip(
              avatar: Icon(serviceIconFor(service.slug),
                  size: 16, color: AppColors.primary),
              label: Text(service.name, style: const TextStyle(fontSize: 12)),
              onPressed: () => ref
                  .read(assistantControllerProvider.notifier)
                  .choose(service, turn.customerWords),
            ),
        ],
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.service,
    required this.onTap,
    this.subtitle,
  });

  final ServiceCategory service;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderStrong),
        ),
        child: Row(
          children: [
            Icon(serviceIconFor(service.slug),
                size: 20, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.ink,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.inkSecondary,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.inkSecondary),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Composer and starters ──────────────────────────────────────────────────

/// Openers taken from the live catalogue, so they are always things the
/// platform can actually do. Nothing here is written by hand: every chip is
/// a real problem title from `service_problems`.
class _StarterSuggestions extends ConsumerWidget {
  const _StarterSuggestions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final problems = ref.watch(allServiceProblemsProvider).valueOrNull;
    if (problems == null || problems.isEmpty) return const SizedBox.shrink();

    // One per service, so the openers span trades rather than showing four
    // variations of the same one.
    final seen = <String>{};
    final picks = [
      for (final problem in problems)
        if (seen.add(problem.serviceId)) problem,
    ].take(6).toList();

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: picks.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) => Center(
          child: ActionChip(
            label: Text(picks[index].title,
                style: const TextStyle(fontSize: 12)),
            onPressed: () => ref
                .read(assistantControllerProvider.notifier)
                .send(picks[index].title),
          ),
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final void Function([String? preset]) onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              enabled: enabled,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: 'Describe the problem...',
                filled: true,
                fillColor: AppColors.surfaceMuted,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 48,
            height: 48,
            child: ElevatedButton(
              onPressed: enabled ? () => onSend() : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
                minimumSize: const Size(48, 48),
              ),
              child: const Icon(Icons.arrow_upward_rounded, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
