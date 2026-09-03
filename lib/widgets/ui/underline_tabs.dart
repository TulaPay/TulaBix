import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';

class UnderlineTabItem {
  final String label;
  final int? count;
  const UnderlineTabItem(this.label, {this.count});
}

/// Text tabs with a short accent underline under the active one, plus an
/// optional small superscript count dot (reference: Current/Past/Waitlist,
/// All/Messages/Review).
class UnderlineTabs extends StatelessWidget {
  final List<UnderlineTabItem> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final bool spaceEvenly;

  const UnderlineTabs({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    this.spaceEvenly = true,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final row = <Widget>[];

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final selected = i == selectedIndex;
      final tab = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(i),
        child: Padding(
          padding: EdgeInsets.only(
            right: spaceEvenly ? 0 : AppSpacing.xxl,
            top: AppSpacing.sm,
            bottom: AppSpacing.sm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: AppText.pillLabel(
                      color: selected ? cs.primary : cs.onSurfaceVariant,
                    ),
                  ),
                  if (item.count != null) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: selected
                            ? cs.primary
                            : cs.onSurfaceVariant.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      alignment: Alignment.center,
                      child: Text(
                        '${item.count}',
                        style: AppText.caption(color: Colors.white)
                            .copyWith(fontSize: 9, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 3,
                width: selected ? 22 : 0,
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        ),
      );
      row.add(spaceEvenly ? Expanded(child: tab) : tab);
    }

    return Row(
      mainAxisAlignment:
          spaceEvenly ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
      children: row,
    );
  }
}
