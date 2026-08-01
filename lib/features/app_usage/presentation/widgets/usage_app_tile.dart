import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:applications_limitations/src/core/utils/duration_formatter.dart';
import '../../domain/entities/app_usage_entity.dart';
import 'app_icon_view.dart';

class UsageAppTile extends StatelessWidget {
  const UsageAppTile({super.key, required this.app, this.onTap});

  final AppUsageEntity app;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final remaining = app.remaining;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      leading: AppIconView(iconBytes: app.iconBytes, fallbackText: app.name),
      title: Text(app.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text([
        'usage_spent_value'.tr(args: [formatDurationCompact(app.usage)]),
        if (app.limit != null) 'usage_limit_value'.tr(args: [formatDurationCompact(app.limit!)]),
        if (remaining != null) 'usage_remaining_value'.tr(args: [formatDurationCompact(remaining)]),
      ].join(' • ')),
      trailing: app.isBlocked
          ? Icon(Icons.lock_rounded, color: Theme.of(context).colorScheme.error)
          : app.isLimited
              ? Icon(Icons.timer_rounded, color: Theme.of(context).colorScheme.primary)
              : null,
    );
  }
}
