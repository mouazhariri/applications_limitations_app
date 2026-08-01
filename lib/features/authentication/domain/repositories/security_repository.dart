import '../../../../core/error/failure.dart';
import '../../../../core/error/success.dart';
import '../../../../core/utils/either.dart';
import '../entities/security_credential_entity.dart';

abstract interface class SecurityRepository {
  Either<Failure, bool> hasCredential();
  Either<Failure, SecurityMode?> getMode();
  Future<Either<Failure, Success>> saveCredential(SecurityCredentialEntity credential);
  Future<Either<Failure, bool>> verify(String secret);
  Future<Either<Failure, Success>> clear();
}
