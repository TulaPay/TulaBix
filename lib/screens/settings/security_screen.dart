import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tulapay/models/merchant.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/services/supabase_client.dart';
import 'package:tulapay/utils/app_feedback.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/ui/ui.dart';
import 'package:tulapay/l10n/l10n_extension.dart';

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
    }).catchError((_) {
      if (mounted) {
        AppFeedback.toast(context, context.l10n.couldNotLoadYourSecurity);
      }
    });
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
      AppFeedback.toast(context, context.l10n.useAtLeast8Characters);
      return;
    }
    if (pw != _confirm.text.trim()) {
      AppFeedback.toast(context, context.l10n.passwordsDoNotMatch);
      return;
    }
    setState(() => _busy = true);
    try {
      await supabase.auth.updateUser(UserAttributes(password: pw));
      if (!mounted) return;
      _password.clear();
      _confirm.clear();
      AppFeedback.toast(context, context.l10n.passwordUpdated);
    } catch (e) {
      if (mounted) AppFeedback.toast(context, context.l10n.couldNotUpdatePassword);
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
    } catch (_) {
      if (!mounted) return;
      setState(() => _appLock = !value);
      AppFeedback.toast(context, context.l10n.couldNotSaveThisSetting);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AppScaffold(
      title: context.l10n.privacySecurity,
      scrollable: true,
      bodyPadding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.section),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MicroLabel(context.l10n.changePassword),
          const SizedBox(height: AppSpacing.md),
          GlassSurface(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(labelText: context.l10n.newPassword),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _confirm,
                  obscureText: true,
                  decoration:
                      InputDecoration(labelText: context.l10n.confirmNewPassword),
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
                        : Text(context.l10n.updatePassword),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.huge),
          MicroLabel(context.l10n.device),
          const SizedBox(height: AppSpacing.md),
          GlassSurface(
            padding: EdgeInsets.zero,
            child: ToggleTile(
              title: context.l10n.requireUnlockOnOpen,
              subtitle: context.l10n.askForDeviceBiometricsPasscode,
              value: _appLock,
              onChanged: _toggleAppLock,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            context.l10n.your6DigitTransactionPin2,
            style: AppText.caption(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
