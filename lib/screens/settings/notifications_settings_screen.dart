import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/widgets/glass_effects.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Notifications",
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          GlassSurface(
            borderRadius: BorderRadius.circular(28),
            opacity: 0.14,
            blur: 16,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notification preferences',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Choose how the app alerts you about payment activity and security events.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: cs.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassSurface(
            borderRadius: BorderRadius.circular(28),
            opacity: 0.12,
            blur: 14,
            child: Column(
              children: [
                _buildSwitch(
                  context,
                  "Email Notifications",
                  "Settlement updates and reports",
                  _emailNotifications,
                  (v) => setState(() => _emailNotifications = v),
                ),
                const Divider(height: 1),
                _buildSwitch(
                  context,
                  "Push Notifications",
                  "Real-time payment and account alerts",
                  _pushNotifications,
                  (v) => setState(() => _pushNotifications = v),
                ),
                const Divider(height: 1),
                _buildSwitch(
                  context,
                  "SMS Notifications",
                  "Critical fallback alerts",
                  _smsNotifications,
                  (v) => setState(() => _smsNotifications = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    final cs = Theme.of(context).colorScheme;
    return SwitchListTile.adaptive(
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          color: cs.onSurfaceVariant,
        ),
        ),
        value: value,
        onChanged: onChanged,
        activeThumbColor: cs.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      );
  }
}
