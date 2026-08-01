import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:applications_limitations/src/core/di/service_locator.dart';
import 'usage_state.dart';

part 'usage_controller.g.dart';

@riverpod
class UsageController extends _$UsageController {
  static const _historyDays = 7;

  @override
  Future<UsageState> build() => _load();

  Future<UsageState> _load() async {
    final getUsage = ref.read(getUsageStatsUseCaseProvider);
    final results = await Future.wait(
      List.generate(
        _historyDays,
        (dayOffset) => getUsage(dayOffset: dayOffset),
      ),
    );

    final usageByDay = results
        .map((result) => result.fold((failure) => throw failure, (apps) => apps))
        .toList(growable: false);

    return UsageState(
      today: usageByDay.first,
      yesterday: usageByDay[1],
      week: List.generate(
        _historyDays,
        (dayOffset) => UsageDaySummary(
          dayOffset: dayOffset,
          total: usageByDay[dayOffset].fold(
            Duration.zero,
            (sum, app) => sum + app.usage,
          ),
        ),
      ),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }
}
