import 'package:flutter/material.dart';
import 'package:tulapay/screens/Customer_Screen.dart' show CustomerScreen;
import 'package:tulapay/screens/LoanScreen.dart';
import 'package:tulapay/screens/checklist_screen.dart';
import 'package:tulapay/screens/payment_page_screen.dart';
import 'package:tulapay/screens/promo_codes_screen.dart';
import 'package:tulapay/screens/payments_screen.dart';
import 'package:tulapay/screens/notification_screen.dart';
import 'package:tulapay/screens/settings_screen.dart';
import 'package:tulapay/screens/docs_screen.dart';
import 'package:tulapay/screens/help_screen.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:tulapay/widgets/ui/icon_chip.dart';
import 'package:tulapay/widgets/ui/section_header.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl, AppSpacing.lg, AppSpacing.md, AppSpacing.sm),
              child: Row(
                children: [
                  IconChip(Icons.hexagon_outlined,
                      color: cs.primary, size: 40, iconSize: 20),
                  const SizedBox(width: AppSpacing.md),
                  Text('TulaBiz', style: AppText.screenTitle(size: 22)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                children: [
                  const MicroLabel('Main'),
                  const SizedBox(height: AppSpacing.sm),
                  _item(context,
                      icon: Icons.home_rounded,
                      label: 'Home',
                      isActive: true,
                      onTap: () => Navigator.pop(context)),
                  _item(context,
                      icon: Icons.check_circle_outline_rounded,
                      label: 'Checklist',
                      badge: '5 Steps',
                      onTap: () =>
                          _go(context, const ChecklistScreen())),
                  _item(context,
                      icon: Icons.payment_rounded,
                      label: 'Payment Page',
                      onTap: () =>
                          _go(context, const PaymentPageScreen())),
                  _item(context,
                      icon: Icons.monetization_on_outlined,
                      label: 'Loan',
                      onTap: () => _go(context, const Loanscreen())),
                  _item(context,
                      icon: Icons.local_offer_rounded,
                      label: 'Promo Codes',
                      onTap: () =>
                          _go(context, const PromoCodesScreen())),
                  _item(context,
                      icon: Icons.people_rounded,
                      label: 'Customers',
                      onTap: () =>
                          _go(context, const CustomerScreen())),
                  _item(context,
                      icon: Icons.sync_alt_rounded,
                      label: 'Payments',
                      onTap: () => _go(context, const PaymentsScreen())),
                  const SizedBox(height: AppSpacing.xl),
                  const MicroLabel('Support'),
                  const SizedBox(height: AppSpacing.sm),
                  FutureBuilder<int>(
                    future: MerchantRepository.instance
                        .unreadNotificationCount()
                        .catchError((_) => 0),
                    builder: (context, snap) {
                      final n = snap.data ?? 0;
                      return _item(context,
                          icon: Icons.notifications_active_rounded,
                          label: 'Notifications',
                          badge: n > 0 ? '$n' : null,
                          badgeSolid: true,
                          onTap: () =>
                              _go(context, const NotificationScreen()));
                    },
                  ),
                  _item(context,
                      icon: Icons.settings_rounded,
                      label: 'Settings',
                      onTap: () => _go(context, const SettingsScreen())),
                  _item(context,
                      icon: Icons.menu_book_rounded,
                      label: 'Docs',
                      onTap: () => _go(context, const DocsScreen())),
                  _item(context,
                      icon: Icons.help_rounded,
                      label: 'Help',
                      onTap: () => _go(context, const HelpScreen())),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  IconChip(Icons.hexagon_outlined,
                      color: cs.primary, size: 36, iconSize: 18),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Tulabix Limited',
                            style: AppText.cardTitle(color: cs.onSurface)),
                        Text('Professional payment solutions',
                            style: AppText.caption(color: cs.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _go(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Widget _item(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
    String? badge,
    bool badgeSolid = false,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Material(
        color: isActive
            ? cs.primary.withValues(alpha: 0.10)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
            child: Row(
              children: [
                IconChip(icon,
                    color: isActive ? cs.primary : cs.onSurfaceVariant,
                    size: 36,
                    iconSize: 18,
                    background: isActive
                        ? cs.primary.withValues(alpha: 0.14)
                        : context.trackColor),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    label,
                    style: AppText.cardTitle(
                      color: isActive ? cs.onSurface : cs.onSurfaceVariant,
                    ).copyWith(
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w600),
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: badgeSolid
                          ? cs.primary
                          : cs.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      badge,
                      style: AppText.caption(
                        color: badgeSolid ? cs.onPrimary : cs.primary,
                      ).copyWith(fontSize: 10, fontWeight: FontWeight.w800),
                    ),
                  )
                else
                  Icon(Icons.chevron_right_rounded,
                      size: 18,
                      color: cs.onSurfaceVariant.withValues(alpha: 0.4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
