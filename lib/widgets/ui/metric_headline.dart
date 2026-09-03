import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/ui/delta_chip.dart';

/// The "one number that matters" card: a tracked micro-label, a large value,
/// an optional caption + change chip, and an optional full-width sparkline
/// along the bottom. Flat surface — calm and auditable, distinct from the
/// gradient balance hero on Home.
class MetricHeadline extends StatelessWidget {
  final String label;
  final String value;
  final String? caption;
  final String? deltaLabel;
  final bool? deltaPositive;

  /// y-values for the trailing sparkline (x is the index). Null hides it.
  final List<double>? sparkline;

  const MetricHeadline({
    super.key,
    required this.label,
    required this.value,
    this.caption,
    this.deltaLabel,
    this.deltaPositive,
    this.sparkline,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final lineColor = switch (deltaPositive) {
      true => AppColors.positive,
      false => AppColors.negative,
      null => cs.primary,
    };

    return GlassSurface(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppText.microLabel(color: cs.primary),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: AppText.hero(size: 32, color: cs.onSurface),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (caption != null || deltaLabel != null) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                if (deltaLabel != null)
                  DeltaChip(deltaLabel!, positive: deltaPositive),
                if (deltaLabel != null && caption != null)
                  const SizedBox(width: AppSpacing.sm),
                if (caption != null)
                  Flexible(
                    child: Text(
                      caption!,
                      style: AppText.caption(color: cs.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ],
          if (sparkline != null && sparkline!.length > 1) ...[
            const SizedBox(height: AppSpacing.xl),
            // fl_chart 1.x can trip a semantics parent-data assertion when its
            // render objects are re-laid-out inside a scroll view; the chart
            // carries no useful semantics here, so exclude it.
            ExcludeSemantics(
              child: SizedBox(
                height: 48,
                child: LineChart(_sparkData(lineColor)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  LineChartData _sparkData(Color lineColor) {
    final spots = <FlSpot>[
      for (var i = 0; i < sparkline!.length; i++)
        FlSpot(i.toDouble(), sparkline![i]),
    ];
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineTouchData: LineTouchData(enabled: false),
      minY: _min(sparkline!),
      maxY: _max(sparkline!),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.3,
          color: lineColor,
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                lineColor.withValues(alpha: 0.18),
                lineColor.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// A hair of head/foot room so a flat or near-flat series still renders.
double _min(List<double> v) {
  final lo = v.reduce((a, b) => a < b ? a : b);
  final hi = v.reduce((a, b) => a > b ? a : b);
  final pad = (hi - lo).abs() < 1e-9 ? (lo.abs() * 0.1 + 1) : (hi - lo) * 0.15;
  return lo - pad;
}

double _max(List<double> v) {
  final lo = v.reduce((a, b) => a < b ? a : b);
  final hi = v.reduce((a, b) => a > b ? a : b);
  final pad = (hi - lo).abs() < 1e-9 ? (hi.abs() * 0.1 + 1) : (hi - lo) * 0.15;
  return hi + pad;
}
