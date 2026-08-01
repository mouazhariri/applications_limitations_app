import 'package:applications_limitations/src/core/error/failure.dart';
import 'package:applications_limitations/src/core/error/success.dart';
import 'package:applications_limitations/src/core/utils/either.dart';
import '../entities/security_credential_entity.dart';

abstract interface class SecurityRepository {
  Either<Failure, bool> hasCredential();
  Either<Failure, SecurityMode?> getMode();
  Future<Either<Failure, Success>> saveCredential(SecurityCredentialEntity credential);
  Future<Either<Failure, bool>> verify(String secret);
  Future<Either<Failure, Success>> clear();
}
