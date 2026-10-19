import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';

/// Small tinted status pill.
class StatusBadge extends StatelessWidget {
  final String text;
  final Color? color;

  const StatusBadge(this.text, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.14),
        borderRadius: AppRadius.pillAll,
      ),
      child: Text(
        text,
        style: AppText.caption(
          color: c,
        ).copyWith(fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// Corporate Redesign list row: leading icon chip → title + subtitle → trailing value.
/// Defaults to flat inline row with a bottom hairline divider (`floating = false`), matching
/// the Corporate HTML specification.
class ListRowCard extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final Widget? leading;
  final String title;
  final String? subtitle;
  final String? value;
  final String? secondaryValue;
  final Widget? trailing;
  final bool showChevron;
  final VoidCallback? onTap;
  final bool floating;

  const ListRowCard({
    super.key,
    this.icon,
    this.iconColor,
    this.leading,
    required this.title,
    this.subtitle,
    this.value,
    this.secondaryValue,
    this.trailing,
    this.showChevron = false,
    this.onTap,
    this.floating = false,
  });

  /// Returns the correct color for a value string:
  /// '+…' → positive green, '-…' → negative red, else → onSurface.
  Color _valueColor(String? value, ColorScheme cs) {
    if (value == null) return cs.onSurface;
    if (value.startsWith('+')) return AppColors.positive;
    if (value.startsWith('-')) return AppColors.negative;
    return cs.onSurface;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget? trailingWidget = trailing;
    trailingWidget ??= value != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value!,
                style: AppText.cardTitle(
                  color: _valueColor(value, cs),
                  size: 14,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
              if (secondaryValue != null) ...[
                const SizedBox(height: 2),
                Text(
                  secondaryValue!,
                  style: AppText.caption(
                    color: cs.onSurfaceVariant,
                  ).copyWith(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ],
            ],
          )
        : showChevron
        ? Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: context.textTertiary,
          )
        : null;

    final leadingWidget =
        leading ??
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: context.primaryTintColor,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(
            icon ?? Icons.circle,
            color: iconColor ?? cs.primary,
            size: 18,
          ),
        );

    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          leadingWidget,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppText.cardTitle(
                    color: cs.onSurface,
                    size: 14,
                  ).copyWith(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: AppText.caption(
                      color: cs.onSurfaceVariant,
                    ).copyWith(fontSize: 12, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (trailingWidget != null) ...[
            const SizedBox(width: 12),
            trailingWidget,
          ],
        ],
      ),
    );

    if (!floating) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: context.hairlineColor, width: 1),
              ),
            ),
            child: content,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.hairlineColor, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: content,
          ),
        ),
      ),
    );
  }
}
