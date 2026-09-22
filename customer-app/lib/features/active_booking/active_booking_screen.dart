import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/providers/providers.dart';
import '../../app/theme/app_colors.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/worker_location.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/status_timeline.dart';

class ActiveBookingScreen extends ConsumerWidget {
  final String bookingId;

  const ActiveBookingScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(bookingStreamProvider(bookingId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Booking & Worker Tracking'),
      ),
      body: bookingAsync.when(
        data: (booking) => _buildForBooking(context, ref, booking),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => ErrorState(
          message: 'Failed to load this booking.',
          onRetry: () => ref.invalidate(bookingStreamProvider(bookingId)),
        ),
      ),
    );
  }

  Widget _buildForBooking(BuildContext context, WidgetRef ref, Booking booking) {
    if (!booking.status.showLiveTracking) {
      return _buildPreTravelView(context, booking);
    }
    if (!booking.hasLocation) {
      // Booking has no service-location coordinates at all — cannot render
      // any map meaningfully. This should not happen for a real booking,
      // but never fabricate coordinates to paper over it.
      return _buildPreTravelView(context, booking, mapUnavailable: true);
    }

    final workerLocationAsync = ref.watch(workerLocationProvider(bookingId));
    return _buildLiveView(context, ref, booking, workerLocationAsync);
  }

  Widget _buildPreTravelView(BuildContext context, Booking booking, {bool mapUnavailable = false}) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Icon(
              booking.status.isTerminal ? Icons.event_busy_outlined : Icons.hourglass_top_rounded,
              size: 56,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              booking.serviceName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              booking.status.customerLabel,
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
            if (mapUnavailable) ...[
              const SizedBox(height: 8),
              const Text(
                'Live map unavailable for this booking.',
                style: TextStyle(color: AppColors.inkSecondary, fontSize: 12),
              ),
            ],
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => context.push('/bookings/${booking.id}'),
              child: const Text('View Booking Details'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveView(
    BuildContext context,
    WidgetRef ref,
    Booking booking,
    AsyncValue<WorkerLocation?> workerLocationAsync,
  ) {
    final customerLatLng = LatLng(booking.latitude!, booking.longitude!);
    final workerLocation = workerLocationAsync.valueOrNull;
    final hasFreshLocation = workerLocation != null && !workerLocation.isStale;
    final workerLatLng = workerLocation != null
        ? LatLng(workerLocation.latitude, workerLocation.longitude)
        : null;

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: customerLatLng, zoom: 14.5),
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          markers: {
            Marker(
              markerId: const MarkerId('customer'),
              position: customerLatLng,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
              infoWindow: const InfoWindow(title: 'Service location'),
            ),
            // Only ever render a worker marker for a real, received
            // location ping — never a synthesized/fake position.
            if (workerLatLng != null)
              Marker(
                markerId: const MarkerId('worker'),
                position: workerLatLng,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  hasFreshLocation ? BitmapDescriptor.hueAzure : BitmapDescriptor.hueOrange,
                ),
                infoWindow: InfoWindow(
                  title: booking.workerName ?? 'Your professional',
                  snippet: hasFreshLocation ? 'Live' : 'Last known location',
                ),
              ),
          },
          polylines: {
            if (workerLatLng != null)
              Polyline(
                polylineId: const PolylineId('route'),
                points: [customerLatLng, workerLatLng],
                width: 4,
                color: hasFreshLocation ? AppColors.primary : AppColors.inkSecondary,
              ),
          },
        ),

        // Location status banner
        Positioned(
          left: 12,
          right: 12,
          top: 12,
          child: _LocationStatusBanner(
            workerLocation: workerLocation,
            isLoading: workerLocationAsync.isLoading && workerLocation == null,
          ),
        ),

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: AppColors.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.workerName ?? booking.serviceName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              booking.status.customerLabel,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: booking.workerPhone == null
                            ? null
                            : () => launchUrl(Uri(scheme: 'tel', path: booking.workerPhone)),
                        icon: Icon(
                          Icons.phone_in_talk,
                          color: booking.workerPhone == null
                              ? AppColors.inkSecondary.withOpacity(0.4)
                              : AppColors.statusSuccess,
                        ),
                        tooltip: booking.workerPhone == null ? 'Phone not shared yet' : 'Call professional',
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  StatusTimeline(status: booking.status),
                  const SizedBox(height: 16),

                  if (booking.status == BookingStatus.arrived)
                    _ArrivalCodeCard(bookingId: booking.id),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => context.push('/bookings/${booking.id}/materials'),
                          icon: const Icon(Icons.build, size: 16),
                          label: const Text('Materials'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.push('/bookings/${booking.id}'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('View Details'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LocationStatusBanner extends StatefulWidget {
  const _LocationStatusBanner({required this.workerLocation, required this.isLoading});

  final WorkerLocation? workerLocation;
  final bool isLoading;

  @override
  State<_LocationStatusBanner> createState() => _LocationStatusBannerState();
}

class _LocationStatusBannerState extends State<_LocationStatusBanner> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    // Freshness must degrade with the clock even when no new ping arrives —
    // otherwise a genuinely dropped connection would go on reading "Live"
    // forever, which is exactly what a stale-location banner exists to catch.
    _ticker = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workerLocation = widget.workerLocation;
    final isLoading = widget.isLoading;
    final String text;
    final IconData icon;
    final Color color;

    if (isLoading) {
      text = 'Connecting to live location...';
      icon = Icons.sync;
      color = AppColors.inkSecondary;
    } else if (workerLocation == null) {
      text = 'Live location temporarily unavailable';
      icon = Icons.location_off_outlined;
      color = AppColors.statusError;
    } else {
      switch (workerLocation.freshness) {
        case LocationFreshness.live:
          text = 'Live location active';
          icon = Icons.gps_fixed;
          color = AppColors.statusSuccess;
        case LocationFreshness.updating:
          text = 'Updating...';
          icon = Icons.sync;
          color = AppColors.accentGold;
        case LocationFreshness.unavailable:
          text = 'Location temporarily unavailable';
          icon = Icons.location_off_outlined;
          color = AppColors.statusError;
      }
    }

    return Material(
      color: Colors.white,
      elevation: 3,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArrivalCodeCard extends ConsumerWidget {
  const _ArrivalCodeCard({required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeAsync = ref.watch(arrivalCodeProvider(bookingId));

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.accentGold.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Worker Arrived! Share Start Code:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            codeAsync.when(
              data: (code) => Text(
                code ?? '—',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 2,
                  color: AppColors.primary,
                ),
              ),
              loading: () => const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (_, __) => const Text('—'),
            ),
          ],
        ),
      ),
    );
  }
}
