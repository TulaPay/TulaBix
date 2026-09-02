import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tulapay/models/ledger.dart';
import 'package:tulapay/screens/activity_screen.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/utils/money.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/ui/ui.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  int _tab = 0;
  late Future<_PaymentsData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_PaymentsData> _load() async {
    final repo = MerchantRepository.instance;
    final results = await Future.wait([repo.settlements(), repo.transactions(limit: 100)]);
    return _PaymentsData(
      settlements: results[0] as List<SettlementBatch>,
      transactions: results[1] as List<LedgerTransaction>,
    );
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AppScaffold(
      title: 'Payments',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, AppSpacing.md),
            child: SegmentedControl(
              segments: const ['Settlements', 'Recent'],
              selectedIndex: _tab,
              onChanged: (i) => setState(() => _tab = i),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: FutureBuilder<_PaymentsData>(
                future: _future,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final data = snap.data;
                  if (data == null) {
                    return const SizedBox.shrink();
                  }
                  return _tab == 0
                      ? _settlements(data.settlements, cs)
                      : _recent(data.transactions);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settlements(List<SettlementBatch> rows, ColorScheme cs) {
    if (rows.isEmpty) return _empty('No settlements yet');
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.section),
      itemCount: rows.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, i) {
        final s = rows[i];
        return GlassSurface(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${DateFormat.MMMd().format(s.periodStart)} – '
                      '${DateFormat.MMMd().format(s.periodEnd)}',
                      style: AppText.cardTitle(color: cs.onSurface),
                    ),
                  ),
                  _statusChip(s.status, cs),
                ],
              ),
              const SizedBox(height: 8),
              Text(money(s.netAmount),
                  style: AppText.hero(size: 24, color: cs.onSurface)),
              Text(
                'Gross ${money(s.grossAmount)} · Fees ${money(s.feeAmount)} · '
                '${s.payoutAccount}',
                style: AppText.caption(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _recent(List<LedgerTransaction> rows) {
    if (rows.isEmpty) return _empty('No transactions yet');
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.section),
      itemCount: rows.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, i) {
        final t = rows[i];
        return ListRowCard(
          icon: t.isInflow
              ? Icons.south_west_rounded
              : Icons.north_east_rounded,
          iconColor: t.isInflow
              ? const Color(0xFF10B981)
              : Theme.of(context).colorScheme.secondary,
          title: t.counterpartyName ?? t.typeLabel,
          subtitle:
              '${t.channelLabel} · ${DateFormat.MMMd().format(t.createdAt)}',
          value: signedMoney(t.signedAmount),
          secondaryValue: t.status,
          onTap: () => showTransactionDetail(context, t),
        );
      },
    );
  }

  Widget _empty(String label) => ListView(
        children: [
          const SizedBox(height: 120),
          Center(
            child: Text(label,
                style: AppText.body(
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ),
        ],
      );

  Widget _statusChip(String status, ColorScheme cs) {
    final paid = status == 'paid';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: (paid ? const Color(0xFF10B981) : cs.tertiary)
            .withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(status,
          style: AppText.caption(
                  color: paid ? const Color(0xFF10B981) : cs.tertiary)
              .copyWith(fontWeight: FontWeight.w700)),
    );
  }
}

class _PaymentsData {
  final List<SettlementBatch> settlements;
  final List<LedgerTransaction> transactions;
  _PaymentsData({required this.settlements, required this.transactions});
}
