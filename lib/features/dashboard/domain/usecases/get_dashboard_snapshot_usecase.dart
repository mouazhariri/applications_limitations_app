import 'package:applications_limitations/src/core/error/failure.dart';
import 'package:applications_limitations/src/core/utils/either.dart';
import '../entities/dashboard_snapshot_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardSnapshotUseCase {
  const GetDashboardSnapshotUseCase(this._repository);
  final DashboardRepository _repository;
  Future<Either<Failure, DashboardSnapshotEntity>> call() => _repository.getSnapshot();
}
