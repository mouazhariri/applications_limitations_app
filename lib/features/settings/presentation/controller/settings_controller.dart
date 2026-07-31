import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/service_locator.dart';
import '../../domain/entities/app_settings_entity.dart';
import 'settings_state.dart';

final settingsControllerProvider = AsyncNotifierProvider<SettingsController, SettingsState>(SettingsController.new);

class SettingsController extends AsyncNotifier<SettingsState> {
  @override
  Future<SettingsState> build() async {
    final result = ref.read(getSettingsUseCaseProvider)();
    return result.fold((failure) => throw failure, (settings) => SettingsState(settings: settings));
  }

  Future<void> setLanguage(String code) async {
    final data = state.valueOrNull;
    if (data == null) return;
    await ref.read(setLanguageUseCaseProvider)(code);
    state = AsyncData(data.copyWith(settings: AppSettingsEntity(languageCode: code, themeMode: data.settings.themeMode, protectionEnabled: data.settings.protectionEnabled)));
  }

  Future<void> setTheme(String mode) async {
    final data = state.valueOrNull;
    if (data == null) return;
    await ref.read(setThemeModeUseCaseProvider)(mode);
    state = AsyncData(data.copyWith(settings: AppSettingsEntity(languageCode: data.settings.languageCode, themeMode: mode, protectionEnabled: data.settings.protectionEnabled)));
  }

  Future<void> setProtection(bool enabled) async {
    final data = state.valueOrNull;
    if (data == null) return;
    await ref.read(setProtectionEnabledUseCaseProvider)(enabled);
    if (enabled) {
      await ref.read(phoneLimiterChannelProvider).startProtectionService();
    } else {
      await ref.read(phoneLimiterChannelProvider).stopProtectionService();
    }
    state = AsyncData(data.copyWith(settings: AppSettingsEntity(languageCode: data.settings.languageCode, themeMode: data.settings.themeMode, protectionEnabled: enabled)));
  }

  Future<void> resetLimits() async {
    await ref.read(resetLimitsUseCaseProvider)();
  }
}
