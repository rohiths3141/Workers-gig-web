import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers/providers.dart';
import '../../app/theme/app_colors.dart';
import '../../domain/entities/gig_card.dart';
import '../../shared/widgets/empty_state.dart';

const _searchRadiiKm = [5.0, 10.0, 20.0];

class GigDiscoveryScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> request;
  const GigDiscoveryScreen({super.key, required this.request});

  @override
  ConsumerState<GigDiscoveryScreen> createState() => _GigDiscoveryScreenState();
}

class _GigDiscoveryScreenState extends ConsumerState<GigDiscoveryScreen> {
  int _radiusIndex = 0;

  @override
  Widget build(BuildContext context) {
    final lat = (widget.request['latitude'] as num?)?.toDouble();
    final lng = (widget.request['longitude'] as num?)?.toDouble();
    final serviceId = widget.request['serviceId'] as String?;
    final serviceName = widget.request['serviceName'] as String?;

    if (lat == null || lng == null || serviceId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Available Professionals')),
        body: ErrorState(
          message: 'Missing service or location details.',
          onRetry: () => context.pop(),
        ),
      );
    }

    final radiusKm = _searchRadiiKm[_radiusIndex];
    final gigsAsync = ref.watch(
      gigDiscoveryProvider(
        (serviceId: serviceId, lat: lat, lng: lng, radiusKm: radiusKm),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(serviceName ?? 'Available Local Experts')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  const Text(
                    'Within',
                    style: TextStyle(fontSize: 13, color: AppColors.inkSecondary),
                  ),
                  const SizedBox(width: 8),
                  ..._searchRadiiKm.asMap().entries.map((entry) {
                    final selected = entry.key == _radiusIndex;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text('${entry.value.toStringAsFixed(0)} km'),
                        selected: selected,
                        onSelected: (_) => setState(() => _radiusIndex = entry.key),
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : AppColors.ink,
                          fontWeight: FontWeight.w600,
                        ),
                        backgroundColor: AppColors.surfaceMuted,
                        side: BorderSide.none,
                      ),
                    );
                  }),
                ],
              ),
            ),
            Expanded(
              child: gigsAsync.when(
                data: (gigs) {
                  if (gigs.isEmpty) {
                    return EmptyState(
                      icon: Icons.person_search_outlined,
                      title: 'No providers available nearby',
                      message: 'Try a larger search radius or check back later.',
                    );
                  }
                  // One card per professional, not per gig. A worker who
                  // sells two matching services used to appear twice and
                  // read as two different people.
                  final byWorker = _groupByWorker(gigs);
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: byWorker.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _WorkerCard(
                        gigs: byWorker[i],
                        onBook: (gig) => _openGig(context, gig),
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => ErrorState(
                  message: 'Could not load nearby providers.',
                  onRetry: () => ref.invalidate(
                    gigDiscoveryProvider(
                      (serviceId: serviceId, lat: lat, lng: lng, radiusKm: radiusKm),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Collapses the gig list into one entry per worker, keeping the order the
  /// server returned (nearest first) and each worker's services in the same
  /// order they arrived.
  static List<List<GigCard>> _groupByWorker(List<GigCard> gigs) {
    final grouped = <String, List<GigCard>>{};
    for (final gig in gigs) {
      grouped.putIfAbsent(gig.workerId, () => <GigCard>[]).add(gig);
    }
    return grouped.values.toList(growable: false);
  }

  void _openGig(BuildContext context, GigCard gig) {
    final gigData = {
      'gigId': gig.gigId,
      'workerId': gig.workerId,
      'workerName': gig.workerName,
      'serviceTitle': gig.title,
      'priceLabel': gig.priceLabel,
      'rating': gig.workerRating,
      'ratingCount': gig.workerRatingCount,
      'distanceLabel': gig.distanceLabel,
      'isKycVerified': gig.isKycVerified,
      'isBackgroundVerified': gig.isBackgroundVerified,
      'workerPhotoUrl': gig.workerPhotoUrl,
      'request': widget.request,
    };
    context.push('/gigs/${gig.gigId}', extra: gigData);
  }
}

/// One professional and every matching service they sell.
///
/// The header is the person (avatar, name, rating, distance); each service
/// they offer for this request gets its own priced row with its own Book
/// action, so two services never look like two different workers.
class _WorkerCard extends StatelessWidget {
  const _WorkerCard({required this.gigs, required this.onBook});

  final List<GigCard> gigs;
  final void Function(GigCard gig) onBook;

  @override
  Widget build(BuildContext context) {
    final worker = gigs.first;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primarySurface,
                backgroundImage: worker.workerPhotoUrl != null
                    ? NetworkImage(worker.workerPhotoUrl!)
                    : null,
                child: worker.workerPhotoUrl == null
                    ? Text(
                        worker.workerName.isNotEmpty
                            ? worker.workerName[0].toUpperCase()
                            : 'W',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      worker.workerName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, color: AppColors.ink),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: AppColors.star, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          '${worker.ratingLabel} (${worker.workerRatingCount})',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.inkSecondary),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.location_on,
                            color: AppColors.inkTertiary, size: 12),
                        Text(
                          worker.distanceLabel,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.inkSecondary),
                        ),
                      ],
                    ),
                    if (gigs.length > 1) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${gigs.length} services for this job',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.inkTertiary),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final gig in gigs)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: InkWell(
                onTap: () => onBook(gig),
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              gig.title,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.ink,
                                  fontWeight: FontWeight.w600),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              gig.priceLabel,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          onPressed: () => onBook(gig),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 32),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          child: const Text('Book'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
