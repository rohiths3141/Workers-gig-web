import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/localization/l10n.dart';
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
    final l10n = context.l10n;
    final tickets = ref.watch(ticketsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsHelp)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _newTicket(context, ref),
        icon: const Icon(Icons.add_comment_outlined),
        label: Text(l10n.supportNewRequest),
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
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xxxl),
                child: EmptyStateView(
                  icon: Icons.support_agent_rounded,
                  title: l10n.supportEmpty,
                  message: l10n.supportEmptyBody,
                ),
              )
            else ...[
              SectionHeader(title: l10n.supportYourRequests),
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
    final l10n = context.l10n;
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
              Text(l10n.supportEmergency,
                  style: AppTypography.titleMedium
                      .copyWith(color: AppColors.danger)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.supportEmergencyBody,
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
                  label: Text(l10n.supportCall112),
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
                  label: Text(l10n.supportPolice),
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
    final l10n = context.l10n;
    final (label, color) = switch (ticket.status) {
      SupportStatus.open => (l10n.ticketOpen, AppColors.info),
      SupportStatus.inProgress => (l10n.ticketInProgress, AppColors.info),
      SupportStatus.waitingForUser =>
        (l10n.ticketReplyNeeded, AppColors.warning),
      SupportStatus.resolved => (l10n.ticketResolved, AppColors.success),
      SupportStatus.closed => (l10n.ticketClosed, AppColors.inkTertiary),
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
            l10n.ticketLastUpdate(DateFormat('d MMM, h:mm a', context.dateLocale)
                .format(ticket.lastMessageAt)),
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

  static List<(SupportCategory, String)> _categories(AppLocalizations l10n) => [
        (SupportCategory.booking, l10n.supportCategoryJob),
        (SupportCategory.payment, l10n.supportCategoryPayment),
        (SupportCategory.payout, l10n.supportCategoryWithdrawal),
        (SupportCategory.verification, l10n.verificationTitle),
        (SupportCategory.account, l10n.supportCategoryAccount),
        (SupportCategory.safety, l10n.supportCategorySafety),
        (SupportCategory.appIssue, l10n.supportCategoryApp),
        (SupportCategory.other, l10n.supportCategoryOther),
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
        showSuccess(context, context.l10n.supportRaised(ticket.ticketCode));
      },
      (failure) => showFailure(context, failure.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.supportHowHelp,
                style:
                    AppTypography.headlineMedium.copyWith(color: context.ink)),
            const SizedBox(height: AppSpacing.xl),
            Text(l10n.supportAbout,
                style: AppTypography.label.copyWith(color: context.inkSecondary)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final (value, label) in _categories(l10n))
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
              decoration: InputDecoration(
                labelText: l10n.supportSubject,
                hintText: l10n.supportSubjectHint,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _message,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.supportWhatHappened,
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
                  : Text(l10n.supportSend),
            ),
          ],
        ),
      ),
    );
  }
}
