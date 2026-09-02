import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tulapay/models/merchant.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/services/supabase_client.dart';
import 'package:tulapay/utils/app_feedback.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/ui/ui.dart';

/// Backs the Settings → "Privacy & Security" row (was a "coming soon" snackbar).
class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;
  bool _appLock = false;
  MerchantPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    MerchantRepository.instance.preferences().then((p) {
      if (!mounted) return;
      setState(() {
        _prefs = p;
        _appLock = p.posSettings['biometric_lock'] == true;
      });
    }).catchError((_) {});
  }

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final pw = _password.text.trim();
    if (pw.length < 8) {
      AppFeedback.toast(context, 'Use at least 8 characters');
      return;
    }
    if (pw != _confirm.text.trim()) {
      AppFeedback.toast(context, 'Passwords do not match');
      return;
    }
    setState(() => _busy = true);
    try {
      await supabase.auth.updateUser(UserAttributes(password: pw));
      if (!mounted) return;
      _password.clear();
      _confirm.clear();
      AppFeedback.toast(context, 'Password updated');
    } catch (e) {
      if (mounted) AppFeedback.toast(context, 'Could not update password');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _toggleAppLock(bool value) async {
    setState(() => _appLock = value);
    final merged = {
      ...?_prefs?.posSettings,
      'biometric_lock': value,
    };
    try {
      await MerchantRepository.instance
          .savePreferences({'pos_settings': merged});
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AppScaffold(
      title: 'Privacy & Security',
      scrollable: true,
      bodyPadding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.section),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MicroLabel('Change password'),
          const SizedBox(height: AppSpacing.md),
          GlassSurface(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'New password'),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _confirm,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Confirm new password'),
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _busy ? null : _changePassword,
                    child: _busy
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Update password'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.huge),
          const MicroLabel('Device'),
          const SizedBox(height: AppSpacing.md),
          GlassSurface(
            padding: EdgeInsets.zero,
            child: ToggleTile(
              title: 'Require unlock on open',
              subtitle: 'Ask for device biometrics / passcode each launch',
              value: _appLock,
              onChanged: _toggleAppLock,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Your 6-digit transaction PIN is managed separately and is required '
            'for every payout regardless of this setting.',
            style: AppText.caption(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
