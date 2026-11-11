import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/models/engagement.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/utils/app_feedback.dart';
import 'package:tulapay/utils/money.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/l10n/l10n_extension.dart';

class GrowthGoalsScreen extends StatefulWidget {
  const GrowthGoalsScreen({super.key});

  @override
  State<GrowthGoalsScreen> createState() => _GrowthGoalsScreenState();
}

class _GrowthGoalsScreenState extends State<GrowthGoalsScreen> {
  late Future<List<GrowthGoal>> _future;

  @override
  void initState() {
    super.initState();
    _future = MerchantRepository.instance.growthGoals();
  }

  void _reload() => setState(() {
        _future = MerchantRepository.instance.growthGoals();
      });

  Future<void> _editGoal([GrowthGoal? goal]) async {
    final titleCtrl = TextEditingController(text: goal?.title ?? '');
    final targetCtrl =
        TextEditingController(text: goal == null ? '' : '${goal.targetAmount}');
    final currentCtrl = TextEditingController(
        text: goal == null ? '' : '${goal.currentAmount}');
    String kind = goal?.kind ?? 'revenue';

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: StatefulBuilder(
          builder: (context, setSheet) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(goal == null ? context.l10n.newGoal : context.l10n.editGoal,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 14),
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(labelText: context.l10n.title),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: kind,
                  decoration: InputDecoration(labelText: context.l10n.type),
                  items: [
                    DropdownMenuItem(value: 'revenue', child: Text(context.l10n.revenue)),
                    DropdownMenuItem(
                        value: 'customers', child: Text(context.l10n.customers)),
                    DropdownMenuItem(value: 'orders', child: Text(context.l10n.orders)),
                    DropdownMenuItem(value: 'custom', child: Text(context.l10n.custom)),
                  ],
                  onChanged: (v) => setSheet(() => kind = v ?? 'revenue'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: currentCtrl,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: context.l10n.current),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: targetCtrl,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: context.l10n.target),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    if (goal != null)
                      TextButton(
                        onPressed: () async {
                          await MerchantRepository.instance
                              .deleteGoal(goal.id);
                          if (context.mounted) Navigator.pop(context, true);
                        },
                        child: Text(context.l10n.delete),
                      ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () async {
                        final target = num.tryParse(targetCtrl.text.trim());
                        if (titleCtrl.text.trim().isEmpty || target == null) {
                          AppFeedback.toast(
                              context, context.l10n.addATitleAndNumeric);
                          return;
                        }
                        await MerchantRepository.instance.saveGoal(
                          id: goal?.id,
                          title: titleCtrl.text.trim(),
                          kind: kind,
                          targetAmount: target,
                          currentAmount:
                              num.tryParse(currentCtrl.text.trim()) ?? 0,
                        );
                        if (context.mounted) Navigator.pop(context, true);
                      },
                      child: Text(context.l10n.save),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (saved == true) _reload();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(context.l10n.growthGoals,
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editGoal(),
        child: const Icon(Icons.add_rounded),
      ),
      body: FutureBuilder<List<GrowthGoal>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final goals = snap.data ?? const [];
          return ListView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 96),
            children: [
              GlassSurface(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.trackMerchantGrowth,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(
                      context.l10n.setTargetsForRevenueCustomers2,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 14, color: context.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (goals.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text(context.l10n.noGoalsYetTapTo,
                        style: GoogleFonts.plusJakartaSans(
                            color: cs.onSurfaceVariant)),
                  ),
                ),
              for (final g in goals) _goalCard(context, g),
            ],
          );
        },
      ),
    );
  }

  Widget _goalCard(BuildContext context, GrowthGoal g) {
    final cs = Theme.of(context).colorScheme;
    String fmt(num v) => g.isMonetary ? money(v) : amountOnly(v);
    return GestureDetector(
      onTap: () => _editGoal(g),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: context.hairlineColor)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(g.title,
                      style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                ),
                Text('${g.progressPercent}%',
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700, color: cs.primary)),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: g.progress,
                minHeight: 6,
                backgroundColor: context.hairlineColor,
                valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
              ),
            ),
            const SizedBox(height: 6),
            Text(context.l10n.currentOfTarget(fmt(g.currentAmount), fmt(g.targetAmount)),
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12, color: context.textSecondary)),
          ],
        ),
      ),
    );
  }
}
