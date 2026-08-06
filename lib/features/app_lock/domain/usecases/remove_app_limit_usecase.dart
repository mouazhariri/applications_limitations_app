import 'package:applications_limitations/src/core/error/failure.dart';
import 'package:applications_limitations/src/core/error/success.dart';
import 'package:applications_limitations/src/core/utils/either.dart';
import '../repositories/app_limit_repository.dart';

class RemoveAppLimitUseCase {
  const RemoveAppLimitUseCase(this._repository);
  final AppLimitRepository _repository;
  Future<Either<Failure, Success>> call(String packageName) => _repository.removeLimit(packageName);
}
