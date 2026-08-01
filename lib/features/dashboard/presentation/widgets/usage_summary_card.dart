import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:applications_limitations/src/core/shared/widgets/section_card.dart';
import 'package:applications_limitations/src/core/utils/duration_formatter.dart';
import '../../domain/entities/dashboard_snapshot_entity.dart';

class UsageSummaryCard extends StatelessWidget {
  const UsageSummaryCard({super.key, required this.snapshot});

  final DashboardSnapshotEntity snapshot;

  @override
  Widget build(BuildContext context) {
    final progress = snapshot.phoneLimit.inMilliseconds == 0 ? 0.0 : (snapshot.todayUsage.inMilliseconds / snapshot.phoneLimit.inMilliseconds).clamp(0.0, 1.0);
    return SectionCard(
      padding: const EdgeInsets.all(22),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('dashboard_today_screen_time'.tr(), style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        Text(formatDurationCompact(snapshot.todayUsage), style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 16),
        ClipRRect(borderRadius: BorderRadius.circular(999), child: LinearProgressIndicator(value: progress, minHeight: 12)),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _Metric(title: 'dashboard_remaining'.tr(), value: formatDurationCompact(snapshot.remaining))),
          Expanded(child: _Metric(title: 'dashboard_daily_limit'.tr(), value: formatDurationCompact(snapshot.phoneLimit))),
        ]),
      ]),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.title, required this.value});
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: 4), Text(value, style: Theme.of(context).textTheme.titleLarge)]);
}
