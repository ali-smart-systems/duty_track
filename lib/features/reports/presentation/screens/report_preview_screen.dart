import 'package:duty_track/core/constants/app_colors.dart';
import 'package:duty_track/features/duties/data/models/duty_view_model.dart';
import 'package:duty_track/features/personnel/data/models/personnel_view_model.dart';
import 'package:duty_track/features/reports/data/models/report_result.dart';
import 'package:duty_track/features/reports/presentation/screens/report_pdf_preview_screen.dart';
import 'package:duty_track/features/reports/presentation/widgets/summary_card.dart';
import 'package:duty_track/features/reports/providers/reports_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ReportPreviewScreen extends ConsumerWidget {
  const ReportPreviewScreen({super.key});

  static const double _maxContentWidth = 1180;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reportsControllerProvider);
    final exportService = ref.watch(reportsExportServiceProvider);

    return Directionality(
      textDirection: Directionality.of(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('معاينة التقرير'),
          actions: [
            IconButton(
              tooltip: 'تحديث التقرير',
              onPressed: state.result.isLoading
                  ? null
                  : () {
                      ref
                          .read(reportsControllerProvider.notifier)
                          .generateReport();
                    },
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: state.result.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => const _ErrorState(),
          data: (report) {
            if (report == null) {
              return _EmptyPreview(
                onGenerate: () {
                  ref.read(reportsControllerProvider.notifier).generateReport();
                },
              );
            }

            return Align(
              alignment: AlignmentDirectional.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                  children: [
                    _PreviewHeader(
                      reportType: state.reportType,
                      result: report,
                      onPreviewPdf: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) =>
                                const ReportPdfPreviewScreen(),
                          ),
                        );
                      },
                      onPrint: () => _runExportAction(
                        context,
                        action: () => exportService.printPdf(
                          result: report,
                          reportTitle: state.reportType.title,
                          reportFileKey: state.reportType.name,
                        ),
                        successMessage: 'تم إرسال التقرير للطباعة',
                      ),
                      onSharePdf: () => _runExportAction(
                        context,
                        action: () => exportService.sharePdf(
                          result: report,
                          reportTitle: state.reportType.title,
                          reportFileKey: state.reportType.name,
                        ),
                        successMessage: 'تمت مشاركة ملف PDF',
                      ),
                      onShareExcel: () => _runExportAction(
                        context,
                        action: () => exportService.shareExcel(
                          result: report,
                          reportTitle: state.reportType.title,
                          reportFileKey: state.reportType.name,
                        ),
                        successMessage: 'تمت مشاركة ملف Excel',
                      ),
                      onSavePdf: () => _runExportAction(
                        context,
                        action: () async {
                          await exportService.savePdf(
                            result: report,
                            reportTitle: state.reportType.title,
                            reportFileKey: state.reportType.name,
                          );
                        },
                        successMessage: 'تم حفظ ملف PDF محلياً',
                      ),
                      onSaveExcel: () => _runExportAction(
                        context,
                        action: () async {
                          await exportService.saveExcel(
                            result: report,
                            reportTitle: state.reportType.title,
                            reportFileKey: state.reportType.name,
                          );
                        },
                        successMessage: 'تم حفظ ملف Excel محلياً',
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SummaryGrid(result: report),
                    const SizedBox(height: 16),
                    _DistributionSection(
                      title: 'التوزيعات الإحصائية',
                      sections: [
                        _DistributionData(
                          title: 'المهام',
                          values: report.summary.missionCounts,
                        ),
                        _DistributionData(
                          title: 'الورديات',
                          values: report.summary.shiftCounts,
                        ),
                        _DistributionData(
                          title: 'المواقع',
                          values: report.summary.locationCounts,
                        ),
                        _DistributionData(
                          title: 'النقاط',
                          values: report.summary.postCounts,
                        ),
                        _DistributionData(
                          title: 'الأقسام',
                          values: report.summary.departmentCounts,
                        ),
                        _DistributionData(
                          title: 'الرتب',
                          values: report.summary.rankCounts,
                        ),
                        _DistributionData(
                          title: 'حالات المناوبات',
                          values: report.summary.statusCounts,
                        ),
                        _DistributionData(
                          title: 'الإجازات',
                          values: report.summary.leaveCounts,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _DutyPreviewTable(duties: report.duties),
                    const SizedBox(height: 16),
                    _PersonnelPreviewTable(personnel: report.personnel),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _runExportAction(
    BuildContext context, {
    required Future<void> Function() action,
    required String successMessage,
  }) async {
    try {
      await action();

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تعذر تنفيذ عملية التصدير'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}

class _PreviewHeader extends StatelessWidget {
  const _PreviewHeader({
    required this.reportType,
    required this.result,
    required this.onPreviewPdf,
    required this.onPrint,
    required this.onSharePdf,
    required this.onShareExcel,
    required this.onSavePdf,
    required this.onSaveExcel,
  });

  final ReportType reportType;
  final ReportResult result;
  final VoidCallback onPreviewPdf;
  final VoidCallback onPrint;
  final VoidCallback onSharePdf;
  final VoidCallback onShareExcel;
  final VoidCallback onSavePdf;
  final VoidCallback onSaveExcel;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy-MM-dd');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  child: const Icon(Icons.summarize_outlined),
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
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${formatter.format(result.filter.fromDate)} - ${formatter.format(result.filter.toDate)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ExportActionChip(
                  icon: Icons.preview_outlined,
                  label: 'معاينة PDF',
                  onPressed: onPreviewPdf,
                ),
                _ExportActionChip(
                  icon: Icons.print,
                  label: 'طباعة',
                  onPressed: onPrint,
                ),
                _ExportActionChip(
                  icon: Icons.picture_as_pdf,
                  label: 'مشاركة PDF',
                  onPressed: onSharePdf,
                ),
                _ExportActionChip(
                  icon: Icons.table_chart,
                  label: 'مشاركة Excel',
                  onPressed: onShareExcel,
                ),
                _ExportActionChip(
                  icon: Icons.save_alt,
                  label: 'حفظ PDF',
                  onPressed: onSavePdf,
                ),
                _ExportActionChip(
                  icon: Icons.download,
                  label: 'حفظ Excel',
                  onPressed: onSaveExcel,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ExportActionChip extends StatelessWidget {
  const _ExportActionChip({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onPressed,
      side: const BorderSide(color: AppColors.border),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.result});

  final ReportResult result;

  @override
  Widget build(BuildContext context) {
    final summary = result.summary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth >= 900
            ? (constraints.maxWidth - 36) / 4
            : constraints.maxWidth >= 620
            ? (constraints.maxWidth - 12) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SummaryCard(
              title: 'إجمالي القوة',
              value: summary.totalPersonnel.toString(),
              icon: Icons.groups_outlined,
            ),
            SummaryCard(
              title: 'الحاضرون',
              value: summary.presentPersonnel.toString(),
              icon: Icons.how_to_reg_outlined,
              color: AppColors.success,
            ),
            SummaryCard(
              title: 'الغائبون',
              value: summary.absentPersonnel.toString(),
              icon: Icons.person_off_outlined,
              color: AppColors.error,
            ),
            SummaryCard(
              title: 'في إجازة',
              value: summary.leavePersonnel.toString(),
              icon: Icons.beach_access_outlined,
              color: AppColors.warning,
            ),
            SummaryCard(
              title: 'المتاحون',
              value: summary.availablePersonnel.toString(),
              icon: Icons.verified_user_outlined,
              color: AppColors.secondary,
            ),
            SummaryCard(
              title: 'المناوبات',
              value: summary.totalDuties.toString(),
              icon: Icons.event_note_outlined,
            ),
            SummaryCard(
              title: 'المهام',
              value: summary.totalMissions.toString(),
              icon: Icons.assignment_outlined,
            ),
            SummaryCard(
              title: 'الجاهزية',
              value: '${summary.readinessPercentage.toStringAsFixed(1)}%',
              icon: Icons.speed_outlined,
              color: AppColors.info,
            ),
            SummaryCard(
              title: 'برامج التدريب',
              value: summary.trainingPrograms.toString(),
              icon: Icons.school_outlined,
            ),
            SummaryCard(
              title: 'حضور التدريب',
              value: summary.trainingAttendance.toString(),
              icon: Icons.fact_check_outlined,
            ),
            SummaryCard(
              title: 'ساعات التدريب',
              value: summary.trainingHours.toString(),
              icon: Icons.timer_outlined,
            ),
            SummaryCard(
              title: 'نقاط الخدمة',
              value: summary.totalPosts.toString(),
              icon: Icons.place_outlined,
            ),
          ].map((card) => SizedBox(width: width, child: card)).toList(),
        );
      },
    );
  }
}

class _DistributionSection extends StatelessWidget {
  const _DistributionSection({required this.title, required this.sections});

  final String title;
  final List<_DistributionData> sections;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth >= 760
                    ? (constraints.maxWidth - 12) / 2
                    : constraints.maxWidth;

                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: sections
                      .map(
                        (section) => SizedBox(
                          width: width,
                          child: _DistributionCard(section: section),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DistributionCard extends StatelessWidget {
  const _DistributionCard({required this.section});

  final _DistributionData section;

  @override
  Widget build(BuildContext context) {
    final entries = section.values.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            if (entries.isEmpty)
              const Text('لا توجد بيانات')
            else
              ...entries.take(6).map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.key,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Badge(label: Text(entry.value.toString())),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DistributionData {
  const _DistributionData({required this.title, required this.values});

  final String title;
  final Map<String, int> values;
}

class _DutyPreviewTable extends StatelessWidget {
  const _DutyPreviewTable({required this.duties});

  final List<DutyViewModel> duties;

  @override
  Widget build(BuildContext context) {
    return _PreviewSection(
      title: 'المناوبات',
      count: duties.length,
      child: duties.isEmpty
          ? const _EmptySectionText()
          : Column(
              children: duties.take(10).map((duty) {
                return ListTile(
                  leading: const Icon(Icons.event_note_outlined),
                  title: Text(
                    '${duty.shiftName} - ${duty.locationName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${duty.postName} • ${duty.taskTypeName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(duty.status),
                );
              }).toList(),
            ),
    );
  }
}

class _PersonnelPreviewTable extends StatelessWidget {
  const _PersonnelPreviewTable({required this.personnel});

  final List<PersonnelViewModel> personnel;

  @override
  Widget build(BuildContext context) {
    return _PreviewSection(
      title: 'الأفراد',
      count: personnel.length,
      child: personnel.isEmpty
          ? const _EmptySectionText()
          : Column(
              children: personnel.take(10).map((item) {
                return ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(
                    item.personnel.fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${item.rankName} • ${item.departmentName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(item.personnel.status),
                );
              }).toList(),
            ),
    );
  }
}

class _PreviewSection extends StatelessWidget {
  const _PreviewSection({
    required this.title,
    required this.count,
    required this.child,
  });

  final String title;
  final int count;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Badge(label: Text(count.toString())),
              ],
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _EmptySectionText extends StatelessWidget {
  const _EmptySectionText();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Text('لا توجد بيانات ضمن نطاق التقرير'),
    );
  }
}

class _EmptyPreview extends StatelessWidget {
  const _EmptyPreview({required this.onGenerate});

  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.analytics_outlined, size: 56),
            const SizedBox(height: 12),
            Text(
              'لم يتم إنشاء تقرير بعد',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onGenerate,
              icon: const Icon(Icons.play_arrow),
              label: const Text('إنشاء التقرير'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'تعذر تحميل معاينة التقرير',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }
}
