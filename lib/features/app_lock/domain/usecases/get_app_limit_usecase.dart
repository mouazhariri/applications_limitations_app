import '../../../../core/error/failure.dart';
import '../../../../core/utils/either.dart';
import '../repositories/app_limit_repository.dart';

class GetAppLimitUseCase {
  const GetAppLimitUseCase(this._repository);
  final AppLimitRepository _repository;
  Either<Failure, Duration?> call(String packageName) => _repository.getLimit(packageName);
}
