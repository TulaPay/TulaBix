import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tulapay/screens/Business_Screen.dart' show BusinessScreen;
import 'package:tulapay/screens/Homepage.dart';
import 'package:tulapay/screens/Analytics.dart';
import 'package:tulapay/screens/Customer_Screen.dart' show CustomerScreen;
import 'package:tulapay/screens/settings_screen.dart';
import 'package:tulapay/widgets/glass_effects.dart';

class Navigation_Bar extends StatefulWidget {
  const Navigation_Bar({super.key});

  @override
  State<Navigation_Bar> createState() => _Navigation_BarState();
}

class _Navigation_BarState extends State<Navigation_Bar> {
  int _selectedIndex = 0;
  bool _isHomeDrawerOpen = false;

  final List<Widget> _screens = [
    const AnalyticsScreen(),
    const BusinessScreen(),
    const CustomerScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onHomeDrawerChanged(bool isOpen) {
    setState(() {
      _isHomeDrawerOpen = isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barOpacity = isDark ? 0.16 : 0.10;
    final barBlur = isDark ? 18.0 : 12.0;
    final barBorder = isDark
        ? Colors.white.withValues(alpha: 0.14)
        : colorScheme.outline.withValues(alpha: 0.12);
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Homepage(onDrawerChanged: _onHomeDrawerChanged),
          ..._screens,
        ],
      ),
      bottomNavigationBar: (_selectedIndex == 0 && _isHomeDrawerOpen)
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: GlassSurface(
                borderRadius: BorderRadius.circular(30),
                opacity: barOpacity,
                blur: barBlur,
                tint: isDark
                    ? colorScheme.surface
                    : colorScheme.surfaceContainerHighest,
                border: Border.all(color: barBorder),
                child: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.house),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.chartLine),
                      label: 'Analytics',
                    ),
                    BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.briefcase),
                      label: 'Business',
                    ),
                    BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.users),
                      label: 'Customers',
                    ),
                    BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.gear),
                      label: 'Settings',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: colorScheme.primary,
                  unselectedItemColor: colorScheme.onSurfaceVariant.withValues(
                    alpha: isDark ? 0.6 : 0.72,
                  ),
                  onTap: _onItemTapped,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              ),
            ),
    );
  }
}
