import 'package:applications_limitations/src/core/error/failure.dart';
import 'package:applications_limitations/src/core/error/success.dart';
import 'package:applications_limitations/src/core/utils/either.dart';
import '../repositories/permissions_repository.dart';

class OpenPermissionSettingsUseCase {
  const OpenPermissionSettingsUseCase(this._repository);
  final PermissionsRepository _repository;
  Future<Either<Failure, Success>> call(String permissionKey) => _repository.openSettings(permissionKey);
}
