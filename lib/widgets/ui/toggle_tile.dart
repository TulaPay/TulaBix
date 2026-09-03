import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';

/// Reference switch row: label + description on the left, an iOS-style switch
/// on the right (accent when on). Meant to be grouped inside one card,
/// separated by hairline dividers.
class ToggleTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showStateLabel;

  const ToggleTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.showStateLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.cardTitle(color: cs.onSurface)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!,
                      style: AppText.caption(color: cs.onSurfaceVariant)),
                ],
              ],
            ),
          ),
          if (showStateLabel) ...[
            Text(
              value ? 'ON' : 'OFF',
              style: AppText.pillLabel(
                color: value ? cs.primary : cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Switch.adaptive(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
