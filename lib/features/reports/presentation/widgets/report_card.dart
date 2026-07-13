import 'package:duty_track/core/constants/app_colors.dart';
import 'package:duty_track/features/reports/providers/reports_provider.dart';
import 'package:flutter/material.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({
    super.key,
    required this.reportType,
    required this.selected,
    required this.onSelected,
  });

  final ReportType reportType;
  final bool selected;
  final ValueChanged<ReportType> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: selected ? 3 : 1,
      child: InkWell(
        onTap: () => onSelected(reportType),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? colorScheme.primary : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: selected
                    ? colorScheme.primary
                    : colorScheme.primaryContainer,
                foregroundColor: selected
                    ? colorScheme.onPrimary
                    : colorScheme.onPrimaryContainer,
                child: Icon(_iconFor(reportType)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reportType.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      reportType.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected) ...[
                const SizedBox(width: 8),
                Icon(Icons.check_circle, color: colorScheme.primary),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFor(ReportType type) {
    return switch (type) {
      ReportType.humanResources => Icons.groups_outlined,
      ReportType.duty => Icons.event_note_outlined,
      ReportType.mission => Icons.assignment_outlined,
      ReportType.leave => Icons.beach_access_outlined,
      ReportType.training => Icons.school_outlined,
      ReportType.executive => Icons.dashboard_outlined,
    };
  }
}
