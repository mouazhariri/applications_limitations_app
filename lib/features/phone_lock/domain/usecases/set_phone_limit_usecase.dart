import '../../../../core/error/failure.dart';
import '../../../../core/error/success.dart';
import '../../../../core/utils/either.dart';
import '../repositories/phone_limit_repository.dart';

class SetPhoneLimitUseCase {
  const SetPhoneLimitUseCase(this._repository);
  final PhoneLimitRepository _repository;
  Future<Either<Failure, Success>> call(Duration limit) => _repository.setLimit(limit);
}
