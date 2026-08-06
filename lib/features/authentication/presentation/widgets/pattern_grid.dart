import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PatternGrid extends StatelessWidget {
  const PatternGrid({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = value
        .split('-')
        .where((item) => item.isNotEmpty)
        .map(int.tryParse)
        .whereType<int>()
        .toSet();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        SizedBox(
          width: 244,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              final id = index + 1;
              final isSelected = selected.contains(id);
              return Semantics(
                button: true,
                label: 'Pattern dot $id',
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () {
                      final parts = value.isEmpty
                          ? <String>[]
                          : value.split('-').where((item) => item.isNotEmpty).toList();
                      final stringId = '$id';
                      if (parts.contains(stringId)) {
                        onChanged('');
                        return;
                      }
                      parts.add(stringId);
                      onChanged(parts.join('-'));
                    },
                    customBorder: const CircleBorder(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.surfaceContainerHighest,
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.outlineVariant,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? Icon(Icons.check_rounded, color: colorScheme.onPrimary)
                          : null,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 4),
        TextButton.icon(
          onPressed: value.isEmpty ? null : () => onChanged(''),
          icon: const Icon(Icons.restart_alt_rounded),
          label: Text('common_reset'.tr()),
        ),
      ],
    );
  }
}
