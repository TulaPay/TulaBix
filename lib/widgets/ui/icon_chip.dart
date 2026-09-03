import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_tokens.dart';

/// A tinted rounded container holding a single line icon — the recurring
/// "icon chip" from the references (list-row leading, action tiles, headers).
class IconChip extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double size;
  final double iconSize;
  final bool circular;
  final Color? background;

  const IconChip(
    this.icon, {
    super.key,
    this.color,
    this.size = 44,
    this.iconSize = 20,
    this.circular = false,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    final accent = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background ?? accent.withValues(alpha: 0.12),
        borderRadius: circular
            ? BorderRadius.circular(AppRadius.pill)
            : BorderRadius.circular(AppRadius.md),
      ),
      child: Icon(icon, color: accent, size: iconSize),
    );
  }
}

/// A small circular icon button on a white pill with a soft shadow — used for
/// back / bell / overflow controls in sub-page headers.
class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double size;

  const CircleIconButton(this.icon, {super.key, this.onTap, this.size = 42});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: context.cardColor,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: size,
          width: size,
          child: Icon(icon, size: 20, color: cs.onSurface),
        ),
      ),
    );
  }
}
