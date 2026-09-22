/// Rupee formatting for amounts held in integer minor units (paise).
///
/// Every amount on this platform is an integer number of paise, end to end —
/// the database stores `*_amount_minor`, the payment gateway is given paise,
/// and nothing divides until it reaches a screen. This is the one place that
/// divides.
///
/// It replaced six copies of `'₹${(minor / 100).toStringAsFixed(0)}'`, which
/// had two problems. `toStringAsFixed(0)` *rounds*, so ₹499.50 was shown as
/// "₹500" — a price the customer was never charged. And with six copies, a
/// screen that formatted an amount slightly differently from the one before it
/// was only a matter of time.
library;

/// `49900` -> `"₹499"`, `49950` -> `"₹499.50"`, `-5000` -> `"-₹50"`.
///
/// Paise appear only when there are any, so whole-rupee prices — which is all
/// of them today — read as plainly as they did before.
String formatRupees(int minor) {
  final negative = minor < 0;
  final abs = minor.abs();
  final rupees = abs ~/ 100;
  final paise = abs % 100;

  final sign = negative ? '-' : '';
  final body = paise == 0
      ? '$rupees'
      : '$rupees.${paise.toString().padLeft(2, '0')}';

  return '$sign₹$body';
}

/// The same, or [ifNull] when there is no amount to show.
///
/// A missing amount is not zero: a booking whose final price has not been
/// settled yet has `final_amount_minor` null, and showing "₹0" for it would be
/// a statement about the price rather than the absence of one.
String formatRupeesOr(int? minor, String ifNull) =>
    minor == null ? ifNull : formatRupees(minor);
