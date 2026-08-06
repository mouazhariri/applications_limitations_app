import 'package:applications_limitations/src/core/error/failure.dart';
import 'package:applications_limitations/src/core/error/success.dart';
import 'package:applications_limitations/src/core/utils/either.dart';
import '../../domain/repositories/phone_limit_repository.dart';
import '../datasource/phone_limit_local_datasource.dart';

class PhoneLimitRepositoryImpl implements PhoneLimitRepository {
  PhoneLimitRepositoryImpl(this._dataSource);
  final PhoneLimitLocalDataSource _dataSource;

  @override
  Either<Failure, Duration> getLimit() {
    try {
      return Right(_dataSource.getLimit());
    } catch (exception) {
      return Left(Failure(message: 'phone_limit_load_error', exception: exception));
    }
  }

  @override
  Future<Either<Failure, Success>> setLimit(Duration limit) async {
    try {
      await _dataSource.setLimit(limit);
      return const Right(Success());
    } catch (exception) {
      return Left(Failure(message: 'phone_limit_save_error', exception: exception));
    }
  }

  @override
  Either<Failure, Duration> getLockDuration() {
    try {
      return Right(_dataSource.getLockDuration());
    } catch (exception) {
      return Left(Failure(message: 'phone_limit_load_error', exception: exception));
    }
  }

  @override
  Future<Either<Failure, Success>> setLockDuration(Duration lockDuration) async {
    try {
      await _dataSource.setLockDuration(lockDuration);
      return const Right(Success());
    } catch (exception) {
      return Left(Failure(message: 'phone_limit_save_error', exception: exception));
    }
  }

  @override
  Future<Either<Failure, Success>> reset() async {
    try {
      await _dataSource.reset();
      return const Right(Success());
    } catch (exception) {
      return Left(Failure(message: 'phone_limit_save_error', exception: exception));
    }
  }
}
