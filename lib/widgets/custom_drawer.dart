import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/screens/checklist_screen.dart';
import 'package:tulapay/screens/payment_page_screen.dart';
import 'package:tulapay/screens/promo_codes_screen.dart';
import 'package:tulapay/screens/customers_screen.dart';
import 'package:tulapay/screens/payments_screen.dart';
import 'package:tulapay/screens/notification_screen.dart';
import 'package:tulapay/screens/settings_screen.dart';
import 'package:tulapay/screens/docs_screen.dart';
import 'package:tulapay/screens/help_screen.dart';
import 'package:tulapay/widgets/glass_effects.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: isDark ? 18 : 14, sigmaY: isDark ? 18 : 14),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: isDark ? 0.14 : 0.10),
              border: Border(
                right: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.14)
                      : colorScheme.outline.withValues(alpha: 0.10),
                ),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: GlassSurface(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      opacity: isDark ? 0.16 : 0.10,
                      blur: isDark ? 16 : 12,
                      child: Row(
                        children: [
                          Icon(
                            Icons.hexagon_outlined,
                            color: colorScheme.primary,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "TulaBiz",
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                              color: colorScheme.primary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 24),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      children: [
                        _sectionLabel(context, "Main"),
                        _buildDrawerItem(
                          context,
                          icon: Icons.home_rounded,
                          label: "Home",
                          isActive: true,
                          onTap: () => Navigator.pop(context),
                        ),
                        _buildDrawerItem(
                          context,
                          icon: Icons.check_circle_outline_rounded,
                          label: "Checklist",
                          badge: "5 Steps",
                          badgeColor: colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          badgeTextColor: colorScheme.primary,
                          onTap: () =>
                              _navigateTo(context, const ChecklistScreen()),
                        ),
                        _buildDrawerItem(
                          context,
                          icon: Icons.payment_rounded,
                          label: "Payment Page",
                          onTap: () =>
                              _navigateTo(context, const PaymentPageScreen()),
                        ),
                        _buildDrawerItem(
                          context,
                          icon: Icons.local_offer_rounded,
                          label: "Promo Codes",
                          onTap: () =>
                              _navigateTo(context, const PromoCodesScreen()),
                        ),
                        _buildDrawerItem(
                          context,
                          icon: Icons.people_rounded,
                          label: "Customers",
                          onTap: () =>
                              _navigateTo(context, const CustomersScreen()),
                        ),
                        _buildDrawerItem(
                          context,
                          icon: Icons.sync_alt_rounded,
                          label: "Payments",
                          onTap: () =>
                              _navigateTo(context, const PaymentsScreen()),
                        ),

                        const SizedBox(height: 18),
                        _sectionLabel(context, "Support"),
                        _buildDrawerItem(
                          context,
                          icon: Icons.notifications_active_rounded,
                          label: "Notifications",
                          badge: "+9",
                          badgeColor: colorScheme.primary,
                          badgeTextColor: Colors.white,
                          onTap: () =>
                              _navigateTo(context, const NotificationScreen()),
                        ),
                        _buildDrawerItem(
                          context,
                          icon: Icons.settings_rounded,
                          label: "Settings",
                          onTap: () =>
                              _navigateTo(context, const SettingsScreen()),
                        ),
                        _buildDrawerItem(
                          context,
                          icon: Icons.menu_book_rounded,
                          label: "Docs",
                          onTap: () => _navigateTo(context, const DocsScreen()),
                        ),
                        _buildDrawerItem(
                          context,
                          icon: Icons.help_rounded,
                          label: "Help",
                          onTap: () => _navigateTo(context, const HelpScreen()),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GlassSurface(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      opacity: 0.12,
                      blur: 14,
                      child: Row(
                        children: [
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.primary.withValues(alpha: 0.22),
                                  colorScheme.secondary.withValues(
                                    alpha: 0.12,
                                  ),
                                ],
                              ),
                            ),
                            child: Icon(
                              Icons.hexagon_outlined,
                              color: colorScheme.primary,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Tulabix Limited",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "Professional payment solutions",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.pop(context); // Close drawer
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
    String? badge,
    Color? badgeColor,
    Color? badgeTextColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: GlassSurface(
        borderRadius: BorderRadius.circular(18),
        opacity: isActive ? 0.16 : 0.10,
        blur: 12,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        border: Border.all(
          color: isActive
              ? colorScheme.primary.withValues(alpha: 0.18)
              : colorScheme.outlineVariant.withValues(alpha: 0.15),
        ),
        child: ListTile(
          onTap: onTap,
          dense: true,
          visualDensity: const VisualDensity(vertical: -2),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          leading: Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  (isActive ? colorScheme.primary : colorScheme.secondary)
                      .withValues(alpha: 0.24),
                  (isActive ? colorScheme.primary : colorScheme.secondary)
                      .withValues(alpha: 0.10),
                ],
              ),
            ),
            child: Icon(
              icon,
              color:
                  isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          title: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
              fontSize: 14,
              color:
                  isActive ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: badge != null
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: badgeTextColor,
                    ),
                  ),
                )
              : const Icon(Icons.chevron_right_rounded, size: 18),
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.6,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
