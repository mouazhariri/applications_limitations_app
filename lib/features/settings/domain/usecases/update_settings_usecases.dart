import 'package:applications_limitations/src/core/error/failure.dart';
import 'package:applications_limitations/src/core/error/success.dart';
import 'package:applications_limitations/src/core/utils/either.dart';
import '../repositories/settings_repository.dart';

class SetLanguageUseCase {
  const SetLanguageUseCase(this._repository);
  final SettingsRepository _repository;
  Future<Either<Failure, Success>> call(String languageCode) => _repository.setLanguage(languageCode);
}

class SetThemeModeUseCase {
  const SetThemeModeUseCase(this._repository);
  final SettingsRepository _repository;
  Future<Either<Failure, Success>> call(String themeMode) => _repository.setThemeMode(themeMode);
}

class SetProtectionEnabledUseCase {
  const SetProtectionEnabledUseCase(this._repository);
  final SettingsRepository _repository;
  Future<Either<Failure, Success>> call(bool enabled) => _repository.setProtectionEnabled(enabled);
}

class ResetLimitsUseCase {
  const ResetLimitsUseCase(this._repository);
  final SettingsRepository _repository;
  Future<Either<Failure, Success>> call() => _repository.resetLimits();
}
