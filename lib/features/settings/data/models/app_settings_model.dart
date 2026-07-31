import '../../domain/entities/app_settings_entity.dart';

class AppSettingsModel extends AppSettingsEntity {
  const AppSettingsModel({required super.languageCode, required super.themeMode, required super.protectionEnabled});
}
