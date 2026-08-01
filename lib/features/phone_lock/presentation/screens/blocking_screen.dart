import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:applications_limitations/src/core/di/service_locator.dart';
import '../../authentication/domain/entities/security_credential_entity.dart';
import '../../authentication/presentation/widgets/pattern_grid.dart';

/// Flutter fallback for the native blocking surface.
///
/// It mirrors the native screen: there is no bypass button. A valid parent
/// credential removes the route and grants the native policy's daily unlock.
class BlockingScreen extends ConsumerStatefulWidget {
  const BlockingScreen({
    super.key,
    required this.packageName,
    required this.appName,
    this.phoneLock = false,
  });

  final String packageName;
  final String appName;
  final bool phoneLock;

  @override
  ConsumerState<BlockingScreen> createState() => _BlockingScreenState();
}

class _BlockingScreenState extends ConsumerState<BlockingScreen> {
  final TextEditingController _pinController = TextEditingController();
  SecurityMode _mode = SecurityMode.pattern;
  String _pattern = '';
  bool _isChecking = false;
  bool _hasError = false;
  bool _canExit = false;

  @override
  void initState() {
    super.initState();
    final result = ref.read(getSecurityModeUseCaseProvider)();
    _mode = result.fold(
      (_) => SecurityMode.pattern,
      (mode) => mode ?? SecurityMode.pattern,
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _tryUnlock({bool showError = false}) async {
    if (_isChecking) return;
    final secret = _mode == SecurityMode.pattern ? _pattern : _pinController.text;
    if (secret.replaceAll('-', '').length < 4) return;

    setState(() => _isChecking = true);
    final result = await ref.read(verifySecurityCredentialUseCaseProvider)(secret);
    final valid = result.fold((_) => false, (value) => value);
    if (!mounted) return;

    if (valid) {
      await ref.read(phoneLimiterChannelProvider).grantParentUnlock(
            packageName: widget.packageName,
            phoneLock: widget.phoneLock,
          );
      setState(() => _canExit = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).pop();
      });
      return;
    }

    setState(() {
      _isChecking = false;
      _hasError = showError;
      if (showError) {
        _pattern = '';
        _pinController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canExit,
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0A1221), Color(0xFF172B4D)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: Container(
                  width: 420,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.16),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 42,
                        backgroundColor: Color(0xFF47B8FF),
                        child: Icon(Icons.lock_rounded, size: 42, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.appName,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'blocking_limit_reached'.tr(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _mode == SecurityMode.pattern
                            ? 'parent_unlock_pattern_desc'.tr()
                            : 'parent_unlock_desc'.tr(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 22),
                      if (_mode == SecurityMode.pattern)
                        _PatternUnlockPad(
                          value: _pattern,
                          isChecking: _isChecking,
                          onChanged: (value) async {
                            setState(() {
                              _pattern = value;
                              _hasError = false;
                            });
                            if (value.replaceAll('-', '').length == 9) {
                              await _tryUnlock(showError: true);
                            } else if (value.replaceAll('-', '').length >= 4) {
                              await _tryUnlock();
                            }
                          },
                        )
                      else
                        TextField(
                          controller: _pinController,
                          autofocus: true,
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                          onChanged: (value) {
                            if (value.length >= 4) {
                              _tryUnlock(showError: value.length >= 8);
                            }
                          },
                          onSubmitted: (_) => _tryUnlock(showError: true),
                          decoration: InputDecoration(
                            hintText: 'parent_unlock_desc'.tr(),
                            hintStyle: const TextStyle(color: Colors.white60),
                            fillColor: Colors.white.withValues(alpha: 0.1),
                            errorText: _hasError ? 'parent_unlock_error'.tr() : null,
                          ),
                        ),
                      if (_hasError && _mode == SecurityMode.pattern) ...[
                        const SizedBox(height: 12),
                        Text(
                          'parent_unlock_error'.tr(),
                          style: const TextStyle(color: Color(0xFFFFB4AB)),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PatternUnlockPad extends StatelessWidget {
  const _PatternUnlockPad({
    required this.value,
    required this.isChecking,
    required this.onChanged,
  });

  final String value;
  final bool isChecking;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isChecking,
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: const Color(0xFF47B8FF),
                surfaceContainerHighest: Colors.white.withValues(alpha: 0.12),
              ),
        ),
        child: PatternGrid(value: value, onChanged: onChanged),
      ),
    );
  }
}
