import 'package:applications_limitations/src/core/error/failure.dart';
import 'package:applications_limitations/src/core/utils/either.dart';
import '../entities/installed_app_entity.dart';
import '../repositories/app_usage_repository.dart';

class GetInstalledAppsUseCase {
  const GetInstalledAppsUseCase(this._repository);
  final AppUsageRepository _repository;
  Future<Either<Failure, List<InstalledAppEntity>>> call() => _repository.getInstalledApps();
}
