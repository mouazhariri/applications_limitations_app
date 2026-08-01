import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/service_locator.dart';

class ParentUnlockDialog extends ConsumerStatefulWidget {
  const ParentUnlockDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(context: context, barrierDismissible: false, builder: (_) => const ParentUnlockDialog()) ?? false;
  }

  @override
  ConsumerState<ParentUnlockDialog> createState() => _ParentUnlockDialogState();
}

class _ParentUnlockDialogState extends ConsumerState<ParentUnlockDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _isChecking = false;
  bool _hasError = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('parent_unlock_title'.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('parent_unlock_desc'.tr()),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            obscureText: true,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(errorText: _hasError ? 'parent_unlock_error'.tr() : null),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: _isChecking ? null : () => Navigator.of(context).pop(false), child: Text('common_cancel'.tr())),
        FilledButton(
          onPressed: _isChecking
              ? null
              : () async {
                  setState(() => _isChecking = true);
                  final result = await ref.read(verifySecurityCredentialUseCaseProvider)(_controller.text);
                  final valid = result.fold((_) => false, (value) => value);
                  if (!context.mounted) return;
                  if (valid) {
                    Navigator.of(context).pop(true);
                  } else {
                    setState(() {
                      _isChecking = false;
                      _hasError = true;
                    });
                  }
                },
          child: Text('parent_unlock_button'.tr()),
        ),
      ],
    );
  }
}
