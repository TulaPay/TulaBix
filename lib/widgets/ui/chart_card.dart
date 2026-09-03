import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:tulapay/widgets/glass_effects.dart';

/// White card wrapper for a chart: a title, an optional big value, an optional
/// trailing widget (legend toggle, range pill), then the chart body.
class ChartCard extends StatelessWidget {
  final String title;
  final String? value;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry padding;

  const ChartCard({
    super.key,
    required this.title,
    this.value,
    this.trailing,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GlassSurface(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppText.cardTitle(color: cs.onSurface)),
                    if (value != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        value!,
                        style: AppText.hero(size: 26, color: cs.onSurface),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          child,
        ],
      ),
    );
  }
}
