import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:applications_limitations/src/core/di/service_locator.dart';
import '../../domain/entities/security_credential_entity.dart';
import 'pattern_grid.dart';

/// Parent confirmation used before changing limits, protection, or policies.
/// It renders the same pattern interaction that was selected during setup.
class ParentUnlockDialog extends ConsumerStatefulWidget {
  const ParentUnlockDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => const ParentUnlockDialog(),
        ) ??
        false;
  }

  @override
  ConsumerState<ParentUnlockDialog> createState() => _ParentUnlockDialogState();
}

class _ParentUnlockDialogState extends ConsumerState<ParentUnlockDialog> {
  final TextEditingController _pinController = TextEditingController();
  SecurityMode _mode = SecurityMode.pattern;
  String _pattern = '';
  bool _isLoadingMode = true;
  bool _isChecking = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadMode();
  }

  Future<void> _loadMode() async {
    final result = ref.read(getSecurityModeUseCaseProvider)();
    if (!mounted) return;
    setState(() {
      _mode = result.fold(
        (_) => SecurityMode.pattern,
        (mode) => mode ?? SecurityMode.pattern,
      );
      _isLoadingMode = false;
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final secret = _mode == SecurityMode.pattern ? _pattern : _pinController.text;
    if (secret.replaceAll('-', '').length < 4) {
      setState(() => _hasError = true);
      return;
    }

    setState(() => _isChecking = true);
    final result = await ref.read(verifySecurityCredentialUseCaseProvider)(secret);
    final valid = result.fold((_) => false, (value) => value);
    if (!mounted) return;

    if (valid) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _isChecking = false;
      _hasError = true;
      _pattern = '';
      _pinController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.shield_rounded),
      title: Text('parent_unlock_title'.tr()),
      content: SizedBox(
        width: 320,
        child: _isLoadingMode
            ? const SizedBox(
                height: 150,
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _mode == SecurityMode.pattern
                        ? 'parent_unlock_pattern_desc'.tr()
                        : 'parent_unlock_desc'.tr(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  if (_mode == SecurityMode.pattern)
                    PatternGrid(
                      value: _pattern,
                      onChanged: (value) {
                        setState(() {
                          _pattern = value;
                          _hasError = false;
                        });
                      },
                    )
                  else
                    TextField(
                      controller: _pinController,
                      obscureText: true,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() => _hasError = false),
                      onSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        errorText: _hasError ? 'parent_unlock_error'.tr() : null,
                      ),
                    ),
                  if (_mode == SecurityMode.pattern && _hasError) ...[
                    const SizedBox(height: 8),
                    Text(
                      'parent_unlock_error'.tr(),
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: _isChecking ? null : () => Navigator.of(context).pop(false),
          child: Text('common_cancel'.tr()),
        ),
        FilledButton(
          onPressed: _isLoadingMode || _isChecking ? null : _submit,
          child: _isChecking
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('parent_unlock_button'.tr()),
        ),
      ],
    );
  }
}
