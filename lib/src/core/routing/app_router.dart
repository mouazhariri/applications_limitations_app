import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:applications_limitations/features/app_lock/presentation/screens/app_limit_screen.dart';
import 'package:applications_limitations/features/app_usage/presentation/screens/installed_apps_screen.dart';
import 'package:applications_limitations/features/app_usage/presentation/screens/usage_screen.dart';
import 'package:applications_limitations/features/authentication/presentation/screens/create_parent_security_screen.dart';
import 'package:applications_limitations/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:applications_limitations/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:applications_limitations/features/permissions/presentation/screens/permissions_screen.dart';
import 'package:applications_limitations/features/phone_lock/presentation/screens/blocking_screen.dart';
import 'package:applications_limitations/features/phone_lock/presentation/screens/phone_limit_screen.dart';
import 'package:applications_limitations/features/settings/presentation/screens/settings_screen.dart';
import '../di/service_locator.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.bootstrap,
    routes: [
      _smoothRoute(path: AppRoutes.bootstrap, builder: (context, state) => const _BootstrapScreen()),
      _smoothRoute(path: AppRoutes.onboarding, builder: (context, state) => const OnboardingScreen()),
      _smoothRoute(path: AppRoutes.permissions, builder: (context, state) => const PermissionsScreen()),
      _smoothRoute(path: AppRoutes.security, builder: (context, state) => const CreateParentSecurityScreen()),
      _smoothRoute(path: AppRoutes.dashboard, builder: (context, state) => const DashboardScreen()),
      _smoothRoute(path: AppRoutes.usage, builder: (context, state) => const UsageScreen()),
      _smoothRoute(path: AppRoutes.apps, builder: (context, state) => const InstalledAppsScreen()),
      _smoothRoute(path: AppRoutes.appLimit, builder: (context, state) {
        final packageName = Uri.decodeComponent(state.pathParameters['packageName'] ?? '');
        final appName = state.extra as String? ?? packageName;
        return AppLimitScreen(packageName: packageName, appName: appName);
      }),
      _smoothRoute(path: AppRoutes.phoneLimit, builder: (context, state) => const PhoneLimitScreen()),
      _smoothRoute(path: AppRoutes.settings, builder: (context, state) => const SettingsScreen()),
      _smoothRoute(path: AppRoutes.blocking, builder: (context, state) {
        final packageName = Uri.decodeComponent(state.pathParameters['packageName'] ?? '');
        return BlockingScreen(packageName: packageName, appName: state.extra as String? ?? packageName);
      }),
    ],
  );
});

/// Wraps every route in a smooth fade + subtle slide transition so navigation
/// between screens feels fluid instead of abruptly swapping pages.
GoRoute _smoothRoute({
  required String path,
  required Widget Function(BuildContext context, GoRouterState state) builder,
}) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) {
      return CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 280),
        reverseTransitionDuration: const Duration(milliseconds: 220),
        child: builder(context, state),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final offsetAnimation =
              Tween<Offset>(begin: const Offset(0, 0.02), end: Offset.zero)
                  .animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ));
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: offsetAnimation, child: child),
          );
        },
      );
    },
  );
}

class _BootstrapScreen extends ConsumerStatefulWidget {
  const _BootstrapScreen();

  @override
  ConsumerState<_BootstrapScreen> createState() => _BootstrapScreenState();
}

class _BootstrapScreenState extends ConsumerState<_BootstrapScreen> {
  @override
  void initState() {
    super.initState();
    // Start the native protection service so limits keep being enforced in the
    // background even after the user closes the app.
    ref.read(phoneLimiterChannelProvider).startProtectionService();
    WidgetsBinding.instance.addPostFrameCallback((_) => _route());
  }

  Future<void> _route() async {
    final onboarding = ref.read(getOnboardingStatusUseCaseProvider)().fold((_) => false, (value) => value);
    final hasSecurity = ref.read(hasSecurityCredentialUseCaseProvider)().fold((_) => false, (value) => value);
    if (!onboarding) {
      if (mounted) context.go(AppRoutes.onboarding);
      return;
    }
    final permissionResult = await ref.read(getPermissionStatusesUseCaseProvider)();
    final permissionsReady = permissionResult.fold((_) => false, (items) => items.where((item) => item.isRequired).every((item) => item.isGranted));
    if (!permissionsReady) {
      if (mounted) context.go(AppRoutes.permissions);
    } else if (!hasSecurity) {
      if (mounted) context.go(AppRoutes.security);
    } else {
      if (mounted) context.go(AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: CircularProgressIndicator()));
}
