import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';

/// ALL-CAPS micro-label section title with an optional trailing plain-text
/// action link ('See all') — replaces the per-screen `_SectionHeader` helpers.
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
              title.toUpperCase(),
              style: AppText.microLabel(
                color: context.textTertiary,
              ).copyWith(letterSpacing: 1.6),
            ),
          ),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: AppText.caption(
                  color: cs.secondary,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
            ),
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
        color: color ?? context.textTertiary,
      ).copyWith(letterSpacing: 1.6),
    );
  }
}
