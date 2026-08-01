import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/service_locator.dart';
import 'permissions_state.dart';

final permissionsControllerProvider = AsyncNotifierProvider<PermissionsController, PermissionsState>(PermissionsController.new);

class PermissionsController extends AsyncNotifier<PermissionsState> {
  @override
  Future<PermissionsState> build() async => _load();

  Future<PermissionsState> _load() async {
    final result = await ref.read(getPermissionStatusesUseCaseProvider)();
    return result.fold((failure) => throw failure, (permissions) => PermissionsState(permissions: permissions));
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> openSettings(String permissionKey) async {
    final value = state.value;
    if (value != null) state = AsyncData(value.copyWith(isOpeningSettings: true));
    await ref.read(openPermissionSettingsUseCaseProvider)(permissionKey);
    if (value != null) state = AsyncData(value.copyWith(isOpeningSettings: false));
  }
}
