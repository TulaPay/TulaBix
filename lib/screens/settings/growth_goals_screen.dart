import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/models/engagement.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/utils/app_feedback.dart';
import 'package:tulapay/utils/money.dart';
import 'package:tulapay/widgets/glass_effects.dart';

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

  void _reload() =>
      setState(() => _future = MerchantRepository.instance.growthGoals());

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
                  const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(goal == null ? 'New goal' : 'Edit goal',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 14),
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: kind,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: const [
                    DropdownMenuItem(value: 'revenue', child: Text('Revenue')),
                    DropdownMenuItem(
                        value: 'customers', child: Text('Customers')),
                    DropdownMenuItem(value: 'orders', child: Text('Orders')),
                    DropdownMenuItem(value: 'custom', child: Text('Custom')),
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
                            const InputDecoration(labelText: 'Current'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: targetCtrl,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: 'Target'),
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
                        child: const Text('Delete'),
                      ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () async {
                        final target = num.tryParse(targetCtrl.text.trim());
                        if (titleCtrl.text.trim().isEmpty || target == null) {
                          AppFeedback.toast(
                              context, 'Add a title and numeric target');
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
                      child: const Text('Save'),
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
        title: Text("Growth Goals",
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
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
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 96),
            children: [
              GlassSurface(
                borderRadius: BorderRadius.circular(28),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Track merchant growth',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 20, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text(
                      'Set targets for revenue, customers, and repeat orders '
                      'and watch progress against them.',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 13, color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (goals.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text('No goals yet — tap + to add one',
                        style: GoogleFonts.plusJakartaSans(
                            color: cs.onSurfaceVariant)),
                  ),
                ),
              for (final g in goals) ...[
                _goalCard(context, g),
                const SizedBox(height: 12),
              ],
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
      child: GlassSurface(
        borderRadius: BorderRadius.circular(24),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(g.title,
                      style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800, fontSize: 14)),
                ),
                Text('${g.progressPercent}%',
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800, color: cs.primary)),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: g.progress,
                minHeight: 8,
                backgroundColor: cs.outlineVariant.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
              ),
            ),
            const SizedBox(height: 6),
            Text('${fmt(g.currentAmount)} of ${fmt(g.targetAmount)}',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12, color: cs.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
