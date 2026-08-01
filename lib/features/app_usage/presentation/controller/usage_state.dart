import '../../domain/entities/app_usage_entity.dart';

class UsageState {
  const UsageState({required this.today, required this.yesterday});

  final List<AppUsageEntity> today;
  final List<AppUsageEntity> yesterday;

  Duration get todayTotal => today.fold(Duration.zero, (sum, app) => sum + app.usage);
  Duration get yesterdayTotal => yesterday.fold(Duration.zero, (sum, app) => sum + app.usage);
}
