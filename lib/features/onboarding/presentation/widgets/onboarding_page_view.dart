import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/onboarding_page_entity.dart';

class OnboardingPageView extends StatelessWidget {
  const OnboardingPageView({super.key, required this.page});

  final OnboardingPageEntity page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.92, end: 1),
            duration: const Duration(milliseconds: 420),
            builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]),
              ),
              child: Icon(page.icon, color: Colors.white, size: 64),
            ),
          ),
          const SizedBox(height: 36),
          Text(page.titleKey.tr(), style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(page.descriptionKey.tr(), style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
