import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tulapay/models/ledger.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/utils/app_feedback.dart';
import 'package:tulapay/utils/money.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/ui/ui.dart';

/// Full transaction feed. Opened from Homepage's "Recent Activity → All" and
/// from Billing's "Transaction history".
class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  static const _filters = ['All', 'Payments', 'Payouts', 'Refunds'];
  int _filterIndex = 0;
  late Future<List<LedgerTransaction>> _future;

  @override
  void initState() {
    super.initState();
    _future = MerchantRepository.instance.transactions(limit: 200);
  }

  Future<void> _refresh() async {
    setState(() {
      _future = MerchantRepository.instance.transactions(limit: 200);
    });
    await _future;
  }

  List<LedgerTransaction> _apply(List<LedgerTransaction> all) {
    switch (_filterIndex) {
      case 1:
        return all.where((t) => t.type == 'payment').toList();
      case 2:
        return all.where((t) => t.type == 'payout').toList();
      case 3:
        return all.where((t) => t.type == 'refund').toList();
      default:
        return all;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Activity',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, AppSpacing.md),
            child: SegmentedControl(
              segments: _filters,
              selectedIndex: _filterIndex,
              onChanged: (i) => setState(() => _filterIndex = i),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: FutureBuilder<List<LedgerTransaction>>(
                future: _future,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final rows = _apply(snap.data ?? const []);
                  if (rows.isEmpty) {
                    return ListView(
                      children: [
                        const SizedBox(height: 120),
                        Icon(Icons.receipt_long_rounded,
                            size: 56,
                            color: Theme.of(context).colorScheme.outlineVariant),
                        const SizedBox(height: 12),
                        Center(
                          child: Text('No activity yet',
                              style: AppText.body(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant)),
                        ),
                      ],
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.section),
                    itemCount: rows.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, i) =>
                        _TxnTile(rows[i], onTap: () => showTransactionDetail(context, rows[i])),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TxnTile extends StatelessWidget {
  final LedgerTransaction txn;
  final VoidCallback onTap;
  const _TxnTile(this.txn, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final green = const Color(0xFF10B981);
    return ListRowCard(
      icon: txn.isInflow
          ? Icons.south_west_rounded
          : Icons.north_east_rounded,
      iconColor: txn.isInflow ? green : cs.secondary,
      title: txn.counterpartyName ?? txn.typeLabel,
      subtitle:
          '${txn.channelLabel} · ${DateFormat.MMMd().add_jm().format(txn.createdAt)}',
      value: signedMoney(txn.signedAmount),
      secondaryValue: _statusLabel(txn.status),
      onTap: onTap,
    );
  }

  String _statusLabel(String s) =>
      s.isEmpty ? '' : s[0].toUpperCase() + s.substring(1);
}

Future<void> showTransactionDetail(
    BuildContext context, LedgerTransaction txn) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final cs = Theme.of(context).colorScheme;
      Widget kv(String k, String v) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: 120, child: Text(k, style: AppText.caption())),
                Expanded(child: Text(v, style: AppText.body())),
              ],
            ),
          );
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.xxl)),
        ),
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xxl),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(signedMoney(txn.signedAmount),
                  style: AppText.hero(size: 30, color: cs.onSurface)),
              const SizedBox(height: 2),
              Text('${txn.typeLabel} · ${txn.channelLabel}',
                  style: AppText.body(color: cs.onSurfaceVariant)),
              const SizedBox(height: AppSpacing.lg),
              GlassSurface(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    kv('Reference', txn.id),
                    if (txn.counterpartyName != null)
                      kv('Counterparty', txn.counterpartyName!),
                    kv('Status', txn.status),
                    if (txn.provider != null) kv('Provider', txn.provider!),
                    kv('Fee', money(txn.feeAmount)),
                    kv('Created',
                        DateFormat.yMMMd().add_jm().format(txn.createdAt)),
                    if (txn.settledAt != null)
                      kv('Settled',
                          DateFormat.yMMMd().add_jm().format(txn.settledAt!)),
                    if (txn.reference != null) kv('Note', txn.reference!),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => AppFeedback.copy(context, txn.id,
                          label: 'Reference copied'),
                      icon: const Icon(Icons.copy_rounded, size: 18),
                      label: const Text('Copy ref'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => AppFeedback.share(
                        'TulaBix transaction ${txn.id}\n'
                        '${txn.typeLabel} ${signedMoney(txn.signedAmount)}\n'
                        '${DateFormat.yMMMd().add_jm().format(txn.createdAt)}',
                      ),
                      icon: const Icon(Icons.ios_share_rounded, size: 18),
                      label: const Text('Share'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
