import 'package:applications_limitations/src/core/error/failure.dart';
import 'package:applications_limitations/src/core/error/success.dart';
import 'package:applications_limitations/src/core/utils/either.dart';

abstract interface class PhoneLimitRepository {
  Either<Failure, Duration> getLimit();
  Future<Either<Failure, Success>> setLimit(Duration limit);

  Either<Failure, Duration> getLockDuration();
  Future<Either<Failure, Success>> setLockDuration(Duration lockDuration);

  Future<Either<Failure, Success>> reset();
}
