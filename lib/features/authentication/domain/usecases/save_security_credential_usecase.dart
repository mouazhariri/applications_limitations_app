import '../../../../core/error/failure.dart';
import '../../../../core/error/success.dart';
import '../../../../core/utils/either.dart';
import '../entities/security_credential_entity.dart';
import '../repositories/security_repository.dart';

class SaveSecurityCredentialUseCase {
  const SaveSecurityCredentialUseCase(this._repository);
  final SecurityRepository _repository;
  Future<Either<Failure, Success>> call(SecurityCredentialEntity credential) => _repository.saveCredential(credential);
}
