import '../../../../core/services/local_storage.dart';
import '../../../../core/services/phone_limiter_channel.dart';
import '../models/app_usage_model.dart';
import '../models/installed_app_model.dart';

abstract interface class AppUsagePlatformDataSource {
  Future<List<InstalledAppModel>> getInstalledApps();
  Future<List<AppUsageModel>> getUsageStats({required int dayOffset});
}

class AppUsagePlatformDataSourceImpl implements AppUsagePlatformDataSource {
  AppUsagePlatformDataSourceImpl(this._channel, this._storage);

  final PhoneLimiterChannel _channel;
  final LocalStorage _storage;

  @override
  Future<List<InstalledAppModel>> getInstalledApps() async {
    final apps = await _channel.getInstalledApps();
    return apps.map(InstalledAppModel.fromMap).where((app) => app.packageName.isNotEmpty).toList();
  }

  @override
  Future<List<AppUsageModel>> getUsageStats({required int dayOffset}) async {
    final limits = _storage.getStringIntMap(LocalStorage.appLimitsJsonKey);
    final usage = await _channel.getUsageStats(dayOffset: dayOffset);
    final models = usage.map((map) {
      final packageName = (map['packageName'] ?? '').toString();
      final limitMs = limits[packageName];
      return AppUsageModel.fromMap(map, limit: limitMs == null ? null : Duration(milliseconds: limitMs));
    }).where((app) => app.packageName.isNotEmpty).toList();
    models.sort((a, b) => b.usage.compareTo(a.usage));
    return models;
  }
}
