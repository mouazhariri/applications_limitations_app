import '../../../../core/error/failure.dart';
import '../../../../core/error/success.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/permission_status_entity.dart';
import '../../domain/repositories/permissions_repository.dart';
import '../datasource/permissions_platform_datasource.dart';

class PermissionsRepositoryImpl implements PermissionsRepository {
  PermissionsRepositoryImpl(this._dataSource);

  final PermissionsPlatformDataSource _dataSource;

  @override
  Future<Either<Failure, List<PermissionStatusEntity>>> getStatuses() async {
    try {
      return Right(await _dataSource.getStatuses());
    } catch (exception) {
      return Left(Failure(message: 'permissions_load_error', exception: exception));
    }
  }

  @override
  Future<Either<Failure, Success>> openSettings(String permissionKey) async {
    try {
      await _dataSource.openSettings(permissionKey);
      return const Right(Success());
    } catch (exception) {
      return Left(Failure(message: 'permissions_open_error', exception: exception));
    }
  }
}
