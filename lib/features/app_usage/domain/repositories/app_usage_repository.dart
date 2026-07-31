import '../../../../core/error/failure.dart';
import '../../../../core/utils/either.dart';
import '../entities/app_usage_entity.dart';
import '../entities/installed_app_entity.dart';

abstract interface class AppUsageRepository {
  Future<Either<Failure, List<InstalledAppEntity>>> getInstalledApps();
  Future<Either<Failure, List<AppUsageEntity>>> getUsageStats({required int dayOffset});
}
