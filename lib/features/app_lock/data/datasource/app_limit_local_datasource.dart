import 'package:applications_limitations/src/core/services/local_storage.dart';

abstract interface class AppLimitLocalDataSource {
  Map<String, Duration> getLimits();
  Duration? getLimit(String packageName);
  Future<void> setLimit(String packageName, Duration limit);
  Future<void> removeLimit(String packageName);
  Future<void> resetAll();
}

class AppLimitLocalDataSourceImpl implements AppLimitLocalDataSource {
  AppLimitLocalDataSourceImpl(this._storage);

  final LocalStorage _storage;

  @override
  Map<String, Duration> getLimits() => _storage.getStringIntMap(LocalStorage.appLimitsJsonKey).map((key, value) => MapEntry(key, Duration(milliseconds: value)));

  @override
  Duration? getLimit(String packageName) => getLimits()[packageName];

  @override
  Future<void> setLimit(String packageName, Duration limit) async {
    final limits = _storage.getStringIntMap(LocalStorage.appLimitsJsonKey);
    limits[packageName] = limit.inMilliseconds;
    await _storage.setStringIntMap(LocalStorage.appLimitsJsonKey, limits);
  }

  @override
  Future<void> removeLimit(String packageName) async {
    final limits = _storage.getStringIntMap(LocalStorage.appLimitsJsonKey)..remove(packageName);
    await _storage.setStringIntMap(LocalStorage.appLimitsJsonKey, limits);
  }

  @override
  Future<void> resetAll() async {
    await _storage.setStringIntMap(LocalStorage.appLimitsJsonKey, <String, int>{});
  }
}
