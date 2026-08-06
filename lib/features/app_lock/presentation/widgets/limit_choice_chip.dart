import 'package:flutter/material.dart';

import 'package:applications_limitations/src/core/utils/duration_formatter.dart';

class LimitChoiceChip extends StatelessWidget {
  const LimitChoiceChip({
    super.key,
    required this.duration,
    required this.isSelected,
    required this.onSelected,
  });

  final Duration duration;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: isSelected
          ? colorScheme.primary
          : colorScheme.surfaceContainerHighest.withValues(alpha: 0.56),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onSelected,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
            ),
          ),
          child: Text(
            formatDurationCompact(duration),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                ),
          ),
        ),
      ),
    );
  }
}
