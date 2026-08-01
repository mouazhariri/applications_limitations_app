import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shared/widgets/app_scaffold.dart';
import '../../../../core/shared/widgets/async_state_view.dart';
import '../../../../core/shared/widgets/section_card.dart';
import '../../../../core/utils/duration_formatter.dart';
import '../controller/usage_controller.dart';
import '../widgets/usage_app_tile.dart';

class UsageScreen extends ConsumerWidget {
  const UsageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(usageControllerProvider);
    return AppScaffold(
      title: 'usage_title'.tr(),
      actions: [IconButton(onPressed: () => ref.read(usageControllerProvider.notifier).refresh(), icon: const Icon(Icons.refresh_rounded))],
      body: AsyncStateView(
        value: state,
        onRetry: () => ref.read(usageControllerProvider.notifier).refresh(),
        data: (data) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Expanded(child: SectionCard(child: _Metric(title: 'usage_today'.tr(), value: formatDurationCompact(data.todayTotal)))),
                const SizedBox(width: 12),
                Expanded(child: SectionCard(child: _Metric(title: 'usage_yesterday'.tr(), value: formatDurationCompact(data.yesterdayTotal)))),
              ],
            ),
            const SizedBox(height: 24),
            Text('usage_all_apps'.tr(), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...data.today.map((app) => UsageAppTile(app: app)),
            const SizedBox(height: 24),
            Text('usage_yesterday'.tr(), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...data.yesterday.map((app) => UsageAppTile(app: app)),
          ],
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
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: 8), Text(value, style: Theme.of(context).textTheme.headlineMedium)]);
}
