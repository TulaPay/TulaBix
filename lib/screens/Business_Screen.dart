import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tulapay/format.dart';
import 'package:tulapay/models/commerce.dart';
import 'package:tulapay/models/ledger.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/widgets/ui/ui.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

/// The merchant "money cockpit": leads with net revenue + trend, then money
/// in motion, a money-in-vs-out cash-flow chart, an operating-cost breakdown,
/// exceptions that need attention, and the top payment channels. All figures
/// are computed live from `transactions`/`settlement_batches`/`merchant_expenses`
/// — nothing here is fabricated, so a fresh merchant with no activity yet
/// sees honest zeros rather than a canned demo dashboard.
class BusinessScreen extends StatefulWidget {
  const BusinessScreen({super.key});

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
  static const _periods = ['Week', 'Month', 'Quarter', 'Year'];
  int _period = 1; // Month

  bool _loading = true;
  String? _error;
  List<LedgerTransaction> _txns = const [];
  List<SettlementBatch> _settlements = const [];
  List<MerchantExpense> _expenses = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = MerchantRepository.instance;
      final results = await Future.wait([
        repo.transactions(limit: 1000),
        repo.settlements(),
        repo.expenses(),
      ]);
      if (!mounted) return;
      setState(() {
        _txns = results[0] as List<LedgerTransaction>;
        _settlements = results[1] as List<SettlementBatch>;
        _expenses = results[2] as List<MerchantExpense>;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load business data. Pull to try again.';
        _loading = false;
      });
    }
  }

  Future<void> _refresh() => _load();

  void _export() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Exporting business report…')));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _header(cs),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                color: cs.primary,
                child: _loading
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 160),
                          Center(child: CircularProgressIndicator()),
                        ],
                      )
                    : _error != null
                        ? _errorState(cs)
                        : _content(cs),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorState(ColorScheme cs) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, 120, AppSpacing.xxl, 100),
      children: [
        Icon(Icons.cloud_off_rounded, size: 48, color: cs.outlineVariant),
        const SizedBox(height: 12),
        Text(_error!, style: AppText.body(color: cs.onSurfaceVariant)),
      ],
    );
  }

  Widget _content(ColorScheme cs) {
    final m = _computeMetrics(_period, _txns, _settlements, _expenses);
    final period = _periods[_period].toLowerCase();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        AppSpacing.lg,
        AppSpacing.xxl,
        100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentedControl(
            segments: _periods,
            selectedIndex: _period,
            onChanged: (i) => setState(() => _period = i),
          ),
          const SizedBox(height: AppSpacing.xl),

          MetricHeadline(
            label: 'Net revenue',
            value: money(m.net),
            caption: 'this $period',
            deltaLabel:
                '${m.deltaPct.abs().toStringAsFixed(1)}% ${m.deltaCaption}',
            deltaPositive: m.deltaPct >= 0,
            sparkline: m.sparkline,
          ),
          const SizedBox(height: AppSpacing.section),

          const SectionHeader('Money in motion'),
          const SizedBox(height: AppSpacing.md),
          _moneyInMotion(m),
          const SizedBox(height: AppSpacing.section),

          const SectionHeader('Cash flow'),
          const SizedBox(height: AppSpacing.md),
          _cashFlowCard(m, cs),
          const SizedBox(height: AppSpacing.section),

          const SectionHeader('Operating costs'),
          const SizedBox(height: AppSpacing.md),
          _costsCard(m, cs),
          const SizedBox(height: AppSpacing.section),

          const SectionHeader('Needs attention'),
          const SizedBox(height: AppSpacing.md),
          _alerts(m),
          const SizedBox(height: AppSpacing.section),

          const SectionHeader('Top channels'),
          const SizedBox(height: AppSpacing.md),
          _channels(m, cs),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _header(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MicroLabel('Overview'),
              const SizedBox(height: 2),
              Text('Business', style: AppText.screenTitle(size: 28)),
            ],
          ),
          PillButton.dark(
            'Export',
            icon: Icons.ios_share_rounded,
            dense: true,
            onTap: _export,
          ),
        ],
      ),
    );
  }

  // ── Money in motion ───────────────────────────────────────────────────────

  Widget _moneyInMotion(_Metrics m) {
    return StatGrid(
      cards: [
        StatCard(
          label: 'Available to pay out',
          value: money(m.availablePayout, compact: true),
          secondary: 'Next: ${m.nextSettlement}',
          icon: Icons.account_balance_rounded,
          filled: true,
        ),
        StatCard(
          label: 'Processing',
          value: '${m.processingCount}',
          unit: 'txns',
          secondary: money(m.processingAmount, compact: true),
          icon: Icons.sync_rounded,
        ),
        StatCard(
          label: 'Failed',
          value: money(m.failedAmount, compact: true),
          secondary: '${m.failedCount} to review',
          icon: Icons.error_outline_rounded,
        ),
        StatCard(
          label: 'Settled',
          value: money(m.settled, compact: true),
          secondary: m.settledCaption,
          icon: Icons.verified_rounded,
        ),
      ],
    );
  }

  // ── Cash flow ─────────────────────────────────────────────────────────────

  Widget _cashFlowCard(_Metrics m, ColorScheme cs) {
    return ChartCard(
      title: 'Money in vs out',
      value: money(m.net, compact: true),
      trailing: DeltaChip(
        '${m.deltaPct.abs().toStringAsFixed(1)}%',
        positive: m.deltaPct >= 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CashFlowChart(points: m.cashFlow),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              _legend(
                cs,
                cs.primary,
                'Money in',
                money(m.moneyIn, compact: true),
              ),
              _legend(
                cs,
                AppColors.negative.withValues(alpha: 0.55),
                'Money out',
                money(m.moneyOut, compact: true),
              ),
              _legend(
                cs,
                cs.onSurface,
                'Net',
                money(m.net, compact: true),
                showDot: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legend(
    ColorScheme cs,
    Color color,
    String label,
    String value, {
    bool showDot = true,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (showDot) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(label, style: AppText.caption(color: cs.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppText.cardTitle(size: 14, color: cs.onSurface),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ── Operating costs ───────────────────────────────────────────────────────

  Widget _costsCard(_Metrics m, ColorScheme cs) {
    final total = m.costsTotal;
    final palette = <Color>[
      cs.primary,
      AppColors.negative,
      AppColors.warning,
      cs.secondary,
      cs.onSurfaceVariant,
    ];

    return ChartCard(
      title: 'Operating costs',
      value: money(total, compact: true),
      child: m.costs.isEmpty
          ? Text(
              'No costs logged this period.',
              style: AppText.caption(color: cs.onSurfaceVariant),
            )
          : BreakdownList(
              rows: [
                for (var i = 0; i < m.costs.length; i++)
                  BreakdownRow(
                    label: m.costs[i].label,
                    amount: money(m.costs[i].amount, compact: true),
                    fraction: total == 0 ? 0 : m.costs[i].amount / total,
                    color: palette[i % palette.length],
                  ),
              ],
            ),
    );
  }

  // ── Needs attention ───────────────────────────────────────────────────────

  Widget _alerts(_Metrics m) {
    if (m.failedCount == 0) {
      return const AlertTile(
        severity: AlertSeverity.info,
        title: 'All caught up',
        subtitle: 'No failed payments this period.',
      );
    }
    return AlertTile(
      severity: AlertSeverity.critical,
      title:
          '${m.failedCount} payment${m.failedCount == 1 ? '' : 's'} failed to settle',
      subtitle: '${money(m.failedAmount)} needs review.',
    );
  }

  // ── Top channels ──────────────────────────────────────────────────────────

  Widget _channels(_Metrics m, ColorScheme cs) {
    if (m.channels.isEmpty) {
      return Text(
        'No transactions yet this period.',
        style: AppText.caption(color: cs.onSurfaceVariant),
      );
    }
    return Column(
      children: [
        for (var i = 0; i < m.channels.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.md),
          _channelRow(m.channels[i], cs),
        ],
      ],
    );
  }

  Widget _channelRow(_Channel c, ColorScheme cs) {
    final color = Color(c.color);
    final onColor = color.computeLuminance() > 0.5
        ? Colors.black87
        : Colors.white;
    return ListRowCard(
      leading: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Text(
          c.short,
          style: AppText.caption(
            color: onColor,
          ).copyWith(fontWeight: FontWeight.w900, fontSize: 11),
        ),
      ),
      title: c.name,
      subtitle: '${c.txns} transactions',
      trailing: Text(
        '${(c.share * 100).round()}%',
        style: AppText.hero(size: 20, color: cs.primary),
      ),
      onTap: () {},
    );
  }
}

// ─── Real metrics, computed from transactions / settlements / expenses ────────

class _Cost {
  final String label;
  final double amount;
  const _Cost(this.label, this.amount);
}

class _Channel {
  final String name;
  final String short;
  final int color; // 0xAARRGGBB
  final int txns;
  final double share;
  const _Channel(this.name, this.short, this.color, this.txns, this.share);
}

class _Metrics {
  final String deltaCaption;
  final double deltaPct;
  final List<double> sparkline;
  final double availablePayout;
  final String nextSettlement;
  final int processingCount;
  final double processingAmount;
  final double failedAmount;
  final int failedCount;
  final double settled;
  final String settledCaption;
  final List<CashFlowPoint> cashFlow;
  final List<_Cost> costs;
  final List<_Channel> channels;

  const _Metrics({
    required this.deltaCaption,
    required this.deltaPct,
    required this.sparkline,
    required this.availablePayout,
    required this.nextSettlement,
    required this.processingCount,
    required this.processingAmount,
    required this.failedAmount,
    required this.failedCount,
    required this.settled,
    required this.settledCaption,
    required this.cashFlow,
    required this.costs,
    required this.channels,
  });

  double get moneyIn => cashFlow.fold(0.0, (s, p) => s + p.inflow);
  double get moneyOut => cashFlow.fold(0.0, (s, p) => s + p.outflow);
  double get net => moneyIn - moneyOut;
  double get costsTotal => costs.fold(0.0, (s, c) => s + c.amount);
}

const _periodDays = [7, 30, 90, 365];
const _periodLabels = ['week', 'month', 'quarter', 'year'];

const _mtn = 0xFFFFCC00;
const _orange = 0xFFFF6D00;
const _card = 0xFF2D6CDF;
const _bank = 0xFF10B981;
const _other = 0xFF8E9AAB;

(String, String, int) _channelMeta(String key) => switch (key) {
      'mtn_momo' => ('MTN Mobile Money', 'MTN', _mtn),
      'orange_money' => ('Orange Money', 'OM', _orange),
      'visa' || 'mastercard' || 'card' => ('Card payment', 'CARD', _card),
      'bank_transfer' => ('Bank transfer', 'BANK', _bank),
      'qr_checkout' => ('QR checkout', 'QR', _card),
      'payment_link' => ('Payment link', 'LINK', _orange),
      _ => (
          key.isEmpty ? 'Other' : key,
          key.length >= 3 ? key.substring(0, 3).toUpperCase() : key.toUpperCase(),
          _other,
        ),
    };

class _ChannelAgg {
  final String key;
  int count = 0;
  num amount = 0;
  _ChannelAgg(this.key);
}

class _PeriodBucket {
  final DateTime start;
  final DateTime end; // exclusive
  final String label;
  const _PeriodBucket(this.start, this.end, this.label);
}

List<_PeriodBucket> _buildBuckets(int period, DateTime now) {
  switch (period) {
    case 0: // week — 7 daily buckets
      return List.generate(7, (i) {
        final day = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(Duration(days: 6 - i));
        return _PeriodBucket(
          day,
          day.add(const Duration(days: 1)),
          DateFormat('E').format(day),
        );
      });
    case 2: // quarter — 3 monthly buckets
      return List.generate(3, (i) {
        final anchor = DateTime(now.year, now.month - (2 - i), 1);
        final end = DateTime(anchor.year, anchor.month + 1, 1);
        return _PeriodBucket(anchor, end, DateFormat('MMM').format(anchor));
      });
    case 3: // year — 4 quarterly buckets
      return List.generate(4, (i) {
        final anchor = DateTime(now.year, now.month - (3 - i) * 3, 1);
        final end = DateTime(anchor.year, anchor.month + 3, 1);
        final q = ((anchor.month - 1) ~/ 3) + 1;
        return _PeriodBucket(anchor, end, 'Q$q');
      });
    default: // month — 4 weekly buckets
      return List.generate(4, (i) {
        final start = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(Duration(days: (3 - i) * 7 + 6));
        final end = start.add(const Duration(days: 7));
        return _PeriodBucket(start, end, 'W${i + 1}');
      });
  }
}

_Metrics _computeMetrics(
  int period,
  List<LedgerTransaction> allTxns,
  List<SettlementBatch> settlements,
  List<MerchantExpense> allExpenses,
) {
  final now = DateTime.now();
  final days = _periodDays[period];
  final start = now.subtract(Duration(days: days));
  final prevStart = now.subtract(Duration(days: days * 2));

  bool inCurrent(DateTime d) => !d.isBefore(start) && !d.isAfter(now);
  bool inPrevious(DateTime d) => !d.isBefore(prevStart) && d.isBefore(start);

  num netFor(bool Function(DateTime) inRange) {
    num n = 0;
    for (final t in allTxns) {
      if (t.status != 'completed' || !inRange(t.createdAt)) continue;
      if (t.type == 'payment') n += t.amount;
      if (t.type == 'refund') n -= t.amount;
    }
    return n;
  }

  final currentNet = netFor(inCurrent);
  final previousNet = netFor(inPrevious);
  final deltaPct = previousNet == 0
      ? (currentNet == 0 ? 0.0 : 100.0)
      : ((currentNet - previousNet) / previousNet.abs()) * 100;

  final txnsInPeriod = allTxns.where((t) => inCurrent(t.createdAt)).toList();

  num processingAmount = 0;
  var processingCount = 0;
  num failedAmount = 0;
  var failedCount = 0;
  num settled = 0;
  num grossCompleted = 0;
  num platformFees = 0;
  num refundsIssued = 0;
  final channelTotals = <String, _ChannelAgg>{};

  for (final t in txnsInPeriod) {
    switch (t.status) {
      case 'pending':
        processingCount++;
        processingAmount += t.amount;
      case 'failed':
        failedCount++;
        failedAmount += t.amount;
      case 'completed':
        platformFees += t.feeAmount;
        if (t.type == 'payment') {
          grossCompleted += t.amount;
          if (t.settledAt != null) settled += t.amount;
          final key = t.provider ?? t.channel;
          final agg = channelTotals.putIfAbsent(key, () => _ChannelAgg(key));
          agg.count++;
          agg.amount += t.amount;
        } else if (t.type == 'refund') {
          refundsIssued += t.amount;
        }
    }
  }

  final channelTotalAmount = channelTotals.values.fold<num>(
    0,
    (s, c) => s + c.amount,
  );
  final channels =
      channelTotals.values.map((c) {
          final meta = _channelMeta(c.key);
          return _Channel(
            meta.$1,
            meta.$2,
            meta.$3,
            c.count,
            channelTotalAmount == 0
                ? 0
                : (c.amount / channelTotalAmount).toDouble(),
          );
        }).toList()
        ..sort((a, b) => b.share.compareTo(a.share));

  // Available-to-pay-out is a current balance, not scoped to the period.
  num availablePayout = 0;
  for (final t in allTxns) {
    if (t.status == 'completed' && t.settledAt == null) {
      availablePayout += t.signedAmount - t.feeAmount;
    }
  }

  SettlementBatch? next;
  for (final s in settlements) {
    if (s.status == 'scheduled' || s.status == 'processing') {
      if (next == null || s.periodEnd.isBefore(next.periodEnd)) next = s;
    }
  }
  final nextSettlement = next == null
      ? 'Not scheduled'
      : DateFormat('EEE, d MMM').format(next.periodEnd);

  final buckets = _buildBuckets(period, now);
  final cashFlow = buckets.map((b) {
    num inflow = 0, outflow = 0;
    for (final t in allTxns) {
      if (t.status != 'completed') continue;
      if (t.createdAt.isBefore(b.start) || !t.createdAt.isBefore(b.end)) {
        continue;
      }
      if (t.isInflow) {
        inflow += t.amount;
      } else {
        outflow += t.amount;
      }
    }
    return CashFlowPoint(b.label, inflow.toDouble(), outflow.toDouble());
  }).toList();

  final sparkline = cashFlow.map((p) => p.inflow - p.outflow).toList();

  final costs = <_Cost>[
    if (platformFees > 0) _Cost('Platform fees', platformFees.toDouble()),
    if (refundsIssued > 0) _Cost('Refunds issued', refundsIssued.toDouble()),
    for (final e in allExpenses.where((e) => inCurrent(e.incurredAt)))
      _Cost(e.category, e.amount.toDouble()),
  ];

  return _Metrics(
    deltaCaption: 'vs last ${_periodLabels[period]}',
    deltaPct: deltaPct.toDouble(),
    sparkline: sparkline,
    availablePayout: availablePayout.toDouble(),
    nextSettlement: nextSettlement,
    processingCount: processingCount,
    processingAmount: processingAmount.toDouble(),
    failedAmount: failedAmount.toDouble(),
    failedCount: failedCount,
    settled: settled.toDouble(),
    settledCaption: 'of ${money(grossCompleted, compact: true)} in',
    cashFlow: cashFlow,
    costs: costs,
    channels: channels,
  );
}
