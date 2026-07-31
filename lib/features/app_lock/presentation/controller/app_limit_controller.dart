import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/service_locator.dart';
import 'app_limit_state.dart';

final appLimitControllerProvider = AsyncNotifierProvider.family<AppLimitController, AppLimitState, ({String packageName, String appName})>(AppLimitController.new);

class AppLimitController extends FamilyAsyncNotifier<AppLimitState, ({String packageName, String appName})> {
  @override
  Future<AppLimitState> build(({String packageName, String appName}) arg) async {
    final result = ref.read(getAppLimitUseCaseProvider)(arg.packageName);
    return result.fold((failure) => throw failure, (limit) => AppLimitState(packageName: arg.packageName, appName: arg.appName, currentLimit: limit));
  }

  void updateCustomMinutes(String value) {
    final data = state.valueOrNull;
    if (data != null) state = AsyncData(data.copyWith(customMinutes: value));
  }

  Future<bool> setLimit(Duration limit) async {
    final data = state.valueOrNull;
    if (data == null) return false;
    state = AsyncData(data.copyWith(isSaving: true));
    final result = await ref.read(setAppLimitUseCaseProvider)(data.packageName, limit);
    await ref.read(phoneLimiterChannelProvider).startProtectionService();
    return result.fold((failure) {
      state = AsyncError(failure, StackTrace.current);
      return false;
    }, (_) {
      state = AsyncData(data.copyWith(currentLimit: limit, isSaving: false));
      return true;
    });
  }

  Future<bool> setCustomLimit() async {
    final data = state.valueOrNull;
    final minutes = int.tryParse(data?.customMinutes ?? '');
    if (minutes == null || minutes <= 0) return false;
    return setLimit(Duration(minutes: minutes));
  }

  Future<bool> removeLimit() async {
    final data = state.valueOrNull;
    if (data == null) return false;
    state = AsyncData(data.copyWith(isSaving: true));
    final result = await ref.read(removeAppLimitUseCaseProvider)(data.packageName);
    return result.fold((failure) {
      state = AsyncError(failure, StackTrace.current);
      return false;
    }, (_) {
      state = AsyncData(data.copyWith(clearLimit: true, isSaving: false));
      return true;
    });
  }
}
