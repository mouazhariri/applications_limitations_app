import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:applications_limitations/src/core/di/service_locator.dart';
import 'installed_apps_state.dart';

part 'installed_apps_controller.g.dart';

@riverpod
class InstalledAppsController extends _$InstalledAppsController {
  @override
  Future<InstalledAppsState> build() => _load();

  Future<InstalledAppsState> _load() async {
    final result = await ref.read(getInstalledAppsUseCaseProvider)();
    return result.fold(
      (failure) => throw failure,
      (apps) => InstalledAppsState(apps: apps),
    );
  }

  void search(String query) {
    final data = state.value;
    if (data == null) return;
    state = AsyncData(data.copyWith(searchQuery: query));
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }
}
