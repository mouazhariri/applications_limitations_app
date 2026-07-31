import '../../domain/entities/permission_status_entity.dart';

class PermissionsState {
  const PermissionsState({required this.permissions, this.isOpeningSettings = false});

  final List<PermissionStatusEntity> permissions;
  final bool isOpeningSettings;

  bool get canContinue => permissions.where((permission) => permission.isRequired).every((permission) => permission.isGranted);

  PermissionsState copyWith({List<PermissionStatusEntity>? permissions, bool? isOpeningSettings}) {
    return PermissionsState(
      permissions: permissions ?? this.permissions,
      isOpeningSettings: isOpeningSettings ?? this.isOpeningSettings,
    );
  }
}
