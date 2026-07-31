import '../../domain/entities/permission_status_entity.dart';

class PermissionStatusModel extends PermissionStatusEntity {
  const PermissionStatusModel({required super.key, required super.titleKey, required super.descriptionKey, required super.isGranted, required super.isRequired});

  factory PermissionStatusModel.fromNative(String key, bool granted) {
    final definitions = <String, ({String title, String desc, bool required})>{
      'usageAccess': (title: 'permission_usage_access_title', desc: 'permission_usage_access_desc', required: true),
      'accessibility': (title: 'permission_accessibility_title', desc: 'permission_accessibility_desc', required: true),
      'overlay': (title: 'permission_overlay_title', desc: 'permission_overlay_desc', required: true),
      'notification': (title: 'permission_notification_title', desc: 'permission_notification_desc', required: true),
      'battery': (title: 'permission_battery_title', desc: 'permission_battery_desc', required: true),
    };
    final definition = definitions[key] ?? (title: key, desc: key, required: true);
    return PermissionStatusModel(key: key, titleKey: definition.title, descriptionKey: definition.desc, isGranted: granted, isRequired: definition.required);
  }
}
