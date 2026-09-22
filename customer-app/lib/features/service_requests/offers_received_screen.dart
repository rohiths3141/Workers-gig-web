import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers/providers.dart';
import '../../app/theme/app_colors.dart';
import '../../core/errors/result.dart';
import '../../domain/entities/service_request_offer.dart';
import '../../shared/widgets/empty_state.dart';

/// Displays all offers received for a service request.
/// Customer can compare offers and accept/reject them.
class OffersReceivedScreen extends ConsumerWidget {
  const OffersReceivedScreen({super.key, required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersAsync = ref.watch(offersForRequestStreamProvider(requestId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers Received'),
      ),
      body: offersAsync.when(
        data: (offers) {
          if (offers.isEmpty) {
            return const EmptyState(
              icon: Icons.local_offer_outlined,
              title: 'No offers yet',
              message:
                  'Workers are reviewing your request. You\'ll be notified when someone responds.',
            );
          }

          final pending = offers.where((o) => o.canBeAccepted).toList();
          final other = offers.where((o) => !o.canBeAccepted).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (pending.isNotEmpty) ...[
                const Text(
                  'Pending Offers',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 12),
                ...pending.map(
                    (o) => _OfferCard(offer: o, requestId: requestId)),
              ],
              if (other.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text(
                  'Past Offers',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.inkSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                ...other.map(
                    (o) => _OfferCard(offer: o, requestId: requestId)),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _OfferCard extends ConsumerStatefulWidget {
  const _OfferCard({required this.offer, required this.requestId});

  final ServiceRequestOffer offer;
  final String requestId;

  @override
  ConsumerState<_OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends ConsumerState<_OfferCard> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final o = widget.offer;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: o.canBeAccepted
              ? AppColors.primary.withOpacity(0.3)
              : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Worker info row
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  o.workerInitial,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      o.workerDisplayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                      ),
                    ),
                    Row(
                      children: [
                        if (o.workerRating != null) ...[
                          const Icon(Icons.star, size: 14, color: AppColors.accentGold),
                          const SizedBox(width: 2),
                          Text(
                            o.workerRating!.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (o.workerJobsCompleted != null)
                          Text(
                            '${o.workerJobsCompleted} jobs',
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.inkSecondary),
                          ),
                        if (o.workerCity != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            o.workerCity!,
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.inkSecondary),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    o.priceLabel,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  if (o.durationLabel.isNotEmpty)
                    Text(
                      o.durationLabel,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.inkSecondary),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Verification badges
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              if (o.isKycVerified)
                _badge(Icons.verified_user, 'KYC Verified'),
              if (o.isBackgroundVerified)
                _badge(Icons.shield, 'Background Verified'),
              if (o.isInsured) _badge(Icons.health_and_safety, 'Insured'),
              if (o.gigTitle != null)
                _badge(Icons.work_outline, o.gigTitle!),
            ],
          ),

          // Message
          if (o.message != null && o.message!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.message_outlined,
                      size: 16, color: AppColors.inkSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      o.message!,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.ink),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Status / Action buttons
          if (!o.canBeAccepted) ...[
            const SizedBox(height: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                o.status.customerLabel,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.inkSecondary),
              ),
            ),
          ],
          if (o.canBeAccepted) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _loading ? null : () => _reject(o.id),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: _loading ? null : () => _accept(o.id),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Accept Offer'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _badge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(text,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.primary)),
        ],
      ),
    );
  }

  Future<void> _accept(String offerId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Accept this offer?'),
        content: Text(
            'A booking will be created with ${widget.offer.workerDisplayName} '
            'at ${widget.offer.priceLabel}. All other offers will be closed.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary),
            child: const Text('Accept'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _loading = true);
    final result = await ref
        .read(serviceRequestOfferRepositoryProvider)
        .acceptOffer(offerId);

    if (!mounted) return;
    setState(() => _loading = false);

    switch (result) {
      case Ok(value: final booking):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Booking ${booking.bookingCode} created!'),
            backgroundColor: AppColors.successGreen,
          ),
        );
        context.go('/bookings/${booking.id}/active');
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            backgroundColor: Colors.red,
          ),
        );
    }
  }

  Future<void> _reject(String offerId) async {
    setState(() => _loading = true);
    final result = await ref
        .read(serviceRequestOfferRepositoryProvider)
        .rejectOffer(offerId);

    if (!mounted) return;
    setState(() => _loading = false);

    switch (result) {
      case Ok():
        break;
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            backgroundColor: Colors.red,
          ),
        );
    }
  }
}
