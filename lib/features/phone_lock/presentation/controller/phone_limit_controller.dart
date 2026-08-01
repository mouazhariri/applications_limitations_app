import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/service_locator.dart';
import 'phone_limit_state.dart';

final phoneLimitControllerProvider = AsyncNotifierProvider<PhoneLimitController, PhoneLimitState>(PhoneLimitController.new);

class PhoneLimitController extends AsyncNotifier<PhoneLimitState> {
  @override
  Future<PhoneLimitState> build() async {
    final result = ref.read(getPhoneLimitUseCaseProvider)();
    return result.fold((failure) => throw failure, (limit) => PhoneLimitState(currentLimit: limit));
  }

  void updateCustomMinutes(String value) {
    final data = state.value;
    if (data != null) state = AsyncData(data.copyWith(customMinutes: value));
  }

  Future<bool> setLimit(Duration limit) async {
    final data = state.value;
    if (data == null) return false;
    state = AsyncData(data.copyWith(isSaving: true));
    final result = await ref.read(setPhoneLimitUseCaseProvider)(limit);
    await ref.read(phoneLimiterChannelProvider).startProtectionService();
    return result.fold((failure) {
      state = AsyncError(failure, StackTrace.current);
      return false;
    }, (_) {
      state = AsyncData(data.copyWith(currentLimit: limit, isSaving: false));
      return true;
    });
  }

  Future<bool> setCustomLimit() async {
    final minutes = int.tryParse(state.value?.customMinutes ?? '');
    if (minutes == null || minutes <= 0) return false;
    return setLimit(Duration(minutes: minutes));
  }
}
