import 'dart:convert';

import '../../domain/entities/installed_app_entity.dart';

class InstalledAppModel extends InstalledAppEntity {
  const InstalledAppModel({required super.packageName, required super.name, super.iconBytes});

  factory InstalledAppModel.fromMap(Map<String, Object?> map) {
    final icon = map['icon'] as String?;
    return InstalledAppModel(
      packageName: (map['packageName'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      iconBytes: icon == null || icon.isEmpty ? null : base64Decode(icon),
    );
  }
}
