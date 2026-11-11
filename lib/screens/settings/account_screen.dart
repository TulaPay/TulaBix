import 'package:flutter/material.dart';
import 'package:tulapay/authentication/upgrade_to_tier2.dart';
import 'package:tulapay/models/merchant.dart';
import 'package:tulapay/screens/settings/edit_profile_screen.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';
import 'package:tulapay/widgets/ui/ui.dart';
import 'package:tulapay/l10n/l10n_extension.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Future<Merchant> _future;

  @override
  void initState() {
    super.initState();
    _future = MerchantRepository.instance.myMerchant(refresh: true);
  }

  void _reload() => setState(() {
        _future = MerchantRepository.instance.myMerchant(refresh: true);
      });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return FutureBuilder<Merchant>(
      future: _future,
      builder: (context, snap) {
        final m = snap.data;
        return GlassPageShell(
          title: context.l10n.accountInformation,
          subtitle: context.l10n.businessIdentityAndMerchantVerification,
          icon: Icons.person_rounded,
          actionLabel: context.l10n.updateDetails,
          onAction: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditProfileScreen()),
          ).then((_) => _reload()),
          children: [
            if (snap.connectionState == ConnectionState.waiting)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (m == null)
              GlassInfoCard(
                icon: Icons.error_outline_rounded,
                title: context.l10n.couldNotLoadYourAccount,
                subtitle: context.l10n.pullToRefreshOrTry,
              )
            else ...[
              _kv(context.l10n.businessName, m.businessName),
              _kv(context.l10n.category, m.businessCategory),
              _kv(context.l10n.owner, m.ownerName),
              _kv(context.l10n.phone, m.ownerPhone),
              _kv(context.l10n.email, m.ownerEmail ?? '—'),
              _kv(context.l10n.address, m.addressLine),
              const SizedBox(height: 24),
              GlassSurface(
                borderRadius: AppRadius.smAll,
                border: Border.all(color: context.hairlineColor),
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Icon(
                      m.isVerified
                          ? Icons.verified_rounded
                          : Icons.hourglass_bottom_rounded,
                      color: m.isVerified
                          ? AppColors.positive
                          : AppColors.warning,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.l10n.verification,
                              style: AppText.cardTitle(color: cs.onSurface)),
                          Text(
                            context.l10n.verificationLine(m.kycStatus, '${m.kybTier}', m.accountStatus),
                            style: AppText.caption(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (m.isTier1) ...[
                const SizedBox(height: 12),
                GlassInfoCard(
                  icon: Icons.trending_up_rounded,
                  title: context.l10n.upgradeToTier2,
                  subtitle: context.l10n.higherLimitsAndLowerFees,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const UpgradeToTier()),
                  ).then((_) => _reload()),
                ),
              ],
            ],
          ],
        );
      },
    );
  }

  Widget _kv(String k, String v) => Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: context.hairlineColor)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              child: Text(k, style: AppText.caption(color: context.textTertiary)),
            ),
            Expanded(
              child: Text(
                v,
                style: AppText.body(color: Theme.of(context).colorScheme.onSurface)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
}
