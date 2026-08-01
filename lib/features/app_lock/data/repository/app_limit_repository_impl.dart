import '../../../../core/error/failure.dart';
import '../../../../core/error/success.dart';
import '../../../../core/utils/either.dart';
import '../../domain/repositories/app_limit_repository.dart';
import '../datasource/app_limit_local_datasource.dart';

class AppLimitRepositoryImpl implements AppLimitRepository {
  AppLimitRepositoryImpl(this._dataSource);

  final AppLimitLocalDataSource _dataSource;

  @override
  Either<Failure, Map<String, Duration>> getLimits() {
    try {
      return Right(_dataSource.getLimits());
    } catch (exception) {
      return Left(Failure(message: 'limit_load_error', exception: exception));
    }
  }

  @override
  Either<Failure, Duration?> getLimit(String packageName) {
    try {
      return Right(_dataSource.getLimit(packageName));
    } catch (exception) {
      return Left(Failure(message: 'limit_load_error', exception: exception));
    }
  }

  @override
  Future<Either<Failure, Success>> setLimit(String packageName, Duration limit) async {
    try {
      await _dataSource.setLimit(packageName, limit);
      return const Right(Success());
    } catch (exception) {
      return Left(Failure(message: 'limit_save_error', exception: exception));
    }
  }

  @override
  Future<Either<Failure, Success>> removeLimit(String packageName) async {
    try {
      await _dataSource.removeLimit(packageName);
      return const Right(Success());
    } catch (exception) {
      return Left(Failure(message: 'limit_save_error', exception: exception));
    }
  }

  @override
  Future<Either<Failure, Success>> resetAll() async {
    try {
      await _dataSource.resetAll();
      return const Right(Success());
    } catch (exception) {
      return Left(Failure(message: 'limit_save_error', exception: exception));
    }
  }
}
