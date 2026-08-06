import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:applications_limitations/src/core/utils/duration_formatter.dart';
import '../../domain/entities/dashboard_snapshot_entity.dart';

class UsageSummaryCard extends StatelessWidget {
  const UsageSummaryCard({super.key, required this.snapshot});

  final DashboardSnapshotEntity snapshot;

  @override
  Widget build(BuildContext context) {
    final progress = snapshot.phoneLimit.inMilliseconds == 0
        ? 0.0
        : (snapshot.todayUsage.inMilliseconds /
                snapshot.phoneLimit.inMilliseconds)
            .clamp(0.0, 1.0)
            .toDouble();
    final colors = snapshot.isPhoneLocked
        ? const [Color(0xFFB42318), Color(0xFFEF6820)]
        : const [Color(0xFF174EA6), Color(0xFF2D7FF9)];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: colors.last.withValues(alpha: 0.28),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.insights_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'dashboard_today_screen_time'.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            formatDurationCompact(snapshot.todayUsage),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 40,
                ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              color: Colors.white,
              backgroundColor: Colors.white.withValues(alpha: 0.22),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  title: 'dashboard_remaining'.tr(),
                  value: formatDurationCompact(snapshot.remaining),
                ),
              ),
              Container(width: 1, height: 42, color: Colors.white24),
              Expanded(
                child: _Metric(
                  title: 'dashboard_daily_limit'.tr(),
                  value: formatDurationCompact(snapshot.phoneLimit),
                  alignment: CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.title,
    required this.value,
    this.alignment = CrossAxisAlignment.start,
  });

  final String title;
  final String value;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
        ),
      ],
    );
  }
}
