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
      GoRoute(path: AppRoutes.bootstrap, builder: (context, state) => const _BootstrapScreen()),
      GoRoute(path: AppRoutes.onboarding, builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: AppRoutes.permissions, builder: (context, state) => const PermissionsScreen()),
      GoRoute(path: AppRoutes.security, builder: (context, state) => const CreateParentSecurityScreen()),
      GoRoute(path: AppRoutes.dashboard, builder: (context, state) => const DashboardScreen()),
      GoRoute(path: AppRoutes.usage, builder: (context, state) => const UsageScreen()),
      GoRoute(path: AppRoutes.apps, builder: (context, state) => const InstalledAppsScreen()),
      GoRoute(path: AppRoutes.appLimit, builder: (context, state) {
        final packageName = Uri.decodeComponent(state.pathParameters['packageName'] ?? '');
        final appName = state.extra as String? ?? packageName;
        return AppLimitScreen(packageName: packageName, appName: appName);
      }),
      GoRoute(path: AppRoutes.phoneLimit, builder: (context, state) => const PhoneLimitScreen()),
      GoRoute(path: AppRoutes.settings, builder: (context, state) => const SettingsScreen()),
      GoRoute(path: AppRoutes.blocking, builder: (context, state) {
        final packageName = Uri.decodeComponent(state.pathParameters['packageName'] ?? '');
        return BlockingScreen(packageName: packageName, appName: state.extra as String? ?? packageName);
      }),
    ],
  );
});

class _BootstrapScreen extends ConsumerStatefulWidget {
  const _BootstrapScreen();

  @override
  ConsumerState<_BootstrapScreen> createState() => _BootstrapScreenState();
}

class _BootstrapScreenState extends ConsumerState<_BootstrapScreen> {
  @override
  void initState() {
    super.initState();
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
