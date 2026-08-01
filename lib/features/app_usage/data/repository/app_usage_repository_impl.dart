import '../../../../core/error/failure.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/app_usage_entity.dart';
import '../../domain/entities/installed_app_entity.dart';
import '../../domain/repositories/app_usage_repository.dart';
import '../datasource/app_usage_platform_datasource.dart';

class AppUsageRepositoryImpl implements AppUsageRepository {
  AppUsageRepositoryImpl(this._dataSource);

  final AppUsagePlatformDataSource _dataSource;

  @override
  Future<Either<Failure, List<InstalledAppEntity>>> getInstalledApps() async {
    try {
      return Right(await _dataSource.getInstalledApps());
    } catch (exception) {
      return Left(Failure(message: 'apps_load_error', exception: exception));
    }
  }

  @override
  Future<Either<Failure, List<AppUsageEntity>>> getUsageStats({required int dayOffset}) async {
    try {
      return Right(await _dataSource.getUsageStats(dayOffset: dayOffset));
    } catch (exception) {
      return Left(Failure(message: 'usage_load_error', exception: exception));
    }
  }
}
