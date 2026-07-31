import 'package:flutter/material.dart';

import '../../../../core/utils/duration_formatter.dart';

class LimitChoiceChip extends StatelessWidget {
  const LimitChoiceChip({super.key, required this.duration, required this.isSelected, required this.onSelected});

  final Duration duration;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(formatDurationCompact(duration)),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    );
  }
}
