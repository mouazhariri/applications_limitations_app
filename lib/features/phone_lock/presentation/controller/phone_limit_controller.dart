import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:applications_limitations/src/core/di/service_locator.dart';
import 'phone_limit_state.dart';

part 'phone_limit_controller.g.dart';

@riverpod
class PhoneLimitController extends _$PhoneLimitController {
  @override
  Future<PhoneLimitState> build() async {
    final result = ref.read(getPhoneLimitUseCaseProvider)();
    return result.fold(
      (failure) => throw failure,
      (limit) => PhoneLimitState(currentLimit: limit),
    );
  }

  void updateCustomMinutes(String value) {
    final data = state.value;
    if (data == null) return;
    state = AsyncData(data.copyWith(customMinutes: value));
  }

  Future<bool> setLimit(Duration limit) async {
    final data = state.value;
    if (data == null) return false;

    state = AsyncData(data.copyWith(isSaving: true));
    final result = await ref.read(setPhoneLimitUseCaseProvider)(limit);

    return result.fold(
      (_) {
        state = AsyncData(data.copyWith(isSaving: false));
        return false;
      },
      (_) async {
        await ref.read(phoneLimiterChannelProvider).startProtectionService();
        state = AsyncData(
          data.copyWith(currentLimit: limit, isSaving: false),
        );
        return true;
      },
    );
  }

  Future<bool> setCustomLimit() async {
    final minutes = int.tryParse(state.value?.customMinutes ?? '');
    if (minutes == null || minutes <= 0) return false;
    return setLimit(Duration(minutes: minutes));
  }
}
