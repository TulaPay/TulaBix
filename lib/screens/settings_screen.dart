import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tulapay/screens/settings/account_screen.dart';
import 'package:tulapay/screens/settings/billing_screen.dart';
import 'package:tulapay/screens/settings/edit_profile_screen.dart';
import 'package:tulapay/screens/settings/favorites_screen.dart';
import 'package:tulapay/screens/settings/growth_goals_screen.dart';
import 'package:tulapay/screens/settings/help_center_screen.dart';
import 'package:tulapay/screens/settings/notifications_settings_screen.dart';
import 'package:tulapay/screens/settings/privacy_policy_screen.dart';
import 'package:tulapay/widgets/glass_effects.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final quickActions = [
      _QuickAction(
        icon: Icons.person_outline_rounded,
        title: 'Profile',
        subtitle: 'Name, email, and merchant identity',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EditProfileScreen()),
        ),
      ),
      _QuickAction(
        icon: Icons.credit_card_rounded,
        title: 'Billing',
        subtitle: 'Cards, wallets, and settlement methods',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BillingScreen()),
        ),
      ),
      _QuickAction(
        icon: Icons.notifications_active_rounded,
        title: 'Alerts',
        subtitle: 'Payment, security, and app notifications',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const NotificationsSettingsScreen(),
          ),
        ),
      ),
      _QuickAction(
        icon: Icons.lock_outline_rounded,
        title: 'Security',
        subtitle: 'Privacy, access, and device trust',
        onTap: () => _showPlaceholder(context, 'Security'),
      ),
    ];

    final settingsGroups = [
      _SettingsGroup(
        title: 'Account',
        items: [
          _SettingsItem(
            icon: Icons.person_rounded,
            title: 'Account Information',
            subtitle: 'Business identity and verification',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AccountScreen()),
            ),
          ),
          _SettingsItem(
            icon: Icons.star_outline_rounded,
            title: 'Favorites',
            subtitle: 'Frequently used screens and shortcuts',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesScreen()),
            ),
          ),
          _SettingsItem(
            icon: Icons.flag_outlined,
            title: 'Growth Goals',
            subtitle: 'Track revenue and customer milestones',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GrowthGoalsScreen()),
            ),
          ),
        ],
      ),
      _SettingsGroup(
        title: 'Money & operations',
        items: [
          _SettingsItem(
            icon: Icons.account_balance_wallet_rounded,
            title: 'Payment Methods',
            subtitle: 'Cards, bank accounts, and payout routes',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BillingScreen()),
            ),
          ),
          _SettingsItem(
            icon: Icons.security_rounded,
            title: 'Transaction Controls',
            subtitle: 'Limits, approvals, and safe payment defaults',
            onTap: () => _showPlaceholder(context, 'Transaction controls'),
          ),
          _SettingsItem(
            icon: Icons.receipt_long_rounded,
            title: 'Receipt & invoicing',
            subtitle: 'Branding, delivery, and receipt preferences',
            onTap: () => _showPlaceholder(context, 'Receipt settings'),
          ),
        ],
      ),
      _SettingsGroup(
        title: 'Preferences',
        items: [
          _SettingsItem(
            icon: Icons.notifications_rounded,
            title: 'Notifications',
            subtitle: 'Email, push, and SMS alerts',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const NotificationsSettingsScreen(),
              ),
            ),
          ),
          _SettingsItem(
            icon: Icons.language_rounded,
            title: 'Language',
            subtitle: 'English',
            onTap: () => _showPlaceholder(context, 'Language'),
          ),
          _SettingsItem(
            icon: Icons.color_lens_outlined,
            title: 'Appearance',
            subtitle: 'Follows system theme',
            onTap: () => _showPlaceholder(context, 'Appearance'),
          ),
        ],
      ),
      _SettingsGroup(
        title: 'Support',
        items: [
          _SettingsItem(
            icon: Icons.help_center_rounded,
            title: 'Help Center',
            subtitle: 'FAQs, chat, and contact support',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HelpCenterScreen()),
            ),
          ),
          _SettingsItem(
            icon: Icons.description_rounded,
            title: 'Legal & privacy',
            subtitle: 'Policies, terms, and compliance',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
            ),
          ),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            expandedHeight: 140,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: cs.onSurface),
              onPressed: () => Navigator.maybePop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              title: Text(
                'Settings',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                  fontSize: 26,
                  letterSpacing: -1.0,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: GlassSurface(
                borderRadius: BorderRadius.circular(30),
                opacity: 0.14,
                blur: 16,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            cs.primary.withValues(alpha: 0.22),
                            cs.secondary.withValues(alpha: 0.12),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.business_rounded,
                        color: cs.primary,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Merchant control center',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Manage your business profile, money flow, security, and support from one place.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: cs.onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'Quick access',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: cs.onSurfaceVariant.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: quickActions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1.45,
                  ),
                  itemBuilder: (context, index) {
                    final action = quickActions[index];
                    return _QuickActionCard(action: action);
                  },
                ),
                // const SizedBox(height: 10),
                ...settingsGroups.expand(
                  (group) => [
                    _GroupHeader(title: group.title),
                    const SizedBox(height: 10),
                    ...group.items.expand(
                      (item) => [
                        _SettingsTile(item: item),
                        const SizedBox(height: 10),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                GlassSurface(
                  borderRadius: BorderRadius.circular(24),
                  opacity: 0.12,
                  blur: 12,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              cs.primary.withValues(alpha: 0.24),
                              cs.secondary.withValues(alpha: 0.12),
                            ],
                          ),
                        ),
                        child: Icon(Icons.verified_outlined, color: cs.primary),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tulabix Limited',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Professional payment solutions for modern merchants',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton.icon(
                    onPressed: () => _showPlaceholder(context, 'Logout'),
                    icon: Icon(Icons.logout_rounded, color: cs.error),
                    label: Text(
                      'Sign out',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        color: cs.error,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showPlaceholder(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

class _QuickActionCard extends StatelessWidget {
  final _QuickAction action;
  const _QuickActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: action.onTap,
        child: GlassSurface(
          borderRadius: BorderRadius.circular(24),
          opacity: 0.12,
          blur: 12,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    colors: [
                      cs.primary.withValues(alpha: 0.22),
                      cs.secondary.withValues(alpha: 0.12),
                    ],
                  ),
                ),
                child: Icon(action.icon, color: cs.primary, size: 15),
              ),

              Text(
                action.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                action.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: cs.onSurfaceVariant,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsGroup {
  final String title;
  final List<_SettingsItem> items;
  const _SettingsGroup({required this.title, required this.items});
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

class _GroupHeader extends StatelessWidget {
  final String title;
  const _GroupHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.plusJakartaSans(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
        color: cs.onSurfaceVariant.withValues(alpha: 0.55),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final _SettingsItem item;
  const _SettingsTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GlassSurface(
      borderRadius: BorderRadius.circular(24),
      opacity: 0.12,
      blur: 12,
      padding: const EdgeInsets.all(16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(24),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      cs.primary.withValues(alpha: 0.22),
                      cs.secondary.withValues(alpha: 0.10),
                    ],
                  ),
                ),
                child: Icon(item.icon, color: cs.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurfaceVariant.withValues(alpha: 0.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
