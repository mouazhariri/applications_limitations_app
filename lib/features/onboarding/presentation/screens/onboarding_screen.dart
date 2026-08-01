import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:applications_limitations/src/core/routing/app_routes.dart';
import 'package:applications_limitations/src/core/shared/widgets/async_state_view.dart';
import 'package:applications_limitations/src/core/shared/widgets/app_scaffold.dart';
import '../controller/onboarding_controller.dart';
import '../widgets/onboarding_page_view.dart';
import '../widgets/page_indicator.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    return AppScaffold(
      showBackButton: false,
      body: AsyncStateView(
        value: state,
        data: (data) => Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: data.pages.length,
                onPageChanged: ref.read(onboardingControllerProvider.notifier).setPage,
                itemBuilder: (context, index) => OnboardingPageView(page: data.pages[index]),
              ),
            ),
            PageIndicator(count: data.pages.length, currentIndex: data.currentIndex),
            Padding(
              padding: const EdgeInsets.all(24),
              child: FilledButton(
                onPressed: data.isCompleting
                    ? null
                    : () async {
                        if (!data.isLastPage) {
                          await _pageController.nextPage(duration: const Duration(milliseconds: 260), curve: Curves.easeOut);
                          return;
                        }
                        final completed = await ref
                            .read(onboardingControllerProvider.notifier)
                            .complete();
                        if (completed && context.mounted) {
                          context.go(AppRoutes.permissions);
                        }
                      },
                child: data.isCompleting ? const CircularProgressIndicator() : Text((data.isLastPage ? 'common_continue' : 'common_next').tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
