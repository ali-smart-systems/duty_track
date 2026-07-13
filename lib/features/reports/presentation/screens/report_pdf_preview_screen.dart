import 'package:duty_track/features/reports/providers/reports_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

class ReportPdfPreviewScreen extends ConsumerWidget {
  const ReportPdfPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reportsControllerProvider);
    final result = state.result.valueOrNull;
    final exportService = ref.watch(reportsExportServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('معاينة PDF'),
      ),
      body: result == null
          ? const Center(
              child: Text('لا يوجد تقرير جاهز للمعاينة'),
            )
          : PdfPreview(
              canChangeOrientation: false,
              canChangePageFormat: false,
              allowSharing: true,
              allowPrinting: true,
              pdfFileName: '${state.reportType.name}.pdf',
              build: (_) => exportService.buildPdf(
                result: result,
                reportTitle: state.reportType.title,
              ),
            ),
    );
  }
}