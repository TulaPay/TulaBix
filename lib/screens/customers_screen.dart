/// Deprecated shim. The drawer's "Customers" entry now routes to the real
/// [CustomerScreen] (the bottom-nav customers screen, backed by
/// `merchant_customers`). Kept as a re-export so any lingering import of
/// `CustomersScreen` still resolves.
export 'Customer_Screen.dart' show CustomerScreen;

import 'package:flutter/widgets.dart';
import 'Customer_Screen.dart';

@Deprecated('Use CustomerScreen from Customer_Screen.dart')
class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) => const CustomerScreen();
}
