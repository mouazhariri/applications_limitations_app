import '../../../../core/error/failure.dart';
import '../../../../core/utils/either.dart';
import '../entities/permission_status_entity.dart';
import '../repositories/permissions_repository.dart';

class GetPermissionStatusesUseCase {
  const GetPermissionStatusesUseCase(this._repository);
  final PermissionsRepository _repository;
  Future<Either<Failure, List<PermissionStatusEntity>>> call() => _repository.getStatuses();
}
