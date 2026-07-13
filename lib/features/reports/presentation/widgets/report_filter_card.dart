import 'package:duty_track/features/reports/data/models/report_filter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportFilterCard extends StatelessWidget {
  const ReportFilterCard({
    super.key,
    required this.filter,
    required this.onOpenFilters,
    required this.onPickDateRange,
    required this.onClearFilters,
  });

  final ReportFilter filter;
  final VoidCallback onOpenFilters;
  final VoidCallback onPickDateRange;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy-MM-dd');

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.tune),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'نطاق التقرير والفلاتر',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                InputChip(
                  avatar: const Icon(Icons.date_range, size: 18),
                  label: Text(
                    '${formatter.format(filter.fromDate)} - ${formatter.format(filter.toDate)}',
                  ),
                  onPressed: onPickDateRange,
                ),
                if (_hasFilters(filter))
                  InputChip(
                    avatar: const Icon(Icons.filter_alt, size: 18),
                    label: const Text('فلاتر مخصصة'),
                    onDeleted: onClearFilters,
                  )
                else
                  const Chip(
                    avatar: Icon(Icons.filter_alt_off, size: 18),
                    label: Text('بدون فلاتر إضافية'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onOpenFilters,
                    icon: const Icon(Icons.filter_alt_outlined),
                    label: const Text('تعديل الفلاتر'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.outlined(
                  tooltip: 'مسح الفلاتر',
                  onPressed: _hasFilters(filter) ? onClearFilters : null,
                  icon: const Icon(Icons.filter_alt_off_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _hasFilters(ReportFilter filter) {
    return filter.locationId != null ||
        filter.postId != null ||
        filter.shiftId != null ||
        filter.missionTypeId != null ||
        filter.dutyStatus != null ||
        filter.departmentId != null ||
        filter.rankId != null ||
        filter.personnelId != null;
  }
}
