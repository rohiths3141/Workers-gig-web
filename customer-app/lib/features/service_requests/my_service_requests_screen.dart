import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers/providers.dart';
import '../../app/theme/app_colors.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/service_request.dart';
import '../../shared/widgets/empty_state.dart';

/// Lists the customer's own service requests with tab filtering.
class MyServiceRequestsScreen extends ConsumerWidget {
  const MyServiceRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(myServiceRequestsStreamProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Service Requests'),
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.inkSecondary,
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
              Tab(text: 'All'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/post-request'),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('New Request',
              style: TextStyle(color: Colors.white)),
        ),
        body: requestsAsync.when(
          data: (requests) {
            final active = requests.where((r) => r.status.isActive).toList();
            final completed =
                requests.where((r) => r.status.isTerminal || r.status == ServiceRequestStatus.booked).toList();

            return TabBarView(
              children: [
                _buildList(context, active, 'No active requests'),
                _buildList(context, completed, 'No completed requests'),
                _buildList(context, requests, 'No service requests yet'),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) =>
              Center(child: Text('Failed to load: $e')),
        ),
      ),
    );
  }

  Widget _buildList(
      BuildContext context, List<ServiceRequest> requests, String emptyText) {
    if (requests.isEmpty) {
      return EmptyState(
        icon: Icons.post_add_rounded,
        title: emptyText,
        message: 'Post a requirement and let workers come to you.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) =>
          _RequestCard(request: requests[index]),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request});

  final ServiceRequest request;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/my-requests/${request.id}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    request.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _StatusChip(status: request.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              request.description,
              style: const TextStyle(color: AppColors.inkSecondary, fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _infoChip(Icons.category_rounded, request.categoryName),
                const SizedBox(width: 8),
                _infoChip(Icons.currency_rupee, request.budgetLabel),
                const Spacer(),
                _infoChip(
                    Icons.people_outline, request.offerCountLabel),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _infoChip(Icons.schedule, request.scheduleLabel),
                const Spacer(),
                Text(
                  '#${request.requestCode}',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.inkSecondary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.inkSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final ServiceRequestStatus status;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg) = switch (status) {
      ServiceRequestStatus.open ||
      ServiceRequestStatus.receivingOffers =>
        (AppColors.successGreen.withOpacity(0.1), AppColors.successGreen),
      ServiceRequestStatus.workerSelected ||
      ServiceRequestStatus.booked =>
        (AppColors.primary.withOpacity(0.1), AppColors.primary),
      ServiceRequestStatus.cancelled ||
      ServiceRequestStatus.expired =>
        (Colors.red.withOpacity(0.1), Colors.red),
      _ => (AppColors.border, AppColors.inkSecondary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.customerLabel,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}
