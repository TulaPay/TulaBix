import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';

/// Shared `fl_chart` styling so every chart in the app reads as one system:
/// faint dotted horizontal gridlines only, tiny muted edge labels, rounded-top
/// accent bars (faded when not highlighted), and a dark rounded-pill tooltip.
abstract class AppChart {
  static FlGridData grid(BuildContext context, {double interval = 10}) {
    final c = context.hairlineColor;
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: interval,
      getDrawingHorizontalLine: (_) => FlLine(
        color: c,
        strokeWidth: 1,
        dashArray: const [3, 4],
      ),
    );
  }

  static FlBorderData get noBorder => FlBorderData(show: false);

  static AxisTitles hiddenAxis() =>
      const AxisTitles(sideTitles: SideTitles(showTitles: false));

  static AxisTitles bottomLabels(
    BuildContext context,
    List<String> labels, {
    double reservedSize = 26,
  }) {
    final style = AppText.caption(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    ).copyWith(fontSize: 10);
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: reservedSize,
        interval: 1,
        getTitlesWidget: (value, meta) {
          final i = value.toInt();
          if (i < 0 || i >= labels.length) return const SizedBox.shrink();
          return SideTitleWidget(
            meta: meta,
            space: 6,
            child: Text(labels[i], style: style),
          );
        },
      ),
    );
  }

  static AxisTitles edgeValueLabels(
    BuildContext context, {
    double reservedSize = 32,
    String Function(double)? format,
  }) {
    final style = AppText.caption(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    ).copyWith(fontSize: 10);
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: reservedSize,
        getTitlesWidget: (value, meta) {
          if (value == meta.min) return const SizedBox.shrink();
          return SideTitleWidget(
            meta: meta,
            space: 6,
            child: Text(
              format?.call(value) ?? value.toInt().toString(),
              style: style,
            ),
          );
        },
      ),
    );
  }

  static BarTouchData barTooltip(
    BuildContext context, {
    String Function(double)? format,
  }) {
    final cs = Theme.of(context).colorScheme;
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (_) => cs.inverseSurface,
        tooltipBorderRadius: BorderRadius.circular(AppRadius.sm),
        tooltipPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        getTooltipItem: (group, _, rod, __) => BarTooltipItem(
          format?.call(rod.toY) ?? rod.toY.toStringAsFixed(0),
          AppText.pillLabel(color: cs.onInverseSurface).copyWith(fontSize: 12),
        ),
      ),
    );
  }

  /// A single rounded-top bar; [highlighted] uses the solid accent, others a
  /// faded tint.
  static BarChartGroupData bar(
    BuildContext context,
    int x,
    double y, {
    bool highlighted = false,
    double width = 14,
  }) {
    final cs = Theme.of(context).colorScheme;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: width,
          color: highlighted
              ? cs.primary
              : cs.primary.withValues(alpha: 0.22),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }

  /// Dashed horizontal reference/goal line for LineChart / BarChart.
  static HorizontalLine goalLine(BuildContext context, double y, String label) {
    final cs = Theme.of(context).colorScheme;
    return HorizontalLine(
      y: y,
      color: cs.onSurfaceVariant.withValues(alpha: 0.5),
      strokeWidth: 1,
      dashArray: const [4, 4],
      label: HorizontalLineLabel(
        show: true,
        alignment: Alignment.topLeft,
        style: AppText.caption(color: cs.onSurfaceVariant),
        labelResolver: (_) => label,
      ),
    );
  }
}
