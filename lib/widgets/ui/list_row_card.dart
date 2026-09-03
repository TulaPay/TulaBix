import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:tulapay/widgets/ui/icon_chip.dart';

/// Small tinted status pill (e.g. "Verified", "Goal: 104%").
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
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        text,
        style: AppText.caption(color: c)
            .copyWith(fontSize: 10, fontWeight: FontWeight.w800),
      ),
    );
  }
}

/// The reference list row: leading icon chip (or custom [leading]) → title +
/// subtitle → trailing value/secondary or a [trailing] widget / chevron.
///
/// [floating] true renders it as its own white card (Wallet-style); false
/// renders a bare row for grouping inside one card with hairline dividers.
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
    this.floating = true,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget? trailingWidget = trailing;
    trailingWidget ??= value != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value!, style: AppText.cardTitle(color: cs.onSurface)),
              if (secondaryValue != null) ...[
                const SizedBox(height: 2),
                Text(secondaryValue!,
                    style: AppText.caption(color: cs.onSurfaceVariant)),
              ],
            ],
          )
        : showChevron
            ? Icon(Icons.chevron_right_rounded,
                size: 20, color: cs.onSurfaceVariant.withValues(alpha: 0.5))
            : null;

    final row = Padding(
      padding: EdgeInsets.all(floating ? AppSpacing.lg : AppSpacing.md),
      child: Row(
        children: [
          leading ??
              IconChip(icon ?? Icons.circle,
                  color: iconColor ?? cs.primary, size: 44),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: AppText.cardTitle(color: cs.onSurface),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!,
                      style: AppText.caption(color: cs.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
          ),
          if (trailingWidget != null) ...[
            const SizedBox(width: AppSpacing.md),
            trailingWidget,
          ],
        ],
      ),
    );

    if (!floating) {
      return Material(
        color: Colors.transparent,
        child: InkWell(onTap: onTap, child: row),
      );
    }

    return Material(
      color: context.cardColor,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: context.hairlineColor),
          ),
          child: row,
        ),
      ),
    );
  }
}
