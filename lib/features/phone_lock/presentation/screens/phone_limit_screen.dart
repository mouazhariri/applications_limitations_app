import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:applications_limitations/src/core/shared/widgets/app_scaffold.dart';
import 'package:applications_limitations/src/core/shared/widgets/async_state_view.dart';
import 'package:applications_limitations/src/core/shared/widgets/section_card.dart';
import 'package:applications_limitations/src/core/utils/duration_formatter.dart';
import '../../../app_lock/presentation/widgets/limit_choice_chip.dart';
import '../../../authentication/presentation/widgets/parent_unlock_dialog.dart';
import '../controller/phone_limit_controller.dart';

class PhoneLimitScreen extends ConsumerWidget {
  const PhoneLimitScreen({super.key});

  static const _presets = [Duration(minutes: 30), Duration(hours: 1), Duration(hours: 2), Duration(hours: 3), Duration(hours: 4)];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(phoneLimitControllerProvider);
    return AppScaffold(
      title: 'phone_limit_title'.tr(),
      body: AsyncStateView(
        value: state,
        data: (data) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('phone_limit_current'.tr(), style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text(formatDurationCompact(data.currentLimit), style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text('phone_limit_explain'.tr()),
            ])),
            const SizedBox(height: 24),
            Wrap(spacing: 10, runSpacing: 10, children: _presets.map((duration) => LimitChoiceChip(duration: duration, isSelected: duration == data.currentLimit, onSelected: () async {
              if (!await ParentUnlockDialog.show(context)) return;
              await ref.read(phoneLimitControllerProvider.notifier).setLimit(duration);
            })).toList()),
            const SizedBox(height: 24),
            TextField(keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'phone_limit_custom'.tr(), suffixText: 'common_minutes'.tr()), onChanged: ref.read(phoneLimitControllerProvider.notifier).updateCustomMinutes),
            const SizedBox(height: 12),
            FilledButton(onPressed: data.isSaving ? null : () async {
              if (!await ParentUnlockDialog.show(context)) return;
              await ref.read(phoneLimitControllerProvider.notifier).setCustomLimit();
            }, child: Text('phone_limit_save'.tr())),
          ],
        ),
      ),
    );
  }
}
