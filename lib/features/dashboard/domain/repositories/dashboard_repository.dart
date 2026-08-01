import 'package:applications_limitations/src/core/error/failure.dart';
import 'package:applications_limitations/src/core/utils/either.dart';
import '../entities/dashboard_snapshot_entity.dart';

abstract interface class DashboardRepository {
  Future<Either<Failure, DashboardSnapshotEntity>> getSnapshot();
}
