import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/shared/widgets/app_scaffold.dart';
import '../../../../core/shared/widgets/async_state_view.dart';
import '../../../app_usage/presentation/widgets/usage_app_tile.dart';
import '../../../authentication/presentation/widgets/parent_unlock_dialog.dart';
import '../controller/dashboard_controller.dart';
import '../widgets/quick_action_grid.dart';
import '../widgets/usage_summary_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardControllerProvider);
    return AppScaffold(
      title: 'dashboard_title'.tr(),
      showBackButton: false,
      actions: [
        IconButton(onPressed: () => ref.read(dashboardControllerProvider.notifier).refresh(), icon: const Icon(Icons.refresh_rounded)),
        IconButton(
          onPressed: () async {
            if (await ParentUnlockDialog.show(context) && context.mounted) context.push(AppRoutes.settings);
          },
          icon: const Icon(Icons.settings_rounded),
        ),
      ],
      body: AsyncStateView(
        value: state,
        onRetry: () => ref.read(dashboardControllerProvider.notifier).refresh(),
        data: (data) => RefreshIndicator(
          onRefresh: () => ref.read(dashboardControllerProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              UsageSummaryCard(snapshot: data.snapshot),
              const SizedBox(height: 20),
              Text('dashboard_quick_actions'.tr(), style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              QuickActionGrid(actions: [
                QuickAction(title: 'dashboard_manage_apps'.tr(), icon: Icons.apps_rounded, onTap: () => context.push(AppRoutes.apps)),
                QuickAction(title: 'dashboard_phone_limit'.tr(), icon: Icons.phone_android_rounded, onTap: () => context.push(AppRoutes.phoneLimit)),
                QuickAction(title: 'dashboard_usage'.tr(), icon: Icons.history_rounded, onTap: () => context.push(AppRoutes.usage)),
                QuickAction(title: 'dashboard_permissions'.tr(), icon: Icons.security_rounded, onTap: () => context.push(AppRoutes.permissions)),
              ]),
              const SizedBox(height: 24),
              Text('dashboard_recent_blocked'.tr(), style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              if (data.snapshot.recentBlockedApps.isEmpty) Text('dashboard_no_blocked'.tr()) else ...data.snapshot.recentBlockedApps.map((app) => UsageAppTile(app: app)),
              const SizedBox(height: 24),
              Text('dashboard_most_used'.tr(), style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ...data.snapshot.mostUsedApps.map((app) => UsageAppTile(app: app, onTap: () => context.push('/apps/${Uri.encodeComponent(app.packageName)}', extra: app.name))),
            ],
          ),
        ),
      ),
    );
  }
}
