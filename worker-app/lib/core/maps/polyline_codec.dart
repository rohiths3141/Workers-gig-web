/// Decodes a Google encoded polyline into a list of (latitude, longitude)
/// pairs. Standalone rather than a dependency — the algorithm is a few lines
/// and this is the only place in the app that needs it.
List<(double, double)> decodePolyline(String encoded) {
  final points = <(double, double)>[];
  var index = 0;
  var lat = 0;
  var lng = 0;

  while (index < encoded.length) {
    lat += _decodeChunk(encoded, () => index, (v) => index = v);
    lng += _decodeChunk(encoded, () => index, (v) => index = v);
    points.add((lat / 1e5, lng / 1e5));
  }

  return points;
}

int _decodeChunk(String encoded, int Function() getIndex, void Function(int) setIndex) {
  var index = getIndex();
  var result = 0;
  var shift = 0;
  int b;
  do {
    b = encoded.codeUnitAt(index++) - 63;
    result |= (b & 0x1f) << shift;
    shift += 5;
  } while (b >= 0x20);
  setIndex(index);
  return (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
}
