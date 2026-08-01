import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage(this._preferences);

  final SharedPreferences _preferences;

  static const onboardingCompleteKey = 'onboarding_complete';
  static const securityPinHashKey = 'security_pin_hash';
  static const securityPinSaltKey = 'security_pin_salt';
  static const securityModeKey = 'security_mode';
  static const phoneLimitMsKey = 'phone_limit_ms';
  static const appLimitsJsonKey = 'app_limits_json';
  static const protectionEnabledKey = 'protection_enabled';
  static const themeModeKey = 'theme_mode';
  static const localeKey = 'locale';
  static const recentBlockedAppsJsonKey = 'recent_blocked_apps_json';

  bool getBool(String key, {bool fallback = false}) => _preferences.getBool(key) ?? fallback;
  Future<bool> setBool(String key, bool value) => _preferences.setBool(key, value);

  String? getString(String key) => _preferences.getString(key);
  Future<bool> setString(String key, String value) => _preferences.setString(key, value);

  int getInt(String key, {int fallback = 0}) => _preferences.getInt(key) ?? fallback;
  Future<bool> setInt(String key, int value) => _preferences.setInt(key, value);

  Map<String, int> getStringIntMap(String key) {
    final encoded = getString(key);
    if (encoded == null || encoded.isEmpty) return <String, int>{};
    final decoded = jsonDecode(encoded) as Map<String, dynamic>;
    return decoded.map((packageName, value) => MapEntry(packageName, (value as num).toInt()));
  }

  Future<bool> setStringIntMap(String key, Map<String, int> value) {
    return setString(key, jsonEncode(value));
  }

  Future<bool> remove(String key) => _preferences.remove(key);
  Future<bool> clearLimits() async {
    final app = await remove(appLimitsJsonKey);
    final phone = await remove(phoneLimitMsKey);
    return app && phone;
  }
}
