import 'package:applications_limitations/src/core/error/failure.dart';
import 'package:applications_limitations/src/core/error/success.dart';
import 'package:applications_limitations/src/core/utils/either.dart';
import '../../domain/entities/app_settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasource/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._dataSource);
  final SettingsLocalDataSource _dataSource;

  @override
  Either<Failure, AppSettingsEntity> getSettings() {
    try { return Right(_dataSource.getSettings()); } catch (exception) { return Left(Failure(message: 'settings_load_error', exception: exception)); }
  }

  @override
  Future<Either<Failure, Success>> setLanguage(String languageCode) async {
    try { await _dataSource.setLanguage(languageCode); return const Right(Success()); } catch (exception) { return Left(Failure(message: 'settings_save_error', exception: exception)); }
  }

  @override
  Future<Either<Failure, Success>> setThemeMode(String themeMode) async {
    try { await _dataSource.setThemeMode(themeMode); return const Right(Success()); } catch (exception) { return Left(Failure(message: 'settings_save_error', exception: exception)); }
  }

  @override
  Future<Either<Failure, Success>> setProtectionEnabled(bool enabled) async {
    try { await _dataSource.setProtectionEnabled(enabled); return const Right(Success()); } catch (exception) { return Left(Failure(message: 'settings_save_error', exception: exception)); }
  }

  @override
  Future<Either<Failure, Success>> resetLimits() async {
    try { await _dataSource.resetLimits(); return const Right(Success()); } catch (exception) { return Left(Failure(message: 'settings_save_error', exception: exception)); }
  }
}
