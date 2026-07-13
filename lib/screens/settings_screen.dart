import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'settings/account_screen.dart';
import 'settings/billing_screen.dart';
import 'settings/favorites_screen.dart';
import 'settings/growth_goals_screen.dart';
import 'settings/notifications_settings_screen.dart';
import 'settings/help_center_screen.dart';
import 'settings/privacy_policy_screen.dart';
import 'settings/edit_profile_screen.dart';

// ─── Custom Background Pattern ───────────────────────────────────────────────

class _GeometricPatternPainter extends CustomPainter {
  final Color color;
  _GeometricPatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.02)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (var i = 0.0; i < size.width; i += 40) {
      for (var j = 0.0; j < size.height; j += 40) {
        canvas.drawCircle(Offset(i, j), 2, paint);
        if ((i + j) % 80 == 0) {
          canvas.drawRect(Rect.fromLTWH(i, j, 15, 15), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  String _currentLanguage = 'English';

  void _showPlaceholder(String feature) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(label: 'OK', onPressed: () {}),
      ),
    );
  }

  void _showLanguageSelector(ColorScheme cs) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Language', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ...['English', 'French', 'Spanish', 'German'].map((lang) => ListTile(
                  title: Text(lang, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                  trailing: _currentLanguage == lang ? Icon(Icons.check_circle, color: cs.primary) : null,
                  onTap: () {
                    setState(() => _currentLanguage = lang);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerLow,
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _GeometricPatternPainter(cs.primary))),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context, cs),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    children: [
                      _buildProfileCard(cs).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05),
                      const SizedBox(height: 32),
                      _sectionTitle('Account details', cs),
                      const SizedBox(height: 12),
                      _buildSettingsGroup(cs, [
                        _settingsTile(Icons.person_outline_rounded, 'Account', cs, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountScreen()))),
                        _settingsTile(Icons.wallet_outlined, 'Billing', cs, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BillingScreen()))),
                      ]).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05),
                      const SizedBox(height: 24),
                      _sectionTitle('Target', cs),
                      const SizedBox(height: 12),
                      _buildSettingsGroup(cs, [
                        _settingsTile(Icons.favorite_outline_rounded, 'Favorites', cs, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()))),
                        _settingsTile(Icons.language_rounded, 'Growth Goals', cs, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GrowthGoalsScreen()))),
                      ]).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05),
                      const SizedBox(height: 24),
                      _sectionTitle('General', cs),
                      const SizedBox(height: 12),
                      _buildSettingsGroup(cs, [
                        _settingsTile(Icons.notifications_none_rounded, 'Notifications', cs, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsSettingsScreen()))),
                        _settingsTile(Icons.public_rounded, 'Language', cs, trailingLabel: _currentLanguage, onTap: () => _showLanguageSelector(cs)),
                        _settingsTile(
                          _isDarkMode ? Icons.nightlight_round : Icons.wb_sunny_outlined,
                          'Light/Dark Mode',
                          cs,
                          trailingLabel: _isDarkMode ? 'Dark' : 'Light',
                          onTap: () => setState(() => _isDarkMode = !_isDarkMode),
                        ),
                      ]).animate().fadeIn(delay: 300.ms).slideY(begin: 0.05),
                      const SizedBox(height: 24),
                      _sectionTitle('Support', cs),
                      const SizedBox(height: 12),
                      _buildSettingsGroup(cs, [
                        _settingsTile(Icons.help_outline_rounded, 'Help Center', cs, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpCenterScreen()))),
                        _settingsTile(Icons.privacy_tip_outlined, 'Privacy Policy', cs, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()))),
                      ]).animate().fadeIn(delay: 400.ms).slideY(begin: 0.05),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 24),
              onPressed: () => Navigator.maybePop(context),
              color: cs.onSurface,
            ),
          ),
          Text(
            'Settings',
            style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700, color: cs.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: cs.shadow.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: cs.surfaceContainerHigh,
            backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=jacob'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Jacob Jones', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: cs.onSurface)),
                Text('jacobjones24@gmail.com', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w500, color: cs.onSurfaceVariant)),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen())),
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 14, color: cs.primary),
                      const SizedBox(width: 4),
                      Text('Edit Profile', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: cs.primary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: cs.onSurfaceVariant)),
    );
  }

  Widget _buildSettingsGroup(ColorScheme cs, List<Widget> tiles) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: cs.shadow.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: List.generate(tiles.length, (index) {
          if (index == tiles.length - 1) return tiles[index];
          return Column(
            children: [
              tiles[index],
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(height: 1, color: cs.outlineVariant.withValues(alpha: 0.3)),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _settingsTile(IconData icon, String title, ColorScheme cs, {String? trailingLabel, VoidCallback? onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: cs.onSurfaceVariant, size: 22),
      title: Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w600, color: cs.onSurface)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingLabel != null)
            Text(trailingLabel, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w500, color: cs.onSurfaceVariant)),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded, color: cs.outlineVariant, size: 20),
        ],
      ),
      onTap: onTap,
    );
  }
}
