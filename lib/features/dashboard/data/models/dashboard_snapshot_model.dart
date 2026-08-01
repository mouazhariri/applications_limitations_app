import '../../domain/entities/dashboard_snapshot_entity.dart';
import '../../../app_usage/domain/entities/app_usage_entity.dart';

class DashboardSnapshotModel extends DashboardSnapshotEntity {
  const DashboardSnapshotModel({required super.todayUsage, required super.phoneLimit, required super.mostUsedApps, required super.recentBlockedApps});

  factory DashboardSnapshotModel.fromData({required List<AppUsageEntity> todayApps, required Duration phoneLimit}) {
    final total = todayApps.fold(Duration.zero, (sum, app) => sum + app.usage);
    final mostUsed = [...todayApps]..sort((a, b) => b.usage.compareTo(a.usage));
    final blocked = todayApps.where((app) => app.isBlocked).toList();
    return DashboardSnapshotModel(todayUsage: total, phoneLimit: phoneLimit, mostUsedApps: mostUsed.take(5).toList(), recentBlockedApps: blocked.take(5).toList());
  }
}
