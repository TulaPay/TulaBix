import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/ui/icon_chip.dart';

/// Standard "list of info rows + primary action" page. API unchanged; visuals
/// now follow the reference language — a big left-aligned title, a caption, and
/// a stack of hairline-bordered rows.
class GlassPageShell extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> children;
  final String? actionLabel;
  final VoidCallback? onAction;

  const GlassPageShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.children,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(title)),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.sm,
                AppSpacing.xl,
                AppSpacing.xl,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconChip(icon, color: cs.primary, size: 52, iconSize: 24),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppText.screenTitle(size: 24)),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: AppText.body(color: cs.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ...children,
                const SizedBox(height: AppSpacing.xxl),
                if (actionLabel != null)
                  FilledButton(onPressed: onAction, child: Text(actionLabel!)),
                const SizedBox(height: AppSpacing.xxl),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

/// Icon-chip + title + subtitle row used inside [GlassPageShell].
class GlassInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? accent;
  final VoidCallback? onTap;

  const GlassInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.accent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = accent ?? cs.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: GlassSurface(
        padding: EdgeInsets.zero,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  IconChip(icon, color: color, size: 46, iconSize: 22),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppText.cardTitle(color: cs.onSurface)),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          style: AppText.caption(color: cs.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  if (onTap != null)
                    Icon(Icons.chevron_right_rounded,
                        size: 20,
                        color: cs.onSurfaceVariant.withValues(alpha: 0.5)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
