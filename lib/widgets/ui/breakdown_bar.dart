import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';

/// One line of a "where the money goes" breakdown: a label and amount on top,
/// a thin proportional bar and a percent on the bottom.
class BreakdownRow extends StatelessWidget {
  final String label;
  final String amount;

  /// 0..1 — drives both the bar width and the percent readout.
  final double fraction;
  final Color? color;

  const BreakdownRow({
    super.key,
    required this.label,
    required this.amount,
    required this.fraction,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final c = color ?? cs.primary;
    final pct = (fraction.clamp(0.0, 1.0) * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppText.body(size: 13, color: cs.onSurface)
                    .copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              amount,
              style: AppText.cardTitle(size: 13, color: cs.onSurface),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: LinearProgressIndicator(
                  value: fraction.clamp(0.0, 1.0),
                  minHeight: 6,
                  backgroundColor: c.withValues(alpha: 0.10),
                  valueColor: AlwaysStoppedAnimation<Color>(c),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            SizedBox(
              width: 34,
              child: Text(
                '$pct%',
                textAlign: TextAlign.right,
                style: AppText.caption(color: cs.onSurfaceVariant)
                    .copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Vertically-spaced stack of [BreakdownRow]s.
class BreakdownList extends StatelessWidget {
  final List<BreakdownRow> rows;
  final double spacing;

  const BreakdownList({super.key, required this.rows, this.spacing = AppSpacing.lg});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) SizedBox(height: spacing),
          rows[i],
        ],
      ],
    );
  }
}
