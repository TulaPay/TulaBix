import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';

/// Corporate Redesign Hero Card component: clean flat corporate surface with
/// optional micro-badge and bullet points.
class GradientHeroCard extends StatelessWidget {
  final String? badge;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final List<Widget>? bullets;

  const GradientHeroCard({
    super.key,
    this.badge,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.xl),
    this.bullets,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.hairlineColor, width: 1),
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  badge!,
                  style: AppText.caption(
                    color: cs.primary,
                  ).copyWith(fontWeight: FontWeight.w700, fontSize: 11),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            child,
            if (bullets != null && bullets!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              Container(height: 1, color: context.hairlineColor),
              const SizedBox(height: AppSpacing.lg),
              ...bullets!.map(
                (b) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_rounded, size: 16, color: cs.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DefaultTextStyle(
                          style: AppText.body(color: cs.onSurface),
                          child: b,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
