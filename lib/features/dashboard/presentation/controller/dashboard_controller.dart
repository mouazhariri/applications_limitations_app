import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:applications_limitations/src/core/di/service_locator.dart';
import 'dashboard_state.dart';

part 'dashboard_controller.g.dart';

@riverpod
class DashboardController extends _$DashboardController {
  @override
  Future<DashboardState> build() => _load();

  Future<DashboardState> _load() async {
    await ref.read(phoneLimiterChannelProvider).startProtectionService();
    final result = await ref.read(getDashboardSnapshotUseCaseProvider)();
    return result.fold(
      (failure) => throw failure,
      (snapshot) => DashboardState(snapshot: snapshot),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }
}
