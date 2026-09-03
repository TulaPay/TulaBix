import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';

/// Pill segmented control: neutral track, active segment is a white (card)
/// pill with a soft shadow, inactive segments are muted text.
class SegmentedControl extends StatelessWidget {
  final List<String> segments;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const SegmentedControl({
    super.key,
    required this.segments,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.trackColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: List.generate(segments.length, (i) {
          final selected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: selected ? context.cardColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: cs.shadow.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  segments[i],
                  textAlign: TextAlign.center,
                  style: AppText.pillLabel(
                    color: selected ? cs.onSurface : cs.onSurfaceVariant,
                  ).copyWith(fontSize: 13),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
