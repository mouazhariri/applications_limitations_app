import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:applications_limitations/src/core/shared/widgets/app_scaffold.dart';
import 'package:applications_limitations/src/core/shared/widgets/async_state_view.dart';
import 'package:applications_limitations/src/core/shared/widgets/section_card.dart';
import 'package:applications_limitations/src/core/utils/duration_formatter.dart';
import '../../../authentication/presentation/widgets/parent_unlock_dialog.dart';
import '../controller/app_limit_controller.dart';
import '../widgets/limit_choice_chip.dart';

class AppLimitScreen extends ConsumerWidget {
  const AppLimitScreen({super.key, required this.packageName, required this.appName});

  final String packageName;
  final String appName;

  static const _presets = [Duration(minutes: 20), Duration(minutes: 30), Duration(minutes: 45), Duration(minutes: 60), Duration(hours: 2)];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
  appLimitControllerProvider(
 packageName: packageName, appName: appName
  ),
);

final provider = ref.read(
  appLimitControllerProvider(
 packageName: packageName, appName: appName
  ).notifier,
);
    // final provider = appLimitControllerProvider((packageName: packageName, appName: appName));
    // final state = ref.watch(provider);
    return AppScaffold(
      title: 'app_limit_title'.tr(),
      body: AsyncStateView(
        value: state,
        data: (data) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SectionCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(data!.appName, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(packageName, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),
                Text(data.currentLimit == null ? 'app_limit_none'.tr() : 'app_limit_current'.tr(args: [formatDurationCompact(data.currentLimit!)])),
              ]),
            ),
            const SizedBox(height: 24),
            Text('app_limit_choose'.tr(), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _presets.map((duration) => LimitChoiceChip(
                    duration: duration,
                    isSelected: data.currentLimit == duration,
                    onSelected: () async {
                      if (!await ParentUnlockDialog.show(context)) return;
                      await provider.setLimit(duration);
                    },
                  )).toList(),
            ),
            const SizedBox(height: 24),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'app_limit_custom_minutes'.tr(), suffixText: 'common_minutes'.tr()),
              onChanged: provider.updateCustomMinutes,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: data.isSaving
                  ? null
                  : () async {
                      if (!await ParentUnlockDialog.show(context)) return;
                      await provider.setCustomLimit();
                    },
              child: Text('app_limit_save'.tr()),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: data.currentLimit == null || data.isSaving
                  ? null
                  : () async {
                      if (!await ParentUnlockDialog.show(context)) return;
                      await provider.removeLimit();
                    },
              child: Text('app_limit_remove'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
