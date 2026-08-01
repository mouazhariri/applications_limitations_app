import 'package:applications_limitations/src/core/error/failure.dart';
import 'package:applications_limitations/src/core/error/success.dart';
import 'package:applications_limitations/src/core/utils/either.dart';

abstract interface class OnboardingRepository {
  Either<Failure, bool> isCompleted();
  Future<Either<Failure, Success>> complete();
}
