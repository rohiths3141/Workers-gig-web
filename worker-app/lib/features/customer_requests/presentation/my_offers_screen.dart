import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/providers.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/localization/l10n.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/worker_offer.dart';

/// Lists all offers the current worker has submitted.
class MyOffersScreen extends ConsumerStatefulWidget {
  const MyOffersScreen({super.key});

  @override
  ConsumerState<MyOffersScreen> createState() => _MyOffersScreenState();
}

class _MyOffersScreenState extends ConsumerState<MyOffersScreen> {
  List<WorkerOffer>? _offers;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await ref.read(workerOfferRepositoryProvider).getMyOffers();
    if (!mounted) return;
    result.fold(
      (offers) => setState(() {
        _offers = offers;
        _loading = false;
      }),
      (failure) => setState(() {
        _error = failure.message;
        _loading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.homeMyOffers),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: context.l10n.requestsRefresh,
            onPressed: _load,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final l10n = context.l10n;
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(onPressed: _load, child: Text(l10n.commonRetry)),
            ],
          ),
        ),
      );
    }
    if (_offers == null || _offers!.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_offer_outlined,
                size: 64, color: AppColors.inkTertiary),
            const SizedBox(height: 12),
            Text(
              l10n.jobsEmptyOffers,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              l10n.offersEmptyBody,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.inkSecondary),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _offers!.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final offer = _offers![index];
          return _OfferCard(
            offer: offer,
            onWithdrawn: _load,
          );
        },
      ),
    );
  }
}

class _OfferCard extends ConsumerStatefulWidget {
  const _OfferCard({required this.offer, required this.onWithdrawn});

  final WorkerOffer offer;
  final VoidCallback onWithdrawn;

  @override
  ConsumerState<_OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends ConsumerState<_OfferCard> {
  bool _withdrawing = false;

  @override
  Widget build(BuildContext context) {
    final o = widget.offer;

    final (Color statusBg, Color statusFg) = switch (o.status) {
      OfferStatus.submitted ||
      OfferStatus.viewed ||
      OfferStatus.shortlisted =>
        (AppColors.primarySurface, AppColors.primary),
      OfferStatus.accepted =>
        (AppColors.successSurface, AppColors.success),
      OfferStatus.rejected =>
        (AppColors.dangerSurface, AppColors.danger),
      OfferStatus.withdrawn =>
        (AppColors.warningSurface, AppColors.warning),
      _ => (AppColors.surfaceMuted, AppColors.inkTertiary),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Request title
          if (o.requestTitle != null)
            Text(
              o.requestTitle!,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.ink,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          if (o.requestCode != null) ...[
            const SizedBox(height: 2),
            Text(
              '#${o.requestCode}',
              style: TextStyle(fontSize: 11, color: AppColors.inkTertiary),
            ),
          ],
          const SizedBox(height: 10),

          // Price and status
          Row(
            children: [
              Text(
                o.priceLabel,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              if (o.durationLabel.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(
                  o.durationLabel,
                  style: TextStyle(
                      fontSize: 12, color: AppColors.inkSecondary),
                ),
              ],
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  o.statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusFg,
                  ),
                ),
              ),
            ],
          ),

          // Message
          if (o.message != null && o.message!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              o.message!,
              style: TextStyle(fontSize: 13, color: AppColors.inkSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // Withdraw button
          if (o.canWithdraw) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _withdrawing ? null : _withdraw,
                icon: _withdrawing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.undo, size: 16),
                label: Text(context.l10n.offerWithdraw),
                style: TextButton.styleFrom(foregroundColor: AppColors.warning),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _withdraw() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.offerWithdrawTitle),
        content: Text(ctx.l10n.offerWithdrawBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(ctx.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(ctx.l10n.offerWithdraw,
                style: const TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _withdrawing = true);
    final result = await ref
        .read(workerOfferRepositoryProvider)
        .withdrawOffer(widget.offer.id);

    if (!mounted) return;
    setState(() => _withdrawing = false);

    result.fold(
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(context.l10n.offerWithdrawn),
          backgroundColor: AppColors.success,
        ));
        widget.onWithdrawn();
      },
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(failure.message),
          backgroundColor: AppColors.danger,
        ));
      },
    );
  }
}
