import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../authentication/presentation/widgets/parent_unlock_dialog.dart';

class BlockingScreen extends StatelessWidget {
  const BlockingScreen({super.key, required this.packageName, required this.appName});

  final String packageName;
  final String appName;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.error]),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_rounded, size: 104, color: Colors.white),
                  const SizedBox(height: 24),
                  Text(appName, style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white), textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Text('blocking_limit_reached'.tr(), style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text('blocking_come_back'.tr(), style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70), textAlign: TextAlign.center),
                  const SizedBox(height: 32),
                  FilledButton.tonal(
                    onPressed: () async {
                      final unlocked = await ParentUnlockDialog.show(context);
                      if (unlocked && context.mounted) Navigator.of(context).maybePop();
                    },
                    child: Text('blocking_unlock_parent'.tr()),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white70)),
                    onPressed: () => const MethodChannel('phone_limiter/native').invokeMethod<void>('openEmergencyDialer'),
                    icon: const Icon(Icons.emergency_rounded),
                    label: Text('blocking_emergency'.tr()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
