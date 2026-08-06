import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:applications_limitations/src/core/di/service_locator.dart';
import 'phone_limit_state.dart';

part 'phone_limit_controller.g.dart';

@riverpod
class PhoneLimitController extends _$PhoneLimitController {
  @override
  Future<PhoneLimitState> build() async {
    final limitResult = ref.read(getPhoneLimitUseCaseProvider)();
    final lockResult = ref.read(getPhoneLockDurationUseCaseProvider)();
    final limit = limitResult.fold((failure) => throw failure, (value) => value);
    final lockDuration =
        lockResult.fold((failure) => throw failure, (value) => value);
    return PhoneLimitState(
      currentLimit: limit,
      currentLockDuration: lockDuration,
    );
  }

  void updateCustomMinutes(String value) {
    final data = state.value;
    if (data == null) return;
    state = AsyncData(data.copyWith(customMinutes: value));
  }

  void updateCustomLockMinutes(String value) {
    final data = state.value;
    if (data == null) return;
    state = AsyncData(data.copyWith(customLockMinutes: value));
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

  Future<bool> setLockDuration(Duration lockDuration) async {
    final data = state.value;
    if (data == null) return false;

    state = AsyncData(data.copyWith(isSaving: true));
    final result = await ref.read(setPhoneLockDurationUseCaseProvider)(lockDuration);

    return result.fold(
      (_) {
        state = AsyncData(data.copyWith(isSaving: false));
        return false;
      },
      (_) async {
        await ref.read(phoneLimiterChannelProvider).startProtectionService();
        state = AsyncData(
          data.copyWith(currentLockDuration: lockDuration, isSaving: false),
        );
        return true;
      },
    );
  }

  Future<bool> setCustomLockDuration() async {
    final minutes = int.tryParse(state.value?.customLockMinutes ?? '');
    if (minutes == null || minutes <= 0) return false;
    return setLockDuration(Duration(minutes: minutes));
  }
}
