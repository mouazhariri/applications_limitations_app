import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/service_locator.dart';
import 'app_limit_state.dart';

part 'app_limit_controller.g.dart';

@riverpod
class AppLimitController extends _$AppLimitController {
  @override
  Future<AppLimitState> build({
    required String packageName,
    required String appName,
  }) async {
    final result =
        await ref.read(getAppLimitUseCaseProvider)(packageName);

    return result.fold(
      (failure) => throw Exception(failure),
      (limit) => AppLimitState(
        packageName: packageName,
        appName: appName,
        currentLimit: limit,
      ),
    );
  }

  void updateCustomMinutes(String value) {
    final data = state.value;
    if (data == null) return;

    state = AsyncData(
      data.copyWith(customMinutes: value),
    );
  }

  Future<bool> setLimit(Duration limit) async {
    final data = state.value;
    if (data == null) return false;

    state = AsyncData(
      data.copyWith(isSaving: true),
    );

    final result = await ref.read(setAppLimitUseCaseProvider)(
      data.packageName,
      limit,
    );

    return result.fold(
      (failure) {
        state = AsyncData(
          data.copyWith(isSaving: false),
        );
        return false;
      },
      (_) async {
        await ref
            .read(phoneLimiterChannelProvider)
            .startProtectionService();

        state = AsyncData(
          data.copyWith(
            currentLimit: limit,
            isSaving: false,
          ),
        );

        return true;
      },
    );
  }

  Future<bool> setCustomLimit() async {
    final data = state.value;
    if (data == null) return false;

    final minutes = int.tryParse(data.customMinutes);

    if (minutes == null || minutes <= 0) {
      return false;
    }

    return setLimit(
      Duration(minutes: minutes),
    );
  }

  Future<bool> removeLimit() async {
    final data = state.value;
    if (data == null) return false;

    state = AsyncData(
      data.copyWith(isSaving: true),
    );

    final result =
        await ref.read(removeAppLimitUseCaseProvider)(data.packageName);

    return result.fold(
      (failure) {
        state = AsyncData(
          data.copyWith(isSaving: false),
        );
        return false;
      },
      (_) {
        state = AsyncData(
          data.copyWith(
            currentLimit: null,
            clearLimit: true,
            isSaving: false,
          ),
        );

        return true;
      },
    );
  }
}