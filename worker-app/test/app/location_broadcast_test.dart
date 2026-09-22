import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:wervexa_worker/app/providers/providers.dart';
import 'package:wervexa_worker/core/errors/result.dart';
import 'package:wervexa_worker/core/money/money.dart';
import 'package:wervexa_worker/domain/entities/enums.dart';
import 'package:wervexa_worker/domain/entities/job.dart';
import 'package:wervexa_worker/domain/repositories/repositories.dart';
import 'package:wervexa_worker/features/jobs/presentation/jobs_controller.dart';

/// The phone must stop reporting the worker's position when the job screen goes.
///
/// `locationBroadcastProvider` starts GPS asynchronously: it checks the
/// location service, then the permission — and that second step can raise a
/// system dialog the worker takes seconds to answer. `ref.onDispose` cancelled
/// a `subscription` variable that was still null for the whole of that window,
/// so leaving the screen before answering left the stream to open afterwards
/// with nothing holding a handle to it.
///
/// What that costs is not abstract: the position stream stays alive for the
/// rest of the process, draining the battery of a worker who is out all day,
/// and every fix is written to `worker_locations` — where the customer's map
/// reads it — long after the job it belonged to was closed.
void main() {
  late _FakeGeolocator geolocator;
  late _RecordingJobRepository jobs;
  late ProviderContainer container;

  setUp(() {
    geolocator = _FakeGeolocator();
    GeolocatorPlatform.instance = geolocator;
    jobs = _RecordingJobRepository();
    container = ProviderContainer(
      overrides: [jobRepositoryProvider.overrideWithValue(jobs)],
    );
  });

  tearDown(() => container.dispose());

  group('Live location tracking', () {
    test('does not start for a job the customer cannot watch', () async {
      jobs.emit(_job(BookingStatus.accepted));
      final sub = container.listen(locationBroadcastProvider('booking-1'), (_, __) {});
      await _settle();

      expect(geolocator.positionStreamsOpened, 0,
          reason: 'Only TRAVELING, ARRIVED and IN_PROGRESS are watchable');
      sub.close();
    });

    for (final status in [
      BookingStatus.traveling,
      BookingStatus.arrived,
      BookingStatus.inProgress,
    ]) {
      test('starts once the job is ${status.wire}', () async {
        jobs.emit(_job(status));
        final sub =
            container.listen(locationBroadcastProvider('booking-1'), (_, __) {});
        await _settle();

        expect(geolocator.positionStreamsOpened, 1);
        sub.close();
      });
    }

    test('cancels the stream when the screen is left', () async {
      jobs.emit(_job(BookingStatus.traveling));
      final sub =
          container.listen(locationBroadcastProvider('booking-1'), (_, __) {});
      await _settle();
      expect(geolocator.hasLiveListener, isTrue);

      sub.close();
      await _settle();

      expect(geolocator.hasLiveListener, isFalse);
    });

    test('cancels a stream that opens after the screen was already left',
        () async {
      // The race: the worker taps back while the permission dialog is still
      // up. Before the fix, onDispose ran against a null subscription and the
      // stream that opened a moment later was never cancelled.
      geolocator.holdPermission();
      jobs.emit(_job(BookingStatus.traveling));

      final sub =
          container.listen(locationBroadcastProvider('booking-1'), (_, __) {});
      await _settle();
      expect(geolocator.positionStreamsOpened, 0,
          reason: 'Still waiting on the permission answer');

      sub.close();
      // autoDispose is deferred, so let the teardown actually run before the
      // permission comes back. This is the ordering that bites in practice:
      // the screen is gone, and only then does the worker answer the dialog.
      await _settle();
      geolocator.releasePermission(LocationPermission.whileInUse);
      await _settle();

      // Either outcome is correct — decline to open, or open and cancel — so
      // long as nothing is left listening. (The companion test below is the
      // one that proves this scenario is reachable: against the unfixed
      // provider it records a position write with no screen open.)
      expect(geolocator.hasLiveListener, isFalse,
          reason: 'A phone with no job screen open must not be reporting '
              "the worker's position");
    });

    test('writes nothing after the screen is left', () async {
      geolocator.holdPermission();
      jobs.emit(_job(BookingStatus.traveling));
      final sub =
          container.listen(locationBroadcastProvider('booking-1'), (_, __) {});
      await _settle();

      sub.close();
      await _settle();
      geolocator.releasePermission(LocationPermission.whileInUse);
      await _settle();

      geolocator.movePosition(11.3410, 77.7172);
      await _settle();

      expect(jobs.locationUpdates, isEmpty,
          reason: 'worker_locations is what the customer map reads');
    });

    test('reports position while the job screen is open', () async {
      jobs.emit(_job(BookingStatus.traveling));
      final sub =
          container.listen(locationBroadcastProvider('booking-1'), (_, __) {});
      await _settle();

      geolocator.movePosition(11.3410, 77.7172);
      await _settle();

      expect(jobs.locationUpdates, hasLength(1));
      expect(jobs.locationUpdates.single.$1, 'booking-1');
      sub.close();
    });

    test('never starts when the worker refuses permission', () async {
      geolocator.permission = LocationPermission.deniedForever;
      jobs.emit(_job(BookingStatus.traveling));
      final sub =
          container.listen(locationBroadcastProvider('booking-1'), (_, __) {});
      await _settle();

      expect(geolocator.positionStreamsOpened, 0);
      sub.close();
    });

    test('never starts when location services are switched off', () async {
      geolocator.serviceEnabled = false;
      jobs.emit(_job(BookingStatus.traveling));
      final sub =
          container.listen(locationBroadcastProvider('booking-1'), (_, __) {});
      await _settle();

      expect(geolocator.positionStreamsOpened, 0);
      sub.close();
    });
  });
}

/// Lets the provider's chain of awaits — service check, permission, stream
/// open — run to completion.
Future<void> _settle() async {
  for (var i = 0; i < 8; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

Job _job(BookingStatus status) => Job(
      id: 'booking-1',
      bookingCode: 'WBK-1',
      status: status,
      serviceId: 'service-1',
      serviceName: 'Electrical',
      problemDescription: 'A socket has stopped working.',
      addressLine: '1 Test Street',
      materialAmount: const Money(0),
      city: 'Erode',
      pincode: '638001',
      quotedAmount: const Money(50000),
      workerAmount: const Money(45000),
      createdAt: DateTime.utc(2026, 9, 20),
    );

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class _FakeGeolocator extends GeolocatorPlatform with MockPlatformInterfaceMixin {
  bool serviceEnabled = true;
  LocationPermission permission = LocationPermission.whileInUse;

  int positionStreamsOpened = 0;

  /// Listen/cancel are recorded from the controller's own callbacks rather
  /// than read off `hasListener`, which a cancel resets — the question here is
  /// whether anything is still listening, not whether anything ever did.
  int listens = 0;
  int cancels = 0;
  StreamController<Position>? _positions;

  Completer<LocationPermission>? _heldPermission;

  /// Makes the permission check hang, the way a system dialog does.
  void holdPermission() => _heldPermission = Completer<LocationPermission>();

  void releasePermission(LocationPermission answer) {
    permission = answer;
    _heldPermission?.complete(answer);
    _heldPermission = null;
  }

  bool get hasLiveListener => listens > cancels;

  void movePosition(double latitude, double longitude) {
    _positions?.add(Position(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.utc(2026, 9, 20),
      accuracy: 5,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    ));
  }

  @override
  Future<bool> isLocationServiceEnabled() async => serviceEnabled;

  @override
  Future<LocationPermission> checkPermission() =>
      _heldPermission?.future ?? Future.value(permission);

  @override
  Future<LocationPermission> requestPermission() =>
      _heldPermission?.future ?? Future.value(permission);

  @override
  Stream<Position> getPositionStream({LocationSettings? locationSettings}) {
    positionStreamsOpened++;
    late final StreamController<Position> controller;
    controller = StreamController<Position>(
      onListen: () => listens++,
      onCancel: () => cancels++,
    );
    _positions = controller;
    return controller.stream;
  }
}

class _RecordingJobRepository implements JobRepository {
  final _jobs = StreamController<Job>.broadcast();

  /// The last job emitted. A real `watchJob` re-reads the row on subscribe, so
  /// a listener that attaches late still gets the current state; without that
  /// here, the provider would see nothing and every assertion below would pass
  /// for the wrong reason.
  Job? _latest;

  /// (bookingId, latitude, longitude) for every position written.
  final List<(String, double, double)> locationUpdates = [];

  void emit(Job job) {
    _latest = job;
    _jobs.add(job);
  }

  @override
  Stream<Job> watchJob(String bookingId) async* {
    final current = _latest;
    if (current != null) yield current;
    yield* _jobs.stream;
  }

  @override
  Future<Result<void>> updateLocation({
    required String bookingId,
    required double latitude,
    required double longitude,
    double? accuracy,
    double? heading,
    double? speed,
  }) async {
    locationUpdates.add((bookingId, latitude, longitude));
    return const Ok(null);
  }

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
