import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';

/// Small tinted pill showing a change: an up/down caret + a label like
/// `+14.2%` or `- XAF 4,500`. Green for a gain, red for a loss, neutral when
/// [positive] is null. Used in metric headlines, stat rows, chart summaries.
class DeltaChip extends StatelessWidget {
  final String label;

  /// `true` -> gain (green), `false` -> loss (red), `null` -> neutral (muted).
  final bool? positive;

  /// Hide the caret icon (e.g. when the label already carries a sign).
  final bool showArrow;
  final bool dense;

  const DeltaChip(
    this.label, {
    super.key,
    this.positive,
    this.showArrow = true,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final Color color = switch (positive) {
      true => AppColors.positive,
      false => AppColors.negative,
      null => cs.onSurfaceVariant,
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 10,
        vertical: dense ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showArrow && positive != null) ...[
            Icon(
              positive! ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              size: dense ? 11 : 13,
              color: color,
            ),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: AppText.caption(color: color).copyWith(
              fontSize: dense ? 11 : 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
