import 'dart:convert';
import 'dart:io';

/// Builds rows that match the shape real production rows have.
///
/// `live_shapes.json` records, per column, the JSON types the live table
/// actually produces, whether the column is ever null, whether its strings are
/// UUIDs / timestamps / codes / free text, and — for code-like columns only —
/// which values occur. It holds no names, numbers, addresses or free text: see
/// `web/supabase/scripts/profile-app-data.mjs`.
///
/// From that this synthesises two rows per query, which between them are where
/// mappers actually break:
///
///   * [full]  — every column present and populated, as a healthy row looks.
///   * [sparse] — every nullable column null, as a half-finished row looks.
///
/// A mapper that only ever meets handwritten maps passes both by accident. One
/// that reads `row['labour_amount_minor'] as int` does not, because that column
/// is null on every booking in the live database.
class LiveShapes {
  LiveShapes._(this._queries);

  factory LiveShapes.load([String path = 'test/fixtures/live_shapes.json']) {
    final json = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
    return LiveShapes._((json['queries'] as Map).cast<String, dynamic>());
  }

  final Map<String, dynamic> _queries;

  Iterable<String> get names => _queries.keys;

  bool hasRows(String query) => (_shape(query)['rowsProfiled'] as int? ?? 0) > 0;

  Map<String, dynamic> _shape(String query) {
    final shape = _queries[query];
    if (shape == null) {
      throw StateError(
        'live_shapes.json has no "$query". Regenerate it with '
        '`node web/supabase/scripts/profile-app-data.mjs`.',
      );
    }
    return (shape as Map).cast<String, dynamic>();
  }

  /// A row with every column populated.
  Map<String, dynamic> full(String query) =>
      _build((_shape(query)['columns'] as Map).cast<String, dynamic>(), nulls: false);

  /// A row where everything that can be null, is.
  Map<String, dynamic> sparse(String query) =>
      _build((_shape(query)['columns'] as Map).cast<String, dynamic>(), nulls: true);

  /// One row per recorded value of [column], so every status a mapper can meet
  /// is actually exercised rather than just the first one.
  List<Map<String, dynamic>> eachValueOf(String query, String column) {
    final columns = (_shape(query)['columns'] as Map).cast<String, dynamic>();
    final spec = (columns[column] as Map?)?.cast<String, dynamic>();
    final values = (spec?['values'] as List?)?.cast<String>() ?? const [];
    if (values.isEmpty) return [full(query)];
    return [
      for (final value in values) {...full(query), column: value},
    ];
  }

  Map<String, dynamic> _build(Map<String, dynamic> columns, {required bool nulls}) {
    final row = <String, dynamic>{};
    columns.forEach((name, raw) {
      final spec = (raw as Map).cast<String, dynamic>();
      final nullable = spec['nullable'] == true;
      final types = (spec['types'] as List).cast<String>();

      // A column that is null in every live row has no recorded type; there is
      // nothing to synthesise and null is the honest value either way.
      if (types.isEmpty || (nulls && nullable)) {
        row[name] = null;
        return;
      }
      row[name] = _value(name, spec, types.first, nulls: nulls);
    });
    return row;
  }

  Object? _value(
    String name,
    Map<String, dynamic> spec,
    String type, {
    required bool nulls,
  }) {
    switch (type) {
      case 'number':
        return 1000;
      case 'boolean':
        return false;
      case 'array':
        return const <Object?>[];
      case 'object':
        final nested = (spec['nested'] as Map?)?.cast<String, dynamic>();
        return nested == null ? <String, dynamic>{} : _build(nested, nulls: nulls);
      case 'string':
      default:
        final values = (spec['values'] as List?)?.cast<String>();
        if (values != null && values.isNotEmpty) return values.first;

        final formats = (spec['formats'] as List?)?.cast<String>() ?? const [];
        if (formats.contains('uuid')) return '00000000-0000-4000-8000-000000000001';
        if (formats.contains('timestamp')) return '2026-01-02T03:04:05.000000+00:00';
        return 'value-for-$name';
    }
  }
}
