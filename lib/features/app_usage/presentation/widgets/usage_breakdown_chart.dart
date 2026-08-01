import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:applications_limitations/src/core/shared/widgets/section_card.dart';
import 'package:applications_limitations/src/core/utils/duration_formatter.dart';
import '../../domain/entities/app_usage_entity.dart';
import 'app_icon_view.dart';

/// A proportional chart of the five most-used applications today.
class UsageBreakdownChart extends StatelessWidget {
  const UsageBreakdownChart({
    super.key,
    required this.apps,
  });

  final List<AppUsageEntity> apps;

  @override
  Widget build(BuildContext context) {
    final topApps = [...apps]
      ..sort((first, second) => second.usage.compareTo(first.usage));
    final visibleApps = topApps.take(5).toList(growable: false);
    final maxUsage = visibleApps.isEmpty
        ? Duration.zero
        : visibleApps.first.usage;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'usage_breakdown_chart'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'usage_breakdown_chart_desc'.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          if (visibleApps.isEmpty)
            Text('usage_chart_empty'.tr())
          else
            ...visibleApps.map(
              (app) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _UsageBar(
                  app: app,
                  ratio: maxUsage == Duration.zero
                      ? 0
                      : app.usage.inMilliseconds / maxUsage.inMilliseconds,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _UsageBar extends StatelessWidget {
  const _UsageBar({
    required this.app,
    required this.ratio,
  });

  final AppUsageEntity app;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${app.name}: ${formatDurationCompact(app.usage)}',
      child: ExcludeSemantics(
        child: Row(
          children: [
            AppIconView(iconBytes: app.iconBytes, fallbackText: app.name),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          app.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        formatDurationCompact(app.usage),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: ratio.clamp(0, 1).toDouble(),
                      minHeight: 9,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
