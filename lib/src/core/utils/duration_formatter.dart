import 'package:easy_localization/easy_localization.dart';

String formatDurationCompact(Duration duration) {
  final totalMinutes = duration.inMinutes;
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;
  final hourUnit = 'unit_hours_short'.tr();
  final minuteUnit = 'unit_minutes_short'.tr();
  if (hours == 0) return '$minutes$minuteUnit';
  if (minutes == 0) return '$hours$hourUnit';
  return '$hours$hourUnit $minutes$minuteUnit';
}
