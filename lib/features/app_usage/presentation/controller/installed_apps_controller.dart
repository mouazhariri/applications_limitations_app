import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/service_locator.dart';
import 'installed_apps_state.dart';

final installedAppsControllerProvider = AsyncNotifierProvider<InstalledAppsController, InstalledAppsState>(InstalledAppsController.new);

class InstalledAppsController extends AsyncNotifier<InstalledAppsState> {
  @override
  Future<InstalledAppsState> build() => _load();

  Future<InstalledAppsState> _load() async {
    final result = await ref.read(getInstalledAppsUseCaseProvider)();
    return result.fold((failure) => throw failure, (apps) => InstalledAppsState(apps: apps));
  }

  void search(String query) {
    final value = state.value;
    if (value != null) state = AsyncData(value.copyWith(searchQuery: query));
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }
}
