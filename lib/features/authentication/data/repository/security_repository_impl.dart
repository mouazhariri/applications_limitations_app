import '../../../../core/error/failure.dart';
import '../../../../core/error/success.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/security_credential_entity.dart';
import '../../domain/repositories/security_repository.dart';
import '../datasource/security_local_datasource.dart';

class SecurityRepositoryImpl implements SecurityRepository {
  SecurityRepositoryImpl(this._dataSource);

  final SecurityLocalDataSource _dataSource;

  @override
  Either<Failure, bool> hasCredential() {
    try {
      return Right(_dataSource.hasCredential());
    } catch (exception) {
      return Left(Failure(message: 'security_error', exception: exception));
    }
  }

  @override
  Either<Failure, SecurityMode?> getMode() {
    try {
      return Right(_dataSource.getMode());
    } catch (exception) {
      return Left(Failure(message: 'security_error', exception: exception));
    }
  }

  @override
  Future<Either<Failure, Success>> saveCredential(SecurityCredentialEntity credential) async {
    try {
      await _dataSource.saveCredential(credential);
      return const Right(Success());
    } catch (exception) {
      return Left(Failure(message: 'security_save_error', exception: exception));
    }
  }

  @override
  Future<Either<Failure, bool>> verify(String secret) async {
    try {
      return Right(await _dataSource.verify(secret));
    } catch (exception) {
      return Left(Failure(message: 'security_verify_error', exception: exception));
    }
  }

  @override
  Future<Either<Failure, Success>> clear() async {
    try {
      await _dataSource.clear();
      return const Right(Success());
    } catch (exception) {
      return Left(Failure(message: 'security_error', exception: exception));
    }
  }
}
