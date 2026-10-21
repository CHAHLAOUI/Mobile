String formatResult(double value) {
  if (!value.isFinite) throw const FormatException('Result is not finite');
  if (value == 0) return '0';

  final formatted = value.toStringAsPrecision(12);
  final exponentIndex = formatted.indexOf('e');
  if (exponentIndex >= 0) {
    final mantissa = _trimDecimalZeros(formatted.substring(0, exponentIndex));
    final exponent = formatted.substring(exponentIndex + 1);
    return '${mantissa}e$exponent';
  }
  return _trimDecimalZeros(formatted);
}

String _trimDecimalZeros(String value) {
  if (!value.contains('.')) return value;
  return value
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
}
