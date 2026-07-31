import 'package:flutter/material.dart';

class PatternGrid extends StatelessWidget {
  const PatternGrid({super.key, required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = value.split('-').where((item) => item.isNotEmpty).toSet();
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 14, crossAxisSpacing: 14),
          itemCount: 9,
          itemBuilder: (context, index) {
            final id = '${index + 1}';
            final isSelected = selected.contains(id);
            return InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () {
                final parts = value.isEmpty ? <String>[] : value.split('-');
                if (!parts.contains(id)) parts.add(id);
                onChanged(parts.join('-'));
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: Center(child: Text(id, style: TextStyle(color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant))),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        TextButton.icon(onPressed: () => onChanged(''), icon: const Icon(Icons.backspace_outlined), label: const Text('⌫')),
      ],
    );
  }
}
