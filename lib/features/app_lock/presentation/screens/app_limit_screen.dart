import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:applications_limitations/src/core/shared/widgets/app_scaffold.dart';
import 'package:applications_limitations/src/core/shared/widgets/async_state_view.dart';
import 'package:applications_limitations/src/core/shared/widgets/section_card.dart';
import 'package:applications_limitations/src/core/utils/duration_formatter.dart';
import '../../../authentication/presentation/widgets/parent_unlock_dialog.dart';
import '../controller/app_limit_controller.dart';
import '../controller/app_limit_state.dart';
import '../widgets/limit_choice_chip.dart';

class AppLimitScreen extends ConsumerWidget {
  const AppLimitScreen({
    super.key,
    required this.packageName,
    required this.appName,
  });

  final String packageName;
  final String appName;

  static const _presets = [
    Duration(minutes: 20),
    Duration(minutes: 30),
    Duration(minutes: 45),
    Duration(minutes: 60),
    Duration(hours: 2),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerProvider = appLimitControllerProvider(
      packageName: packageName,
      appName: appName,
    );
    final state = ref.watch(controllerProvider);
    final controller = ref.read(controllerProvider.notifier);

    return AppScaffold(
      title: 'app_limit_title'.tr(),
      body: AsyncStateView(
        value: state,
        data: (data) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            _AppLimitHero(data: data),
            const SizedBox(height: 28),
            Text(
              'app_limit_choose'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _presets
                  .map(
                    (duration) => LimitChoiceChip(
                      duration: duration,
                      isSelected: data.currentLimit == duration,
                      onSelected: () async {
                        if (!await ParentUnlockDialog.show(context)) return;
                        await controller.setLimit(duration);
                      },
                    ),
                  )
                  .toList(growable: false),
            ),
            const SizedBox(height: 28),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'app_limit_custom_minutes'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.timer_outlined),
                      suffixText: 'common_minutes'.tr(),
                    ),
                    onChanged: controller.updateCustomMinutes,
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: data.isSaving
                        ? null
                        : () async {
                            if (!await ParentUnlockDialog.show(context)) return;
                            await controller.setCustomLimit();
                          },
                    icon: const Icon(Icons.check_rounded),
                    label: Text('app_limit_save'.tr()),
                  ),
                ],
              ),
            ),
            if (data.currentLimit != null) ...[
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: data.isSaving
                    ? null
                    : () async {
                        if (!await ParentUnlockDialog.show(context)) return;
                        await controller.removeLimit();
                      },
                icon: const Icon(Icons.delete_outline_rounded),
                label: Text('app_limit_remove'.tr()),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AppLimitHero extends StatelessWidget {
  const _AppLimitHero({required this.data});

  final AppLimitState data;

  @override
  Widget build(BuildContext context) {
    final hasLimit = data.currentLimit != null;
    final colorScheme = Theme.of(context).colorScheme;
    return SectionCard(
      color: colorScheme.primaryContainer.withValues(alpha: 0.66),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(Icons.apps_rounded, color: colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.appName, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 3),
                Text(
                  hasLimit
                      ? 'app_limit_current'.tr(
                          args: [formatDurationCompact(data.currentLimit!)],
                        )
                      : 'app_limit_none'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
