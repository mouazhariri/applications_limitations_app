import 'package:applications_limitations/src/core/error/failure.dart';
import 'package:applications_limitations/src/core/error/success.dart';
import 'package:applications_limitations/src/core/utils/either.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasource/onboarding_local_datasource.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._dataSource);

  final OnboardingLocalDataSource _dataSource;

  @override
  Either<Failure, bool> isCompleted() {
    try {
      return Right(_dataSource.isCompleted());
    } catch (exception) {
      return Left(Failure(message: 'onboarding_storage_error', exception: exception));
    }
  }

  @override
  Future<Either<Failure, Success>> complete() async {
    try {
      await _dataSource.complete();
      return const Right(Success());
    } catch (exception) {
      return Left(Failure(message: 'onboarding_storage_error', exception: exception));
    }
  }
}
