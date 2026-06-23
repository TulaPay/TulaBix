import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Icon(Icons.hexagon_outlined, color: colorScheme.primary, size: 28),
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
            const Divider(height: 1),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.check_circle_outline_rounded,
                    label: "Checklist",
                    badge: "5 Steps",
                    badgeColor: colorScheme.primary.withValues(alpha: 0.1),
                    badgeTextColor: colorScheme.primary,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.home_rounded,
                    label: "Home",
                    isActive: true,
                  ),
                  _buildDrawerItem(context, icon: Icons.grid_view_rounded, label: "Products"),
                  _buildDrawerItem(context, icon: Icons.payment_rounded, label: "Payment page"),
                  _buildDrawerItem(context, icon: Icons.local_offer_rounded, label: "Promo codes"),
                  _buildDrawerItem(context, icon: Icons.people_rounded, label: "Customers"),
                  _buildDrawerItem(context, icon: Icons.sync_alt_rounded, label: "Payments"),
                  
                  const SizedBox(height: 32),
                  
                  _buildDrawerItem(
                    context,
                    icon: Icons.notifications_active_rounded,
                    label: "Notification",
                    badge: "+9",
                    badgeColor: colorScheme.primary,
                    badgeTextColor: Colors.white,
                  ),
                  _buildDrawerItem(context, icon: Icons.settings_rounded, label: "Settings"),
                  _buildDrawerItem(context, icon: Icons.menu_book_rounded, label: "Docs"),
                  _buildDrawerItem(context, icon: Icons.help_rounded, label: "Help"),
                ],
              ),
            ),

            // Footer
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/multiplepayments.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Team Tula",
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Admin Account",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.unfold_more_rounded, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    bool isActive = false,
    String? badge,
    Color? badgeColor,
    Color? badgeTextColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isActive ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () {},
        dense: true,
        visualDensity: const VisualDensity(vertical: -2),
        leading: Icon(
          icon,
          color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
          size: 22,
        ),
        title: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
            fontSize: 14,
            color: isActive ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: badge != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
            : null,
      ),
    );
  }
}
