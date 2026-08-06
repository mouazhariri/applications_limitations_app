import 'package:applications_limitations/src/core/error/failure.dart';
import 'package:applications_limitations/src/core/utils/either.dart';
import '../repositories/security_repository.dart';

class HasSecurityCredentialUseCase {
  const HasSecurityCredentialUseCase(this._repository);
  final SecurityRepository _repository;
  Either<Failure, bool> call() => _repository.hasCredential();
}
