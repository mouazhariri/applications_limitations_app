import 'package:applications_limitations/src/core/services/phone_limiter_channel.dart';
import '../models/permission_status_model.dart';

abstract interface class PermissionsPlatformDataSource {
  Future<List<PermissionStatusModel>> getStatuses();
  Future<void> openSettings(String permissionKey);
}

class PermissionsPlatformDataSourceImpl implements PermissionsPlatformDataSource {
  PermissionsPlatformDataSourceImpl(this._channel);

  final PhoneLimiterChannel _channel;

  @override
  Future<List<PermissionStatusModel>> getStatuses() async {
    final nativeStatuses = await _channel.getPermissionStatuses();
    const order = ['usageAccess', 'accessibility', 'overlay', 'notification', 'battery'];
    return order.map((key) => PermissionStatusModel.fromNative(key, nativeStatuses[key] ?? false)).toList();
  }

  @override
  Future<void> openSettings(String permissionKey) => _channel.openPermissionSettings(permissionKey);
}
