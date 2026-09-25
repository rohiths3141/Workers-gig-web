import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../app/providers/providers.dart';
import '../../app/theme/app_colors.dart';
import '../../domain/entities/gig_card.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/service_icon.dart';
import '../../core/localization/l10n.dart';

enum _LocationState { loading, ready, serviceDisabled, permissionDenied }

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  bool _isMapView = true;
  String? _selectedCategoryId;
  String _selectedCategoryName = '';
  String _searchQuery = '';
  _LocationState _locationState = _LocationState.loading;
  LatLng? _position;
  String? _addressLine;
  String? _selectedGigId;

  @override
  void initState() {
    super.initState();
    _resolveLocation();
  }

  Future<void> _resolveLocation() async {
    setState(() => _locationState = _LocationState.loading);
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _locationState = _LocationState.serviceDisabled);
      return;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      setState(() => _locationState = _LocationState.permissionDenied);
      return;
    }
    try {
      final pos = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        _position = LatLng(pos.latitude, pos.longitude);
        _locationState = _LocationState.ready;
      });
      try {
        final placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
        if (mounted && placemarks.isNotEmpty) {
          final p = placemarks.first;
          setState(() {
            _addressLine = [p.street, p.subLocality, p.locality]
                .where((s) => s != null && s.trim().isNotEmpty)
                .join(', ');
          });
        }
      } catch (_) {
        // Address label is a convenience for the booking summary — the
        // real lat/lng is still used regardless.
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _locationState = _LocationState.permissionDenied);
    }
  }

  /// Builds the request context passed to GigDetailsScreen. Explore lets the
  /// customer browse by current location instead of a hand-picked service
  /// address — real GPS coordinates either way, never a fabricated one.
  Map<String, dynamic> _bookingExtra(GigCard gig, String categoryName) {
    return {
      'gigId': gig.gigId,
      'workerId': gig.workerId,
      'workerName': gig.workerName,
      'serviceTitle': gig.title,
      'priceLabel': gig.priceLabel,
      'rating': gig.workerRating,
      'ratingCount': gig.workerRatingCount,
      'isKycVerified': gig.isKycVerified,
      'isBackgroundVerified': gig.isBackgroundVerified,
      'workerPhotoUrl': gig.workerPhotoUrl,
      'request': {
        'serviceId': _selectedCategoryId,
        'serviceName': categoryName,
        'description': '',
        'latitude': _position!.latitude,
        'longitude': _position!.longitude,
        'addressLine': _addressLine ??
            'Near ${_position!.latitude.toStringAsFixed(4)}, ${_position!.longitude.toStringAsFixed(4)}',
        'city': null,
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(serviceCategoriesProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.exploreTitle),
        actions: [
          IconButton(
            icon: Icon(_isMapView ? Icons.format_list_bulleted : Icons.map_outlined),
            tooltip: _isMapView ? l10n.exploreListView : l10n.exploreMapView,
            onPressed: () => setState(() => _isMapView = !_isMapView),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
                  decoration: InputDecoration(
                    hintText: l10n.exploreSearchHint,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(height: 8),
                categoriesAsync.when(
                  data: (categories) => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((cat) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(localizedServiceName(l10n, cat.name, slug: cat.slug)),
                            selected: _selectedCategoryId == cat.id,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategoryId = selected ? cat.id : null;
                                _selectedCategoryName = selected ? cat.name : '';
                                _selectedGigId = null;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          Expanded(child: _buildBody(context)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final l10n = context.l10n;
    switch (_locationState) {
      case _LocationState.loading:
        return const Center(child: CircularProgressIndicator());
      case _LocationState.serviceDisabled:
        return EmptyState(
          icon: Icons.location_disabled,
          title: l10n.exploreLocationOffTitle,
          message: l10n.exploreLocationOffMessage,
          actionLabel: l10n.commonRetry,
          onAction: _resolveLocation,
        );
      case _LocationState.permissionDenied:
        return EmptyState(
          icon: Icons.location_off_outlined,
          title: l10n.exploreLocationPermissionTitle,
          message: l10n.exploreLocationPermissionMessage,
          actionLabel: l10n.commonGrantPermission,
          onAction: _resolveLocation,
        );
      case _LocationState.ready:
        break;
    }

    if (_selectedCategoryId == null) {
      return EmptyState(
        icon: Icons.category_outlined,
        title: l10n.exploreChooseService,
        message: l10n.exploreChooseServiceMessage,
      );
    }

    final gigsAsync = ref.watch(
      gigDiscoveryProvider((
        serviceId: _selectedCategoryId!,
        lat: _position!.latitude,
        lng: _position!.longitude,
        radiusKm: 20,
      )),
    );

    return gigsAsync.when(
      data: (gigs) {
        final filtered = _searchQuery.isEmpty
            ? gigs
            : gigs.where((g) =>
                g.workerName.toLowerCase().contains(_searchQuery) ||
                g.title.toLowerCase().contains(_searchQuery)).toList();

        if (filtered.isEmpty) {
          return EmptyState(
            icon: Icons.person_search_outlined,
            title: l10n.exploreNoProfessionals,
          );
        }

        return _isMapView ? _buildMapView(filtered) : _buildListView(context, filtered);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => ErrorState(
        message: l10n.exploreLoadFailed,
        onRetry: () => ref.invalidate(gigDiscoveryProvider((
          serviceId: _selectedCategoryId!,
          lat: _position!.latitude,
          lng: _position!.longitude,
          radiusKm: 20,
        ))),
      ),
    );
  }

  Widget _buildMapView(List<GigCard> gigs) {
    final selected = gigs.where((g) => g.gigId == _selectedGigId).toList();
    final markers = gigs.map((gig) {
      return Marker(
        markerId: MarkerId(gig.gigId),
        position: LatLng(gig.approxLatitude, gig.approxLongitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          gig.gigId == _selectedGigId ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueBlue,
        ),
        onTap: () => setState(() => _selectedGigId = gig.gigId),
      );
    }).toSet();

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: _position!, zoom: 13.0),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          markers: markers,
        ),
        if (selected.isNotEmpty)
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: _GigMapCard(
              gig: selected.first,
              onView: () => context.push('/gigs/${selected.first.gigId}',
                  extra: _bookingExtra(selected.first, _selectedCategoryName)),
            ),
          ),
      ],
    );
  }

  Widget _buildListView(BuildContext context, List<GigCard> gigs) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: gigs.length,
      itemBuilder: (context, index) {
        final gig = gigs[index];
        return _GigListCard(
          gig: gig,
          selected: gig.gigId == _selectedGigId,
          onTap: () => setState(() => _selectedGigId = gig.gigId),
          onView: () => context.push('/gigs/${gig.gigId}', extra: _bookingExtra(gig, _selectedCategoryName)),
        );
      },
    );
  }
}

class _GigListCard extends StatelessWidget {
  const _GigListCard({required this.gig, required this.selected, required this.onTap, required this.onView});

  final GigCard gig;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: selected ? AppColors.primary : AppColors.border, width: selected ? 1.5 : 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                backgroundImage: gig.workerPhotoUrl != null ? NetworkImage(gig.workerPhotoUrl!) : null,
                child: gig.workerPhotoUrl == null
                    ? Text(
                        gig.workerName.isNotEmpty ? gig.workerName[0] : 'W',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 20),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(gig.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(context.l10n.exploreByWorker(gig.workerName), style: const TextStyle(color: AppColors.inkSecondary, fontSize: 13)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text('${gig.ratingLabel} (${gig.workerRatingCount})',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 12),
                        const Icon(Icons.location_on, color: AppColors.inkSecondary, size: 14),
                        const SizedBox(width: 2),
                        Text(gig.distanceLabel, style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(gig.priceLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: onView,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(context.l10n.commonView),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GigMapCard extends StatelessWidget {
  const _GigMapCard({required this.gig, required this.onView});

  final GigCard gig;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              backgroundImage: gig.workerPhotoUrl != null ? NetworkImage(gig.workerPhotoUrl!) : null,
              child: gig.workerPhotoUrl == null
                  ? Text(gig.workerName.isNotEmpty ? gig.workerName[0] : 'W',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary))
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(gig.workerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(gig.title, style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
                  Text('${gig.priceLabel} · ${gig.distanceLabel}',
                      style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onView,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                // Sized to its label: the themed infinite minimum width is an
                // invalid constraint inside a Row.
                minimumSize: const Size(0, 44),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: Text(context.l10n.commonView),
            ),
          ],
        ),
      ),
    );
  }
}
