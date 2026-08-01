import '../../../app_usage/domain/entities/app_usage_entity.dart';

class DashboardSnapshotEntity {
  const DashboardSnapshotEntity({required this.todayUsage, required this.phoneLimit, required this.mostUsedApps, required this.recentBlockedApps});

  final Duration todayUsage;
  final Duration phoneLimit;
  final List<AppUsageEntity> mostUsedApps;
  final List<AppUsageEntity> recentBlockedApps;

  Duration get remaining {
    final remainingMs = (phoneLimit.inMilliseconds - todayUsage.inMilliseconds).clamp(0, phoneLimit.inMilliseconds).toInt();
    return Duration(milliseconds: remainingMs);
  }
  bool get isPhoneLocked => todayUsage >= phoneLimit;
}
