import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/service_locator.dart';
import 'dashboard_state.dart';

final dashboardControllerProvider = AsyncNotifierProvider<DashboardController, DashboardState>(DashboardController.new);

class DashboardController extends AsyncNotifier<DashboardState> {
  @override
  Future<DashboardState> build() => _load();

  Future<DashboardState> _load() async {
    await ref.read(phoneLimiterChannelProvider).startProtectionService();
    final result = await ref.read(getDashboardSnapshotUseCaseProvider)();
    return result.fold((failure) => throw failure, (snapshot) => DashboardState(snapshot: snapshot));
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }
}
