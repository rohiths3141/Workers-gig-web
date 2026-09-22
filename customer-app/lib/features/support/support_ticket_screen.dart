import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers/providers.dart';
import '../../app/theme/app_colors.dart';
import '../../core/errors/result.dart';
import '../../shared/widgets/empty_state.dart';

class SupportTicketScreen extends ConsumerStatefulWidget {
  final String ticketId;
  final String? subject;

  const SupportTicketScreen({super.key, required this.ticketId, this.subject});

  @override
  ConsumerState<SupportTicketScreen> createState() => _SupportTicketScreenState();
}

class _SupportTicketScreenState extends ConsumerState<SupportTicketScreen> {
  final _messageController = TextEditingController();
  bool _isSending = false;

  Future<void> _send() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() => _isSending = true);
    final res = await ref.read(supportRepositoryProvider).postMessage(widget.ticketId, text);
    if (!mounted) return;
    setState(() => _isSending = false);
    res.fold(
      (_) => _messageController.clear(),
      (failure) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message))),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(supportMessagesProvider(widget.ticketId));

    return Scaffold(
      appBar: AppBar(title: Text(widget.subject ?? 'Support Ticket')),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return const EmptyState(icon: Icons.forum_outlined, title: 'No messages yet');
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final m = messages[index];
                    return Align(
                      alignment: m.isFromCustomer ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        constraints: const BoxConstraints(maxWidth: 280),
                        decoration: BoxDecoration(
                          color: m.isFromCustomer ? AppColors.primary : Colors.white,
                          border: m.isFromCustomer ? null : Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          m.body,
                          style: TextStyle(color: m.isFromCustomer ? Colors.white : AppColors.ink),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => ErrorState(
                message: 'Could not load messages.',
                onRetry: () => ref.invalidate(supportMessagesProvider(widget.ticketId)),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _isSending ? null : _send,
                    icon: const Icon(Icons.send, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
