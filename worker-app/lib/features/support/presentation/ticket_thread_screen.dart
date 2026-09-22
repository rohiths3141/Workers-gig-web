import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/support.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/common_widgets.dart';
import 'support_controller.dart';

/// One support conversation.
///
/// Internal staff notes never reach this screen: the RLS policy filters them
/// out server-side rather than relying on the client to hide them, so there is
/// no way for a note meant for operations to leak through a client bug.
class TicketThreadScreen extends ConsumerStatefulWidget {
  const TicketThreadScreen({required this.ticketId, super.key});

  final String ticketId;

  @override
  ConsumerState<TicketThreadScreen> createState() => _TicketThreadScreenState();
}

class _TicketThreadScreenState extends ConsumerState<TicketThreadScreen> {
  final _reply = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _reply.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_reply.text.trim().isEmpty || _busy) return;
    setState(() => _busy = true);

    final result = await ref.read(supportControllerProvider.notifier).reply(
          ticketId: widget.ticketId,
          body: _reply.text,
        );

    if (!mounted) return;
    setState(() => _busy = false);

    result.fold(
      (_) => _reply.clear(),
      (failure) => showFailure(context, failure.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(ticketMessagesProvider(widget.ticketId));

    return Scaffold(
      appBar: AppBar(title: const Text('Support request')),
      body: Column(
        children: [
          Expanded(
            child: AsyncValueView<List<SupportMessage>>(
              value: messages,
              onRetry: () =>
                  ref.invalidate(ticketMessagesProvider(widget.ticketId)),
              onData: (items) {
                if (items.isEmpty) {
                  return const EmptyStateView(
                    icon: Icons.forum_outlined,
                    title: 'No messages yet',
                    message: 'Your conversation will appear here.',
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  itemCount: items.length,
                  itemBuilder: (_, index) => _MessageBubble(message: items[index]),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.sm,
              AppSpacing.screenPadding,
              AppSpacing.sm + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              color: context.surface,
              border: Border(top: BorderSide(color: context.border)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _reply,
                    maxLines: 4,
                    minLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: 'Write a message',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                SizedBox(
                  width: AppSpacing.minTouchTarget,
                  height: AppSpacing.minTouchTarget,
                  child: IconButton.filled(
                    onPressed: _busy ? null : _send,
                    icon: const Icon(Icons.send_rounded, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final SupportMessage message;

  @override
  Widget build(BuildContext context) {
    final isMine = message.isFromWorker;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: isMine ? AppColors.primarySurface : context.surfaceMuted,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppRadius.lg),
            topRight: const Radius.circular(AppRadius.lg),
            bottomLeft: Radius.circular(isMine ? AppRadius.lg : AppRadius.sm),
            bottomRight: Radius.circular(isMine ? AppRadius.sm : AppRadius.lg),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMine)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Text('Wervexa support',
                    style: AppTypography.badge
                        .copyWith(color: context.inkSecondary)),
              ),
            Text(message.body,
                style: AppTypography.bodyMedium.copyWith(color: context.ink)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              DateFormat('d MMM, h:mm a').format(message.createdAt),
              style:
                  AppTypography.bodySmall.copyWith(color: context.inkTertiary),
            ),
          ],
        ),
      ),
    );
  }
}
