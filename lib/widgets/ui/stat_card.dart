import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';

/// Corporate Redesign StatCard component: micro-label, high-contrast metric value,
/// optional secondary text, and indicator icon.
///
/// [delta] — optional change string (e.g. '+8.6%'). Displayed as a small pill
/// next to the label. [deltaPositive] controls its colour (green / red).
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final String? secondary;
  final IconData? icon;
  final bool filled;
  final VoidCallback? onTap;

  /// Optional change indicator shown beside the label (e.g. '+8.6%').
  final String? delta;

  /// Whether [delta] should be coloured green (true) or red (false).
  final bool deltaPositive;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.secondary,
    this.icon,
    this.filled = false,
    this.onTap,
    this.delta,
    this.deltaPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fg = cs.onSurface;
    final muted = context.textTertiary;
    final deltaColor = deltaPositive ? AppColors.positive : AppColors.negative;
    final radius = BorderRadius.circular(AppRadius.sm);

    // Selectable / highlighted tile (style guide flag 01): bordered, 8px
    // radius, no shadow. [filled] marks the emphasised tile with the brand tint.
    return DecoratedBox(
      decoration: BoxDecoration(
        color: filled ? context.primaryTintColor : null,
        borderRadius: radius,
        border: Border.all(
          color: filled ? cs.primary : context.hairlineColor,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            constraints: const BoxConstraints(minHeight: 84),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        label.toUpperCase(),
                        style: AppText.microLabel(
                          color: filled ? cs.primary : muted,
                        ).copyWith(fontSize: 10, letterSpacing: 1.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (delta != null) ...[
                      const SizedBox(width: 4),
                      Text(
                        delta!,
                        style: AppText.microLabel(
                          color: deltaColor,
                        ).copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Flexible(
                      child: Text(
                        value,
                        style: AppText.cardTitle(size: 18, color: fg).copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.4,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (unit != null) ...[
                      const SizedBox(width: 4),
                      Text(
                        unit!,
                        style: AppText.cardTitle(size: 18, color: fg),
                      ),
                    ],
                  ],
                ),
                if (secondary != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    secondary!,
                    style: AppText.caption(color: context.textSecondary),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Lays a list of [StatCard]s into a 2-column grid.
class StatGrid extends StatelessWidget {
  final List<StatCard> cards;
  final double spacing;

  const StatGrid({
    super.key,
    required this.cards,
    this.spacing = AppSpacing.md,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < cards.length; i += 2) {
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: cards[i]),
              SizedBox(width: spacing),
              Expanded(
                child: i + 1 < cards.length ? cards[i + 1] : const SizedBox(),
              ),
            ],
          ),
        ),
      );
      if (i + 2 < cards.length) rows.add(SizedBox(height: spacing));
    }
    return Column(children: rows);
  }
}
