import '../../domain/entities/app_usage_entity.dart';

/// A single day in the usage-history chart. Day offset zero is today.
class UsageDaySummary {
  const UsageDaySummary({
    required this.dayOffset,
    required this.total,
  });

  final int dayOffset;
  final Duration total;
}

class UsageState {
  const UsageState({
    required this.today,
    required this.yesterday,
    required this.week,
  });

  final List<AppUsageEntity> today;
  final List<AppUsageEntity> yesterday;
  final List<UsageDaySummary> week;

  Duration get todayTotal =>
      today.fold(Duration.zero, (sum, app) => sum + app.usage);

  Duration get yesterdayTotal =>
      yesterday.fold(Duration.zero, (sum, app) => sum + app.usage);
}
