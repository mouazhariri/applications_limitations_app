import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:applications_limitations/src/core/shared/widgets/section_card.dart';
import 'package:applications_limitations/src/core/utils/duration_formatter.dart';
import '../controller/usage_state.dart';

/// Seven-day screen-time chart built with Flutter primitives, so it does not
/// add a chart package or a second state source to the app.
class UsageWeekChart extends StatelessWidget {
  const UsageWeekChart({
    super.key,
    required this.days,
  });

  final List<UsageDaySummary> days;

  @override
  Widget build(BuildContext context) {
    final orderedDays = days.reversed.toList(growable: false);
    final colorScheme = Theme.of(context).colorScheme;
    final maxUsage = orderedDays.fold<Duration>(
      Duration.zero,
      (current, day) => current > day.total ? current : day.total,
    );

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'usage_weekly_chart'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'usage_weekly_chart_desc'.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Semantics(
            label: 'usage_weekly_chart_semantics'.tr(
              args: [formatDurationCompact(maxUsage)],
            ),
            child: ExcludeSemantics(
              child: SizedBox(
                height: 154,
                width: double.infinity,
                child: CustomPaint(
                  painter: _UsageWeekChartPainter(
                    days: orderedDays,
                    barColor: colorScheme.primary,
                    gridColor: colorScheme.outlineVariant,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: orderedDays
                .map(
                  (day) => Expanded(
                    child: Text(
                      _weekdayLabel(context, day.dayOffset),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }

  String _weekdayLabel(BuildContext context, int dayOffset) {
    final day = DateTime.now().subtract(Duration(days: dayOffset));
    return DateFormat.E(context.locale.toString()).format(day);
  }
}

class _UsageWeekChartPainter extends CustomPainter {
  const _UsageWeekChartPainter({
    required this.days,
    required this.barColor,
    required this.gridColor,
  });

  final List<UsageDaySummary> days;
  final Color barColor;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = gridColor.withOpacity(0.55)
      ..strokeWidth = 1;
    final barPaint = Paint()..color = barColor;
    const gridLines = 4;

    for (var line = 0; line <= gridLines; line++) {
      final y = size.height * line / gridLines;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (days.isEmpty) return;

    final maxMilliseconds = days.fold<int>(
      1,
      (maximum, day) => math.max(maximum, day.total.inMilliseconds).toInt(),
    );
    final slotWidth = size.width / days.length;
    final barWidth = math.min(30.0, slotWidth * 0.58).toDouble();

    for (var index = 0; index < days.length; index++) {
      final ratio = days[index].total.inMilliseconds / maxMilliseconds;
      final barHeight = math
          .max(ratio * size.height, days[index].total == Duration.zero ? 0.0 : 3.0)
          .toDouble();
      final left = index * slotWidth + (slotWidth - barWidth) / 2;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, size.height - barHeight, barWidth, barHeight),
        const Radius.circular(8),
      );
      canvas.drawRRect(rect, barPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _UsageWeekChartPainter oldDelegate) {
    return oldDelegate.days != days ||
        oldDelegate.barColor != barColor ||
        oldDelegate.gridColor != gridColor;
  }
}
