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
import '../../../core/localization/l10n.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/job.dart';
import '../../../domain/repositories/repositories.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../../shared/widgets/service_names.dart';
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

  /// After a failed route call, GPS ticks wait this long before trying again,
  /// so a server outage is not retried every 10 m the worker moves.
  static const _routeRetryAfter = Duration(seconds: 30);

  final _cardKey = GlobalKey();

  StreamSubscription<Position>? _positionSub;
  GoogleMapController? _mapController;
  LatLng? _worker;
  RouteInfo? _route;
  DateTime? _routeComputedAt;
  DateTime? _routeFailedAt;
  bool _routeLoading = false;
  bool _cameraFittedToRoute = false;
  double _cardHeight = 0;
  String? _routeError;

  @override
  void initState() {
    super.initState();
    // The GPS fix can land before the job has loaded; route as soon as both
    // are known rather than waiting for the worker to move.
    ref.listenManual<AsyncValue<Job>>(jobProvider(widget.bookingId), (_, next) {
      final worker = _worker;
      if (worker != null && next.hasValue) _maybeRecomputeRoute(worker);
    });
    _startPositioning();
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _mapController?.dispose();
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
    final worker = LatLng(initial.latitude, initial.longitude);
    setState(() => _worker = worker);
    // The position stream only emits once the worker has moved, so a worker
    // standing still would otherwise never get a route.
    _maybeRecomputeRoute(worker);

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

    if (_routeFailedAt != null &&
        DateTime.now().difference(_routeFailedAt!) < _routeRetryAfter) {
      return;
    }

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
      (route) {
        setState(() {
          _route = route;
          _routeComputedAt = DateTime.now();
          _routeFailedAt = null;
          _routeLoading = false;
        });
        if (!_cameraFittedToRoute) _fitCameraToRoute();
      },
      (failure) => setState(() {
        _routeError = context.l10n.travelRouteUnavailable;
        _routeFailedAt = DateTime.now();
        _routeLoading = false;
      }),
    );
  }

  void _retryRoute() {
    final worker = _worker;
    final job = ref.read(jobProvider(widget.bookingId)).valueOrNull;
    if (worker == null || job?.latitude == null || job?.longitude == null) return;
    _computeRoute(worker, job!);
  }

  /// Frames the whole route once, when it first arrives. Later recomputes
  /// leave the camera alone so they never fight the worker's own panning.
  Future<void> _fitCameraToRoute() async {
    final controller = _mapController;
    final points = _route?.points ?? const [];
    if (controller == null || points.isEmpty) return;
    _cameraFittedToRoute = true;

    var (south, west) = points.first;
    var (north, east) = points.first;
    for (final (lat, lng) in points) {
      if (lat < south) south = lat;
      if (lat > north) north = lat;
      if (lng < west) west = lng;
      if (lng > east) east = lng;
    }

    try {
      await controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: LatLng(south, west), northeast: LatLng(north, east)),
        AppSpacing.xl,
      ));
    } catch (_) {
      // The map can refuse bounds before it has been laid out; the route is
      // still drawn, just not framed.
      _cameraFittedToRoute = false;
    }
  }

  /// Keeps the map's padding equal to the bottom card, so the camera frames
  /// the route in the part of the map the worker can actually see.
  void _measureCard() {
    final height = _cardKey.currentContext?.size?.height;
    if (height != null && height != _cardHeight) {
      setState(() => _cardHeight = height);
    }
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
      return EmptyStateView(
        icon: Icons.location_off_outlined,
        title: context.l10n.travelNoDestination,
        message: context.l10n.travelNoDestinationBody,
      );
    }

    final destination = LatLng(job.latitude!, job.longitude!);
    final worker = _worker;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _measureCard();
    });

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: destination, zoom: 13),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            bottom: _cardHeight,
          ),
          onMapCreated: (controller) {
            _mapController = controller;
            if (_route != null && !_cameraFittedToRoute) _fitCameraToRoute();
          },
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          markers: {
            Marker(
              markerId: const MarkerId('destination'),
              position: destination,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              infoWindow: InfoWindow(title: context.l10n.travelJobLocation),
            ),
            if (worker != null)
              Marker(
                markerId: const MarkerId('worker'),
                position: worker,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                infoWindow: InfoWindow(title: context.l10n.travelYou),
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
            key: _cardKey,
            job: job,
            route: _route,
            isLoading: _routeLoading,
            error: _routeError,
            onRetry: _routeLoading || worker == null ? null : _retryRoute,
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
    required this.onRetry,
    super.key,
  });

  final Job job;
  final RouteInfo? route;
  final bool isLoading;
  final String? error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
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
          Text(job.customerName ?? l10n.travelCustomer, style: AppTypography.titleMedium.copyWith(color: context.ink)),
          const SizedBox(height: AppSpacing.xxs),
          Text(job.gigTitle ?? localizedServiceName(l10n, job.serviceName),
              style: AppTypography.bodySmall.copyWith(color: context.inkSecondary)),
          const SizedBox(height: AppSpacing.md),
          if (error != null)
            Row(
              children: [
                Expanded(
                  child: Text(error!,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.danger)),
                ),
                if (onRetry != null)
                  TextButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
              ],
            )
          else if (isLoading && route == null)
            Text(l10n.travelCalculating,
                style: AppTypography.bodySmall.copyWith(color: context.inkSecondary))
          else if (route != null)
            Row(
              children: [
                Icon(Icons.near_me_outlined, size: 16, color: context.inkSecondary),
                const SizedBox(width: AppSpacing.xs),
                Text(_formatDistance(l10n, route!.distanceMeters),
                    style: AppTypography.bodyMedium.copyWith(color: context.ink)),
                const SizedBox(width: AppSpacing.lg),
                Icon(Icons.schedule_rounded, size: 16, color: context.inkSecondary),
                const SizedBox(width: AppSpacing.xs),
                Text(_formatEta(l10n, route!.durationSeconds),
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
                    : Text(job.status == BookingStatus.traveling
                        ? l10n.jobActionArrived
                        : l10n.commonContinue),
              ),
            ),
        ],
      ),
    );
  }

  static String _formatDistance(AppLocalizations l10n, int? metres) {
    if (metres == null) return '—';
    if (metres < 1000) return l10n.distanceMetres('$metres');
    return l10n.distanceKm((metres / 1000).toStringAsFixed(1));
  }

  static String _formatEta(AppLocalizations l10n, int? seconds) {
    if (seconds == null) return '—';
    final minutes = (seconds / 60).ceil();
    return minutes < 60
        ? l10n.etaMinutes('$minutes')
        : l10n.etaHours((minutes / 60).toStringAsFixed(1));
  }
}
