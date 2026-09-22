import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/support.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/common_widgets.dart';
import 'support_controller.dart';

/// Support.
class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickets = ref.watch(ticketsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Help and support')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _newTicket(context, ref),
        icon: const Icon(Icons.add_comment_outlined),
        label: const Text('New request'),
      ),
      body: AsyncValueView<List<SupportTicket>>(
        value: tickets,
        onRetry: () => ref.invalidate(ticketsProvider),
        loading: const ListSkeleton(itemHeight: 88),
        onData: (items) => ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.screenPadding,
            AppSpacing.screenPadding,
            AppSpacing.huge * 2,
          ),
          children: [
            const _EmergencyCard(),
            const SizedBox(height: AppSpacing.xl),

            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: AppSpacing.xxxl),
                child: EmptyStateView(
                  icon: Icons.support_agent_rounded,
                  title: 'No requests yet',
                  message:
                      'If something goes wrong with a job, a payment or your account, raise a request and we will help.',
                ),
              )
            else ...[
              const SectionHeader(title: 'Your requests'),
              for (final ticket in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _TicketTile(ticket: ticket),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _newTicket(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const _NewTicketSheet(),
      ),
    );
  }
}

/// Emergency contact.
///
/// This is deliberately not an in-app SOS button. There is no dispatch
/// integration behind this product, no location transmission and no incident
/// record, so a button that looked like one would be worse than useless — a
/// worker in trouble would press it and wait for help that was never coming.
/// Instead it dials the real emergency services, and says plainly what the app
/// can and cannot do.
class _EmergencyCard extends StatelessWidget {
  const _EmergencyCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderColor: AppColors.danger.withValues(alpha: 0.3),
      backgroundColor: AppColors.dangerSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emergency_outlined, color: AppColors.danger),
              const SizedBox(width: AppSpacing.md),
              Text('In an emergency',
                  style: AppTypography.titleMedium
                      .copyWith(color: AppColors.danger)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'This app cannot call for help on your behalf. If you are in danger, call the emergency services directly.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.danger),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _dial('112'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.danger),
                  ),
                  icon: const Icon(Icons.call_rounded),
                  label: const Text('Call 112'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _dial('100'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.danger),
                  ),
                  icon: const Icon(Icons.local_police_outlined),
                  label: const Text('Police'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _dial(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}

class _TicketTile extends StatelessWidget {
  const _TicketTile({required this.ticket});

  final SupportTicket ticket;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (ticket.status) {
      SupportStatus.open => ('OPEN', AppColors.info),
      SupportStatus.inProgress => ('IN PROGRESS', AppColors.info),
      SupportStatus.waitingForUser => ('YOUR REPLY NEEDED', AppColors.warning),
      SupportStatus.resolved => ('RESOLVED', AppColors.success),
      SupportStatus.closed => ('CLOSED', AppColors.inkTertiary),
    };

    return AppCard(
      onTap: () => context.push(Routes.ticket(ticket.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusBadge(label: label, color: color),
              const Spacer(),
              Text(ticket.ticketCode,
                  style: AppTypography.bodySmall
                      .copyWith(color: context.inkTertiary)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(ticket.subject,
              style: AppTypography.titleMedium.copyWith(color: context.ink)),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Last update ${DateFormat('d MMM, h:mm a').format(ticket.lastMessageAt)}',
            style: AppTypography.bodySmall.copyWith(color: context.inkSecondary),
          ),
        ],
      ),
    );
  }
}

class _NewTicketSheet extends ConsumerStatefulWidget {
  const _NewTicketSheet();

  @override
  ConsumerState<_NewTicketSheet> createState() => _NewTicketSheetState();
}

class _NewTicketSheetState extends ConsumerState<_NewTicketSheet> {
  final _subject = TextEditingController();
  final _message = TextEditingController();
  SupportCategory _category = SupportCategory.other;
  bool _busy = false;

  static const _categories = [
    (SupportCategory.booking, 'A job'),
    (SupportCategory.payment, 'A payment'),
    (SupportCategory.payout, 'A withdrawal'),
    (SupportCategory.verification, 'Verification'),
    (SupportCategory.account, 'My account'),
    (SupportCategory.safety, 'Safety'),
    (SupportCategory.appIssue, 'The app'),
    (SupportCategory.other, 'Something else'),
  ];

  @override
  void dispose() {
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _busy = true);

    final result = await ref.read(supportControllerProvider.notifier).createTicket(
          subject: _subject.text,
          category: _category,
          message: _message.text,
        );

    if (!mounted) return;
    setState(() => _busy = false);

    result.fold(
      (ticket) {
        Navigator.of(context).pop();
        showSuccess(context, 'Request ${ticket.ticketCode} raised.');
      },
      (failure) => showFailure(context, failure.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How can we help?',
                style:
                    AppTypography.headlineMedium.copyWith(color: context.ink)),
            const SizedBox(height: AppSpacing.xl),
            Text('What is it about?',
                style: AppTypography.label.copyWith(color: context.inkSecondary)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final (value, label) in _categories)
                  ChoiceChip(
                    label: Text(label),
                    selected: _category == value,
                    onSelected: (_) => setState(() => _category = value),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _subject,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Subject',
                hintText: 'A few words about the problem',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _message,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'What happened?',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: _busy ? null : _submit,
              child: _busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Text('Send request'),
            ),
          ],
        ),
      ),
    );
  }
}
