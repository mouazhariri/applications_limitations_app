import 'package:applications_limitations/src/core/services/phone_limiter_channel.dart';

import '../../domain/entities/app_settings_entity.dart';

class SettingsState {
  const SettingsState({
    required this.settings,
    this.uninstallProtection = const UninstallProtectionStatus.unavailable(),
    this.isSaving = false,
  });

  final AppSettingsEntity settings;
  final UninstallProtectionStatus uninstallProtection;
  final bool isSaving;

  SettingsState copyWith({
    AppSettingsEntity? settings,
    UninstallProtectionStatus? uninstallProtection,
    bool? isSaving,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      uninstallProtection: uninstallProtection ?? this.uninstallProtection,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
