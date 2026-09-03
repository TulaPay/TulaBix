import 'package:flutter/material.dart';
import 'package:tulapay/format.dart';
import 'package:tulapay/widgets/ui/ui.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

/// The merchant "money cockpit": leads with net revenue + trend, then money
/// in motion, a money-in-vs-out cash-flow chart, an operating-cost breakdown,
/// exceptions that need attention, and the top payment channels.
class BusinessScreen extends StatefulWidget {
  const BusinessScreen({super.key});

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
  static const _periods = ['Week', 'Month', 'Quarter', 'Year'];
  int _period = 1; // Month

  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() {});
  }

  void _export() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Exporting business report…')));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final m = _metricsFor(_period);
    final period = _periods[_period].toLowerCase();

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
                child: SingleChildScrollView(
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
                      _alerts(),
                      const SizedBox(height: AppSpacing.section),

                      const SectionHeader('Top channels'),
                      const SizedBox(height: AppSpacing.md),
                      _channels(m, cs),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
          label: 'In review',
          value: money(m.heldAmount, compact: true),
          secondary: 'On hold',
          icon: Icons.gpp_maybe_rounded,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BreakdownList(
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
          const SizedBox(height: AppSpacing.xl),
          _insightCallout(cs),
        ],
      ),
    );
  }

  Widget _insightCallout(ColorScheme cs) {
    return InkWell(
      onTap: _showInsightSheet,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: cs.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: cs.primary.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            Icon(Icons.lightbulb_outline_rounded, color: cs.primary, size: 20),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Cut SMS alerts to save about ${money(12000)} a month. Tap for details.',
                style: AppText.caption(
                  color: cs.onSurface,
                ).copyWith(fontWeight: FontWeight.w600, height: 1.4),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(Icons.chevron_right_rounded, color: cs.primary, size: 18),
          ],
        ),
      ),
    );
  }

  // ── Needs attention ───────────────────────────────────────────────────────

  Widget _alerts() {
    final tiles = <Widget>[
      const AlertTile(
        severity: AlertSeverity.critical,
        title: '2 payments failed to settle',
        subtitle: 'XAF 46,000 will retry tonight — or retry now.',
      ),
      AlertTile(
        severity: AlertSeverity.warning,
        title: 'SMS spend up 32% this period',
        subtitle: 'Switch to in-app alerts to cut about XAF 12,000 / month.',
        onTap: _showInsightSheet,
      ),
      const AlertTile(
        severity: AlertSeverity.info,
        title: 'KYB re-verification due in 5 days',
        subtitle: 'Upload a recent utility bill to keep payouts active.',
      ),
    ];
    return Column(
      children: [
        for (var i = 0; i < tiles.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.md),
          tiles[i],
        ],
      ],
    );
  }

  // ── Top channels ──────────────────────────────────────────────────────────

  Widget _channels(_Metrics m, ColorScheme cs) {
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

  // ── Insight sheet ─────────────────────────────────────────────────────────

  void _showInsightSheet() {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Row(
              children: [
                IconChip(Icons.lightbulb_rounded, color: cs.primary, size: 44),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Cut your SMS spend',
                    style: AppText.sectionTitle(color: cs.onSurface),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              "You're sending an SMS for every transaction. Switching to in-app "
              "push alerts would cut about ${money(12000)} from your monthly "
              "running costs, with no change for your customers.",
              style: AppText.body(
                color: cs.onSurfaceVariant,
              ).copyWith(height: 1.6),
            ),
            const SizedBox(height: AppSpacing.huge),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Got it'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Mock data ────────────────────────────────────────────────────────────────

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
  final double heldAmount;
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
    required this.heldAmount,
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

_Metrics _metricsFor(int period) => switch (period) {
  0 => _week,
  2 => _quarter,
  3 => _year,
  _ => _month,
};

const _mtn = 0xFFFFCC00;
const _orange = 0xFFFF6D00;
const _card = 0xFF2D6CDF;
const _bank = 0xFF10B981;

const _week = _Metrics(
  deltaCaption: 'vs last week',
  deltaPct: 6.4,
  sparkline: [0.90, 1.05, 0.98, 1.20, 1.10, 1.35, 1.28, 1.42],
  availablePayout: 1180000,
  nextSettlement: 'Tomorrow',
  processingCount: 5,
  processingAmount: 210000,
  heldAmount: 40000,
  settled: 4060000,
  settledCaption: 'of XAF 4.3M in',
  cashFlow: [
    CashFlowPoint('Mon', 720000, 540000),
    CashFlowPoint('Tue', 610000, 430000),
    CashFlowPoint('Wed', 840000, 560000),
    CashFlowPoint('Thu', 930000, 610000),
    CashFlowPoint('Fri', 1180000, 720000),
  ],
  costs: [
    _Cost('Platform fees', 224000),
    _Cost('Refunds issued', 156000),
    _Cost('SMS alerts', 78000),
    _Cost('Payout fees', 36000),
    _Cost('Other', 24000),
  ],
  channels: [
    _Channel('MTN Mobile Money', 'MTN', _mtn, 107, 0.54),
    _Channel('Orange Money', 'OM', _orange, 55, 0.28),
    _Channel('Card payment', 'CARD', _card, 24, 0.12),
    _Channel('Bank transfer', 'BANK', _bank, 12, 0.06),
  ],
);

const _month = _Metrics(
  deltaCaption: 'vs last month',
  deltaPct: 14.2,
  sparkline: [1.10, 1.35, 1.22, 1.60, 1.48, 1.95, 1.82, 2.45],
  availablePayout: 1180000,
  nextSettlement: 'Fri, 6 Sep',
  processingCount: 12,
  processingAmount: 340000,
  heldAmount: 85000,
  settled: 10900000,
  settledCaption: 'of XAF 11.4M in',
  cashFlow: [
    CashFlowPoint('W1', 3100000, 2350000),
    CashFlowPoint('W2', 2420000, 1980000),
    CashFlowPoint('W3', 2980000, 2600000),
    CashFlowPoint('W4', 2900000, 2020000),
  ],
  costs: [
    _Cost('Platform fees', 890000),
    _Cost('Refunds issued', 620000),
    _Cost('SMS alerts', 310000),
    _Cost('Payout fees', 145000),
    _Cost('Other', 95000),
  ],
  channels: [
    _Channel('MTN Mobile Money', 'MTN', _mtn, 428, 0.54),
    _Channel('Orange Money', 'OM', _orange, 221, 0.28),
    _Channel('Card payment', 'CARD', _card, 96, 0.12),
    _Channel('Bank transfer', 'BANK', _bank, 48, 0.06),
  ],
);

const _quarter = _Metrics(
  deltaCaption: 'vs last quarter',
  deltaPct: 21.8,
  sparkline: [5.2, 5.8, 6.1, 6.6, 7.2, 7.8, 8.1, 8.6],
  availablePayout: 2640000,
  nextSettlement: 'Fri, 6 Sep',
  processingCount: 28,
  processingAmount: 910000,
  heldAmount: 190000,
  settled: 31800000,
  settledCaption: 'of XAF 33.5M in',
  cashFlow: [
    CashFlowPoint('Jul', 9800000, 7600000),
    CashFlowPoint('Aug', 11200000, 8400000),
    CashFlowPoint('Sep', 12500000, 8900000),
  ],
  costs: [
    _Cost('Platform fees', 2670000),
    _Cost('Refunds issued', 1860000),
    _Cost('SMS alerts', 930000),
    _Cost('Payout fees', 435000),
    _Cost('Other', 285000),
  ],
  channels: [
    _Channel('MTN Mobile Money', 'MTN', _mtn, 1284, 0.54),
    _Channel('Orange Money', 'OM', _orange, 663, 0.28),
    _Channel('Card payment', 'CARD', _card, 288, 0.12),
    _Channel('Bank transfer', 'BANK', _bank, 144, 0.06),
  ],
);

const _year = _Metrics(
  deltaCaption: 'vs last year',
  deltaPct: 38.5,
  sparkline: [18, 21, 22, 25, 27, 29, 30.5, 31.6],
  availablePayout: 3900000,
  nextSettlement: 'Fri, 6 Sep',
  processingCount: 46,
  processingAmount: 1600000,
  heldAmount: 320000,
  settled: 121700000,
  settledCaption: 'of XAF 128.5M in',
  cashFlow: [
    CashFlowPoint('Q1', 26000000, 21000000),
    CashFlowPoint('Q2', 31000000, 24000000),
    CashFlowPoint('Q3', 33500000, 24900000),
    CashFlowPoint('Q4', 38000000, 27000000),
  ],
  costs: [
    _Cost('Platform fees', 10680000),
    _Cost('Refunds issued', 7440000),
    _Cost('SMS alerts', 3720000),
    _Cost('Payout fees', 1740000),
    _Cost('Other', 1140000),
  ],
  channels: [
    _Channel('MTN Mobile Money', 'MTN', _mtn, 5136, 0.54),
    _Channel('Orange Money', 'OM', _orange, 2652, 0.28),
    _Channel('Card payment', 'CARD', _card, 1152, 0.12),
    _Channel('Bank transfer', 'BANK', _bank, 576, 0.06),
  ],
);
