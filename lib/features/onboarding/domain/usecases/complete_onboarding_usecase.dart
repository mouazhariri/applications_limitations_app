import '../../../../core/error/failure.dart';
import '../../../../core/error/success.dart';
import '../../../../core/utils/either.dart';
import '../repositories/onboarding_repository.dart';

class CompleteOnboardingUseCase {
  const CompleteOnboardingUseCase(this._repository);
  final OnboardingRepository _repository;
  Future<Either<Failure, Success>> call() => _repository.complete();
}
