import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:applications_limitations/src/core/di/service_locator.dart';
import 'permissions_state.dart';

part 'permissions_controller.g.dart';

@riverpod
class PermissionsController extends _$PermissionsController {
  @override
  Future<PermissionsState> build() => _load();

  Future<PermissionsState> _load() async {
    final result = await ref.read(getPermissionStatusesUseCaseProvider)();
    return result.fold(
      (failure) => throw failure,
      (permissions) => PermissionsState(permissions: permissions),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> openSettings(String permissionKey) async {
    final data = state.value;
    if (data != null) {
      state = AsyncData(data.copyWith(isOpeningSettings: true));
    }
    await ref.read(openPermissionSettingsUseCaseProvider)(permissionKey);
    if (data != null) {
      state = AsyncData(data.copyWith(isOpeningSettings: false));
    }
  }
}
