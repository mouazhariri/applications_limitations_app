import '../../../../core/error/failure.dart';
import '../../../../core/error/success.dart';
import '../../../../core/utils/either.dart';
import '../repositories/app_limit_repository.dart';

class SetAppLimitUseCase {
  const SetAppLimitUseCase(this._repository);
  final AppLimitRepository _repository;
  Future<Either<Failure, Success>> call(String packageName, Duration limit) => _repository.setLimit(packageName, limit);
}
