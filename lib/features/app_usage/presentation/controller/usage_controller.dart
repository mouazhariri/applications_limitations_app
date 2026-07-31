import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/service_locator.dart';
import 'usage_state.dart';

final usageControllerProvider = AsyncNotifierProvider<UsageController, UsageState>(UsageController.new);

class UsageController extends AsyncNotifier<UsageState> {
  @override
  Future<UsageState> build() => _load();

  Future<UsageState> _load() async {
    final getUsage = ref.read(getUsageStatsUseCaseProvider);
    final today = await getUsage(dayOffset: 0);
    final yesterday = await getUsage(dayOffset: 1);
    final todayApps = today.fold((failure) => throw failure, (apps) => apps);
    final yesterdayApps = yesterday.fold((failure) => throw failure, (apps) => apps);
    return UsageState(today: todayApps, yesterday: yesterdayApps);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }
}
