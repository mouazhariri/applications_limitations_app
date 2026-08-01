import 'package:applications_limitations/src/core/error/failure.dart';
import 'package:applications_limitations/src/core/utils/either.dart';
import '../../domain/entities/dashboard_snapshot_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasource/dashboard_local_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(this._dataSource);
  final DashboardDataSource _dataSource;

  @override
  Future<Either<Failure, DashboardSnapshotEntity>> getSnapshot() async {
    try { return Right(await _dataSource.getSnapshot()); } catch (exception) { return Left(Failure(message: 'dashboard_load_error', exception: exception)); }
  }
}
