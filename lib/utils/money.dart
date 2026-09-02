import 'package:intl/intl.dart';

final NumberFormat _grouped = NumberFormat('#,##0', 'en_US');

String _normalize(String s) => s.replaceAll(',', ' ');

/// "XAF 25 000" — whole-unit XAF, matching the cross-system contract (no
/// centimes). Symbol before the amount, space thousands separators.
String money(num amount, {String currency = 'XAF'}) =>
    '$currency ${_normalize(_grouped.format(amount))}';

/// "25 000" with no symbol.
String amountOnly(num amount) => _normalize(_grouped.format(amount));

/// "+ XAF 25 000" / "- XAF 4 500".
String signedMoney(num amount, {String currency = 'XAF'}) {
  final sign = amount < 0 ? '- ' : '+ ';
  return '$sign${money(amount.abs(), currency: currency)}';
}
