import 'package:intl/intl.dart';

/// Shared money formatting for the merchant app. Currency is XAF by default
/// (matches the control panel and the mobile app's own product screens).
///
/// * `money(2450000)`               -> `XAF 2,450,000`
/// * `money(2450000, compact: true)` -> `XAF 2.4M`
/// * `money(-4500, signed: true)`    -> `- XAF 4,500`
String money(num value, {bool compact = false, bool signed = false}) {
  final abs = value.abs();

  final String body;
  if (compact) {
    body = NumberFormat.compactCurrency(symbol: 'XAF ', decimalDigits: 1)
        .format(abs)
        // compactCurrency keeps a trailing ".0" (e.g. "XAF 12.0K") — trim it.
        .replaceAll('.0', '');
  } else {
    body = NumberFormat.currency(symbol: 'XAF ', decimalDigits: 0).format(abs);
  }

  if (signed && value != 0) return '${value < 0 ? '- ' : '+ '}$body';
  if (value < 0) return '- $body';
  return body;
}

/// A signed percentage delta, e.g. `+14.2%` / `-3.0%`.
String percentDelta(double value, {int decimals = 1}) {
  final sign = value > 0 ? '+' : (value < 0 ? '-' : '');
  return '$sign${value.abs().toStringAsFixed(decimals)}%';
}
