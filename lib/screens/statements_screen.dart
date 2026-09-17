import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tulapay/format.dart';
import 'package:tulapay/models/ledger.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/utils/app_feedback.dart';
import 'package:tulapay/widgets/glass_effects.dart';

/// Real statement screen — backs the "Statements" tile in More Actions.
/// Calls the already-existing [MerchantRepository.statement].
class StatementsScreen extends StatelessWidget {
  const StatementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StatementsView();
  }
}

class _StatementsView extends StatefulWidget {
  const _StatementsView();

  @override
  State<_StatementsView> createState() => _StatementsViewState();
}

class _StatementsViewState extends State<_StatementsView> {
  late DateTimeRange _range;
  Future<StatementPeriod>? _future;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _range = DateTimeRange(start: DateTime(now.year, now.month, 1), end: now);
    _load();
  }

  void _load() {
    _future = MerchantRepository.instance.statement(_range.start, _range.end);
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      initialDateRange: _range,
    );
    if (picked == null) return;
    setState(() {
      _range = picked;
      _load();
    });
  }

  Future<void> _export(StatementPeriod s) async {
    final fmt = DateFormat('MMM d, yyyy');
    final summary = '''
Statement: ${fmt.format(s.periodStart)} – ${fmt.format(s.periodEnd)}
Gross revenue: ${money(s.grossRevenue)}
Refunds: ${money(s.refunds)}
Net revenue: ${money(s.netRevenue)}
Fees charged: ${money(s.feesCharged)}
Payouts received: ${money(s.payoutsReceived)}
Transactions: ${s.transactionCount}
''';
    await AppFeedback.share(summary, subject: 'TulaBiz statement');
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fmt = DateFormat('MMM d, yyyy');

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text('Statements',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                GlassSurface(
                  borderRadius: BorderRadius.circular(24),
                  opacity: 0.12,
                  blur: 14,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.date_range_rounded, color: cs.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${fmt.format(_range.start)} — ${fmt.format(_range.end)}',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _pickRange,
                        child: const Text('Change'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                FutureBuilder<StatementPeriod>(
                  future: _future,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snap.hasError) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'Could not load this statement.',
                          style: GoogleFonts.plusJakartaSans(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      );
                    }
                    final s = snap.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GlassSurface(
                          borderRadius: BorderRadius.circular(24),
                          opacity: 0.14,
                          blur: 16,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _Row('Gross revenue', money(s.grossRevenue), cs),
                              _Row('Refunds', '- ${money(s.refunds)}', cs),
                              const Divider(height: 24),
                              _Row('Net revenue', money(s.netRevenue), cs,
                                  emphasize: true),
                              const SizedBox(height: 12),
                              _Row('Fees charged', money(s.feesCharged), cs),
                              _Row('Payouts received', money(s.payoutsReceived),
                                  cs),
                              _Row('Transactions', '${s.transactionCount}', cs),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: FilledButton.icon(
                            onPressed: () => _export(s),
                            icon: const Icon(Icons.ios_share_rounded),
                            label: const Text('Share summary'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme cs;
  final bool emphasize;

  const _Row(this.label, this.value, this.cs, {this.emphasize = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: emphasize ? 15 : 13,
              fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
              color: emphasize ? cs.onSurface : cs.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: emphasize ? 17 : 14,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
