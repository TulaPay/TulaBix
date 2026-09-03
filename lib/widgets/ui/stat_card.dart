import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';

/// One cell of the reference 2×2 stat grid: a micro-label, a big value with an
/// optional unit, an optional tiny secondary value, and a small indicator icon.
/// Exactly one card in a grid is usually [filled] in the brand accent.
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final String? secondary;
  final IconData? icon;
  final bool filled;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.secondary,
    this.icon,
    this.filled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fg = filled ? cs.onPrimary : cs.onSurface;
    final muted = filled
        ? cs.onPrimary.withValues(alpha: 0.7)
        : cs.onSurfaceVariant;

    return Material(
      color: filled ? cs.primary : context.cardMutedColor,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          constraints: const BoxConstraints(minHeight: 108),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: AppText.caption(color: muted)
                          .copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (icon != null)
                    Icon(icon, size: 16, color: filled ? fg : cs.primary),
                ],
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Flexible(
                    child: Text(
                      value,
                      style: AppText.cardTitle(size: 22, color: fg)
                          .copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.6),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (unit != null) ...[
                    const SizedBox(width: 4),
                    Text(unit!, style: AppText.caption(color: muted)),
                  ],
                ],
              ),
              if (secondary != null) ...[
                const SizedBox(height: 2),
                Text(secondary!, style: AppText.caption(color: muted)),
              ],
            ],
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

  const StatGrid({super.key, required this.cards, this.spacing = AppSpacing.md});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < cards.length; i += 2) {
      rows.add(Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: cards[i]),
          SizedBox(width: spacing),
          Expanded(
            child: i + 1 < cards.length ? cards[i + 1] : const SizedBox(),
          ),
        ],
      ));
      if (i + 2 < cards.length) rows.add(SizedBox(height: spacing));
    }
    return Column(children: rows);
  }
}
