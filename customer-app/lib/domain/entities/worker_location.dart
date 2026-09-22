/// A live location ping from the worker, received via Realtime.
class WorkerLocation {
  const WorkerLocation({
    required this.id,
    required this.workerId,
    required this.latitude,
    required this.longitude,
    required this.recordedAt,
    this.bookingId,
    this.accuracy,
    this.heading,
    this.speed,
  });

  factory WorkerLocation.fromJson(Map<String, dynamic> json) => WorkerLocation(
        id: json['id'] as String,
        workerId: json['worker_id'] as String,
        bookingId: json['booking_id'] as String?,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        accuracy: (json['accuracy'] as num?)?.toDouble(),
        heading: (json['heading'] as num?)?.toDouble(),
        speed: (json['speed'] as num?)?.toDouble(),
        recordedAt: DateTime.parse(json['recorded_at'] as String),
      );

  final String id;
  final String workerId;
  final String? bookingId;
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? heading;
  final double? speed;
  final DateTime recordedAt;

  /// Whether this ping is fresh enough to trust for live tracking.
  bool get isStale => freshness != LocationFreshness.live;

  /// Coarser than a single stale/fresh boolean: a ping that just went quiet
  /// reads differently from one that has been silent long enough to mean the
  /// connection, not just the next GPS tick, is the problem.
  LocationFreshness get freshness {
    final age = DateTime.now().difference(recordedAt).inSeconds;
    if (age <= 15) return LocationFreshness.live;
    if (age <= 45) return LocationFreshness.updating;
    return LocationFreshness.unavailable;
  }
}

enum LocationFreshness { live, updating, unavailable }
