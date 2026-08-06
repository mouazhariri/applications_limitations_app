import 'package:applications_limitations/src/core/error/failure.dart';
import 'package:applications_limitations/src/core/utils/either.dart';
import '../repositories/onboarding_repository.dart';

class GetOnboardingStatusUseCase {
  const GetOnboardingStatusUseCase(this._repository);
  final OnboardingRepository _repository;
  Either<Failure, bool> call() => _repository.isCompleted();
}
