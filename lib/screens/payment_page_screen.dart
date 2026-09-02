import 'package:flutter/material.dart';
import 'package:tulapay/models/merchant.dart';
import 'package:tulapay/screens/payment_links_screen.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/utils/app_feedback.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';
import 'package:tulapay/widgets/ui/ui.dart';

class PaymentPageScreen extends StatefulWidget {
  const PaymentPageScreen({super.key});

  @override
  State<PaymentPageScreen> createState() => _PaymentPageScreenState();
}

class _PaymentPageScreenState extends State<PaymentPageScreen> {
  late Future<Merchant> _future;

  @override
  void initState() {
    super.initState();
    _future = MerchantRepository.instance.myMerchant();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Merchant>(
      future: _future,
      builder: (context, snap) {
        final m = snap.data;
        final pageUrl = m == null
            ? null
            : 'https://pay.tulabix.com/m/${m.id.toLowerCase()}';
        return GlassPageShell(
          title: 'Payment Page',
          subtitle: 'Your always-on link customers can pay you from.',
          icon: Icons.payment_rounded,
          actionLabel: 'Preview page',
          onAction: pageUrl == null
              ? null
              : () => AppFeedback.launch(context, pageUrl),
          children: [
            if (snap.connectionState == ConnectionState.waiting)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (pageUrl != null) ...[
              GlassSurface(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Center(
                      child: Image.network(
                        'https://api.qrserver.com/v1/create-qr-code/'
                        '?size=240x240&data=${Uri.encodeComponent(pageUrl)}',
                        width: 200,
                        height: 200,
                        errorBuilder: (_, __, ___) => const SizedBox(
                          height: 200,
                          child: Center(child: Icon(Icons.qr_code_2_rounded, size: 96)),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SelectableText(pageUrl, style: AppText.body()),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => AppFeedback.copy(context, pageUrl,
                                label: 'Page link copied'),
                            icon: const Icon(Icons.copy_rounded, size: 18),
                            label: const Text('Copy'),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => AppFeedback.share(
                                'Pay ${m!.businessName} securely: $pageUrl'),
                            icon: const Icon(Icons.ios_share_rounded, size: 18),
                            label: const Text('Share'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              GlassInfoCard(
                icon: Icons.link_rounded,
                title: 'One-off payment links',
                subtitle: 'Create a link for a specific amount or invoice.',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaymentLinksScreen()),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
