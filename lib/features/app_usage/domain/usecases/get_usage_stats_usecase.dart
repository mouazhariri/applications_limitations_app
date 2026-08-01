import '../../../../core/error/failure.dart';
import '../../../../core/utils/either.dart';
import '../entities/app_usage_entity.dart';
import '../repositories/app_usage_repository.dart';

class GetUsageStatsUseCase {
  const GetUsageStatsUseCase(this._repository);
  final AppUsageRepository _repository;
  Future<Either<Failure, List<AppUsageEntity>>> call({required int dayOffset}) => _repository.getUsageStats(dayOffset: dayOffset);
}
