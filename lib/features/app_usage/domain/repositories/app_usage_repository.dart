import 'package:applications_limitations/src/core/error/failure.dart';
import 'package:applications_limitations/src/core/utils/either.dart';
import '../entities/app_usage_entity.dart';
import '../entities/installed_app_entity.dart';

abstract interface class AppUsageRepository {
  Future<Either<Failure, List<InstalledAppEntity>>> getInstalledApps();
  Future<Either<Failure, List<AppUsageEntity>>> getUsageStats({required int dayOffset});
}
