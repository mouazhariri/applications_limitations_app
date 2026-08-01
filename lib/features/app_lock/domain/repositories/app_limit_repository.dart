import '../../../../core/error/failure.dart';
import '../../../../core/error/success.dart';
import '../../../../core/utils/either.dart';

abstract interface class AppLimitRepository {
  Either<Failure, Map<String, Duration>> getLimits();
  Either<Failure, Duration?> getLimit(String packageName);
  Future<Either<Failure, Success>> setLimit(String packageName, Duration limit);
  Future<Either<Failure, Success>> removeLimit(String packageName);
  Future<Either<Failure, Success>> resetAll();
}
