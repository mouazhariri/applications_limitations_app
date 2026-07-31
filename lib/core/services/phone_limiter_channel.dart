import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class PhoneLimiterChannel {
  PhoneLimiterChannel({MethodChannel? channel}) : _channel = channel ?? const MethodChannel('phone_limiter/native');

  final MethodChannel _channel;

  Future<Map<String, bool>> getPermissionStatuses() async {
    final result = await _invoke<Map<dynamic, dynamic>>('getPermissionStatuses', const <String, Object?>{}) ?? <dynamic, dynamic>{};
    return result.map((key, value) => MapEntry(key.toString(), value == true));
  }

  Future<void> openPermissionSettings(String permissionKey) async {
    await _invoke<void>('openPermissionSettings', <String, Object?>{'permission': permissionKey});
  }

  Future<List<Map<String, Object?>>> getInstalledApps() async {
    final result = await _invoke<List<dynamic>>('getInstalledApps', const <String, Object?>{}) ?? <dynamic>[];
    return result.cast<Map<dynamic, dynamic>>().map((item) => item.map((key, value) => MapEntry(key.toString(), value))).toList();
  }

  Future<List<Map<String, Object?>>> getUsageStats({int dayOffset = 0}) async {
    final result = await _invoke<List<dynamic>>('getUsageStats', <String, Object?>{'dayOffset': dayOffset}) ?? <dynamic>[];
    return result.cast<Map<dynamic, dynamic>>().map((item) => item.map((key, value) => MapEntry(key.toString(), value))).toList();
  }

  Future<void> startProtectionService() async {
    await _invoke<void>('startProtectionService', const <String, Object?>{});
  }

  Future<void> stopProtectionService() async {
    await _invoke<void>('stopProtectionService', const <String, Object?>{});
  }

  Future<void> showBlockOverlay({required String packageName, required String appName}) async {
    await _invoke<void>('showBlockOverlay', <String, Object?>{'packageName': packageName, 'appName': appName});
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
