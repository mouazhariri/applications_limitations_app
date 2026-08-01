import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:applications_limitations/src/core/shared/widgets/app_scaffold.dart';
import 'package:applications_limitations/src/core/shared/widgets/async_state_view.dart';
import 'package:applications_limitations/src/core/shared/widgets/section_card.dart';
import 'package:applications_limitations/src/core/utils/duration_formatter.dart';
import '../controller/usage_controller.dart';
import '../widgets/usage_app_tile.dart';
import '../widgets/usage_breakdown_chart.dart';
import '../widgets/usage_week_chart.dart';

class UsageScreen extends ConsumerWidget {
  const UsageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(usageControllerProvider);
    return AppScaffold(
      title: 'usage_title'.tr(),
      actions: [
        IconButton(
          tooltip: 'common_refresh'.tr(),
          onPressed: () => ref.read(usageControllerProvider.notifier).refresh(),
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
      body: AsyncStateView(
        value: state,
        onRetry: () => ref.read(usageControllerProvider.notifier).refresh(),
        data: (data) => RefreshIndicator(
          onRefresh: () => ref.read(usageControllerProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  Expanded(
                    child: SectionCard(
                      child: _Metric(
                        title: 'usage_today'.tr(),
                        value: formatDurationCompact(data.todayTotal),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SectionCard(
                      child: _Metric(
                        title: 'usage_yesterday'.tr(),
                        value: formatDurationCompact(data.yesterdayTotal),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              UsageWeekChart(days: data.week),
              const SizedBox(height: 16),
              UsageBreakdownChart(apps: data.today),
              const SizedBox(height: 24),
              Text(
                'usage_all_apps'.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              if (data.today.isEmpty)
                Text('usage_chart_empty'.tr())
              else
                ...data.today.map((app) => UsageAppTile(app: app)),
              const SizedBox(height: 24),
              Text(
                'usage_yesterday'.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              if (data.yesterday.isEmpty)
                Text('usage_chart_empty'.tr())
              else
                ...data.yesterday.map((app) => UsageAppTile(app: app)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }
}
