import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/shared/widgets/app_scaffold.dart';
import '../../../../core/shared/widgets/async_state_view.dart';
import '../../../../core/utils/duration_formatter.dart';
import '../controller/installed_apps_controller.dart';
import '../controller/usage_controller.dart';
import '../widgets/app_icon_view.dart';

class InstalledAppsScreen extends ConsumerWidget {
  const InstalledAppsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(installedAppsControllerProvider);
    final usageState = ref.watch(usageControllerProvider).valueOrNull;
    final usageByPackage = {for (final app in usageState?.today ?? const []) app.packageName: app};
    return AppScaffold(
      title: 'apps_title'.tr(),
      actions: [IconButton(onPressed: () => ref.read(installedAppsControllerProvider.notifier).refresh(), icon: const Icon(Icons.refresh_rounded))],
      body: AsyncStateView(
        value: state,
        onRetry: () => ref.read(installedAppsControllerProvider.notifier).refresh(),
        data: (data) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: TextField(
                onChanged: ref.read(installedAppsControllerProvider.notifier).search,
                decoration: InputDecoration(prefixIcon: const Icon(Icons.search_rounded), hintText: 'apps_search'.tr()),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: data.filteredApps.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final app = data.filteredApps[index];
                  final usage = usageByPackage[app.packageName];
                  final subtitleParts = [
                    'usage_spent_value'.tr(args: [formatDurationCompact(usage?.usage ?? Duration.zero)]),
                    if (usage?.limit != null) 'usage_limit_value'.tr(args: [formatDurationCompact(usage!.limit!)]),
                    if (usage?.remaining != null) 'usage_remaining_value'.tr(args: [formatDurationCompact(usage!.remaining!)]),
                  ];
                  return ListTile(
                    leading: AppIconView(iconBytes: app.iconBytes, fallbackText: app.name),
                    title: Text(app.name),
                    subtitle: Text(subtitleParts.join(' • ')),
                    trailing: usage?.isBlocked == true
                        ? Icon(Icons.lock_rounded, color: Theme.of(context).colorScheme.error)
                        : usage?.isLimited == true
                            ? Icon(Icons.timer_rounded, color: Theme.of(context).colorScheme.primary)
                            : const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/apps/${Uri.encodeComponent(app.packageName)}', extra: app.name),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
