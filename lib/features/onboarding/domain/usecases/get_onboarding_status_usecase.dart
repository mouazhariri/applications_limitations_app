import '../../../../core/error/failure.dart';
import '../../../../core/utils/either.dart';
import '../repositories/onboarding_repository.dart';

class GetOnboardingStatusUseCase {
  const GetOnboardingStatusUseCase(this._repository);
  final OnboardingRepository _repository;
  Either<Failure, bool> call() => _repository.isCompleted();
}
