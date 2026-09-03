import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:tulapay/widgets/ui/icon_chip.dart';

enum AlertSeverity { critical, warning, info }

/// A single "needs attention" row: a severity-tinted icon chip, a title and
/// subtitle, and a chevron. Rendered as its own hairline card so alerts read
/// as distinct, tappable items — never buried in a list.
class AlertTile extends StatelessWidget {
  final AlertSeverity severity;
  final String title;
  final String subtitle;
  final IconData? icon;
  final VoidCallback? onTap;

  const AlertTile({
    super.key,
    required this.severity,
    required this.title,
    required this.subtitle,
    this.icon,
    this.onTap,
  });

  Color _color(ColorScheme cs) => switch (severity) {
        AlertSeverity.critical => AppColors.negative,
        AlertSeverity.warning => AppColors.warning,
        AlertSeverity.info => cs.secondary,
      };

  IconData get _icon =>
      icon ??
      switch (severity) {
        AlertSeverity.critical => Icons.error_outline_rounded,
        AlertSeverity.warning => Icons.warning_amber_rounded,
        AlertSeverity.info => Icons.info_outline_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = _color(cs);

    return Material(
      color: context.cardColor,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: context.hairlineColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                IconChip(_icon, color: color, size: 44),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: AppText.cardTitle(color: cs.onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppText.caption(color: cs.onSurfaceVariant),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (onTap != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: cs.onSurfaceVariant.withValues(alpha: 0.5),
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
