import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/models/merchant.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/utils/app_feedback.dart';
import 'package:tulapay/widgets/glass_effects.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool _loading = true;
  bool _email = true;
  bool _push = true;
  bool _sms = false;

  @override
  void initState() {
    super.initState();
    MerchantRepository.instance.preferences().then((MerchantPreferences p) {
      if (!mounted) return;
      setState(() {
        _email = p.notifEmail;
        _push = p.notifPush;
        _sms = p.notifSms;
        _loading = false;
      });
    }).catchError((_) {
      if (mounted) setState(() => _loading = false);
    });
  }

  Future<void> _save() async {
    try {
      await MerchantRepository.instance.savePreferences({
        'notif_email': _email,
        'notif_push': _push,
        'notif_sms': _sms,
      });
    } catch (_) {
      if (!mounted) return;
      AppFeedback.toast(context, 'Could not save — reverting');
      // Resync from the server rather than guessing which toggle to revert.
      try {
        final p = await MerchantRepository.instance.preferences();
        if (!mounted) return;
        setState(() {
          _email = p.notifEmail;
          _push = p.notifPush;
          _sms = p.notifSms;
        });
      } catch (_) {
        // Best-effort resync only — leave local state as-is if this fails too.
      }
    }
  }

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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                GlassSurface(
                  borderRadius: BorderRadius.circular(28),
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
                        'Choose how the app alerts you about payment activity '
                        'and security events.',
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
                  child: Column(
                    children: [
                      _buildSwitch(
                        context,
                        "Email Notifications",
                        "Settlement updates and reports",
                        _email,
                        (v) {
                          setState(() => _email = v);
                          _save();
                        },
                      ),
                      const Divider(height: 1),
                      _buildSwitch(
                        context,
                        "Push Notifications",
                        "Real-time payment and account alerts",
                        _push,
                        (v) {
                          setState(() => _push = v);
                          _save();
                        },
                      ),
                      const Divider(height: 1),
                      _buildSwitch(
                        context,
                        "SMS Notifications",
                        "Critical fallback alerts",
                        _sms,
                        (v) {
                          setState(() => _sms = v);
                          _save();
                        },
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
    ValueChanged<bool> onChanged,
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
