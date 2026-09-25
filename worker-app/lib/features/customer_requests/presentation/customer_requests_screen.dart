import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/providers.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/localization/l10n.dart';
import '../../../domain/entities/customer_service_request.dart';
import '../../../shared/widgets/service_names.dart';

/// Discovery feed showing nearby customer service requests that match
/// the worker's registered services.
class CustomerRequestsScreen extends ConsumerStatefulWidget {
  const CustomerRequestsScreen({super.key});

  @override
  ConsumerState<CustomerRequestsScreen> createState() =>
      _CustomerRequestsScreenState();
}

class _CustomerRequestsScreenState
    extends ConsumerState<CustomerRequestsScreen> {
  List<CustomerServiceRequest>? _requests;
  bool _loading = true;
  bool _locationDenied = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  /// Never falls back to an invented coordinate — if location cannot be
  /// resolved, the caller shows a real "grant location" state instead of
  /// silently discovering requests around a fake city.
  Future<Position?> _currentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _loadRequests() async {
    setState(() {
      _loading = true;
      _error = null;
      _locationDenied = false;
    });

    final position = await _currentPosition();
    if (position == null) {
      if (!mounted) return;
      setState(() {
        _locationDenied = true;
        _loading = false;
      });
      return;
    }

    final result = await ref
        .read(customerRequestDiscoveryProvider)
        .findEligibleRequests(
          latitude: position.latitude,
          longitude: position.longitude,
        );

    if (!mounted) return;
    result.fold(
      (requests) => setState(() {
        _requests = requests;
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
        title: Text(context.l10n.requestsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: context.l10n.requestsRefresh,
            onPressed: _loadRequests,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final l10n = context.l10n;
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_locationDenied) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_off_outlined,
                  size: 64, color: AppColors.inkTertiary),
              const SizedBox(height: 12),
              Text(
                l10n.requestsLocationNeeded,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.requestsLocationBody,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.inkSecondary),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _loadRequests,
                child: Text(l10n.requestsGrantLocation),
              ),
            ],
          ),
        ),
      );
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _loadRequests,
                child: Text(l10n.commonRetry),
              ),
            ],
          ),
        ),
      );
    }
    if (_requests == null || _requests!.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined,
                size: 64, color: AppColors.inkTertiary),
            const SizedBox(height: 12),
            Text(
              l10n.requestsEmpty,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.requestsEmptyBody,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.inkSecondary),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRequests,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _requests!.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) =>
            _RequestCard(request: _requests![index]),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request});
  final CustomerServiceRequest request;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GestureDetector(
      onTap: () => context.push(
        '/customer-requests/${request.id}',
        extra: request,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    request.budgetLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Description preview
            Text(
              request.description,
              style: TextStyle(color: AppColors.inkSecondary, fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // Info chips row
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _chip(Icons.category_rounded,
                    localizedServiceName(l10n, request.categoryName)),
                _chip(Icons.schedule, request.scheduleLabel),
                if (request.distanceLabel.isNotEmpty)
                  _chip(Icons.location_on, request.distanceLabel),
                if (request.city != null) _chip(Icons.place, request.city!),
              ],
            ),
            const SizedBox(height: 8),

            // Offer count and CTA
            Row(
              children: [
                Text(
                  request.offerCountLabel,
                  style: TextStyle(fontSize: 12, color: AppColors.inkTertiary),
                ),
                const Spacer(),
                Text(
                  l10n.requestsViewOffer,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.inkTertiary),
          const SizedBox(width: 4),
          Text(text,
              style: TextStyle(fontSize: 11, color: AppColors.inkSecondary)),
        ],
      ),
    );
  }
}
