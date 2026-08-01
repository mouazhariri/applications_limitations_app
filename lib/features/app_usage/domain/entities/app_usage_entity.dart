import 'dart:typed_data';

class AppUsageEntity {
  const AppUsageEntity({required this.packageName, required this.name, required this.usage, this.limit, this.iconBytes});

  final String packageName;
  final String name;
  final Duration usage;
  final Duration? limit;
  final Uint8List? iconBytes;

  Duration? get remaining {
    if (limit == null) return null;
    final remainingMs = (limit!.inMilliseconds - usage.inMilliseconds).clamp(0, limit!.inMilliseconds).toInt();
    return Duration(milliseconds: remainingMs);
  }
  bool get isLimited => limit != null;
  bool get isBlocked => limit != null && usage >= limit!;
}
