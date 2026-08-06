import 'package:applications_limitations/src/core/error/failure.dart';
import 'package:applications_limitations/src/core/error/success.dart';
import 'package:applications_limitations/src/core/utils/either.dart';
import '../entities/app_settings_entity.dart';

abstract interface class SettingsRepository {
  Either<Failure, AppSettingsEntity> getSettings();
  Future<Either<Failure, Success>> setLanguage(String languageCode);
  Future<Either<Failure, Success>> setThemeMode(String themeMode);
  Future<Either<Failure, Success>> setProtectionEnabled(bool enabled);
  Future<Either<Failure, Success>> resetLimits();
}
