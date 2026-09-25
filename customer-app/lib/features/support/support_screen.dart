import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers/providers.dart';
import '../../app/theme/app_colors.dart';
import '../../core/errors/result.dart';
import '../../domain/entities/enums.dart';
import '../../shared/widgets/empty_state.dart';
import '../../core/localization/l10n.dart';

class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketsAsync = ref.watch(myTicketsProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.supportTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNewTicketSheet(context, ref),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(l10n.supportNewTicket, style: const TextStyle(color: Colors.white)),
      ),
      body: ticketsAsync.when(
        data: (tickets) {
          if (tickets.isEmpty) {
            return EmptyState(
              icon: Icons.support_agent_outlined,
              title: l10n.supportEmpty,
              message: l10n.supportEmptyMessage,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final t = tickets[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: ListTile(
                  title: Text(t.subject, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('#${t.ticketCode} · ${t.category.label}', style: const TextStyle(fontSize: 12)),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (t.status.isOpen ? AppColors.statusPending : AppColors.statusSuccess).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _statusLabel(l10n, t.status).toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: t.status.isOpen ? AppColors.statusPending : AppColors.statusSuccess,
                      ),
                    ),
                  ),
                  onTap: () => context.push('/profile/support/${t.id}', extra: t.subject),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => ErrorState(
          message: l10n.supportLoadFailed,
          onRetry: () => ref.invalidate(myTicketsProvider),
        ),
      ),
    );
  }

  static String _statusLabel(AppLocalizations l10n, SupportStatus status) =>
      switch (status) {
        SupportStatus.open => l10n.supportStatusOpen,
        SupportStatus.inProgress => l10n.supportStatusInProgress,
        SupportStatus.waitingForUser => l10n.supportStatusWaitingForYou,
        SupportStatus.resolved => l10n.supportStatusResolved,
        SupportStatus.closed => l10n.supportStatusClosed,
      };

  void _openNewTicketSheet(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final subjectController = TextEditingController();
    final messageController = TextEditingController();
    SupportCategory category = SupportCategory.other;
    bool isSubmitting = false;
    String? error;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.supportNewTicketTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              DropdownButtonFormField<SupportCategory>(
                initialValue: category,
                decoration: InputDecoration(labelText: l10n.supportCategory, border: const OutlineInputBorder()),
                // Not `.values`: the enum also carries the categories support
                // staff can move a ticket into, and offering a customer
                // "Payout" or "Verification" would be nonsense.
                items: SupportCategory.customerSelectable
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.label)))
                    .toList(),
                onChanged: (val) => setSheetState(() => category = val ?? category),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: subjectController,
                decoration: InputDecoration(labelText: l10n.supportSubject, border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: messageController,
                maxLines: 4,
                decoration: InputDecoration(labelText: l10n.supportDescribeIssue, border: const OutlineInputBorder()),
              ),
              if (error != null) ...[
                const SizedBox(height: 8),
                Text(error!, style: const TextStyle(color: AppColors.statusError, fontSize: 12)),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (subjectController.text.trim().length < 3 || messageController.text.trim().isEmpty) {
                            setSheetState(() => error = l10n.supportFillSubjectMessage);
                            return;
                          }
                          setSheetState(() {
                            isSubmitting = true;
                            error = null;
                          });
                          final res = await ref.read(supportRepositoryProvider).createTicket(
                                subject: subjectController.text.trim(),
                                category: category,
                                message: messageController.text.trim(),
                              );
                          switch (res) {
                            case Ok():
                              ref.invalidate(myTicketsProvider);
                              if (ctx.mounted) Navigator.pop(ctx);
                            case Err(:final failure):
                              setSheetState(() {
                                isSubmitting = false;
                                error = failure.message;
                              });
                          }
                        },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: isSubmitting
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(l10n.supportSubmitTicket),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
