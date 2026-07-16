import 'package:flutter/material.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';

class PaymentPageScreen extends StatelessWidget {
  const PaymentPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPageShell(
      title: 'Payment Page',
      subtitle: 'Control how customers land on your payment experience.',
      icon: Icons.payment_rounded,
      actionLabel: 'Preview page',
      onAction: () {},
      children: const [
        GlassInfoCard(
          icon: Icons.link_rounded,
          title: 'Shareable link',
          subtitle: 'Create a branded checkout link for customers and campaigns.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.qr_code_rounded,
          title: 'QR layout',
          subtitle: 'Tweak how QR and payment hints are presented on the page.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.palette_outlined,
          title: 'Brand styling',
          subtitle: 'Keep the payment page aligned with your glass theme and colors.',
        ),
      ],
    );
  }
}
