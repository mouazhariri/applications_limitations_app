import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';

/// Native Android policy state for uninstall protection.
///
/// Android only permits an app to block uninstallation when it is provisioned
/// as a Device Owner or Profile Owner. A normal Device Admin cannot intercept
/// or replace Android's uninstall confirmation dialog.
class UninstallProtectionStatus {
  const UninstallProtectionStatus({
    required this.isDeviceAdminActive,
    required this.isDeviceOwner,
    required this.isProfileOwner,
    required this.canBlockUninstall,
    required this.isUninstallBlocked,
  });

  const UninstallProtectionStatus.unavailable()
      : isDeviceAdminActive = false,
        isDeviceOwner = false,
        isProfileOwner = false,
        canBlockUninstall = false,
        isUninstallBlocked = false;

  final bool isDeviceAdminActive;
  final bool isDeviceOwner;
  final bool isProfileOwner;
  final bool canBlockUninstall;
  final bool isUninstallBlocked;

  factory UninstallProtectionStatus.fromMap(Map<dynamic, dynamic> map) {
    bool value(String key) => map[key] == true;
    return UninstallProtectionStatus(
      isDeviceAdminActive: value('isDeviceAdminActive'),
      isDeviceOwner: value('isDeviceOwner'),
      isProfileOwner: value('isProfileOwner'),
      canBlockUninstall: value('canBlockUninstall'),
      isUninstallBlocked: value('isUninstallBlocked'),
    );
  }
}

class PhoneLimiterChannel {
  PhoneLimiterChannel({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel('phone_limiter/native');

  final MethodChannel _channel;

  Future<Map<String, bool>> getPermissionStatuses() async {
    final result = await _invoke<Map<dynamic, dynamic>>(
          'getPermissionStatuses',
          const <String, Object?>{},
        ) ??
        <dynamic, dynamic>{};
    return result.map((key, value) => MapEntry(key.toString(), value == true));
  }

  Future<void> openPermissionSettings(String permissionKey) async {
    await _invoke<void>(
      'openPermissionSettings',
      <String, Object?>{'permission': permissionKey},
    );
  }

  Future<List<Map<String, Object?>>> getInstalledApps() async {
    final result = await _invoke<List<dynamic>>(
          'getInstalledApps',
          const <String, Object?>{},
        ) ??
        <dynamic>[];
    return result
        .cast<Map<dynamic, dynamic>>()
        .map(
          (item) => item.map(
            (key, value) => MapEntry(key.toString(), value),
          ),
        )
        .toList();
  }

  Future<List<Map<String, Object?>>> getUsageStats({int dayOffset = 0}) async {
    final result = await _invoke<List<dynamic>>(
          'getUsageStats',
          <String, Object?>{'dayOffset': dayOffset},
        ) ??
        <dynamic>[];
    return result
        .cast<Map<dynamic, dynamic>>()
        .map(
          (item) => item.map(
            (key, value) => MapEntry(key.toString(), value),
          ),
        )
        .toList();
  }

  Future<void> startProtectionService() async {
    await _invoke<void>('startProtectionService', const <String, Object?>{});
  }

  Future<void> stopProtectionService() async {
    await _invoke<void>('stopProtectionService', const <String, Object?>{});
  }

  Future<void> showBlockOverlay({
    required String packageName,
    required String appName,
  }) async {
    await _invoke<void>(
      'showBlockOverlay',
      <String, Object?>{'packageName': packageName, 'appName': appName},
    );
  }

  Future<UninstallProtectionStatus> getUninstallProtectionStatus() async {
    final result = await _invoke<Map<dynamic, dynamic>>(
      'getUninstallProtectionStatus',
      const <String, Object?>{},
    );
    return result == null
        ? const UninstallProtectionStatus.unavailable()
        : UninstallProtectionStatus.fromMap(result);
  }

  /// Opens Android's Device Admin confirmation surface when it is not active.
  Future<void> requestDeviceAdmin() async {
    await _invoke<void>('requestDeviceAdmin', const <String, Object?>{});
  }

  /// Enables or disables Device Owner/Profile Owner uninstall blocking.
  Future<UninstallProtectionStatus> setUninstallProtection(bool enabled) async {
    final result = await _invoke<Map<dynamic, dynamic>>(
      'setUninstallProtection',
      <String, Object?>{'enabled': enabled},
    );
    return result == null
        ? const UninstallProtectionStatus.unavailable()
        : UninstallProtectionStatus.fromMap(result);
  }

  Uint8List? decodeIcon(String? base64Icon) {
    if (base64Icon == null || base64Icon.isEmpty) return null;
    return base64Decode(base64Icon);
  }

  Future<T?> _invoke<T>(String method, Map<String, Object?> arguments) async {
    try {
      return await _channel.invokeMethod<T>(method, arguments);
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }
}
