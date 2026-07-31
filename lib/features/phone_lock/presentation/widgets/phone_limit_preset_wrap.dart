import 'package:flutter/material.dart';

import '../../../app_lock/presentation/widgets/limit_choice_chip.dart';

class PhoneLimitPresetWrap extends StatelessWidget {
  const PhoneLimitPresetWrap({super.key, required this.presets, required this.selectedLimit, required this.onSelected});

  final List<Duration> presets;
  final Duration selectedLimit;
  final ValueChanged<Duration> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: presets
          .map((duration) => LimitChoiceChip(
                duration: duration,
                isSelected: duration == selectedLimit,
                onSelected: () => onSelected(duration),
              ))
          .toList(),
    );
  }
}
