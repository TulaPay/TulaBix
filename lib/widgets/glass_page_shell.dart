import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';

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

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(title)),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xxl,
                AppSpacing.xs,
                AppSpacing.xxl,
                AppSpacing.xl,
              ),
              child: Text(
                subtitle,
                style: AppText.body(color: context.textSecondary),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
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

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.hairlineColor)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: context.isDark
                      ? AppColors.trackDark
                      : AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppText.cardTitle(color: cs.onSurface)),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppText.caption(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: context.textTertiary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
