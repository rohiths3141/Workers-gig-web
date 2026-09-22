import 'package:intl/intl.dart';

/// An amount of money, always in integer minor units.
///
/// The platform stores every amount as `bigint` paise, and this type is the
/// only way the app handles one. There is no `double` anywhere in the financial
/// path: floating point cannot represent 0.1 exactly, and a worker's earnings
/// are not a place to discover that.
class Money implements Comparable<Money> {
  const Money(this.minor, {this.currency = 'INR'});

  const Money.zero({this.currency = 'INR'}) : minor = 0;

  /// From a major-unit string typed by a worker, e.g. "499.50" -> 49950.
  ///
  /// Returns null when the text is not a well-formed amount. Parsing goes
  /// through the string rather than a double so that "0.29" cannot land on 28.
  static Money? tryParseMajor(String input, {String currency = 'INR'}) {
    final text = input.trim().replaceAll(',', '').replaceAll('₹', '').trim();
    if (text.isEmpty) return null;
    if (!RegExp(r'^\d+(\.\d{0,2})?$').hasMatch(text)) return null;

    final parts = text.split('.');
    final whole = int.tryParse(parts[0]);
    if (whole == null) return null;

    var fraction = 0;
    if (parts.length == 2 && parts[1].isNotEmpty) {
      fraction = int.parse(parts[1].padRight(2, '0'));
    }
    return Money(whole * 100 + fraction, currency: currency);
  }

  /// Integer minor units. Paise for INR.
  final int minor;
  final String currency;

  bool get isZero => minor == 0;
  bool get isPositive => minor > 0;
  bool get isNegative => minor < 0;

  Money get abs => Money(minor.abs(), currency: currency);

  Money operator +(Money other) {
    _assertSameCurrency(other);
    return Money(minor + other.minor, currency: currency);
  }

  Money operator -(Money other) {
    _assertSameCurrency(other);
    return Money(minor - other.minor, currency: currency);
  }

  bool operator >(Money other) {
    _assertSameCurrency(other);
    return minor > other.minor;
  }

  bool operator <(Money other) {
    _assertSameCurrency(other);
    return minor < other.minor;
  }

  bool operator >=(Money other) => this > other || this == other;
  bool operator <=(Money other) => this < other || this == other;

  void _assertSameCurrency(Money other) {
    assert(
      other.currency == currency,
      'Refusing to combine $currency with ${other.currency}',
    );
  }

  /// "₹499" or "₹499.50" — the paise are shown only when they are not zero,
  /// because a worker reading a job card does not want to see ".00" on every line.
  String format({bool alwaysShowDecimals = false, bool showSign = false}) {
    final symbol = _symbols[currency] ?? '$currency ';
    final negative = minor < 0;
    final units = minor.abs();
    final whole = units ~/ 100;
    final paise = units % 100;

    final wholeText = _grouping.format(whole);
    final body = (paise == 0 && !alwaysShowDecimals)
        ? '$symbol$wholeText'
        : '$symbol$wholeText.${paise.toString().padLeft(2, '0')}';

    if (negative) return '-$body';
    if (showSign && minor > 0) return '+$body';
    return body;
  }

  /// Compact form for dense lists: "₹1.5L", "₹12.5k".
  String formatCompact() {
    final symbol = _symbols[currency] ?? '$currency ';
    final whole = minor.abs() ~/ 100;
    final sign = minor < 0 ? '-' : '';

    if (whole >= 10000000) return '$sign$symbol${(whole / 10000000).toStringAsFixed(1)}Cr';
    if (whole >= 100000) return '$sign$symbol${(whole / 100000).toStringAsFixed(1)}L';
    if (whole >= 1000) return '$sign$symbol${(whole / 1000).toStringAsFixed(1)}k';
    return format();
  }

  static final _grouping = NumberFormat.decimalPattern('en_IN');
  static const _symbols = {'INR': '₹'};

  @override
  int compareTo(Money other) {
    _assertSameCurrency(other);
    return minor.compareTo(other.minor);
  }

  @override
  bool operator ==(Object other) =>
      other is Money && other.minor == minor && other.currency == currency;

  @override
  int get hashCode => Object.hash(minor, currency);

  @override
  String toString() => format(alwaysShowDecimals: true);
}
