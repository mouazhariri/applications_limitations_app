import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/app_lock/data/datasource/app_limit_local_datasource.dart';
import '../../features/app_lock/data/repository/app_limit_repository_impl.dart';
import '../../features/app_lock/domain/repositories/app_limit_repository.dart';
import '../../features/app_lock/domain/usecases/get_app_limit_usecase.dart';
import '../../features/app_lock/domain/usecases/remove_app_limit_usecase.dart';
import '../../features/app_lock/domain/usecases/set_app_limit_usecase.dart';
import '../../features/app_usage/data/datasource/app_usage_platform_datasource.dart';
import '../../features/app_usage/data/repository/app_usage_repository_impl.dart';
import '../../features/app_usage/domain/repositories/app_usage_repository.dart';
import '../../features/app_usage/domain/usecases/get_installed_apps_usecase.dart';
import '../../features/app_usage/domain/usecases/get_usage_stats_usecase.dart';
import '../../features/authentication/data/datasource/security_local_datasource.dart';
import '../../features/authentication/data/repository/security_repository_impl.dart';
import '../../features/authentication/domain/repositories/security_repository.dart';
import '../../features/authentication/domain/usecases/has_security_credential_usecase.dart';
import '../../features/authentication/domain/usecases/save_security_credential_usecase.dart';
import '../../features/authentication/domain/usecases/verify_security_credential_usecase.dart';
import '../../features/dashboard/data/datasource/dashboard_local_datasource.dart';
import '../../features/dashboard/data/repository/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/domain/usecases/get_dashboard_snapshot_usecase.dart';
import '../../features/onboarding/data/datasource/onboarding_local_datasource.dart';
import '../../features/onboarding/data/repository/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import '../../features/onboarding/domain/usecases/get_onboarding_status_usecase.dart';
import '../../features/permissions/data/datasource/permissions_platform_datasource.dart';
import '../../features/permissions/data/repository/permissions_repository_impl.dart';
import '../../features/permissions/domain/repositories/permissions_repository.dart';
import '../../features/permissions/domain/usecases/get_permission_statuses_usecase.dart';
import '../../features/permissions/domain/usecases/open_permission_settings_usecase.dart';
import '../../features/phone_lock/data/datasource/phone_limit_local_datasource.dart';
import '../../features/phone_lock/data/repository/phone_limit_repository_impl.dart';
import '../../features/phone_lock/domain/repositories/phone_limit_repository.dart';
import '../../features/phone_lock/domain/usecases/get_phone_limit_usecase.dart';
import '../../features/phone_lock/domain/usecases/set_phone_limit_usecase.dart';
import '../../features/settings/data/datasource/settings_local_datasource.dart';
import '../../features/settings/data/repository/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/get_settings_usecase.dart';
import '../../features/settings/domain/usecases/update_settings_usecases.dart';
import '../services/app_logger.dart';
import '../services/local_storage.dart';
import '../services/phone_limiter_channel.dart';

final loggerProvider = Provider<Logger>((ref) => const AppLogger());
final phoneLimiterChannelProvider = Provider<PhoneLimiterChannel>((ref) => PhoneLimiterChannel());
final localStorageProvider = Provider<LocalStorage>((ref) => throw StateError('LocalStorage override is required'));

final onboardingLocalDataSourceProvider = Provider<OnboardingLocalDataSource>((ref) => OnboardingLocalDataSourceImpl(ref.watch(localStorageProvider)));
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) => OnboardingRepositoryImpl(ref.watch(onboardingLocalDataSourceProvider)));
final getOnboardingStatusUseCaseProvider = Provider<GetOnboardingStatusUseCase>((ref) => GetOnboardingStatusUseCase(ref.watch(onboardingRepositoryProvider)));
final completeOnboardingUseCaseProvider = Provider<CompleteOnboardingUseCase>((ref) => CompleteOnboardingUseCase(ref.watch(onboardingRepositoryProvider)));

final permissionsDataSourceProvider = Provider<PermissionsPlatformDataSource>((ref) => PermissionsPlatformDataSourceImpl(ref.watch(phoneLimiterChannelProvider)));
final permissionsRepositoryProvider = Provider<PermissionsRepository>((ref) => PermissionsRepositoryImpl(ref.watch(permissionsDataSourceProvider)));
final getPermissionStatusesUseCaseProvider = Provider<GetPermissionStatusesUseCase>((ref) => GetPermissionStatusesUseCase(ref.watch(permissionsRepositoryProvider)));
final openPermissionSettingsUseCaseProvider = Provider<OpenPermissionSettingsUseCase>((ref) => OpenPermissionSettingsUseCase(ref.watch(permissionsRepositoryProvider)));

final securityDataSourceProvider = Provider<SecurityLocalDataSource>((ref) => SecurityLocalDataSourceImpl(ref.watch(localStorageProvider)));
final securityRepositoryProvider = Provider<SecurityRepository>((ref) => SecurityRepositoryImpl(ref.watch(securityDataSourceProvider)));
final hasSecurityCredentialUseCaseProvider = Provider<HasSecurityCredentialUseCase>((ref) => HasSecurityCredentialUseCase(ref.watch(securityRepositoryProvider)));
final saveSecurityCredentialUseCaseProvider = Provider<SaveSecurityCredentialUseCase>((ref) => SaveSecurityCredentialUseCase(ref.watch(securityRepositoryProvider)));
final verifySecurityCredentialUseCaseProvider = Provider<VerifySecurityCredentialUseCase>((ref) => VerifySecurityCredentialUseCase(ref.watch(securityRepositoryProvider)));

final appLimitDataSourceProvider = Provider<AppLimitLocalDataSource>((ref) => AppLimitLocalDataSourceImpl(ref.watch(localStorageProvider)));
final appLimitRepositoryProvider = Provider<AppLimitRepository>((ref) => AppLimitRepositoryImpl(ref.watch(appLimitDataSourceProvider)));
final getAppLimitUseCaseProvider = Provider<GetAppLimitUseCase>((ref) => GetAppLimitUseCase(ref.watch(appLimitRepositoryProvider)));
final setAppLimitUseCaseProvider = Provider<SetAppLimitUseCase>((ref) => SetAppLimitUseCase(ref.watch(appLimitRepositoryProvider)));
final removeAppLimitUseCaseProvider = Provider<RemoveAppLimitUseCase>((ref) => RemoveAppLimitUseCase(ref.watch(appLimitRepositoryProvider)));

final phoneLimitDataSourceProvider = Provider<PhoneLimitLocalDataSource>((ref) => PhoneLimitLocalDataSourceImpl(ref.watch(localStorageProvider)));
final phoneLimitRepositoryProvider = Provider<PhoneLimitRepository>((ref) => PhoneLimitRepositoryImpl(ref.watch(phoneLimitDataSourceProvider)));
final getPhoneLimitUseCaseProvider = Provider<GetPhoneLimitUseCase>((ref) => GetPhoneLimitUseCase(ref.watch(phoneLimitRepositoryProvider)));
final setPhoneLimitUseCaseProvider = Provider<SetPhoneLimitUseCase>((ref) => SetPhoneLimitUseCase(ref.watch(phoneLimitRepositoryProvider)));

final appUsageDataSourceProvider = Provider<AppUsagePlatformDataSource>((ref) => AppUsagePlatformDataSourceImpl(ref.watch(phoneLimiterChannelProvider), ref.watch(localStorageProvider)));
final appUsageRepositoryProvider = Provider<AppUsageRepository>((ref) => AppUsageRepositoryImpl(ref.watch(appUsageDataSourceProvider)));
final getInstalledAppsUseCaseProvider = Provider<GetInstalledAppsUseCase>((ref) => GetInstalledAppsUseCase(ref.watch(appUsageRepositoryProvider)));
final getUsageStatsUseCaseProvider = Provider<GetUsageStatsUseCase>((ref) => GetUsageStatsUseCase(ref.watch(appUsageRepositoryProvider)));

final dashboardDataSourceProvider = Provider<DashboardDataSource>((ref) => DashboardDataSourceImpl(ref.watch(appUsageRepositoryProvider), ref.watch(phoneLimitRepositoryProvider)));
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) => DashboardRepositoryImpl(ref.watch(dashboardDataSourceProvider)));
final getDashboardSnapshotUseCaseProvider = Provider<GetDashboardSnapshotUseCase>((ref) => GetDashboardSnapshotUseCase(ref.watch(dashboardRepositoryProvider)));

final settingsDataSourceProvider = Provider<SettingsLocalDataSource>((ref) => SettingsLocalDataSourceImpl(ref.watch(localStorageProvider)));
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) => SettingsRepositoryImpl(ref.watch(settingsDataSourceProvider)));
final getSettingsUseCaseProvider = Provider<GetSettingsUseCase>((ref) => GetSettingsUseCase(ref.watch(settingsRepositoryProvider)));
final setLanguageUseCaseProvider = Provider<SetLanguageUseCase>((ref) => SetLanguageUseCase(ref.watch(settingsRepositoryProvider)));
final setThemeModeUseCaseProvider = Provider<SetThemeModeUseCase>((ref) => SetThemeModeUseCase(ref.watch(settingsRepositoryProvider)));
final setProtectionEnabledUseCaseProvider = Provider<SetProtectionEnabledUseCase>((ref) => SetProtectionEnabledUseCase(ref.watch(settingsRepositoryProvider)));
final resetLimitsUseCaseProvider = Provider<ResetLimitsUseCase>((ref) => ResetLimitsUseCase(ref.watch(settingsRepositoryProvider)));
