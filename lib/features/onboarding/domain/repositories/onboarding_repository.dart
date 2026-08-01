import '../../../../core/error/failure.dart';
import '../../../../core/error/success.dart';
import '../../../../core/utils/either.dart';

abstract interface class OnboardingRepository {
  Either<Failure, bool> isCompleted();
  Future<Either<Failure, Success>> complete();
}
