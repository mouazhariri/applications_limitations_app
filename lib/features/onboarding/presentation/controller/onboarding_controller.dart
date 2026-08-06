import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:applications_limitations/src/core/di/service_locator.dart';
import 'onboarding_state.dart';

part 'onboarding_controller.g.dart';

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  Future<OnboardingState> build() async => OnboardingState.initial();

  void setPage(int index) {
    final data = state.value;
    if (data == null) return;
    state = AsyncData(data.copyWith(currentIndex: index));
  }

  Future<bool> complete() async {
    final data = state.value;
    if (data == null) return false;

    state = AsyncData(data.copyWith(isCompleting: true));
    final result = await ref.read(completeOnboardingUseCaseProvider)();
    return result.fold(
      (failure) {
        state = AsyncData(data.copyWith(isCompleting: false));
        return false;
      },
      (_) {
        state = AsyncData(data.copyWith(isCompleting: false));
        return true;
      },
    );
  }
}
