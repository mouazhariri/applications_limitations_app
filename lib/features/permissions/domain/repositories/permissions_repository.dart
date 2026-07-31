import '../../../../core/error/failure.dart';
import '../../../../core/error/success.dart';
import '../../../../core/utils/either.dart';
import '../entities/permission_status_entity.dart';

abstract interface class PermissionsRepository {
  Future<Either<Failure, List<PermissionStatusEntity>>> getStatuses();
  Future<Either<Failure, Success>> openSettings(String permissionKey);
}
