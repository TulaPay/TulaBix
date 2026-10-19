import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_tokens.dart';

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

/// Chrome-free surface (spacing only; pass [border]/[tint] for selectable tiles) (style guide v1 — replaces glass/card).
/// `blur` / `opacity` are retained for API compatibility.
class GlassSurface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final Color? tint;
  final double blur;
  final double opacity;
  final BoxBorder? border;
  final bool flat;

  const GlassSurface({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.md)),
    this.tint,
    this.blur = 18,
    this.opacity = 0.14,
    this.border,
    this.flat = true,
  });

  @override
  Widget build(BuildContext context) {
    // Style guide v1: no card chrome. Content sits on the page background; a
    // fill is only drawn when a caller explicitly passes [tint]. Radius is
    // clamped to the 12px ceiling regardless of what legacy call sites ask for.
    final radius = BorderRadius.circular(
      borderRadius.topLeft.x.clamp(0, AppRadius.md).toDouble(),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tint,
        borderRadius: radius,
        border: border,
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

/// Square icon-and-label tile used in quick action grids.
/// Matches the Corporate Redesign rounded-square icon style (r=12px icon container).
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppRadius.smAll,
        border: Border.all(color: context.hairlineColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.smAll,
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
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.trackDark : AppColors.primaryTint,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(height: AppSpacing.sm),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption(color: cs.onSurface).copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
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

/// Tinted informational strip (style guide: a flat tint block, 4px radius, no
/// border). [title] is rendered bold inline ahead of [message].
class InfoNote extends StatelessWidget {
  final String? title;
  final String message;
  final IconData icon;

  const InfoNote({
    super.key,
    this.title,
    required this.message,
    this.icon = Icons.info_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.primaryTintColor,
        borderRadius: AppRadius.xsAll,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(icon, size: 16, color: cs.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  if (title != null)
                    TextSpan(
                      text: '$title. ',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                  TextSpan(text: message),
                ],
              ),
              style: AppText.caption(color: context.textSecondary)
                  .copyWith(fontSize: 13, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}
