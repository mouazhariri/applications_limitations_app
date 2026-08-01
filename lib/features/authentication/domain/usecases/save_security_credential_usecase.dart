import 'package:applications_limitations/src/core/error/failure.dart';
import 'package:applications_limitations/src/core/error/success.dart';
import 'package:applications_limitations/src/core/utils/either.dart';
import '../entities/security_credential_entity.dart';
import '../repositories/security_repository.dart';

class SaveSecurityCredentialUseCase {
  const SaveSecurityCredentialUseCase(this._repository);
  final SecurityRepository _repository;
  Future<Either<Failure, Success>> call(SecurityCredentialEntity credential) => _repository.saveCredential(credential);
}
