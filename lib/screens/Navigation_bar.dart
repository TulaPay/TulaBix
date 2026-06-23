import 'package:flutter/material.dart';
import 'package:tulapay/screens/Homepage.dart';
import 'package:tulapay/screens/payments_screen.dart';
import 'package:tulapay/screens/customers_screen.dart';
import 'package:tulapay/screens/settings_screen.dart';

class Navigation_Bar extends StatefulWidget {
  const Navigation_Bar({super.key});

  @override
  State<Navigation_Bar> createState() => _Navigation_BarState();
}

class _Navigation_BarState extends State<Navigation_Bar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Homepage(),
    const Center(child: Text('Analytics Screen'),),
    const Center(child: Text('Payments Screen'),),
    const Center(child: Text("Customer Screen"),),
    const Center(child: Text("Profile Screen"),),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_rounded),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_rounded),
            label: 'Customers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surface,
        elevation: 8,
      ),
    );
  }
}
