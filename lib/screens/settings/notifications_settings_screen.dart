import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/models/merchant.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/services/push_notification_service.dart';
import 'package:tulapay/utils/app_feedback.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/l10n/l10n_extension.dart';

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
      AppFeedback.toast(context, context.l10n.couldNotSaveReverting);
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
          context.l10n.notifications,
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              children: [
                GlassSurface(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.notificationPreferences,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        context.l10n.chooseHowTheAppAlerts2,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: cs.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                GlassSurface(
                  child: Column(
                    children: [
                      _buildSwitch(
                        context,
                        context.l10n.emailNotifications,
                        context.l10n.settlementUpdatesAndReports,
                        _email,
                        (v) {
                          setState(() => _email = v);
                          _save();
                        },
                      ),
                      const Divider(height: 1),
                      _buildSwitch(
                        context,
                        context.l10n.pushNotifications,
                        context.l10n.realTimePaymentAndAccount,
                        _push,
                        (v) async {
                          setState(() => _push = v);
                          if (v) {
                            final granted = await PushNotificationService.instance
                                .requestPermissions();
                            if (granted) {
                              await PushNotificationService.instance.syncToken();
                            }
                          }
                          _save();
                        },
                      ),
                      const Divider(height: 1),
                      _buildSwitch(
                        context,
                        context.l10n.smsNotifications,
                        context.l10n.criticalFallbackAlerts,
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
          color: context.textSecondary,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: cs.primary,
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}
