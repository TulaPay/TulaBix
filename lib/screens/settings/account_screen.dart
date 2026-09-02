import 'package:flutter/material.dart';
import 'package:tulapay/authentication/upgrade_to_tier2.dart';
import 'package:tulapay/models/merchant.dart';
import 'package:tulapay/screens/settings/edit_profile_screen.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';
import 'package:tulapay/widgets/ui/ui.dart';

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

  void _reload() =>
      setState(() => _future = MerchantRepository.instance.myMerchant(refresh: true));

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return FutureBuilder<Merchant>(
      future: _future,
      builder: (context, snap) {
        final m = snap.data;
        return GlassPageShell(
          title: 'Account Information',
          subtitle: 'Business identity and merchant verification.',
          icon: Icons.person_rounded,
          actionLabel: 'Update details',
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
              const GlassInfoCard(
                icon: Icons.error_outline_rounded,
                title: 'Could not load your account',
                subtitle: 'Pull to refresh or try again in a moment.',
              )
            else ...[
              _kv('Business name', m.businessName),
              _kv('Category', m.businessCategory),
              _kv('Owner', m.ownerName),
              _kv('Phone', m.ownerPhone),
              _kv('Email', m.ownerEmail ?? '—'),
              _kv('Address', m.addressLine),
              const SizedBox(height: 12),
              GlassSurface(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Icon(
                      m.isVerified
                          ? Icons.verified_rounded
                          : Icons.hourglass_bottom_rounded,
                      color: m.isVerified
                          ? const Color(0xFF10B981)
                          : cs.tertiary,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Verification',
                              style: AppText.cardTitle(color: cs.onSurface)),
                          Text(
                            'KYC ${m.kycStatus} · Tier ${m.kybTier} · '
                            'Account ${m.accountStatus}',
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
                  title: 'Upgrade to Tier 2',
                  subtitle: 'Higher limits and lower fees. Requires review.',
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

  Widget _kv(String k, String v) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: GlassSurface(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 110,
                child: Text(k, style: AppText.caption()),
              ),
              Expanded(
                child: Text(v, style: AppText.body()),
              ),
            ],
          ),
        ),
      );
}
