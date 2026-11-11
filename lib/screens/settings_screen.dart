import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tulapay/authentication/sign_in.dart';
import 'package:tulapay/models/merchant.dart';
import 'package:tulapay/screens/select_language.dart';
import 'package:tulapay/services/app_preferences.dart';
import 'package:tulapay/services/auth_service.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/utils/app_feedback.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/ui/ui.dart';
import 'settings/account_screen.dart';
import 'settings/billing_screen.dart';
import 'settings/favorites_screen.dart';
import 'settings/growth_goals_screen.dart';
import 'settings/notifications_settings_screen.dart';
import 'settings/help_center_screen.dart';
import 'settings/privacy_policy_screen.dart';
import 'settings/security_screen.dart';
import 'settings/edit_profile_screen.dart';
import 'package:tulapay/l10n/l10n_extension.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Merchant? _merchant;
  bool _signingOut = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final m = await MerchantRepository.instance.myMerchant();
      if (mounted) setState(() => _merchant = m);
    } catch (_) {
      if (mounted) {
        AppFeedback.toast(context, context.l10n.couldNotLoadYourProfile);
      }
    }
  }

  void _push(Widget screen) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => screen),
  ).then((_) => _load());

  Future<void> _signOut() async {
    setState(() => _signingOut = true);
    try {
      await AuthService.instance.signOut();
      MerchantRepository.instance.clearCache();
      AppPreferences.instance.reset();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const SignIn()),
        (route) => false,
      );
    } catch (e) {
      if (mounted) {
        setState(() => _signingOut = false);
        AppFeedback.toast(context, context.l10n.couldNotSignOutTry);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xxl,
              AppSpacing.xxl,
              AppSpacing.xxl,
              AppSpacing.sm,
            ),
            sliver: SliverToBoxAdapter(
              child: Text(context.l10n.settings, style: AppText.screenTitle(size: 30)),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppSpacing.lg),
                _profileCard(cs)
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.08, curve: Curves.easeOutQuart),
                const SizedBox(height: AppSpacing.section),
                MicroLabel(context.l10n.accountSecurity),
                const SizedBox(height: AppSpacing.md),
                _group([
                  _row(
                    icon: Icons.person_rounded,
                    color: cs.primary,
                    title: context.l10n.accountInformation,
                    subtitle: context.l10n.businessIdentityAndVerification,
                    badge: _merchant?.isVerified == true ? context.l10n.verified : null,
                    badgeColor: AppColors.positive,
                    onTap: () => _push(const AccountScreen()),
                  ),
                  _row(
                    icon: Icons.shield_rounded,
                    color: cs.primary,
                    title: context.l10n.privacySecurity,
                    subtitle: context.l10n.passwordAppLockAndPin,
                    onTap: () => _push(const SecurityScreen()),
                  ),
                  _row(
                    icon: Icons.account_balance_wallet_rounded,
                    color: cs.primary,
                    title: context.l10n.paymentMethods,
                    subtitle: context.l10n.settlementAccountAndFees,
                    onTap: () => _push(const BillingScreen()),
                    last: true,
                  ),
                ]),
                const SizedBox(height: AppSpacing.huge),
                MicroLabel(context.l10n.preferences),
                const SizedBox(height: AppSpacing.md),
                _group([
                  _row(
                    icon: Icons.notifications_active_rounded,
                    color: cs.primary,
                    title: context.l10n.notifications,
                    subtitle: context.l10n.alertsAndNotificationChannels,
                    onTap: () => _push(const NotificationsSettingsScreen()),
                  ),
                  _row(
                    icon: Icons.language_rounded,
                    color: cs.primary,
                    title: context.l10n.language,
                    subtitle:
                        AppPreferences.instance.locale.value.languageCode
                                .toLowerCase() ==
                            'fr'
                        ? 'Français'
                        : 'English',
                    onTap: () =>
                        _push(const LanguageScreen(settingsMode: true)),
                  ),
                  ValueListenableBuilder<ThemeMode>(
                    valueListenable: AppPreferences.instance.themeMode,
                    builder: (context, mode, _) {
                      final isDark = mode == ThemeMode.dark;
                      return _toggleRow(
                        icon: isDark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        color: cs.primary,
                        title: context.l10n.appearance,
                        subtitle: switch (mode) {
                          ThemeMode.dark => context.l10n.darkTheme,
                          ThemeMode.light => context.l10n.lightTheme,
                          ThemeMode.system => context.l10n.followsSystem,
                        },
                        value: isDark,
                        onChanged: (v) => AppPreferences.instance.setThemeMode(
                          v ? ThemeMode.dark : ThemeMode.light,
                        ),
                        last: true,
                      );
                    },
                  ),
                ]),
                const SizedBox(height: AppSpacing.huge),
                MicroLabel(context.l10n.growth),
                const SizedBox(height: AppSpacing.md),
                _group([
                  _row(
                    icon: Icons.flag_rounded,
                    color: cs.primary,
                    title: context.l10n.growthGoals,
                    subtitle: context.l10n.revenueCustomersAndRepeatOrders,
                    onTap: () => _push(const GrowthGoalsScreen()),
                  ),
                  _row(
                    icon: Icons.star_rounded,
                    color: cs.primary,
                    title: context.l10n.favorites,
                    subtitle: context.l10n.pinTheScreensYouUse2,
                    onTap: () => _push(const FavoritesScreen()),
                    last: true,
                  ),
                ]),
                const SizedBox(height: AppSpacing.huge),
                MicroLabel(context.l10n.supportLegal),
                const SizedBox(height: AppSpacing.md),
                _group([
                  _row(
                    icon: Icons.help_center_rounded,
                    color: cs.primary,
                    title: context.l10n.helpCenter,
                    subtitle: context.l10n.faqsAndSupportContact,
                    onTap: () => _push(const HelpCenterScreen()),
                  ),
                  _row(
                    icon: Icons.description_rounded,
                    color: cs.primary,
                    title: context.l10n.legalAgreements,
                    subtitle: context.l10n.privacyPolicyAndTermsOf,
                    onTap: () => _push(const PrivacyPolicyScreen()),
                    last: true,
                  ),
                ]),
                const SizedBox(height: AppSpacing.section),
                Center(
                  child: OutlinedButton.icon(
                    onPressed: _signingOut ? null : _signOut,
                    icon: const Icon(Icons.logout_rounded, size: 16),
                    label: Text(_signingOut ? context.l10n.signingOut : context.l10n.signOut2),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cs.onSurface,
                      side: BorderSide(color: context.hairlineColor),
                      minimumSize: const Size(0, 48),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                  ),
                ),
                const SizedBox(height: 96),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileCard(ColorScheme cs) {
    final m = _merchant;
    final initials = _initials(m?.businessName ?? m?.ownerName ?? 'T B');
    return Container(
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: cs.onPrimary.withValues(alpha: 0.22),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: AppText.screenTitle(size: 17, color: cs.onPrimary),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m?.businessName ?? context.l10n.yourBusiness,
                      style: AppText.screenTitle(size: 18, color: cs.onPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      m?.ownerEmail ?? m?.ownerPhone ?? '',
                      style: AppText.caption(
                        color: cs.onPrimary.withValues(alpha: 0.82),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _push(const EditProfileScreen()),
                  icon: const Icon(Icons.edit_rounded, size: 16),
                  label: Text(context.l10n.editProfile),
                  style: FilledButton.styleFrom(
                    backgroundColor: cs.onPrimary,
                    foregroundColor: cs.primary,
                    minimumSize: const Size.fromHeight(44),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: cs.onPrimary.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(
                    Icons.qr_code_2_rounded,
                    color: cs.onPrimary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'TB';
    if (parts.length == 1) {
      return parts.first
          .substring(0, parts.first.length >= 2 ? 2 : 1)
          .toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  Widget _group(List<Widget> children) {
    return GlassSurface(
      padding: EdgeInsets.zero,
      child: Column(children: children),
    );
  }

  Widget _row({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    String? badge,
    Color? badgeColor,
    required VoidCallback onTap,
    bool last = false,
  }) {
    return Column(
      children: [
        ListRowCard(
          floating: false,
          icon: icon,
          iconColor: color,
          title: title,
          subtitle: subtitle,
          onTap: onTap,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (badge != null) ...[
                StatusBadge(badge, color: badgeColor),
                const SizedBox(width: AppSpacing.sm),
              ],
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _toggleRow({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool last = false,
  }) {
    return Column(
      children: [
        ListRowCard(
          floating: false,
          icon: icon,
          iconColor: color,
          title: title,
          subtitle: subtitle,
          trailing: Switch.adaptive(value: value, onChanged: onChanged),
        ),
      ],
    );
  }
}
