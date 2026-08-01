import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/shared/widgets/app_scaffold.dart';
import '../../../../core/shared/widgets/async_state_view.dart';
import '../../../authentication/presentation/widgets/parent_unlock_dialog.dart';
import '../controller/settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              subtitle: Text((data.settings.languageCode == 'ar' ? 'settings_language_ar' : 'settings_language_en').tr()),
              trailing: DropdownButton<String>(
                value: data.settings.languageCode,
                items: [DropdownMenuItem(value: 'en', child: Text('settings_language_en'.tr())), DropdownMenuItem(value: 'ar', child: Text('settings_language_ar'.tr()))],
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
                  DropdownMenuItem(value: 'system', child: Text('settings_theme_system'.tr())),
                  DropdownMenuItem(value: 'light', child: Text('settings_theme_light'.tr())),
                  DropdownMenuItem(value: 'dark', child: Text('settings_theme_dark'.tr())),
                ],
                onChanged: (value) async { if (value != null) await ref.read(settingsControllerProvider.notifier).setTheme(value); },
              ),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.shield_rounded),
              title: Text('settings_protection'.tr()),
              value: data.settings.protectionEnabled,
              onChanged: (enabled) async {
                if (!await ParentUnlockDialog.show(context)) return;
                await ref.read(settingsControllerProvider.notifier).setProtection(enabled);
              },
            ),
            ListTile(leading: const Icon(Icons.pin_rounded), title: Text('settings_change_pin'.tr()), trailing: const Icon(Icons.chevron_right_rounded), onTap: () async { if (await ParentUnlockDialog.show(context) && context.mounted) context.push(AppRoutes.security); }),
            ListTile(leading: const Icon(Icons.timer_rounded), title: Text('settings_phone_limit'.tr()), trailing: const Icon(Icons.chevron_right_rounded), onTap: () => context.push(AppRoutes.phoneLimit)),
            ListTile(leading: const Icon(Icons.security_rounded), title: Text('settings_permissions'.tr()), trailing: const Icon(Icons.chevron_right_rounded), onTap: () => context.push(AppRoutes.permissions)),
            ListTile(leading: Icon(Icons.restart_alt_rounded, color: Theme.of(context).colorScheme.error), title: Text('settings_reset_limits'.tr()), onTap: () async { if (!await ParentUnlockDialog.show(context)) return; await ref.read(settingsControllerProvider.notifier).resetLimits(); }),
            const Divider(),
            ListTile(leading: const Icon(Icons.info_outline_rounded), title: Text('settings_about'.tr()), subtitle: Text('settings_about_desc'.tr())),
          ],
        ),
      ),
    );
  }
}
