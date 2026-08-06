import 'package:flutter/material.dart';

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({super.key, required this.actions});

  final List<QuickAction> actions;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.32,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) => _QuickActionCard(
        action: actions[index],
        color: _colors[index % _colors.length],
      ),
    );
  }
}

const _colors = [
  Color(0xFF2563EB),
  Color(0xFF0F9D8A),
  Color(0xFF7C3AED),
  Color(0xFFEA580C),
];

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.action, required this.color});

  final QuickAction action;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.65),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(action.icon, color: color),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      action.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Icon(Icons.arrow_forward_rounded, size: 18, color: color),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuickAction {
  const QuickAction({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
}
