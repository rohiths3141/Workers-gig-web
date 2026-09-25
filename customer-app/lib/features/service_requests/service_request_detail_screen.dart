import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers/providers.dart';
import '../../app/theme/app_colors.dart';
import '../../core/errors/result.dart';
import '../../domain/entities/enums.dart';
import '../../shared/widgets/service_icon.dart';
import '../../core/localization/l10n.dart';

/// Detail view for a single service request. Shows live offer count,
/// status, and a CTA to view offers.
class ServiceRequestDetailScreen extends ConsumerWidget {
  const ServiceRequestDetailScreen({super.key, required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestAsync = ref.watch(serviceRequestStreamProvider(requestId));
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.requestDetailTitle),
      ),
      body: requestAsync.when(
        data: (request) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: request.status.isOpen ? AppColors.success : AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${request.requestCode}',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8), fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        request.status.customerLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (request.expiresAt != null &&
                          request.status.isOpen) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.timer, color: Colors.white70, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              _expiresLabel(l10n, request.expiresAt!),
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  request.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  request.description,
                  style: const TextStyle(
                      color: AppColors.inkSecondary, fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 20),

                // Details card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _detailRow(Icons.category_rounded, l10n.supportCategory,
                          localizedServiceName(l10n, request.categoryName)),
                      _detailRow(Icons.currency_rupee, l10n.requestDetailBudget, request.budgetLabel),
                      _detailRow(Icons.schedule, l10n.requestDetailSchedule, request.scheduleLabel),
                      if (request.timeWindowLabel.isNotEmpty)
                        _detailRow(Icons.access_time, l10n.paymentTime, request.timeWindowLabel),
                      _detailRow(Icons.location_on, l10n.requestDetailLocation,
                          '${request.addressLine}${request.city != null ? ', ${request.city}' : ''}'),
                      if (request.additionalNotes != null)
                        _detailRow(Icons.note, l10n.requestDetailNotes, request.additionalNotes!),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Offers section
                _buildOffersCard(context, request.offerCount, request.status),

                const SizedBox(height: 20),

                // Cancel button
                if (request.canCancel)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmCancel(context, ref),
                      icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                      label: Text(l10n.requestDetailCancel,
                          style: const TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.commonErrorDetail('$e'))),
      ),
    );
  }

  Widget _buildOffersCard(
      BuildContext context, int offerCount, ServiceRequestStatus status) {
    final l10n = context.l10n;
    return GestureDetector(
      onTap: offerCount > 0
          ? () => context.push('/my-requests/$requestId/offers')
          : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: offerCount > 0 ? AppColors.primary : AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Text(
                '$offerCount',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: offerCount > 0 ? Colors.white : AppColors.inkSecondary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.requestDetailOffersReceived(offerCount),
                    style: TextStyle(
                      color:
                          offerCount > 0 ? Colors.white : AppColors.ink,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    offerCount > 0
                        ? l10n.requestDetailTapToCompare
                        : l10n.requestDetailWorkersSoon,
                    style: TextStyle(
                      color: offerCount > 0
                          ? Colors.white70
                          : AppColors.inkSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (offerCount > 0)
              const Icon(Icons.arrow_forward_ios,
                  color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          SizedBox(
            width: 76,
            child: Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.inkSecondary,
                    fontSize: 13)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: AppColors.ink, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmCancel(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.requestCancelDialogTitle),
        content: Text(l10n.requestCancelDialogBody),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.requestCancelKeep)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.requestCancelConfirm,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final result = await ref
          .read(serviceRequestRepositoryProvider)
          .cancelServiceRequest(requestId);
      if (context.mounted) {
        switch (result) {
          case Ok():
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(l10n.requestCancelled),
              backgroundColor: AppColors.success,
            ));
          case Err(:final failure):
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(failure.message),
              backgroundColor: Colors.red,
            ));
        }
      }
    }
  }

  String _expiresLabel(AppLocalizations l10n, DateTime target) {
    final diff = target.difference(DateTime.now());
    if (diff.inDays > 0) {
      return l10n.requestExpiresInDaysHours(diff.inDays, diff.inHours % 24);
    }
    if (diff.inHours > 0) {
      return l10n.requestExpiresInHoursMinutes(diff.inHours, diff.inMinutes % 60);
    }
    if (diff.inMinutes > 0) return l10n.requestExpiresInMinutes(diff.inMinutes);
    return l10n.requestExpiresSoon;
  }
}
