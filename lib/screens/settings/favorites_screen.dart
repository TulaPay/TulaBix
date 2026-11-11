import 'package:flutter/material.dart';
import 'package:tulapay/screens/activity_screen.dart';
import 'package:tulapay/screens/cash_receipts_screen.dart';
import 'package:tulapay/screens/payment_links_screen.dart';
import 'package:tulapay/screens/promo_codes_screen.dart';
import 'package:tulapay/screens/payment_page_screen.dart';
import 'package:tulapay/screens/settings/billing_screen.dart';
import 'package:tulapay/screens/settings/growth_goals_screen.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';
import 'package:tulapay/widgets/ui/ui.dart';
import 'package:tulapay/l10n/l10n_extension.dart';

/// A curated catalogue of destinations a merchant can pin. Previously this
/// screen had no route in at all.
class _FavItem {
  final String key;
  final String label;
  final IconData icon;
  final WidgetBuilder builder;
  const _FavItem(this.key, this.label, this.icon, this.builder);
}

List<_FavItem> _catalogue(BuildContext context) => <_FavItem>[
  // key stays 'scan_qr' even though this now opens the real Payment Page —
  // a merchant may already have this pinned as a favorite in
  // merchant_favorites, and changing the key would silently orphan it.
  _FavItem('scan_qr', context.l10n.myQrCode, Icons.qr_code_scanner_rounded,
      (_) => const PaymentPageScreen()),
  _FavItem('payment_links', context.l10n.paymentLinks, Icons.link_rounded,
      (_) => const PaymentLinksScreen()),
  _FavItem('cash_receipts', context.l10n.cashReceipts, Icons.receipt_long_rounded,
      (_) => const CashReceiptsScreen()),
  _FavItem('promo_codes', context.l10n.promoCodes, Icons.local_offer_rounded,
      (_) => const PromoCodesScreen()),
  _FavItem('activity', context.l10n.activity, Icons.timeline_rounded,
      (_) => const ActivityScreen()),
  _FavItem('growth_goals', context.l10n.growthGoals, Icons.flag_rounded,
      (_) => const GrowthGoalsScreen()),
  _FavItem('billing', context.l10n.billing, Icons.credit_card_rounded,
      (_) => const BillingScreen()),
];

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Set<String> _pinned = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final favs = await MerchantRepository.instance.favorites();
      if (!mounted) return;
      setState(() {
        _pinned = favs.map((f) => f.settingKey).toSet();
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _toggle(_FavItem item) async {
    final adding = !_pinned.contains(item.key);
    setState(() {
      adding ? _pinned.add(item.key) : _pinned.remove(item.key);
    });
    try {
      if (adding) {
        await MerchantRepository.instance
            .addFavorite(item.key, item.label, route: item.key);
      } else {
        await MerchantRepository.instance.removeFavorite(item.key);
      }
    } catch (_) {
      if (mounted) _load(); // revert to server truth
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GlassPageShell(
      title: context.l10n.favorites,
      subtitle: context.l10n.pinTheScreensYouUse,
      icon: Icons.star_rounded,
      children: [
        if (_loading)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          )
        else
          for (final item in _catalogue(context))
            Padding(
              padding: EdgeInsets.zero,
              child: GlassSurface(
                padding: EdgeInsets.zero,
                child: ListRowCard(
                  floating: false,
                  icon: item.icon,
                  iconColor: cs.primary,
                  title: item.label,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: item.builder),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      _pinned.contains(item.key)
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: _pinned.contains(item.key)
                          ? AppColors.warning
                          : context.textTertiary,
                    ),
                    onPressed: () => _toggle(item),
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
