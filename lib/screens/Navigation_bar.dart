import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tulapay/screens/Business_Screen.dart' show BusinessScreen;
import 'package:tulapay/screens/Homepage.dart';
import 'package:tulapay/screens/Analytics.dart';
import 'package:tulapay/screens/Customer_Screen.dart' show CustomerScreen;
import 'package:tulapay/screens/account_status_gate.dart';
import 'package:tulapay/screens/settings_screen.dart';
import 'package:tulapay/themes/app_theme.dart';

/// The main app shell. Gated on account status: a `pending_kyb`/`rejected`/
/// `suspended`/`closed` merchant sees [AccountStatusGate]'s pending/blocked
/// screen instead of the tabs below — this is the one shared construction
/// point every sign-in/sign-up/onboarding path routes through, so gating it
/// here covers all of them without duplicating the check at each call site.
class Navigation_Bar extends StatelessWidget {
  const Navigation_Bar({super.key});

  @override
  Widget build(BuildContext context) =>
      const AccountStatusGate(child: _NavigationShell());
}

class _NavigationShell extends StatefulWidget {
  const _NavigationShell();

  @override
  State<_NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<_NavigationShell> {
  int _selectedIndex = 0;
  bool _isHomeDrawerOpen = false;

  final List<Widget> _screens = [
    const AnalyticsScreen(),
    const BusinessScreen(),
    const CustomerScreen(),
    const SettingsScreen(),
  ];

  static const _items = <_NavItem>[
    _NavItem(FontAwesomeIcons.house, 'Home'),
    _NavItem(FontAwesomeIcons.chartLine, 'Analytics'),
    _NavItem(FontAwesomeIcons.briefcase, 'Business'),
    _NavItem(FontAwesomeIcons.users, 'Customers'),
    _NavItem(FontAwesomeIcons.gear, 'Settings'),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  void _onHomeDrawerChanged(bool isOpen) =>
      setState(() => _isHomeDrawerOpen = isOpen);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hideBar = _selectedIndex == 0 && _isHomeDrawerOpen;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Homepage(onDrawerChanged: _onHomeDrawerChanged),
          ..._screens,
        ],
      ),
      bottomNavigationBar: hideBar
          ? const SizedBox.shrink()
          : DecoratedBox(
              decoration: BoxDecoration(
                color: context.cardColor,
                border: Border(top: BorderSide(color: context.hairlineColor)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: List.generate(_items.length, (i) {
                      final selected = i == _selectedIndex;
                      final item = _items[i];
                      return Expanded(
                        child: InkWell(
                          onTap: () => _onItemTapped(i),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FaIcon(
                                  item.icon,
                                  size: 18,
                                  color: selected
                                      ? cs.primary
                                      : cs.onSurfaceVariant,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.label,
                                  style: AppText.caption(
                                    color: selected
                                        ? cs.primary
                                        : cs.onSurfaceVariant,
                                  ).copyWith(
                                    fontSize: 10,
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
    );
  }
}

class _NavItem {
  final FaIconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}
