import '../../../app_usage/domain/entities/app_usage_entity.dart';
import '../../../phone_lock/domain/repositories/phone_limit_repository.dart';
import '../../../app_usage/domain/repositories/app_usage_repository.dart';
import '../models/dashboard_snapshot_model.dart';

abstract interface class DashboardDataSource {
  Future<DashboardSnapshotModel> getSnapshot();
}

class DashboardDataSourceImpl implements DashboardDataSource {
  DashboardDataSourceImpl(this._usageRepository, this._phoneLimitRepository);

  final AppUsageRepository _usageRepository;
  final PhoneLimitRepository _phoneLimitRepository;

  @override
  Future<DashboardSnapshotModel> getSnapshot() async {
    final usageResult = await _usageRepository.getUsageStats(dayOffset: 0);
    final limitResult = _phoneLimitRepository.getLimit();
    final List<AppUsageEntity> apps = usageResult.fold((failure) => throw failure, (value) => value);
    final phoneLimit = limitResult.fold((failure) => throw failure, (value) => value);
    return DashboardSnapshotModel.fromData(todayApps: apps, phoneLimit: phoneLimit);
  }
}
