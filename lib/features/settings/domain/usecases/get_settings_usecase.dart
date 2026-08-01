import 'package:applications_limitations/src/core/error/failure.dart';
import 'package:applications_limitations/src/core/utils/either.dart';
import '../entities/app_settings_entity.dart';
import '../repositories/settings_repository.dart';

class GetSettingsUseCase {
  const GetSettingsUseCase(this._repository);
  final SettingsRepository _repository;
  Either<Failure, AppSettingsEntity> call() => _repository.getSettings();
}
