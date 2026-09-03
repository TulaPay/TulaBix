import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';

enum _PillKind { dark, outlined, ghost, accent }

/// The reference button family:
/// * [PillButton.dark] — near-black (near-white in dark mode) toolbar action.
/// * [PillButton.outlined] — accent border + accent label, secondary action.
/// * [PillButton.ghost] — white/neutral pill, tertiary ("see all").
/// * [PillButton.accent] — solid brand-blue pill.
class PillButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final _PillKind _kind;
  final bool dense;

  const PillButton.dark(this.label,
      {super.key, this.icon, this.onTap, this.dense = false})
      : _kind = _PillKind.dark;

  const PillButton.outlined(this.label,
      {super.key, this.icon, this.onTap, this.dense = false})
      : _kind = _PillKind.outlined;

  const PillButton.ghost(this.label,
      {super.key, this.icon, this.onTap, this.dense = false})
      : _kind = _PillKind.ghost;

  const PillButton.accent(this.label,
      {super.key, this.icon, this.onTap, this.dense = false})
      : _kind = _PillKind.accent;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    late final Color bg;
    late final Color fg;
    BorderSide side = BorderSide.none;

    switch (_kind) {
      case _PillKind.dark:
        bg = context.inkPillColor;
        fg = context.onInkPillColor;
        break;
      case _PillKind.outlined:
        bg = Colors.transparent;
        fg = cs.primary;
        side = BorderSide(color: cs.primary, width: 1.5);
        break;
      case _PillKind.ghost:
        bg = context.cardColor;
        fg = cs.onSurface;
        side = BorderSide(color: context.hairlineColor);
        break;
      case _PillKind.accent:
        bg = cs.primary;
        fg = cs.onPrimary;
        break;
    }

    final pad = dense
        ? const EdgeInsets.symmetric(horizontal: 14, vertical: 8)
        : const EdgeInsets.symmetric(horizontal: 18, vertical: 11);

    return Material(
      color: bg,
      shape: StadiumBorder(side: side),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: pad,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: dense ? 15 : 17, color: fg),
                const SizedBox(width: 6),
              ],
              Text(label, style: AppText.pillLabel(color: fg)),
            ],
          ),
        ),
      ),
    );
  }
}
