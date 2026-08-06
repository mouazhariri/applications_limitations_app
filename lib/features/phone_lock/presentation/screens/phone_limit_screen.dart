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

  static const _presets = [
    Duration(minutes: 30),
    Duration(hours: 1),
    Duration(hours: 2),
    Duration(hours: 3),
    Duration(hours: 4),
  ];

  static const _lockPresets = [
    Duration(minutes: 30),
    Duration(hours: 1),
    Duration(hours: 2),
    Duration(hours: 3),
    Duration(hours: 4),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(phoneLimitControllerProvider);
    final controller = ref.read(phoneLimitControllerProvider.notifier);

    return AppScaffold(
      title: 'phone_limit_title'.tr(),
      body: AsyncStateView(
        value: state,
        data: (data) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            _PhoneLimitHero(currentLimit: data.currentLimit),
            const SizedBox(height: 28),
            Text(
              'phone_limit_choose'.tr(),
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
                      isSelected: duration == data.currentLimit,
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
                    'phone_limit_custom'.tr(),
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
                    label: Text('phone_limit_save'.tr()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            _PhoneLockHero(currentLockDuration: data.currentLockDuration),
            const SizedBox(height: 28),
            Text(
              'phone_lock_choose'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'phone_lock_choose_desc'.tr(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _lockPresets
                  .map(
                    (duration) => LimitChoiceChip(
                      duration: duration,
                      isSelected: duration == data.currentLockDuration,
                      onSelected: () async {
                        if (!await ParentUnlockDialog.show(context)) return;
                        await controller.setLockDuration(duration);
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
                    'phone_lock_custom'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_clock_outlined),
                      suffixText: 'common_minutes'.tr(),
                    ),
                    onChanged: controller.updateCustomLockMinutes,
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: data.isSaving
                        ? null
                        : () async {
                            if (!await ParentUnlockDialog.show(context)) return;
                            await controller.setCustomLockDuration();
                          },
                    icon: const Icon(Icons.lock_clock_outlined),
                    label: Text('phone_lock_save'.tr()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhoneLimitHero extends StatelessWidget {
  const _PhoneLimitHero({required this.currentLimit});

  final Duration currentLimit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SectionCard(
      color: colorScheme.primaryContainer.withValues(alpha: 0.66),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.phone_android_rounded, color: colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'phone_limit_current'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            formatDurationCompact(currentLimit),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'phone_limit_explain'.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _PhoneLockHero extends StatelessWidget {
  const _PhoneLockHero({required this.currentLockDuration});

  final Duration currentLockDuration;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SectionCard(
      color: colorScheme.tertiaryContainer.withValues(alpha: 0.66),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.tertiary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.lock_clock_outlined, color: colorScheme.tertiary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'phone_lock_current'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            formatDurationCompact(currentLockDuration),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'phone_lock_explain'.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
