import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/shared/widgets/app_scaffold.dart';
import '../../../../core/shared/widgets/async_state_view.dart';
import '../controller/permissions_controller.dart';
import '../widgets/permission_tile.dart';

class PermissionsScreen extends ConsumerWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(permissionsControllerProvider);
    return AppScaffold(
      title: 'permissions_title'.tr(),
      showBackButton: Navigator.of(context).canPop(),
      actions: [IconButton(onPressed: () => ref.read(permissionsControllerProvider.notifier).refresh(), icon: const Icon(Icons.refresh_rounded))],
      body: AsyncStateView(
        value: state,
        onRetry: () => ref.read(permissionsControllerProvider.notifier).refresh(),
        data: (data) => ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: data.permissions.length + 2,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Text('permissions_intro'.tr(), style: Theme.of(context).textTheme.bodyLarge);
            }
            if (index == data.permissions.length + 1) {
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: FilledButton(
                  onPressed: data.canContinue
                      ? () {
                          if (Navigator.of(context).canPop()) {
                            context.pop();
                          } else {
                            final hasSecurity = ref.read(hasSecurityCredentialUseCaseProvider)().fold((_) => false, (value) => value);
                            context.go(hasSecurity ? AppRoutes.dashboard : AppRoutes.security);
                          }
                        }
                      : null,
                  child: Text('common_continue'.tr()),
                ),
              );
            }
            final permission = data.permissions[index - 1];
            return PermissionTile(
              permission: permission,
              onOpen: () async {
                await ref.read(permissionsControllerProvider.notifier).openSettings(permission.key);
              },
            );
          },
        ),
      ),
    );
  }
}
