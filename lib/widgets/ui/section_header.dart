import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:tulapay/widgets/ui/pill_button.dart';

/// Bold section title with an optional trailing ghost-pill action —
/// replaces the per-screen `_SectionHeader` helpers.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry padding;

  const SectionHeader(
    this.title, {
    super.key,
    this.actionLabel,
    this.onAction,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              title,
              style: AppText.sectionTitle(color: cs.onSurface),
            ),
          ),
          if (actionLabel != null)
            PillButton.ghost(actionLabel!, dense: true, onTap: onAction),
        ],
      ),
    );
  }
}

/// Tiny uppercase tracked label used above values / above a group of cards.
class MicroLabel extends StatelessWidget {
  final String text;
  final Color? color;

  const MicroLabel(this.text, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppText.microLabel(
        color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
