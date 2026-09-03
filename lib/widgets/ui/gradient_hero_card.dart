import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';

/// The reference gradient hero card: a subtle periwinkle→blue diagonal, an
/// optional pill badge, a large value, and optional feature bullets separated
/// by a faint vertical rule. Used for the Home balance card and the Settings
/// profile block.
class GradientHeroCard extends StatelessWidget {
  final String? badge;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final List<Widget>? bullets;

  const GradientHeroCard({
    super.key,
    this.badge,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.xxl),
    this.bullets,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.heroGradientStart, AppColors.heroGradientEnd],
        ),
        boxShadow: AppShadows.floating(AppColors.primary),
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badge != null) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(badge!,
                    style: AppText.caption(color: Colors.white)
                        .copyWith(fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            child,
            if (bullets != null && bullets!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              Container(height: 1, color: Colors.white.withValues(alpha: 0.2)),
              const SizedBox(height: AppSpacing.lg),
              ...bullets!.map((b) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_rounded,
                            size: 16, color: Colors.white),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DefaultTextStyle(
                            style: AppText.body(
                                color: Colors.white.withValues(alpha: 0.92)),
                            child: b,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
