import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'settings/account_screen.dart';
import 'settings/billing_screen.dart';
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
      ..color = color.withValues(alpha: 0.015)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (var i = 0.0; i < size.width; i += 50) {
      for (var j = 0.0; j < size.height; j += 50) {
        canvas.drawCircle(Offset(i, j), 1.5, paint);
        if ((i + j) % 100 == 0) {
          canvas.drawRect(Rect.fromLTWH(i, j, 12, 12), paint);
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
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        // foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _GeometricPatternPainter(cs.primary),
            ),
          ),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context, cs),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileCard(cs)
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: 0.1, curve: Curves.easeOutQuart),
                      
                      const SizedBox(height: 40),
                      _sectionHeader('ACCOUNT & SECURITY', cs),
                      const SizedBox(height: 16),
                      _buildOptionCard(
                        icon: Icons.person_rounded,
                        iconColor: Colors.blue,
                        title: 'Account Information',
                        subtitle: 'Personal details and verification',
                        status: 'Verified',
                        statusColor: Colors.green,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountScreen())),
                        cs: cs,
                      ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.05),
                      
                      _buildOptionCard(
                        icon: Icons.shield_rounded,
                        iconColor: Colors.orange,
                        title: 'Privacy & Security',
                        subtitle: '2FA, Biometrics, and Password',
                        onTap: () => _showPlaceholder('Security'),
                        cs: cs,
                      ).animate().fadeIn(delay: 150.ms).slideX(begin: 0.05),

                      _buildOptionCard(
                        icon: Icons.account_balance_wallet_rounded,
                        iconColor: Colors.purple,
                        title: 'Payment Methods',
                        subtitle: 'Manage cards and bank accounts',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BillingScreen())),
                        cs: cs,
                      ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.05),

                      const SizedBox(height: 32),
                      _sectionHeader('PREFERENCES', cs),
                      const SizedBox(height: 16),
                      _buildOptionCard(
                        icon: Icons.notifications_active_rounded,
                        iconColor: Colors.redAccent,
                        title: 'Notifications',
                        subtitle: 'Alerts and notification channels',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsSettingsScreen())),
                        cs: cs,
                      ).animate().fadeIn(delay: 250.ms).slideX(begin: 0.05),

                      _buildOptionCard(
                        icon: Icons.language_rounded,
                        iconColor: Colors.teal,
                        title: 'Language',
                        subtitle: _currentLanguage,
                        onTap: () => _showPlaceholder('Language'),
                        cs: cs,
                      ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.05),

                      _buildOptionCard(
                        icon: _isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        iconColor: Colors.indigo,
                        title: 'Appearance',
                        subtitle: _isDarkMode ? 'Dark theme enabled' : 'Light theme enabled',
                        onTap: () => setState(() => _isDarkMode = !_isDarkMode),
                        cs: cs,
                      ).animate().fadeIn(delay: 350.ms).slideX(begin: 0.05),

                      const SizedBox(height: 32),
                      _sectionHeader('SUPPORT & LEGAL', cs),
                      const SizedBox(height: 16),
                      _buildOptionCard(
                        icon: Icons.help_center_rounded,
                        iconColor: Colors.cyan,
                        title: 'Help Center',
                        subtitle: 'FAQs and support contact',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpCenterScreen())),
                        cs: cs,
                      ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.05),

                      _buildOptionCard(
                        icon: Icons.description_rounded,
                        iconColor: Colors.grey,
                        title: 'Legal Agreements',
                        subtitle: 'Privacy policy and terms of use',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen())),
                        cs: cs,
                      ).animate().fadeIn(delay: 450.ms).slideX(begin: 0.05),
                      
                      const SizedBox(height: 48),
                      _buildLogoutButton(cs),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ColorScheme cs) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: cs.surface.withValues(alpha: 0.9),
      surfaceTintColor: Colors.transparent,
      expandedHeight: 140,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        title: Text(
          'Settings',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            color: cs.onSurface,
            fontSize: 26,
            letterSpacing: -1.2,
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, size: 22, color: cs.onSurface),
        onPressed: () => Navigator.maybePop(context),
      ),
    );
  }

  Widget _buildProfileCard(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primary,
            cs.primary.withValues(alpha: 0.85),
            cs.secondary.withValues(alpha: 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.35),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
          BoxShadow(
            color: cs.secondary.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(5, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=jacob'),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jacob Jones',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      'jacobjones24@gmail.com',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen())),
                    icon: const Icon(Icons.edit_rounded, size: 18),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: cs.primary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                ),
                child: const Icon(Icons.qr_code_2_rounded, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: cs.onSurfaceVariant.withValues(alpha: 0.5),
          letterSpacing: 2.0,
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? status,
    Color? statusColor,
    required VoidCallback onTap,
    required ColorScheme cs,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Material(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  cs.surfaceContainerLow,
                  cs.surfaceContainer.withValues(alpha: 0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        iconColor.withValues(alpha: 0.15),
                        iconColor.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: iconColor.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: cs.onSurface,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          if (status != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: (statusColor ?? cs.primary).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                status,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: statusColor ?? cs.primary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: cs.onSurfaceVariant.withValues(alpha: 0.25),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(ColorScheme cs) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showPlaceholder('Logout'),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cs.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.logout_rounded, color: cs.error, size: 18),
                ),
                const SizedBox(width: 14),
                Text(
                  'Sign Out',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: cs.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
