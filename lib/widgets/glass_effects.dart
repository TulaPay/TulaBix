import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_tokens.dart';

// Clean-surface replacements for the app's former glassmorphic look.
// Public APIs are unchanged from the glass versions so every existing call
// site keeps compiling/rendering; the visuals now follow the reference
// design language: pale page background, pure-white cards, soft shadow,
// hairline borders, generous radius.

class AppBackdrop extends StatelessWidget {
  final Widget child;

  const AppBackdrop({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: child,
    );
  }
}

/// A flat card surface. `blur` / `opacity` are retained for API compatibility
/// but no longer drive a glass effect — they are ignored.
class GlassSurface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final Color? tint;
  final double blur;
  final double opacity;
  final BoxBorder? border;

  /// When true, drops the shadow (used for nested / inline surfaces).
  final bool flat;

  const GlassSurface({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.borderRadius = AppRadius.xlAll,
    this.tint,
    this.blur = 18,
    this.opacity = 0.14,
    this.border,
    this.flat = false,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final surface = tint ?? context.cardColor;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: borderRadius,
        border: border ?? Border.all(color: context.hairlineColor),
        boxShadow: flat ? null : AppShadows.card(brightness),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

/// Square icon-and-label tile used in "quick action" grids.
class GlassActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color iconColor;
  final Color accentColor;

  const GlassActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.iconColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: context.hairlineColor),
        boxShadow: AppShadows.card(Theme.of(context).brightness),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.md,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(height: AppSpacing.sm),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption(color: cs.onSurface).copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
