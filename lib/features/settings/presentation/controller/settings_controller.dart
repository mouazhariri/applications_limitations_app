import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:applications_limitations/src/core/di/service_locator.dart';
import '../../domain/entities/app_settings_entity.dart';
import 'settings_state.dart';

part 'settings_controller.g.dart';

@riverpod
class SettingsController extends _$SettingsController {
  @override
  Future<SettingsState> build() async {
    final result = ref.read(getSettingsUseCaseProvider)();
    final settings = result.fold((failure) => throw failure, (value) => value);
    final uninstallProtection = await ref
        .read(phoneLimiterChannelProvider)
        .getUninstallProtectionStatus();
    return SettingsState(
      settings: settings,
      uninstallProtection: uninstallProtection,
    );
  }

  Future<void> setLanguage(String code) async {
    final data = state.value;
    if (data == null) return;
    await ref.read(setLanguageUseCaseProvider)(code);
    state = AsyncData(
      data.copyWith(
        settings: AppSettingsEntity(
          languageCode: code,
          themeMode: data.settings.themeMode,
          protectionEnabled: data.settings.protectionEnabled,
        ),
      ),
    );
  }

  Future<void> setTheme(String mode) async {
    final data = state.value;
    if (data == null) return;
    await ref.read(setThemeModeUseCaseProvider)(mode);
    state = AsyncData(
      data.copyWith(
        settings: AppSettingsEntity(
          languageCode: data.settings.languageCode,
          themeMode: mode,
          protectionEnabled: data.settings.protectionEnabled,
        ),
      ),
    );
  }

  Future<void> setProtection(bool enabled) async {
    final data = state.value;
    if (data == null) return;
    await ref.read(setProtectionEnabledUseCaseProvider)(enabled);
    if (enabled) {
      await ref.read(phoneLimiterChannelProvider).startProtectionService();
    } else {
      await ref.read(phoneLimiterChannelProvider).stopProtectionService();
    }
    state = AsyncData(
      data.copyWith(
        settings: AppSettingsEntity(
          languageCode: data.settings.languageCode,
          themeMode: data.settings.themeMode,
          protectionEnabled: enabled,
        ),
      ),
    );
  }

  Future<void> requestDeviceAdmin() async {
    await ref.read(phoneLimiterChannelProvider).requestDeviceAdmin();
  }

  Future<void> refreshUninstallProtection() async {
    final data = state.value;
    if (data == null) return;
    final status = await ref
        .read(phoneLimiterChannelProvider)
        .getUninstallProtectionStatus();
    state = AsyncData(data.copyWith(uninstallProtection: status));
  }

  Future<void> setUninstallProtection(bool enabled) async {
    final data = state.value;
    if (data == null) return;
    state = AsyncData(data.copyWith(isSaving: true));
    final status = await ref
        .read(phoneLimiterChannelProvider)
        .setUninstallProtection(enabled);
    state = AsyncData(
      data.copyWith(uninstallProtection: status, isSaving: false),
    );
  }

  Future<void> resetLimits() async {
    await ref.read(resetLimitsUseCaseProvider)();
  }
}
