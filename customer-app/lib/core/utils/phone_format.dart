/// "9191919191" or "+919191919191" -> "+91 91919 19191". Anything that is not
/// a 10-digit Indian mobile number is returned unchanged.
String formatIndianPhone(String raw) {
  final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
  final local = digits.length == 12 && digits.startsWith('91')
      ? digits.substring(2)
      : digits;
  if (local.length != 10) return raw;
  return '+91 ${local.substring(0, 5)} ${local.substring(5)}';
}
