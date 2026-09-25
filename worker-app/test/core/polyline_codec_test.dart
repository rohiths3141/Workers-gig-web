import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_worker/core/maps/polyline_codec.dart';

/// The travel map draws exactly what this returns, so a wrong sign or a
/// dropped chunk would put the worker's route in the wrong place entirely.
void main() {
  test('decodes Google\'s reference polyline', () {
    // The worked example from Google's encoded polyline algorithm docs.
    final points = decodePolyline(r'_p~iF~ps|U_ulLnnqC_mqNvxq`@');

    expect(points, hasLength(3));
    expect(points[0].$1, closeTo(38.5, 1e-9));
    expect(points[0].$2, closeTo(-120.2, 1e-9));
    expect(points[1].$1, closeTo(40.7, 1e-9));
    expect(points[1].$2, closeTo(-120.95, 1e-9));
    expect(points[2].$1, closeTo(43.252, 1e-9));
    expect(points[2].$2, closeTo(-126.453, 1e-9));
  });

  test('decodes a point in India with positive latitude and longitude', () {
    // Erode, where the test workers are based.
    final points = decodePolyline('s`fdAecjyM');

    expect(points.single.$1, closeTo(11.34106, 1e-9));
    expect(points.single.$2, closeTo(77.71715, 1e-9));
  });

  test('an empty polyline is an empty route', () {
    expect(decodePolyline(''), isEmpty);
  });
}
