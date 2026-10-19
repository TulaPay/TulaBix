import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';

enum AlertSeverity { critical, warning, info }

/// A single "needs attention" row: a severity-tinted icon chip, a title and
/// subtitle, and a chevron. A 3px severity rule on the left instead of a card.
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
    AlertSeverity.critical => AppColors.warning,
    AlertSeverity.warning => AppColors.warning,
    AlertSeverity.info => cs.secondary,
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = _color(cs);

    return InkWell(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 3, color: color),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
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
                      style: AppText.caption(color: context.textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: context.textTertiary,
              ),
          ],
        ),
      ),
    );
  }
}
