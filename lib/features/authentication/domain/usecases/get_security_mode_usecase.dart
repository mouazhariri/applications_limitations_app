import 'package:applications_limitations/src/core/error/failure.dart';
import 'package:applications_limitations/src/core/utils/either.dart';

import '../entities/security_credential_entity.dart';
import '../repositories/security_repository.dart';

class GetSecurityModeUseCase {
  const GetSecurityModeUseCase(this._repository);

  final SecurityRepository _repository;

  Either<Failure, SecurityMode?> call() => _repository.getMode();
}
