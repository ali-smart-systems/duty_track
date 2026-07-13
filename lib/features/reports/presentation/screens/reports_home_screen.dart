import 'package:duty_track/features/reports/presentation/screens/report_filter_screen.dart';
import 'package:duty_track/features/reports/presentation/screens/report_preview_screen.dart';
import 'package:duty_track/features/reports/presentation/widgets/report_card.dart';
import 'package:duty_track/features/reports/presentation/widgets/report_filter_card.dart';
import 'package:duty_track/features/reports/presentation/widgets/summary_card.dart';
import 'package:duty_track/features/reports/data/models/report_result.dart';
import 'package:duty_track/features/reports/providers/reports_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportsHomeScreen extends ConsumerWidget {
  const ReportsHomeScreen({super.key});

  static const double _maxContentWidth = 1100;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reportsControllerProvider);
    final controller = ref.read(reportsControllerProvider.notifier);
    final result = state.result.valueOrNull;
    final isLoading = state.result.isLoading;

    ref.listen<ReportsState>(reportsControllerProvider, (previous, next) {
      if (next.result.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تعذر إنشاء التقرير'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Align(
          alignment: AlignmentDirectional.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [
                _Header(
                  reportType: state.reportType,
                  isLoading: isLoading,
                  onPreview: result == null
                      ? null
                      : () => _openPreview(context),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 760;
                    final cardWidth = isWide
                        ? (constraints.maxWidth - 16) / 2
                        : constraints.maxWidth;

                    return Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: ReportType.values.map((type) {
                        return SizedBox(
                          width: cardWidth,
                          child: ReportCard(
                            reportType: type,
                            selected: state.reportType == type,
                            onSelected: controller.setReportType,
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 16),
                ReportFilterCard(
                  filter: state.filter,
                  onOpenFilters: () => _openFilters(context),
                  onPickDateRange: () => _pickDateRange(context, ref),
                  onClearFilters: controller.clearFilters,
                ),
                const SizedBox(height: 16),
                if (result != null) ...[
                  _LatestSummary(result: result),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: isLoading
                            ? null
                            : () => _generate(context, ref),
                        icon: isLoading
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.play_arrow),
                        label: Text(isLoading ? 'جاري الإنشاء' : 'إنشاء التقرير'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton.outlined(
                      tooltip: 'معاينة التقرير',
                      onPressed: result == null ? null : () => _openPreview(context),
                      icon: const Icon(Icons.visibility_outlined),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateRange(BuildContext context, WidgetRef ref) async {
    final filter = ref.read(reportsControllerProvider).filter;
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: filter.fromDate,
        end: filter.toDate,
      ),
    );

    if (range == null) {
      return;
    }

    ref
        .read(reportsControllerProvider.notifier)
        .setDateRange(range.start, range.end);
  }

  Future<void> _generate(BuildContext context, WidgetRef ref) async {
    await ref.read(reportsControllerProvider.notifier).generateReport();

    if (!context.mounted) {
      return;
    }

    final result = ref.read(reportsControllerProvider).result;
    if (result.hasValue && result.value != null) {
      _openPreview(context);
    }
  }

  void _openFilters(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const ReportFilterScreen(),
      ),
    );
  }

  void _openPreview(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const ReportPreviewScreen(),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.reportType,
    required this.isLoading,
    required this.onPreview,
  });

  final ReportType reportType;
  final bool isLoading;
  final VoidCallback? onPreview;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              child: const Icon(Icons.analytics_outlined),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مركز التقارير',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reportType.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              tooltip: 'معاينة',
              onPressed: isLoading ? null : onPreview,
              icon: const Icon(Icons.visibility_outlined),
            ),
          ],
        ),
      ),
    );
  }
}

class _LatestSummary extends StatelessWidget {
  const _LatestSummary({required this.result});

  final ReportResult result;

  @override
  Widget build(BuildContext context) {
    final summary = result.summary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 760;
        final width = isWide
            ? (constraints.maxWidth - 24) / 3
            : constraints.maxWidth;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: width,
              child: SummaryCard(
                title: 'إجمالي القوة',
                value: summary.totalPersonnel.toString(),
                icon: Icons.groups_outlined,
              ),
            ),
            SizedBox(
              width: width,
              child: SummaryCard(
                title: 'المتاحون',
                value: summary.availablePersonnel.toString(),
                icon: Icons.verified_user_outlined,
                color: Colors.green,
              ),
            ),
            SizedBox(
              width: width,
              child: SummaryCard(
                title: 'نسبة الجاهزية',
                value: '${summary.readinessPercentage.toStringAsFixed(1)}%',
                icon: Icons.speed_outlined,
                color: Colors.teal,
              ),
            ),
          ],
        );
      },
    );
  }
}
