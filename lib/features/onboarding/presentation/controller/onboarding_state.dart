import 'package:flutter/material.dart';
import '../../domain/entities/onboarding_page_entity.dart';

class OnboardingState {
  const OnboardingState({required this.pages, this.currentIndex = 0, this.isCompleting = false});

  final List<OnboardingPageEntity> pages;
  final int currentIndex;
  final bool isCompleting;

  bool get isLastPage => currentIndex == pages.length - 1;

  OnboardingState copyWith({List<OnboardingPageEntity>? pages, int? currentIndex, bool? isCompleting}) {
    return OnboardingState(
      pages: pages ?? this.pages,
      currentIndex: currentIndex ?? this.currentIndex,
      isCompleting: isCompleting ?? this.isCompleting,
    );
  }

  factory OnboardingState.initial() => const OnboardingState(
        pages: [
          OnboardingPageEntity(titleKey: 'onboarding_title_1', descriptionKey: 'onboarding_desc_1', icon: Icons.self_improvement_rounded),
          OnboardingPageEntity(titleKey: 'onboarding_title_2', descriptionKey: 'onboarding_desc_2', icon: Icons.lock_clock_rounded),
          OnboardingPageEntity(titleKey: 'onboarding_title_3', descriptionKey: 'onboarding_desc_3', icon: Icons.verified_user_rounded),
        ],
      );
}
