import '../../../../core/error/failure.dart';
import '../../../../core/error/success.dart';
import '../../../../core/utils/either.dart';

abstract interface class PhoneLimitRepository {
  Either<Failure, Duration> getLimit();
  Future<Either<Failure, Success>> setLimit(Duration limit);
  Future<Either<Failure, Success>> reset();
}
