import 'package:flutter/material.dart';
import 'package:tulapay/models/ledger.dart';
import 'package:tulapay/screens/activity_screen.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/utils/money.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';
import 'package:tulapay/widgets/ui/ui.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  late Future<_BillingData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_BillingData> _load() async {
    final repo = MerchantRepository.instance;
    final results = await Future.wait([repo.settlementAccount(), repo.feeRates()]);
    return _BillingData(
      account: results[0] as Map<String, dynamic>?,
      feeRates: results[1] as List<FeeRate>,
    );
  }

  String _providerLabel(String? p) => switch (p) {
        'mtn_momo' => 'MTN Mobile Money',
        'orange_money' => 'Orange Money',
        _ => p ?? '—',
      };

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_BillingData>(
      future: _future,
      builder: (context, snap) {
        final data = snap.data;
        return GlassPageShell(
          title: 'Billing',
          subtitle: 'Payout destination, published fees, and history.',
          icon: Icons.credit_card_rounded,
          actionLabel: 'Transaction history',
          onAction: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ActivityScreen()),
          ),
          children: [
            if (snap.connectionState == ConnectionState.waiting)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              GlassSurface(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    IconChip(Icons.account_balance_wallet_rounded,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Payout account',
                              style: AppText.cardTitle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface)),
                          Text(
                            data?.account == null
                                ? 'Not set up yet'
                                : '${_providerLabel(data!.account!['provider'] as String?)} '
                                    '•${data.account!['account_last4'] ?? ''}',
                            style: AppText.caption(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const MicroLabel('Published fees'),
              const SizedBox(height: 8),
              GlassSurface(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Column(
                  children: [
                    for (final f in data?.feeRates ?? const <FeeRate>[])
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(f.channel, style: AppText.body())),
                            Text(
                              '${f.percent}%'
                              '${f.fixedFeeXaf > 0 ? ' + ${money(f.fixedFeeXaf)}' : ''}',
                              style: AppText.cardTitle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _BillingData {
  final Map<String, dynamic>? account;
  final List<FeeRate> feeRates;
  _BillingData({required this.account, required this.feeRates});
}
