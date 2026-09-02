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
    } catch (_) {}
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
        AppFeedback.toast(context, 'Could not sign out — try again');
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
                AppSpacing.xl, AppSpacing.xxl, AppSpacing.xl, AppSpacing.sm),
            sliver: SliverToBoxAdapter(
              child: Text('Settings', style: AppText.screenTitle(size: 32)),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppSpacing.lg),
                _profileCard(cs)
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.08, curve: Curves.easeOutQuart),
                const SizedBox(height: AppSpacing.section),
                const MicroLabel('Account & Security'),
                const SizedBox(height: AppSpacing.md),
                _group([
                  _row(
                    icon: Icons.person_rounded,
                    color: cs.primary,
                    title: 'Account Information',
                    subtitle: 'Business identity and verification',
                    badge: _merchant?.isVerified == true ? 'Verified' : null,
                    badgeColor: const Color(0xFF10B981),
                    onTap: () => _push(const AccountScreen()),
                  ),
                  _row(
                    icon: Icons.shield_rounded,
                    color: const Color(0xFFF59E0B),
                    title: 'Privacy & Security',
                    subtitle: 'Password, app lock, and PIN',
                    onTap: () => _push(const SecurityScreen()),
                  ),
                  _row(
                    icon: Icons.account_balance_wallet_rounded,
                    color: const Color(0xFF8B5CF6),
                    title: 'Payment Methods',
                    subtitle: 'Settlement account and fees',
                    onTap: () => _push(const BillingScreen()),
                    last: true,
                  ),
                ]),
                const SizedBox(height: AppSpacing.huge),
                const MicroLabel('Preferences'),
                const SizedBox(height: AppSpacing.md),
                _group([
                  _row(
                    icon: Icons.notifications_active_rounded,
                    color: cs.tertiary,
                    title: 'Notifications',
                    subtitle: 'Alerts and notification channels',
                    onTap: () => _push(const NotificationsSettingsScreen()),
                  ),
                  _row(
                    icon: Icons.language_rounded,
                    color: const Color(0xFF14B8A6),
                    title: 'Language',
                    subtitle: AppPreferences.instance.locale.value.languageCode
                                .toLowerCase() ==
                            'fr'
                        ? 'Français'
                        : 'English',
                    onTap: () => _push(
                        const LanguageScreen(settingsMode: true)),
                  ),
                  ValueListenableBuilder<ThemeMode>(
                    valueListenable: AppPreferences.instance.themeMode,
                    builder: (context, mode, _) {
                      final isDark = mode == ThemeMode.dark;
                      return _toggleRow(
                        icon: isDark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        color: cs.secondary,
                        title: 'Appearance',
                        subtitle: switch (mode) {
                          ThemeMode.dark => 'Dark theme',
                          ThemeMode.light => 'Light theme',
                          ThemeMode.system => 'Follows system',
                        },
                        value: isDark,
                        onChanged: (v) => AppPreferences.instance
                            .setThemeMode(
                                v ? ThemeMode.dark : ThemeMode.light),
                        last: true,
                      );
                    },
                  ),
                ]),
                const SizedBox(height: AppSpacing.huge),
                const MicroLabel('Growth'),
                const SizedBox(height: AppSpacing.md),
                _group([
                  _row(
                    icon: Icons.flag_rounded,
                    color: const Color(0xFF0EA5E9),
                    title: 'Growth Goals',
                    subtitle: 'Revenue, customers, and repeat orders',
                    onTap: () => _push(const GrowthGoalsScreen()),
                  ),
                  _row(
                    icon: Icons.star_rounded,
                    color: const Color(0xFFF59E0B),
                    title: 'Favorites',
                    subtitle: 'Pin the screens you use most',
                    onTap: () => _push(const FavoritesScreen()),
                    last: true,
                  ),
                ]),
                const SizedBox(height: AppSpacing.huge),
                const MicroLabel('Support & Legal'),
                const SizedBox(height: AppSpacing.md),
                _group([
                  _row(
                    icon: Icons.help_center_rounded,
                    color: const Color(0xFF06B6D4),
                    title: 'Help Center',
                    subtitle: 'FAQs and support contact',
                    onTap: () => _push(const HelpCenterScreen()),
                  ),
                  _row(
                    icon: Icons.description_rounded,
                    color: cs.onSurfaceVariant,
                    title: 'Legal Agreements',
                    subtitle: 'Privacy policy and terms of use',
                    onTap: () => _push(const PrivacyPolicyScreen()),
                    last: true,
                  ),
                ]),
                const SizedBox(height: AppSpacing.section),
                Center(
                  child: PillButton.outlined(
                    _signingOut ? 'Signing out…' : 'Sign Out',
                    icon: Icons.logout_rounded,
                    onTap: _signingOut ? null : _signOut,
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
    return GradientHeroCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 64,
                width: 64,
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: AppText.screenTitle(size: 20, color: Colors.white),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m?.businessName ?? 'Your business',
                      style: AppText.screenTitle(size: 22, color: Colors.white),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      m?.ownerEmail ?? m?.ownerPhone ?? '',
                      style: AppText.caption(
                          color: Colors.white.withValues(alpha: 0.8)),
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
                  icon: const Icon(Icons.edit_rounded, size: 18),
                  label: const Text('Edit Profile'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: cs.primary,
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(Icons.qr_code_2_rounded, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
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
              Icon(Icons.chevron_right_rounded,
                  size: 20,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withValues(alpha: 0.5)),
            ],
          ),
        ),
        if (!last) Divider(indent: AppSpacing.lg + 44 + AppSpacing.md),
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
        if (!last) Divider(indent: AppSpacing.lg + 44 + AppSpacing.md),
      ],
    );
  }
}
