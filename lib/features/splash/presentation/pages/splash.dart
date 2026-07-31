// lib/features/splash/presentation/pages/splash.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:applications_limitations/gen/assets.gen.dart';
import 'package:applications_limitations/src/core/utils/extenssions/int_extenssion.dart';
import 'package:applications_limitations/src/resourses/color_manager/app_colors.dart';
import 'package:applications_limitations/src/resourses/font_manager/app_text_style.dart';

import '../controller/splash_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final splashAsync = ref.watch(splashControllerProvider);

    splashAsync.whenData((destination) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go(destination.route);
        }
      });
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // === Lottie Animation: Doctor with Headphones ===
                      Lottie.asset(
                        Assets.lottie.doctor,
                        width: 300,
                        height: 300,
                        fit: BoxFit.contain,
                        repeat: true,
                        animate: true,
                      ),
                  
                      50.verticalSpace,
                  
                      // === App Name ===
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          context.tr('appName'),
                          style: AppTextStyle.rubikBold22.copyWith(color: AppColors.primary)
                        ),
                      ),
                  
                      25.verticalSpace,
                  
                      // === Tagline ===
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          context.tr('splashSubtitle'),
                          style: AppTextStyle.rubikRegular20.copyWith(color: AppColors.black800),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  
                      // const SizedBox(height: 60),
                  
                      // // === Loading Indicator ===
                      // FadeTransition(
                      //   opacity: _fadeAnimation,
                      //   child: SizedBox(
                      //     width: 40,
                      //     height: 40,
                      //     child: CircularProgressIndicator(
                      //       valueColor: AlwaysStoppedAnimation<Color>(
                      //         Colors.white.withOpacity(0.8),
                      //       ),
                      //       strokeWidth: 3,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}