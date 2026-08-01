import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/shared/widgets/section_card.dart';
import '../../domain/entities/permission_status_entity.dart';

class PermissionTile extends StatelessWidget {
  const PermissionTile({super.key, required this.permission, required this.onOpen});

  final PermissionStatusEntity permission;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final grantedColor = permission.isGranted ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.error;
    return SectionCard(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: grantedColor.withValues(alpha: 0.12),
            child: Icon(permission.isGranted ? Icons.check_rounded : Icons.priority_high_rounded, color: grantedColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(permission.titleKey.tr(), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(permission.descriptionKey.tr(), style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          TextButton(onPressed: permission.isGranted ? null : onOpen, child: Text((permission.isGranted ? 'permission_granted' : 'permission_enable').tr())),
        ],
      ),
    );
  }
}
