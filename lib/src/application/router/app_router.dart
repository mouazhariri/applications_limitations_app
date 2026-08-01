import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:applications_limitations/features/splash/presentation/pages/on_boarding.dart';
import 'package:applications_limitations/features/splash/presentation/pages/splash.dart';

import 'app_routes.dart';
import 'custom_navigation_observer.dart';
import 'fallback_screen.dart';

final GlobalKey<NavigatorState> rootKey = GlobalKey<NavigatorState>();

class AppRouter {
  final GoRouter goRouter;

  AppRouter(Ref ref) : goRouter = _createRouter(ref);

  static GoRouter _createRouter(Ref ref) {
    return GoRouter(
      navigatorKey: rootKey,
      initialLocation: AppRoutes.splashScreen,
      observers: [CustomNavigationObserver()],
      errorBuilder: (context, state) => const FallbackScreen(),
      routes: <RouteBase>[
        // ── Splash & onboarding ─────────────────────────────────────────────
        _fadeRoute(
          path: AppRoutes.splashScreen,
          builder: (context, state) => const SplashScreen(),
        ),
        _fadeRoute(
          path: AppRoutes.onBoarding,
          builder: (context, state) => const OnBoardingScreen(),
        ),

        // // ── Auth ────────────────────────────────────────────────────────────
        // _fadeRoute(
        //   path: AppRoutes.authScreen,
        //   builder: (context, state) => const AuthLandingScreen(),
        // ),
        // _fadeRoute(
        //   path: AppRoutes.signInScreen,
        //   builder: (context, state) => const SignInScreen(),
        // ),
        // _fadeRoute(
        //   path: AppRoutes.signUpScreen,
        //   builder: (context, state) => const SignupScreen(),
        // ),
        // _fadeRoute(
        //   path: AppRoutes.verificationScreen,
        //   builder: (context, state) => VerificationAccountScreen(
        //     phone: state.extra is String ? state.extra as String : '',
        //   ),
        // ),

        // // ── Main tabs ───────────────────────────────────────────────────────
        // _fadeRoute(
        //   path: AppRoutes.homeScreen,
        //   builder: (context, state) =>
        //       const MainScaffold(currentIndex: 0, child: HomeScreen()),
        // ),
        // _fadeRoute(
        //   path: AppRoutes.doctorsScreen,
        //   builder: (context, state) =>
        //       const MainScaffold(currentIndex: 1, child: DoctorsScreen()),
        // ),
        // _fadeRoute(
        //   path: AppRoutes.appointmentsScreen,
        //   builder: (context, state) =>
        //       const MainScaffold(currentIndex: 2, child: AppointmentsScreen()),
        // ),
        // _fadeRoute(
        //   path: AppRoutes.profileScreen,
        //   builder: (context, state) =>
        //       const MainScaffold(currentIndex: 3, child: ProfileScreen()),
        // ),

        // // ── Doctor details ──────────────────────────────────────────────────
        // _fadeRoute(
        //   path: AppRoutes.doctorDetailsScreen,
        //   builder: (context, state) {
        //     final doctor = state.extra;
        //     if (doctor is! Doctor) return const FallbackScreen();
        //     return DoctorDetailsScreen(doctor: doctor);
        //   },
        // ),

        // // ── Booking ─────────────────────────────────────────────────────────
        // _fadeRoute(
        //   path: AppRoutes.bookAppointmentScreen,
        //   builder: (context, state) {
        //     final extra = state.extra;
        //     if (extra is! Map) return const FallbackScreen();
        //     final doctor = extra['doctor'];
        //     if (doctor is! Doctor) return const FallbackScreen();
        //     return BookingScreen(doctor: doctor);
        //   },
        // ),


      ],
    );
  }

  static GoRoute _fadeRoute({
    required String path,
    required Widget Function(BuildContext context, GoRouterState state) builder,
  }) {
    return GoRoute(
      path: path,
      parentNavigatorKey: rootKey,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: builder(context, state),
          transitionDuration: const Duration(milliseconds: 250),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    );
  }
}
