import 'package:applications_limitations/src/core/error/failure.dart';
import 'package:applications_limitations/src/core/utils/either.dart';
import '../repositories/security_repository.dart';

class VerifySecurityCredentialUseCase {
  const VerifySecurityCredentialUseCase(this._repository);
  final SecurityRepository _repository;
  Future<Either<Failure, bool>> call(String secret) => _repository.verify(secret);
}
