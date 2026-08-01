import 'package:applications_limitations/src/core/error/failure.dart';
import 'package:applications_limitations/src/core/utils/either.dart';
import '../repositories/phone_limit_repository.dart';

class GetPhoneLimitUseCase {
  const GetPhoneLimitUseCase(this._repository);
  final PhoneLimitRepository _repository;
  Either<Failure, Duration> call() => _repository.getLimit();
}
