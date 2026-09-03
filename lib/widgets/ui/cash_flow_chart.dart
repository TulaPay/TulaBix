import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tulapay/format.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:tulapay/widgets/ui/chart_style.dart';

/// One column of the cash-flow chart: money in vs money out for a sub-period.
class CashFlowPoint {
  final String label;
  final double inflow;
  final double outflow;
  const CashFlowPoint(this.label, this.inflow, this.outflow);
}

/// Grouped bar chart — an `In` rod (brand accent) and an `Out` rod (faded
/// red) per period. Styled through [AppChart] so it reads as one system with
/// the rest of the app's charts. Pair it with a [ChartCard] and a legend row.
class CashFlowChart extends StatelessWidget {
  final List<CashFlowPoint> points;
  final double height;

  const CashFlowChart({super.key, required this.points, this.height = 150});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final inColor = cs.primary;
    final outColor = AppColors.negative.withValues(alpha: 0.55);

    var maxVal = 0.0;
    for (final p in points) {
      if (p.inflow > maxVal) maxVal = p.inflow;
      if (p.outflow > maxVal) maxVal = p.outflow;
    }
    final maxY = maxVal <= 0 ? 1.0 : maxVal * 1.18;

    // fl_chart 1.x can trip a semantics parent-data assertion when its render
    // objects are re-laid-out inside a scroll view; the chart carries no
    // useful semantics here, so exclude it.
    return ExcludeSemantics(
      child: SizedBox(
        height: height,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceBetween,
            maxY: maxY,
            groupsSpace: 18,
            gridData: AppChart.grid(context, interval: maxY / 3),
            borderData: AppChart.noBorder,
            titlesData: FlTitlesData(
              show: true,
              leftTitles: AppChart.hiddenAxis(),
              rightTitles: AppChart.hiddenAxis(),
              topTitles: AppChart.hiddenAxis(),
              bottomTitles: AppChart.bottomLabels(context, [
                for (final p in points) p.label,
              ]),
            ),
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => cs.inverseSurface,
                tooltipBorderRadius: BorderRadius.circular(AppRadius.sm),
                tooltipPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                getTooltipItem: (group, _, rod, rodIndex) => BarTooltipItem(
                  '${rodIndex == 0 ? 'In  ' : 'Out '}${money(rod.toY, compact: true)}',
                  AppText.pillLabel(
                    color: cs.onInverseSurface,
                  ).copyWith(fontSize: 12),
                ),
              ),
            ),
            barGroups: [
              for (var i = 0; i < points.length; i++)
                BarChartGroupData(
                  x: i,
                  barsSpace: 5,
                  barRods: [
                    _rod(points[i].inflow, inColor),
                    _rod(points[i].outflow, outColor),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartRodData _rod(double y, Color color) => BarChartRodData(
    toY: y,
    color: color,
    width: 9,
    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
  );
}
