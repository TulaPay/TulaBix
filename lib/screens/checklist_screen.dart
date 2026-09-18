import 'package:flutter/material.dart';
import 'package:tulapay/models/merchant.dart';
import 'package:tulapay/screens/scan_qr_screen.dart';
import 'package:tulapay/screens/settings/account_screen.dart';
import 'package:tulapay/screens/settings/billing_screen.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';
import 'package:tulapay/widgets/ui/ui.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  late Future<SetupChecklist> _future;

  @override
  void initState() {
    super.initState();
    _future = MerchantRepository.instance.checklist();
  }

  void _reload() => setState(() {
        _future = MerchantRepository.instance.checklist();
      });

  Future<void> _set(String key, bool value) async {
    await MerchantRepository.instance.setChecklistItem(key, value);
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SetupChecklist>(
      future: _future,
      builder: (context, snap) {
        final c = snap.data ?? const SetupChecklist();
        final items = <_Item>[
          _Item('verify_profile', c.verifyProfile, 'Verify profile',
              'Business identity, contact, and verification.',
              Icons.person_outline_rounded, (_) => const AccountScreen()),
          _Item('connect_payments', c.connectPayments, 'Connect payments',
              'Confirm your settlement account and fees.',
              Icons.payments_outlined, (_) => const BillingScreen()),
          _Item('enable_qr', c.enableQr, 'Enable QR',
              'Show your QR so customers can scan and pay.',
              Icons.qr_code_2_rounded, (_) => const ScanQrScreen()),
        ];
        return GlassPageShell(
          title: 'Setup Checklist',
          subtitle:
              '${c.doneCount} of ${c.total} done — finish these to go live.',
          icon: Icons.check_circle_outline_rounded,
          children: [
            if (snap.connectionState == ConnectionState.waiting)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: c.progress,
                  minHeight: 8,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withValues(alpha: 0.2),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              for (final it in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: GlassSurface(
                    padding: EdgeInsets.zero,
                    child: ListRowCard(
                      floating: false,
                      leading: Checkbox(
                        value: it.done,
                        onChanged: (v) => _set(it.key, v ?? false),
                      ),
                      title: it.title,
                      subtitle: it.subtitle,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: it.builder),
                      ).then((_) => _reload()),
                      showChevron: true,
                    ),
                  ),
                ),
            ],
          ],
        );
      },
    );
  }
}

class _Item {
  final String key;
  final bool done;
  final String title;
  final String subtitle;
  final IconData icon;
  final WidgetBuilder builder;
  const _Item(this.key, this.done, this.title, this.subtitle, this.icon,
      this.builder);
}
