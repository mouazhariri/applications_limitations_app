// lib/features/splash/presentation/controller/splash_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:applications_limitations/src/application/router/app_routes.dart';
import 'package:applications_limitations/src/infrastructure/storage/local_storage_service.dart';

part 'splash_controller.g.dart';

@riverpod
class SplashController extends _$SplashController {
  @override
  Future<ScreenDestination> build() async {
    // Simulate loading time for splash animation
    await Future.delayed(const Duration(milliseconds: 2500));
    return _checkUserStatus();
  }

  Future<ScreenDestination> _checkUserStatus() async {
    final storage = ref.read(localStorageServiceProvider);

    // Use .whenComplete to check synchronously after delay
    final isFirstTime = storage.isFirstTimeOpen();

    if (await isFirstTime) {
      return ScreenDestination(route: AppRoutes.onBoarding);
    }

    // TODO: Replace with auth check
    // final isAuth = await ref.read(isAuthenticatedProvider.future);
    // return isAuth
    //     ? ScreenDestination(route: AppRoutes.homeScreen)
    //     : ScreenDestination(route: AppRoutes.signInScreen);

    return ScreenDestination(route: AppRoutes.authScreen);
  }
}

class ScreenDestination {
  final String route;

  ScreenDestination({required this.route});
}