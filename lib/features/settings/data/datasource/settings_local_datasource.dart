import 'package:applications_limitations/src/core/services/local_storage.dart';
import '../models/app_settings_model.dart';

abstract interface class SettingsLocalDataSource {
  AppSettingsModel getSettings();
  Future<void> setLanguage(String languageCode);
  Future<void> setThemeMode(String themeMode);
  Future<void> setProtectionEnabled(bool enabled);
  Future<void> resetLimits();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  SettingsLocalDataSourceImpl(this._storage);
  final LocalStorage _storage;

  @override
  AppSettingsModel getSettings() => AppSettingsModel(
        languageCode: _storage.getString(LocalStorage.localeKey) ?? 'en',
        themeMode: _storage.getString(LocalStorage.themeModeKey) ?? 'system',
        protectionEnabled: _storage.getBool(LocalStorage.protectionEnabledKey, fallback: true),
      );

  @override
  Future<void> setLanguage(String languageCode) async {
    await _storage.setString(LocalStorage.localeKey, languageCode);
  }

  @override
  Future<void> setThemeMode(String themeMode) async {
    await _storage.setString(LocalStorage.themeModeKey, themeMode);
  }

  @override
  Future<void> setProtectionEnabled(bool enabled) async {
    await _storage.setBool(LocalStorage.protectionEnabledKey, enabled);
  }

  @override
  Future<void> resetLimits() async {
    await _storage.clearLimits();
  }
}
