import 'dart:ui';

import 'package:flutter/material.dart';

class AppBackdrop extends StatelessWidget {
  final Widget child;

  const AppBackdrop({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final base = isDark ? const Color(0xFF05081A) : const Color(0xFFF0F4FF);
    final glowA = isDark
        ? scheme.primary.withValues(alpha: 0.22)
        : scheme.primary.withValues(alpha: 0.16);
    final glowB = isDark
        ? scheme.secondary.withValues(alpha: 0.18)
        : scheme.secondary.withValues(alpha: 0.14);
    final glowC = scheme.tertiary.withValues(alpha: isDark ? 0.10 : 0.08);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            base,
            Color.lerp(base, scheme.primary, isDark ? 0.06 : 0.04)!,
          ],
        ),
      ),
      child: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: -80,
              left: -40,
              child: _GlowBlob(color: glowA, size: 220),
            ),
            Positioned(
              top: 160,
              right: -70,
              child: _GlowBlob(color: glowB, size: 260),
            ),
            Positioned(
              bottom: -90,
              left: 80,
              child: _GlowBlob(color: glowC, size: 240),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class GlassSurface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final Color? tint;
  final double blur;
  final double opacity;
  final BoxBorder? border;

  const GlassSurface({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.tint,
    this.blur = 18,
    this.opacity = 0.14,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = tint ?? scheme.surface;

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: background.withValues(alpha: opacity),
            borderRadius: borderRadius,
            border:
                border ??
                Border.all(
                  color: Colors.white.withValues(alpha: 0.16),
                  width: 1,
                ),
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: GlassSurface(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          borderRadius: BorderRadius.circular(22),
          opacity: 0.16,
          blur: 16,
          border: Border.all(color: accentColor.withValues(alpha: 0.18)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accentColor.withValues(alpha: 0.30),
                      accentColor.withValues(alpha: 0.12),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0.0)]),
      ),
    );
  }
}
