import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Aug. 2024';

  Future<void> _refreshData() async {
    // Simulate network delay for pulling fresh data
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String get _headerTitle {
    switch (_tabController.index) {
      case 0:
        return 'Total Revenue';
      case 1:
        return 'Total Expenses';
      case 2:
        return 'Total Budget';
      default:
        return 'Total Revenue';
    }
  }

  String get _headerAmount {
    switch (_tabController.index) {
      case 0:
        return '₦39,000,000';
      case 1:
        return '₦12,500,000';
      case 2:
        return '₦50,000,000';
      default:
        return '₦39,000,000';
    }
  }

  String get _headerPercentage {
    switch (_tabController.index) {
      case 0:
        return '+2.5%';
      case 1:
        return '+5.2%'; // Example of expense increase
      case 2:
        return '80% Used';
      default:
        return '+2.5%';
    }
  }

  Color _headerPercentageColor(ThemeData theme) {
    if (_tabController.index == 0)
      return theme.brightness == Brightness.dark
          ? Colors.greenAccent
          : Colors.green;
    if (_tabController.index == 1) return theme.colorScheme.error;
    return theme.colorScheme.secondary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting report as PDF...')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
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
                          _headerAmount,
                          style: textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Text(
                            _headerPercentage,
                            style: TextStyle(
                              color: _headerPercentageColor(theme),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    DropdownButton<String>(
                      value: _selectedPeriod,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      elevation: 16,
                      style: TextStyle(color: colorScheme.onSurface),
                      underline: const SizedBox(),
                      dropdownColor: colorScheme.surface,
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            _selectedPeriod = value;
                          });
                        }
                      },
                      items: ['Aug. 2024', 'Jul. 2024', 'Jun. 2024']
                          .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          })
                          .toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Tabs
                TabBar(
                  controller: _tabController,
                  labelColor: colorScheme.onSurface,
                  unselectedLabelColor: colorScheme.onSurfaceVariant,
                  indicatorColor: colorScheme.onSurface,
                  dividerColor: colorScheme.outline.withValues(alpha: 0.2),
                  tabs: const [
                    Tab(text: 'Income'),
                    Tab(text: 'Expenses'),
                    Tab(text: 'Budget'),
                  ],
                ),
                const SizedBox(height: 24),

                // Content based on selected tab
                _buildSelectedContent(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedContent(BuildContext context) {
    switch (_tabController.index) {
      case 0:
        return _buildIncomeContent(context);
      case 1:
        return _buildExpensesContent(context);
      case 2:
        return _buildBudgetContent(context);
      default:
        return _buildIncomeContent(context);
    }
  }

  Widget _buildIncomeContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final color1 = colorScheme.primary;
    final color2 = colorScheme.secondary;
    final color3 = colorScheme.tertiary;
    final color4 = colorScheme.primary.withValues(alpha: 0.6);
    final color5 = colorScheme.secondary.withValues(alpha: 0.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChartCard(
              context,
              title: 'Income Trend',
              subtitle: '₦39,000,000',
              child: AspectRatio(
                aspectRatio: 1.5,
                child: BarChart(
                  _buildBarChartData(
                    context,
                    colorScheme.primary,
                    _selectedPeriod == 'Aug. 2024'
                        ? [20, 24, 20, 40, 29, 15, 20]
                        : _selectedPeriod == 'Jul. 2024'
                        ? [15, 30, 25, 35, 20, 25, 30]
                        : [30, 20, 40, 10, 25, 35, 15],
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.1, curve: Curves.easeOutQuad),
        const SizedBox(height: 16),
        _buildPieChartCard(
              context,
              title: 'Income Sources',
              sections: [35, 25, 20, 10, 10],
              colors: [color1, color2, color3, color4, color5],
              legendTitles: ['Products', 'Transfers', 'Pos', 'Links', 'Other'],
              legendAmounts: [
                '₦3,500,000',
                '₦2,000,000',
                '₦2,500,000',
                '₦1,000,000',
                '₦1,000,000',
              ],
            )
            .animate()
            .fadeIn(duration: 400.ms, delay: 100.ms)
            .slideY(begin: 0.1, curve: Curves.easeOutQuad),
        const SizedBox(height: 16),
        _buildTransactionsList(
          context,
          title: 'Recent Transactions',
          items: ['Customer 1', 'Customer 2', 'Customer 3'],
          amounts: ['+₦50,000', '+₦25,000', '+₦15,000'],
          isPositive: true,
        ),
      ],
    );
  }

  Widget _buildExpensesContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final color1 = colorScheme.error;
    final color2 = colorScheme.error.withValues(alpha: 0.8);
    final color3 = colorScheme.error.withValues(alpha: 0.6);
    final color4 = colorScheme.error.withValues(alpha: 0.4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChartCard(
              context,
              title: 'Expenses Trend',
              subtitle: '₦12,500,000',
              child: AspectRatio(
                aspectRatio: 1.5,
                child: BarChart(
                  _buildBarChartData(
                    context,
                    colorScheme.error,
                    _selectedPeriod == 'Aug. 2024'
                        ? [10, 8, 12, 15, 10, 5, 8]
                        : _selectedPeriod == 'Jul. 2024'
                        ? [8, 12, 10, 18, 12, 7, 10]
                        : [12, 10, 15, 8, 15, 10, 12],
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.1, curve: Curves.easeOutQuad),
        const SizedBox(height: 16),
        _buildPieChartCard(
              context,
              title: 'Expense Categories',
              sections: [40, 30, 20, 10],
              colors: [color1, color2, color3, color4],
              legendTitles: [
                'Refunds',
                'Platform Fees',
                'Staff Salary',
                'Other',
              ],
              legendAmounts: [
                '₦5,000,000',
                '₦3,750,000',
                '₦2,500,000',
                '₦1,250,000',
              ],
            )
            .animate()
            .fadeIn(duration: 400.ms, delay: 100.ms)
            .slideY(begin: 0.1, curve: Curves.easeOutQuad),
        const SizedBox(height: 16),
        _buildTransactionsList(
          context,
          title: 'Recent Expenses',
          items: ['Refund - Order #1234', 'Server Hosting', 'Office Supplies'],
          amounts: ['-₦15,000', '-₦50,000', '-₦25,000'],
          isPositive: false,
        ),
      ],
    );
  }

  Widget _buildBudgetContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final color1 = colorScheme.secondary;
    final color2 = colorScheme.secondary.withValues(alpha: 0.8);
    final color3 = colorScheme.secondary.withValues(alpha: 0.6);
    final color4 = colorScheme.secondary.withValues(alpha: 0.4);
    final color5 = colorScheme.secondary.withValues(alpha: 0.2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChartCard(
              context,
              title: 'Budget Usage Trend',
              subtitle: '₦40,000,000 Used',
              child: AspectRatio(
                aspectRatio: 1.5,
                child: BarChart(
                  _buildBarChartData(
                    context,
                    colorScheme.secondary,
                    _selectedPeriod == 'Aug. 2024'
                        ? [5, 15, 25, 30, 40, 40, 40]
                        : _selectedPeriod == 'Jul. 2024'
                        ? [10, 20, 30, 35, 45, 45, 45]
                        : [2, 10, 15, 20, 25, 30, 35],
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.1, curve: Curves.easeOutQuad),
        const SizedBox(height: 16),
        _buildPieChartCard(
              context,
              title: 'Budget Allocation',
              sections: [35, 25, 20, 15, 5],
              colors: [color1, color2, color3, color4, color5],
              legendTitles: [
                'Marketing',
                'Operations',
                'Tech',
                'R&D',
                'Miscellaneous',
              ],
              legendAmounts: [
                '₦17,500,000',
                '₦12,500,000',
                '₦10,000,000',
                '₦7,500,000',
                '₦2,500,000',
              ],
            )
            .animate()
            .fadeIn(duration: 400.ms, delay: 100.ms)
            .slideY(begin: 0.1, curve: Curves.easeOutQuad),
        const SizedBox(height: 16),
        _buildTransactionsList(
          context,
          title: 'Upcoming Bills',
          items: ['Marketing Agency', 'AWS Cloud Services', 'Internet Bill'],
          amounts: ['₦500,000', '₦150,000', '₦50,000'],
          isPositive: false,
          isBudget: true,
        ),
      ],
    );
  }

  BarChartData _buildBarChartData(
    BuildContext context,
    Color barColor,
    List<double> values,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 50,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => colorScheme.surfaceContainerHighest,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${rod.toY.toInt()}M',
              TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
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
                  '${value.toInt()}M',
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
      gridData: FlGridData(
        show: true,
        checkToShowHorizontalLine: (value) => value % 10 == 0,
        getDrawingHorizontalLine: (value) => FlLine(
          color: colorScheme.outline.withValues(alpha: 0.2),
          strokeWidth: 1,
        ),
        drawVerticalLine: false,
      ),
      borderData: FlBorderData(show: false),
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
                Row(
                  children: [
                    Expanded(
                      child: _buildLegendItem(
                        context,
                        legendTitles[0],
                        legendAmounts[0],
                        colors[0],
                      ),
                    ),
                    if (legendTitles.length > 1)
                      Expanded(
                        child: _buildLegendItem(
                          context,
                          legendTitles[1],
                          legendAmounts[1],
                          colors[1],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (legendTitles.length > 2)
                      Expanded(
                        child: _buildLegendItem(
                          context,
                          legendTitles[2],
                          legendAmounts[2],
                          colors[2],
                        ),
                      ),
                    if (legendTitles.length > 3)
                      Expanded(
                        child: _buildLegendItem(
                          context,
                          legendTitles[3],
                          legendAmounts[3],
                          colors[3],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (legendTitles.length > 4)
                      Expanded(
                        child: _buildLegendItem(
                          context,
                          legendTitles[4],
                          legendAmounts[4],
                          colors[4],
                        ),
                      ),
                  ],
                ),
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
                  'Today, 12:00 PM',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      amounts[index],
                      style: TextStyle(
                        color: amountColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isBudget) ...[
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Paying ${items[index]}...'),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                        ),
                        child: Text('Pay', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ],
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
          width: 16,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
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
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
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
