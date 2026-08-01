import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:applications_limitations/src/core/routing/app_routes.dart';
import 'package:applications_limitations/src/core/shared/widgets/app_scaffold.dart';
import 'package:applications_limitations/src/core/shared/widgets/async_state_view.dart';
import 'package:applications_limitations/src/core/shared/widgets/section_card.dart';
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
      title: 'app_name'.tr(),
      showBackButton: false,
      actions: [
        IconButton(
          tooltip: 'common_refresh'.tr(),
          onPressed: () => ref.read(dashboardControllerProvider.notifier).refresh(),
          icon: const Icon(Icons.refresh_rounded),
        ),
        IconButton(
          tooltip: 'settings_title'.tr(),
          onPressed: () async {
            if (await ParentUnlockDialog.show(context) && context.mounted) {
              context.push(AppRoutes.settings);
            }
          },
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
      body: AsyncStateView(
        value: state,
        onRetry: () => ref.read(dashboardControllerProvider.notifier).refresh(),
        data: (data) => RefreshIndicator(
          onRefresh: () => ref.read(dashboardControllerProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              const _DashboardGreeting(),
              const SizedBox(height: 20),
              UsageSummaryCard(snapshot: data.snapshot),
              const SizedBox(height: 28),
              _SectionHeading(title: 'dashboard_quick_actions'.tr()),
              const SizedBox(height: 12),
              QuickActionGrid(
                actions: [
                  QuickAction(
                    title: 'dashboard_manage_apps'.tr(),
                    icon: Icons.apps_rounded,
                    onTap: () => context.push(AppRoutes.apps),
                  ),
                  QuickAction(
                    title: 'dashboard_phone_limit'.tr(),
                    icon: Icons.phone_android_rounded,
                    onTap: () => context.push(AppRoutes.phoneLimit),
                  ),
                  QuickAction(
                    title: 'dashboard_usage'.tr(),
                    icon: Icons.bar_chart_rounded,
                    onTap: () => context.push(AppRoutes.usage),
                  ),
                  QuickAction(
                    title: 'dashboard_permissions'.tr(),
                    icon: Icons.verified_user_rounded,
                    onTap: () => context.push(AppRoutes.permissions),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              _SectionHeading(title: 'dashboard_recent_blocked'.tr()),
              const SizedBox(height: 12),
              SectionCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: data.snapshot.recentBlockedApps.isEmpty
                    ? const _EmptyList(
                        icon: Icons.verified_user_outlined,
                        messageKey: 'dashboard_no_blocked',
                      )
                    : Column(
                        children: data.snapshot.recentBlockedApps
                            .map((app) => UsageAppTile(app: app))
                            .toList(growable: false),
                      ),
              ),
              const SizedBox(height: 28),
              _SectionHeading(title: 'dashboard_most_used'.tr()),
              const SizedBox(height: 12),
              SectionCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: data.snapshot.mostUsedApps.isEmpty
                    ? const _EmptyList(
                        icon: Icons.hourglass_empty_rounded,
                        messageKey: 'dashboard_no_usage',
                      )
                    : Column(
                        children: data.snapshot.mostUsedApps
                            .map(
                              (app) => UsageAppTile(
                                app: app,
                                onTap: () => context.push(
                                  '/apps/${Uri.encodeComponent(app.packageName)}',
                                  extra: app.name,
                                ),
                              ),
                            )
                            .toList(growable: false),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardGreeting extends StatelessWidget {
  const _DashboardGreeting();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'dashboard_welcome'.tr(),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        Text(
          'dashboard_welcome_desc'.tr(),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList({required this.icon, required this.messageKey});

  final IconData icon;
  final String messageKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            messageKey.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
