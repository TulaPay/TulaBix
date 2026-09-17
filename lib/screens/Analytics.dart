import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:tulapay/format.dart';
import 'package:tulapay/models/commerce.dart';
import 'package:tulapay/models/ledger.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/ui/ui.dart';

// Real income/expenses/budget analytics — computed from `transactions`,
// `merchant_expenses`, and `merchant_budgets`. A fresh merchant with no
// activity/logged expenses/allocated budgets yet sees honest zeros and
// empty states, not the previous fabricated Budget/Expense categories.

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final List<_MonthOption> _months;
  late _MonthOption _selectedMonth;

  bool _loading = true;
  String? _error;
  List<LedgerTransaction> _txns = const [];
  List<MerchantExpense> _expenses = const [];
  List<MerchantBudget> _budgets = const [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging ||
          _tabController.animation?.value == _tabController.index) {
        setState(() {});
      }
    });
    _months = _recentMonths(DateTime.now());
    _selectedMonth = _months.first;
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        repo.expenses(),
        repo.budgets(),
      ]);
      if (!mounted) return;
      setState(() {
        _txns = results[0] as List<LedgerTransaction>;
        _expenses = results[1] as List<MerchantExpense>;
        _budgets = results[2] as List<MerchantBudget>;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load analytics. Pull to try again.';
        _loading = false;
      });
    }
  }

  Future<void> _refreshData() => _load();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics', style: AppText.screenTitle(size: 28)),
        toolbarHeight: 72,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: Center(
              child: PillButton.dark(
                'Export',
                icon: Icons.ios_share_rounded,
                dense: true,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Exporting report as PDF...')),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _loading
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 160),
                  Center(child: CircularProgressIndicator()),
                ],
              )
            : _error != null
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 120, 16, 16),
                    children: [
                      Icon(
                        Icons.cloud_off_rounded,
                        size: 48,
                        color: colorScheme.outlineVariant,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  )
                : _content(context),
      ),
    );
  }

  Widget _content(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final data = _computeData(_selectedMonth, _txns, _expenses, _budgets);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _headerTitle,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _headerAmount(data),
                      style: textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Text(
                        _headerPercentage(data),
                        style: TextStyle(
                          color: _headerPercentageColor(theme, data),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                DropdownButton<_MonthOption>(
                  value: _selectedMonth,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  elevation: 16,
                  style: TextStyle(color: colorScheme.onSurface),
                  underline: const SizedBox(),
                  dropdownColor: colorScheme.surface,
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedMonth = v);
                  },
                  items: _months
                      .map(
                        (m) => DropdownMenuItem(value: m, child: Text(m.label)),
                      )
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: context.trackColor,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: colorScheme.onSurface,
                unselectedLabelColor: colorScheme.onSurfaceVariant,
                labelStyle: AppText.pillLabel().copyWith(fontSize: 13),
                unselectedLabelStyle:
                    AppText.pillLabel().copyWith(fontSize: 13),
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                splashBorderRadius: BorderRadius.circular(AppRadius.sm),
                indicator: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                tabs: const [
                  Tab(text: 'Income'),
                  Tab(text: 'Expenses'),
                  Tab(text: 'Budget'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSelectedContent(context, data),
          ],
        ),
      ),
    );
  }

  String get _headerTitle => switch (_tabController.index) {
        0 => 'Total Revenue',
        1 => 'Total Expenses',
        _ => 'Total Budget',
      };

  String _headerAmount(_AnalyticsData d) => switch (_tabController.index) {
        0 => money(d.income),
        1 => money(d.expenses),
        _ => money(d.budgetAllocated),
      };

  String _headerPercentage(_AnalyticsData d) => switch (_tabController.index) {
        0 => percentDelta(d.incomeDeltaPct),
        1 => percentDelta(d.expensesDeltaPct),
        _ => '${d.budgetUsedPct.toStringAsFixed(0)}% Used',
      };

  Color _headerPercentageColor(ThemeData theme, _AnalyticsData d) {
    if (_tabController.index == 0) {
      return d.incomeDeltaPct >= 0
          ? (theme.brightness == Brightness.dark
              ? Colors.greenAccent
              : Colors.green)
          : theme.colorScheme.error;
    }
    if (_tabController.index == 1) return theme.colorScheme.error;
    return theme.colorScheme.secondary;
  }

  Widget _buildSelectedContent(BuildContext context, _AnalyticsData d) {
    switch (_tabController.index) {
      case 0:
        return _buildIncomeContent(context, d);
      case 1:
        return _buildExpensesContent(context, d);
      default:
        return _buildBudgetContent(context, d);
    }
  }

  Widget _buildIncomeContent(BuildContext context, _AnalyticsData d) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final palette = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      colorScheme.primary.withValues(alpha: 0.6),
      colorScheme.secondary.withValues(alpha: 0.6),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChartCard(
              context,
              title: 'Income Trend',
              subtitle: money(d.income),
              child: AspectRatio(
                aspectRatio: 1.5,
                child: BarChart(
                  _buildBarChartData(context, colorScheme.primary, d.incomeWeekly),
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.1, curve: Curves.easeOutQuad),
        const SizedBox(height: 16),
        if (d.incomeSources.isEmpty)
          _emptyCard(context, 'Income Sources', 'No payments received yet this month.')
        else
          _buildPieChartCard(
                context,
                title: 'Income Sources',
                sections: d.incomeSources.map((s) => s.amount).toList(),
                colors: List.generate(
                  d.incomeSources.length,
                  (i) => palette[i % palette.length],
                ),
                legendTitles: d.incomeSources.map((s) => s.label).toList(),
                legendAmounts:
                    d.incomeSources.map((s) => money(s.amount, compact: true)).toList(),
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 100.ms)
              .slideY(begin: 0.1, curve: Curves.easeOutQuad),
        const SizedBox(height: 16),
        if (d.recentIncome.isEmpty)
          _emptyCard(context, 'Recent Transactions', 'Nothing yet.')
        else
          _buildTransactionsList(
            context,
            title: 'Recent Transactions',
            items: d.recentIncome
                .map((t) => t.counterpartyName ?? t.channelLabel)
                .toList(),
            amounts:
                d.recentIncome.map((t) => '+${money(t.amount, compact: true)}').toList(),
            dates: d.recentIncome
                .map((t) => DateFormat('MMM d, h:mm a').format(t.createdAt))
                .toList(),
            isPositive: true,
          ),
      ],
    );
  }

  Widget _buildExpensesContent(BuildContext context, _AnalyticsData d) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final palette = [
      colorScheme.error,
      colorScheme.error.withValues(alpha: 0.8),
      colorScheme.error.withValues(alpha: 0.6),
      colorScheme.error.withValues(alpha: 0.4),
      colorScheme.error.withValues(alpha: 0.2),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChartCard(
              context,
              title: 'Expenses Trend',
              subtitle: money(d.expenses),
              child: AspectRatio(
                aspectRatio: 1.5,
                child: BarChart(
                  _buildBarChartData(context, colorScheme.error, d.expensesWeekly),
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.1, curve: Curves.easeOutQuad),
        const SizedBox(height: 16),
        if (d.expenseCategories.isEmpty)
          _emptyCard(context, 'Expense Categories', 'No costs logged this month.')
        else
          _buildPieChartCard(
                context,
                title: 'Expense Categories',
                sections: d.expenseCategories.map((s) => s.amount).toList(),
                colors: List.generate(
                  d.expenseCategories.length,
                  (i) => palette[i % palette.length],
                ),
                legendTitles: d.expenseCategories.map((s) => s.label).toList(),
                legendAmounts: d.expenseCategories
                    .map((s) => money(s.amount, compact: true))
                    .toList(),
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 100.ms)
              .slideY(begin: 0.1, curve: Curves.easeOutQuad),
        const SizedBox(height: 16),
        if (d.recentExpenses.isEmpty)
          _emptyCard(context, 'Recent Expenses', 'No expenses logged yet.')
        else
          _buildTransactionsList(
            context,
            title: 'Recent Expenses',
            items: d.recentExpenses.map((e) => e.category).toList(),
            amounts: d.recentExpenses
                .map((e) => '-${money(e.amount, compact: true)}')
                .toList(),
            dates: d.recentExpenses
                .map((e) => DateFormat('MMM d, h:mm a').format(e.incurredAt))
                .toList(),
            isPositive: false,
          ),
      ],
    );
  }

  Widget _buildBudgetContent(BuildContext context, _AnalyticsData d) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final palette = [
      colorScheme.secondary,
      colorScheme.secondary.withValues(alpha: 0.8),
      colorScheme.secondary.withValues(alpha: 0.6),
      colorScheme.secondary.withValues(alpha: 0.4),
      colorScheme.secondary.withValues(alpha: 0.2),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChartCard(
              context,
              title: 'Budget Usage Trend',
              subtitle: '${money(d.expenses, compact: true)} Used',
              child: AspectRatio(
                aspectRatio: 1.5,
                child: BarChart(
                  _buildBarChartData(
                    context,
                    colorScheme.secondary,
                    d.budgetWeekly,
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.1, curve: Curves.easeOutQuad),
        const SizedBox(height: 16),
        if (d.budgetAllocation.isEmpty)
          _emptyCard(
            context,
            'Budget Allocation',
            'No budget set for this month yet.',
          )
        else
          _buildPieChartCard(
                context,
                title: 'Budget Allocation',
                sections: d.budgetAllocation.map((s) => s.amount).toList(),
                colors: List.generate(
                  d.budgetAllocation.length,
                  (i) => palette[i % palette.length],
                ),
                legendTitles: d.budgetAllocation.map((s) => s.label).toList(),
                legendAmounts: d.budgetAllocation
                    .map((s) => money(s.amount, compact: true))
                    .toList(),
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 100.ms)
              .slideY(begin: 0.1, curve: Curves.easeOutQuad),
        const SizedBox(height: 16),
        if (d.budgetItems.isEmpty)
          _emptyCard(context, 'Budgets', 'Nothing allocated yet.')
        else
          _buildTransactionsList(
            context,
            title: 'Budgets This Month',
            items: d.budgetItems.map((b) => b.category).toList(),
            amounts: d.budgetItems
                .map((b) => money(b.allocatedAmount, compact: true))
                .toList(),
            dates: d.budgetItems
                .map((b) => DateFormat('MMM d').format(b.periodStart))
                .toList(),
            isPositive: false,
            isBudget: true,
          ),
      ],
    );
  }

  Widget _emptyCard(BuildContext context, String title, String message) {
    return _buildChartCard(
      context,
      title: title,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          message,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  BarChartData _buildBarChartData(
    BuildContext context,
    Color barColor,
    List<double> values,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final maxVal = values.isEmpty
        ? 1.0
        : values.reduce((a, b) => a > b ? a : b);
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxVal <= 0 ? 1 : maxVal * 1.2,
      barTouchData: AppChart.barTooltip(
        context,
        format: (v) => '${v.toStringAsFixed(1)}M',
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final style = TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 10,
              );
              String text = 'Week ${value.toInt() + 1}';
              return SideTitleWidget(
                meta: meta,
                space: 4,
                child: Text(text, style: style),
              );
            },
            reservedSize: 28,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            getTitlesWidget: (value, meta) {
              if (value == 0) return const SizedBox.shrink();
              return SideTitleWidget(
                meta: meta,
                space: 4,
                child: Text(
                  '${value.toStringAsFixed(1)}M',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      gridData: AppChart.grid(context),
      borderData: AppChart.noBorder,
      barGroups: List.generate(
        values.length,
        (i) => _makeBarData(i, values[i], barColor),
      ),
    );
  }

  Widget _buildPieChartCard(
    BuildContext context, {
    required String title,
    required List<double> sections,
    required List<Color> colors,
    required List<String> legendTitles,
    required List<String> legendAmounts,
  }) {
    List<PieChartSectionData> pieSections = List.generate(sections.length, (i) {
      return PieChartSectionData(
        color: colors[i],
        value: sections[i],
        title: '',
        radius: 40,
      );
    });

    return _buildChartCard(
      context,
      title: title,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    enabled: true,
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: pieSections,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var row = 0; row < 3; row++) ...[
                  if (row > 0) const SizedBox(height: 12),
                  Row(
                    children: [
                      for (final idx in [row * 2, row * 2 + 1])
                        if (idx < legendTitles.length)
                          Expanded(
                            child: _buildLegendItem(
                              context,
                              legendTitles[idx],
                              legendAmounts[idx],
                              colors[idx],
                            ),
                          ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(
    BuildContext context, {
    required String title,
    required List<String> items,
    required List<String> amounts,
    required List<String> dates,
    required bool isPositive,
    bool isBudget = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final amountColor = isBudget
        ? colorScheme.onSurface
        : (isPositive
              ? (Theme.of(context).brightness == Brightness.dark
                    ? Colors.greenAccent
                    : Colors.green)
              : colorScheme.error);

    return _buildChartCard(
          context,
          title: title,
          child: Column(
            children: List.generate(
              items.length,
              (index) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    isBudget
                        ? Icons.receipt_long
                        : (isPositive ? Icons.person : Icons.shopping_bag),
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                title: Text(
                  items[index],
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                subtitle: Text(
                  dates[index],
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
                trailing: Text(
                  amounts[index],
                  style: TextStyle(
                    color: amountColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: 200.ms)
        .slideY(begin: 0.1, curve: Curves.easeOutQuad);
  }

  Widget _buildLegendItem(
    BuildContext context,
    String title,
    String amount,
    Color color,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          amount,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  BarChartGroupData _makeBarData(int x, double y, Color barColor) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: barColor,
          width: 14,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }

  Widget _buildChartCard(
    BuildContext context, {
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    return GlassSurface(
      borderRadius: BorderRadius.circular(24),
      opacity: 0.14,
      blur: 14,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

// ─── Real data computation ───────────────────────────────────────────────────

class _MonthOption {
  final DateTime start;
  final DateTime end; // exclusive
  final String label;
  const _MonthOption(this.start, this.end, this.label);
}

List<_MonthOption> _recentMonths(DateTime now, {int count = 3}) {
  return List.generate(count, (i) {
    final anchor = DateTime(now.year, now.month - i, 1);
    final end = DateTime(anchor.year, anchor.month + 1, 1);
    return _MonthOption(anchor, end, DateFormat('MMM. yyyy').format(anchor));
  });
}

class _PieSlice {
  final String label;
  final double amount;
  const _PieSlice(this.label, this.amount);
}

class _AnalyticsData {
  final double income;
  final double incomeDeltaPct;
  final List<double> incomeWeekly;
  final List<_PieSlice> incomeSources;
  final List<LedgerTransaction> recentIncome;

  final double expenses;
  final double expensesDeltaPct;
  final List<double> expensesWeekly;
  final List<_PieSlice> expenseCategories;
  final List<MerchantExpense> recentExpenses;

  final double budgetAllocated;
  final double budgetUsedPct;
  final List<double> budgetWeekly;
  final List<_PieSlice> budgetAllocation;
  final List<MerchantBudget> budgetItems;

  const _AnalyticsData({
    required this.income,
    required this.incomeDeltaPct,
    required this.incomeWeekly,
    required this.incomeSources,
    required this.recentIncome,
    required this.expenses,
    required this.expensesDeltaPct,
    required this.expensesWeekly,
    required this.expenseCategories,
    required this.recentExpenses,
    required this.budgetAllocated,
    required this.budgetUsedPct,
    required this.budgetWeekly,
    required this.budgetAllocation,
    required this.budgetItems,
  });
}

/// Buckets amounts into up to 5 weekly windows (in millions of XAF) starting
/// from `monthStart`, covering the longest a calendar month can span.
List<double> _weeklyBuckets(
  DateTime monthStart,
  Iterable<(DateTime date, num amount)> entries,
) {
  const weeks = 5;
  final totals = List<double>.filled(weeks, 0);
  for (final (date, amount) in entries) {
    final dayIndex = date.difference(monthStart).inDays;
    if (dayIndex < 0) continue;
    final w = (dayIndex ~/ 7).clamp(0, weeks - 1);
    totals[w] += amount / 1000000;
  }
  return totals;
}

String _channelLabel(String key) => switch (key) {
      'mtn_momo' => 'MTN Mobile Money',
      'orange_money' => 'Orange Money',
      'visa' || 'mastercard' || 'card' => 'Card payment',
      'bank_transfer' => 'Bank transfer',
      'qr_checkout' => 'QR checkout',
      'payment_link' => 'Payment link',
      _ => key.isEmpty ? 'Other' : key,
    };

_AnalyticsData _computeData(
  _MonthOption month,
  List<LedgerTransaction> allTxns,
  List<MerchantExpense> allExpenses,
  List<MerchantBudget> allBudgets,
) {
  bool inMonth(DateTime d) => !d.isBefore(month.start) && d.isBefore(month.end);

  final prevStart = DateTime(month.start.year, month.start.month - 1, 1);
  bool inPrevMonth(DateTime d) => !d.isBefore(prevStart) && d.isBefore(month.start);

  final incomeTxns = allTxns
      .where((t) => t.status == 'completed' && t.type == 'payment' && inMonth(t.createdAt))
      .toList();
  final income = incomeTxns.fold<num>(0, (s, t) => s + t.amount).toDouble();
  final prevIncome = allTxns
      .where((t) => t.status == 'completed' && t.type == 'payment' && inPrevMonth(t.createdAt))
      .fold<num>(0, (s, t) => s + t.amount)
      .toDouble();
  final incomeDeltaPct =
      prevIncome == 0 ? (income == 0 ? 0.0 : 100.0) : ((income - prevIncome) / prevIncome) * 100;

  final incomeByChannel = <String, num>{};
  for (final t in incomeTxns) {
    final key = t.provider ?? t.channel;
    incomeByChannel[key] = (incomeByChannel[key] ?? 0) + t.amount;
  }
  final incomeSources = incomeByChannel.entries
      .map((e) => _PieSlice(_channelLabel(e.key), e.value.toDouble()))
      .toList()
    ..sort((a, b) => b.amount.compareTo(a.amount));

  final recentIncome = [...incomeTxns]
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  // Expenses: platform fees + refunds (both derived from transactions) plus
  // any merchant-logged expenses for the month.
  num platformFees = 0, refunds = 0;
  for (final t in allTxns) {
    if (t.status != 'completed' || !inMonth(t.createdAt)) continue;
    platformFees += t.feeAmount;
    if (t.type == 'refund') refunds += t.amount;
  }
  final monthExpenses =
      allExpenses.where((e) => inMonth(e.incurredAt)).toList()
        ..sort((a, b) => b.incurredAt.compareTo(a.incurredAt));
  final loggedExpenseTotal =
      monthExpenses.fold<num>(0, (s, e) => s + e.amount).toDouble();
  final expenses = platformFees.toDouble() + refunds.toDouble() + loggedExpenseTotal;

  num prevPlatformFees = 0, prevRefunds = 0;
  for (final t in allTxns) {
    if (t.status != 'completed' || !inPrevMonth(t.createdAt)) continue;
    prevPlatformFees += t.feeAmount;
    if (t.type == 'refund') prevRefunds += t.amount;
  }
  final prevLoggedExpenseTotal = allExpenses
      .where((e) => inPrevMonth(e.incurredAt))
      .fold<num>(0, (s, e) => s + e.amount);
  final prevExpenses =
      prevPlatformFees.toDouble() + prevRefunds.toDouble() + prevLoggedExpenseTotal.toDouble();
  final expensesDeltaPct = prevExpenses == 0
      ? (expenses == 0 ? 0.0 : 100.0)
      : ((expenses - prevExpenses) / prevExpenses) * 100;

  final expenseCategories = <_PieSlice>[
    if (platformFees > 0) _PieSlice('Platform fees', platformFees.toDouble()),
    if (refunds > 0) _PieSlice('Refunds issued', refunds.toDouble()),
    for (final e in monthExpenses) _PieSlice(e.category, e.amount.toDouble()),
  ]..sort((a, b) => b.amount.compareTo(a.amount));

  final expensesWeekly = _weeklyBuckets(month.start, [
    for (final t in allTxns)
      if (t.status == 'completed' && inMonth(t.createdAt) && t.type == 'refund')
        (t.createdAt, t.amount),
    for (final t in allTxns)
      if (t.status == 'completed' && inMonth(t.createdAt))
        (t.createdAt, t.feeAmount),
    for (final e in monthExpenses) (e.incurredAt, e.amount),
  ]);

  final incomeWeekly = _weeklyBuckets(
    month.start,
    incomeTxns.map((t) => (t.createdAt, t.amount)),
  );

  final monthBudgets = allBudgets
      .where((b) => b.periodStart.isBefore(month.end) && b.periodEnd.isAfter(month.start))
      .toList()
    ..sort((a, b) => b.allocatedAmount.compareTo(a.allocatedAmount));
  final budgetAllocated =
      monthBudgets.fold<num>(0, (s, b) => s + b.allocatedAmount).toDouble();
  final budgetUsedPct = budgetAllocated == 0 ? 0.0 : (expenses / budgetAllocated) * 100;
  final budgetAllocation = monthBudgets
      .map((b) => _PieSlice(b.category, b.allocatedAmount.toDouble()))
      .toList();

  return _AnalyticsData(
    income: income,
    incomeDeltaPct: incomeDeltaPct,
    incomeWeekly: incomeWeekly,
    incomeSources: incomeSources,
    recentIncome: recentIncome.take(5).toList(),
    expenses: expenses,
    expensesDeltaPct: expensesDeltaPct,
    expensesWeekly: expensesWeekly,
    expenseCategories: expenseCategories,
    recentExpenses: monthExpenses.take(5).toList(),
    budgetAllocated: budgetAllocated,
    budgetUsedPct: budgetUsedPct,
    budgetWeekly: expensesWeekly,
    budgetAllocation: budgetAllocation,
    budgetItems: monthBudgets,
  );
}
