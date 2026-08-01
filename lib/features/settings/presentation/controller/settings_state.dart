import '../../domain/entities/app_settings_entity.dart';

class SettingsState {
  const SettingsState({required this.settings, this.isSaving = false});

  final AppSettingsEntity settings;
  final bool isSaving;

  SettingsState copyWith({AppSettingsEntity? settings, bool? isSaving}) => SettingsState(settings: settings ?? this.settings, isSaving: isSaving ?? this.isSaving);
}
