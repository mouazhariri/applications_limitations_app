import 'package:applications_limitations/src/core/error/failure.dart';
import 'package:applications_limitations/src/core/error/success.dart';
import 'package:applications_limitations/src/core/utils/either.dart';
import '../repositories/phone_limit_repository.dart';

class SetPhoneLimitUseCase {
  const SetPhoneLimitUseCase(this._repository);
  final PhoneLimitRepository _repository;
  Future<Either<Failure, Success>> call(Duration limit) => _repository.setLimit(limit);
}
