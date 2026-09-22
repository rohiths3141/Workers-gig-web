import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../app/providers/providers.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/job.dart';
import '../../../domain/repositories/repositories.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/common_widgets.dart';
import 'jobs_controller.dart';

/// The in-app map shown while the worker is travelling to a job.
///
/// The destination is the booking's snapshotted service location — never the
/// customer's live/current position, which this app has no access to. The
/// route is fetched once on entry and only recomputed when the worker has
/// drifted meaningfully from it or it has gone stale; ordinary GPS ticks only
/// move the marker, they never trigger a new Routes API call.
class TravelMapScreen extends ConsumerStatefulWidget {
  const TravelMapScreen({required this.bookingId, super.key});

  final String bookingId;

  @override
  ConsumerState<TravelMapScreen> createState() => _TravelMapScreenState();
}

class _TravelMapScreenState extends ConsumerState<TravelMapScreen> {
  static const _routeStaleAfter = Duration(minutes: 5);
  static const _routeDeviationMetres = 500;

  StreamSubscription<Position>? _positionSub;
  LatLng? _worker;
  RouteInfo? _route;
  DateTime? _routeComputedAt;
  bool _routeLoading = false;
  String? _routeError;

  @override
  void initState() {
    super.initState();
    _startPositioning();
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }

  Future<void> _startPositioning() async {
    if (!await Geolocator.isLocationServiceEnabled()) return;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final initial = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    setState(() => _worker = LatLng(initial.latitude, initial.longitude));

    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen(_onPosition);
  }

  void _onPosition(Position position) {
    if (!mounted) return;
    final next = LatLng(position.latitude, position.longitude);
    setState(() => _worker = next);
    _maybeRecomputeRoute(next);
  }

  void _maybeRecomputeRoute(LatLng worker) {
    final job = ref.read(jobProvider(widget.bookingId)).valueOrNull;
    if (job?.latitude == null || job?.longitude == null) return;

    final stale = _routeComputedAt == null ||
        DateTime.now().difference(_routeComputedAt!) > _routeStaleAfter;
    final deviated = _route != null &&
        _route!.points.isNotEmpty &&
        _distanceFromRouteMetres(worker, _route!.points) > _routeDeviationMetres;

    if (stale || deviated) _computeRoute(worker, job!);
  }

  double _distanceFromRouteMetres(LatLng point, List<(double, double)> route) {
    var nearest = double.infinity;
    for (final (lat, lng) in route) {
      final d = Geolocator.distanceBetween(point.latitude, point.longitude, lat, lng);
      if (d < nearest) nearest = d;
    }
    return nearest;
  }

  Future<void> _computeRoute(LatLng worker, Job job) async {
    if (_routeLoading) return;
    setState(() {
      _routeLoading = true;
      _routeError = null;
    });

    final result = await ref.read(jobRepositoryProvider).computeRoute(
          originLat: worker.latitude,
          originLng: worker.longitude,
          destLat: job.latitude!,
          destLng: job.longitude!,
        );

    if (!mounted) return;
    result.fold(
      (route) => setState(() {
        _route = route;
        _routeComputedAt = DateTime.now();
        _routeLoading = false;
      }),
      (failure) => setState(() {
        _routeError = 'Route unavailable';
        _routeLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final job = ref.watch(jobProvider(widget.bookingId));

    return Scaffold(
      body: AsyncValueView<Job>(
        value: job,
        onRetry: () => ref.invalidate(jobProvider(widget.bookingId)),
        onData: _buildMap,
      ),
    );
  }

  Widget _buildMap(Job job) {
    if (job.latitude == null || job.longitude == null) {
      return const EmptyStateView(
        icon: Icons.location_off_outlined,
        title: 'No destination set',
        message: 'This job has no service location to route to.',
      );
    }

    final destination = LatLng(job.latitude!, job.longitude!);
    final worker = _worker;

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: destination, zoom: 13),
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          markers: {
            Marker(
              markerId: const MarkerId('destination'),
              position: destination,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              infoWindow: const InfoWindow(title: 'Job location'),
            ),
            if (worker != null)
              Marker(
                markerId: const MarkerId('worker'),
                position: worker,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                infoWindow: const InfoWindow(title: 'You'),
              ),
          },
          polylines: {
            if (_route != null && _route!.points.isNotEmpty)
              Polyline(
                polylineId: const PolylineId('route'),
                points: [for (final (lat, lng) in _route!.points) LatLng(lat, lng)],
                width: 5,
                color: AppColors.primary,
              ),
          },
        ),

        Positioned(
          top: MediaQuery.of(context).padding.top + AppSpacing.sm,
          left: AppSpacing.md,
          child: _MapButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => context.pop(),
          ),
        ),

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _BottomCard(
            job: job,
            route: _route,
            isLoading: _routeLoading,
            error: _routeError,
          ),
        ),
      ],
    );
  }
}

class _MapButton extends StatelessWidget {
  const _MapButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.surface,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(icon, color: context.ink),
        ),
      ),
    );
  }
}

class _BottomCard extends ConsumerWidget {
  const _BottomCard({
    required this.job,
    required this.route,
    required this.isLoading,
    required this.error,
  });

  final Job job;
  final RouteInfo? route;
  final bool isLoading;
  final String? error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBusy = ref.watch(jobActionsProvider).isLoading;
    final next = job.status.workerNextStatus;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.lg,
        AppSpacing.screenPadding,
        AppSpacing.lg + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, -4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(job.customerName ?? 'Customer', style: AppTypography.titleMedium.copyWith(color: context.ink)),
          const SizedBox(height: AppSpacing.xxs),
          Text(job.gigTitle ?? job.serviceName,
              style: AppTypography.bodySmall.copyWith(color: context.inkSecondary)),
          const SizedBox(height: AppSpacing.md),
          if (error != null)
            Text(error!, style: AppTypography.bodySmall.copyWith(color: AppColors.danger))
          else if (isLoading && route == null)
            Text('Calculating route...',
                style: AppTypography.bodySmall.copyWith(color: context.inkSecondary))
          else if (route != null)
            Row(
              children: [
                Icon(Icons.near_me_outlined, size: 16, color: context.inkSecondary),
                const SizedBox(width: AppSpacing.xs),
                Text(_formatDistance(route!.distanceMeters),
                    style: AppTypography.bodyMedium.copyWith(color: context.ink)),
                const SizedBox(width: AppSpacing.lg),
                Icon(Icons.schedule_rounded, size: 16, color: context.inkSecondary),
                const SizedBox(width: AppSpacing.xs),
                Text(_formatEta(route!.durationSeconds),
                    style: AppTypography.bodyMedium.copyWith(color: context.ink)),
              ],
            ),
          const SizedBox(height: AppSpacing.lg),
          if (next != null)
            SizedBox(
              height: AppSpacing.primaryActionHeight,
              child: FilledButton(
                onPressed: isBusy
                    ? null
                    : () async {
                        final result = await ref
                            .read(jobActionsProvider.notifier)
                            .advance(job.id, next);
                        if (!context.mounted) return;
                        result.fold(
                          (_) => context.pop(),
                          (failure) => showFailure(context, failure.message),
                        );
                      },
                child: isBusy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(job.status == BookingStatus.traveling ? 'I have arrived' : 'Continue'),
              ),
            ),
        ],
      ),
    );
  }

  static String _formatDistance(int? metres) {
    if (metres == null) return '—';
    if (metres < 1000) return '$metres m';
    return '${(metres / 1000).toStringAsFixed(1)} km';
  }

  static String _formatEta(int? seconds) {
    if (seconds == null) return '—';
    final minutes = (seconds / 60).ceil();
    return minutes < 60 ? '$minutes min' : '${(minutes / 60).toStringAsFixed(1)} hr';
  }
}
