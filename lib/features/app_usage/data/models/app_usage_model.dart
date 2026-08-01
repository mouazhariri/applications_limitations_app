import 'dart:convert';

import '../../domain/entities/app_usage_entity.dart';

class AppUsageModel extends AppUsageEntity {
  const AppUsageModel({required super.packageName, required super.name, required super.usage, super.limit, super.iconBytes});

  factory AppUsageModel.fromMap(Map<String, Object?> map, {Duration? limit}) {
    final icon = map['icon'] as String?;
    return AppUsageModel(
      packageName: (map['packageName'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      usage: Duration(milliseconds: ((map['usageMs'] ?? 0) as num).toInt()),
      limit: limit,
      iconBytes: icon == null || icon.isEmpty ? null : base64Decode(icon),
    );
  }
}
