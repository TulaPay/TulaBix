import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/models/commerce.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/utils/app_feedback.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/ui/ui.dart';

class PromoCodesScreen extends StatefulWidget {
  const PromoCodesScreen({super.key});

  @override
  State<PromoCodesScreen> createState() => _PromoCodesScreenState();
}

class _PromoCodesScreenState extends State<PromoCodesScreen> {
  late Future<List<PromoCode>> _future;

  @override
  void initState() {
    super.initState();
    _future = MerchantRepository.instance.promoCodes();
  }

  void _reload() =>
      setState(() => _future = MerchantRepository.instance.promoCodes());

  Future<void> _create() async {
    final codeCtrl = TextEditingController();
    final titleCtrl = TextEditingController();
    final pctCtrl = TextEditingController(text: '10');

    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('New promo code',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 14),
              TextField(
                controller: codeCtrl,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(labelText: 'Code'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: pctCtrl,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Discount %'),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    if (codeCtrl.text.trim().isEmpty ||
                        titleCtrl.text.trim().isEmpty) {
                      AppFeedback.toast(context, 'Code and title are required');
                      return;
                    }
                    try {
                      await MerchantRepository.instance.savePromoCode(
                        code: codeCtrl.text,
                        title: titleCtrl.text.trim(),
                        discountPercent:
                            int.tryParse(pctCtrl.text.trim()),
                      );
                      if (context.mounted) Navigator.pop(context, true);
                    } catch (e) {
                      if (context.mounted) {
                        AppFeedback.toast(
                            context, 'Could not save — code may already exist');
                      }
                    }
                  },
                  child: const Text('Create'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (ok == true) _reload();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AppScaffold(
      title: 'Promo Codes',
      body: FutureBuilder<List<PromoCode>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final rows = snap.data ?? const [];
          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, AppSpacing.section),
              children: [
                if (rows.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Center(
                      child: Text('No promo codes yet',
                          style: AppText.body(color: cs.onSurfaceVariant)),
                    ),
                  ),
                for (final p in rows) ...[
                  GlassSurface(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(p.code,
                                  style: AppText.cardTitle(
                                      size: 18, color: cs.onSurface)),
                            ),
                            Switch.adaptive(
                              value: p.active,
                              onChanged: (v) async {
                                await MerchantRepository.instance
                                    .setPromoActive(p.id, v);
                                _reload();
                              },
                            ),
                          ],
                        ),
                        Text(p.title, style: AppText.body()),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            if (p.discountPercent != null)
                              _chip('${p.discountPercent}% off', cs),
                            const SizedBox(width: 8),
                            _chip('${p.redemptionCount} used', cs),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.copy_rounded, size: 18),
                              onPressed: () => AppFeedback.copy(
                                  context, p.code,
                                  label: 'Code copied'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded,
                                  size: 20),
                              onPressed: () async {
                                await MerchantRepository.instance
                                    .deletePromoCode(p.id);
                                _reload();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _create,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New code'),
      ),
    );
  }

  Widget _chip(String text, ColorScheme cs) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: cs.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(text,
            style: AppText.caption(color: cs.primary)
                .copyWith(fontWeight: FontWeight.w700)),
      );
}
