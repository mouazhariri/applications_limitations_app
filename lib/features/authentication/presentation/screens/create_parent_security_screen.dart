import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/shared/widgets/app_scaffold.dart';
import '../../../../core/shared/widgets/async_state_view.dart';
import '../../domain/entities/security_credential_entity.dart';
import '../controller/security_controller.dart';
import '../widgets/pattern_grid.dart';

class CreateParentSecurityScreen extends ConsumerWidget {
  const CreateParentSecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(securityControllerProvider);
    return AppScaffold(
      title: 'security_title'.tr(),
      showBackButton: Navigator.of(context).canPop(),
      body: AsyncStateView(
        value: state,
        data: (data) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('security_intro'.tr(), style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 20),
            SegmentedButton<SecurityMode>(
              segments: [
                ButtonSegment(value: SecurityMode.pin, icon: const Icon(Icons.pin_rounded), label: Text('security_pin'.tr())),
                ButtonSegment(value: SecurityMode.pattern, icon: const Icon(Icons.pattern_rounded), label: Text('security_pattern'.tr())),
              ],
              selected: {data.mode},
              onSelectionChanged: (selected) => ref.read(securityControllerProvider.notifier).changeMode(selected.first),
            ),
            const SizedBox(height: 24),
            if (data.mode == SecurityMode.pin) ...[
              TextField(
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 8,
                decoration: InputDecoration(labelText: 'security_enter_pin'.tr()),
                onChanged: ref.read(securityControllerProvider.notifier).updateSecret,
              ),
              const SizedBox(height: 12),
              TextField(
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 8,
                decoration: InputDecoration(labelText: 'security_confirm_pin'.tr()),
                onChanged: ref.read(securityControllerProvider.notifier).updateConfirmSecret,
              ),
            ] else ...[
              Text('security_draw_pattern'.tr(), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              PatternGrid(value: data.secret, onChanged: ref.read(securityControllerProvider.notifier).updateSecret),
              const SizedBox(height: 16),
              Text('security_confirm_pattern'.tr(), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              PatternGrid(value: data.confirmSecret, onChanged: ref.read(securityControllerProvider.notifier).updateConfirmSecret),
            ],
            if (data.errorKey != null) ...[
              const SizedBox(height: 12),
              Text(data.errorKey!.tr(), style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: data.isSaving
                  ? null
                  : () async {
                      final saved = await ref.read(securityControllerProvider.notifier).save();
                      if (saved && context.mounted) {
                        if (Navigator.of(context).canPop()) {
                          context.pop();
                        } else {
                          context.go(AppRoutes.dashboard);
                        }
                      }
                    },
              child: data.isSaving ? const CircularProgressIndicator() : Text('security_create'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
