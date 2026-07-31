import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/service_locator.dart';
import 'onboarding_state.dart';

final onboardingControllerProvider = AsyncNotifierProvider<OnboardingController, OnboardingState>(OnboardingController.new);

class OnboardingController extends AsyncNotifier<OnboardingState> {
  @override
  Future<OnboardingState> build() async => OnboardingState.initial();

  void setPage(int index) {
    final value = state.valueOrNull;
    if (value != null) state = AsyncData(value.copyWith(currentIndex: index));
  }

  Future<void> complete() async {
    final value = state.valueOrNull;
    if (value == null) return;
    state = AsyncData(value.copyWith(isCompleting: true));
    final useCase = ref.read(completeOnboardingUseCaseProvider);
    final result = await useCase();
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (_) => state = AsyncData(value.copyWith(isCompleting: false)),
    );
  }
}
