import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:applications_limitations/src/core/routing/app_routes.dart';
import 'package:applications_limitations/src/core/shared/widgets/app_scaffold.dart';
import 'package:applications_limitations/src/core/shared/widgets/async_state_view.dart';
import 'package:applications_limitations/src/core/shared/widgets/section_card.dart';
import '../../../authentication/presentation/widgets/parent_unlock_dialog.dart';
import '../controller/settings_controller.dart';
import '../controller/settings_state.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(settingsControllerProvider.notifier).refreshUninstallProtection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingsControllerProvider);
    return AppScaffold(
      title: 'settings_title'.tr(),
      body: AsyncStateView(
        value: state,
        data: (data) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ListTile(
              leading: const Icon(Icons.language_rounded),
              title: Text('settings_language'.tr()),
              subtitle: Text(
                (data.settings.languageCode == 'ar'
                        ? 'settings_language_ar'
                        : 'settings_language_en')
                    .tr(),
              ),
              trailing: DropdownButton<String>(
                value: data.settings.languageCode,
                items: [
                  DropdownMenuItem(
                    value: 'en',
                    child: Text('settings_language_en'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'ar',
                    child: Text('settings_language_ar'.tr()),
                  ),
                ],
                onChanged: (value) async {
                  if (value == null) return;
                  await ref.read(settingsControllerProvider.notifier).setLanguage(value);
                  if (context.mounted) await context.setLocale(Locale(value));
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6_rounded),
              title: Text('settings_theme'.tr()),
              trailing: DropdownButton<String>(
                value: data.settings.themeMode,
                items: [
                  DropdownMenuItem(
                    value: 'system',
                    child: Text('settings_theme_system'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'light',
                    child: Text('settings_theme_light'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'dark',
                    child: Text('settings_theme_dark'.tr()),
                  ),
                ],
                onChanged: (value) async {
                  if (value != null) {
                    await ref.read(settingsControllerProvider.notifier).setTheme(value);
                  }
                },
              ),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.shield_rounded),
              title: Text('settings_protection'.tr()),
              value: data.settings.protectionEnabled,
              onChanged: (enabled) async {
                if (!await ParentUnlockDialog.show(context)) return;
                await ref
                    .read(settingsControllerProvider.notifier)
                    .setProtection(enabled);
              },
            ),
            const SizedBox(height: 12),
            _UninstallProtectionCard(data: data),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.pin_rounded),
              title: Text('settings_change_pin'.tr()),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () async {
                if (await ParentUnlockDialog.show(context) && context.mounted) {
                  context.push(AppRoutes.security);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer_rounded),
              title: Text('settings_phone_limit'.tr()),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push(AppRoutes.phoneLimit),
            ),
            ListTile(
              leading: const Icon(Icons.security_rounded),
              title: Text('settings_permissions'.tr()),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push(AppRoutes.permissions),
            ),
            ListTile(
              leading: Icon(
                Icons.restart_alt_rounded,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text('settings_reset_limits'.tr()),
              onTap: () async {
                if (!await ParentUnlockDialog.show(context)) return;
                await ref.read(settingsControllerProvider.notifier).resetLimits();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: Text('settings_about'.tr()),
              subtitle: Text('settings_about_desc'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

class _UninstallProtectionCard extends ConsumerWidget {
  const _UninstallProtectionCard({required this.data});

  final SettingsState data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = data.uninstallProtection;
    final controller = ref.read(settingsControllerProvider.notifier);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.admin_panel_settings_rounded),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'settings_uninstall_protection'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: 'common_refresh'.tr(),
                onPressed: controller.refreshUninstallProtection,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            status.canBlockUninstall
                ? 'settings_uninstall_managed_desc'.tr()
                : 'settings_uninstall_standard_desc'.tr(),
          ),
          const SizedBox(height: 12),
          if (status.canBlockUninstall)
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text('settings_uninstall_block_switch'.tr()),
              subtitle: Text(
                status.isUninstallBlocked
                    ? 'settings_uninstall_blocked'.tr()
                    : 'settings_uninstall_not_blocked'.tr(),
              ),
              value: status.isUninstallBlocked,
              onChanged: data.isSaving
                  ? null
                  : (enabled) async {
                      if (!await ParentUnlockDialog.show(context)) return;
                      await controller.setUninstallProtection(enabled);
                    },
            )
          else ...[
            Text(
              status.isDeviceAdminActive
                  ? 'settings_device_admin_active'.tr()
                  : 'settings_device_admin_inactive'.tr(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: () async {
                if (!await ParentUnlockDialog.show(context)) return;
                await controller.requestDeviceAdmin();
              },
              icon: const Icon(Icons.verified_user_rounded),
              label: Text('settings_activate_device_admin'.tr()),
            ),
          ],
        ],
      ),
    );
  }
}
