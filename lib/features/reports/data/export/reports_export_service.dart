import 'dart:io';
import 'dart:typed_data';

import 'package:duty_track/core/constants/app_constants.dart';
import 'package:duty_track/features/reports/data/models/report_result.dart';
import 'package:excel/excel.dart' as xls;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class ReportsExportService {
  const ReportsExportService();

  Future<Uint8List> buildPdf({
    required ReportResult result,
    required String reportTitle,
  }) async {
    final regularFont = await PdfGoogleFonts.notoNaskhArabicRegular();
    final boldFont = await PdfGoogleFonts.notoNaskhArabicBold();
    final document = pw.Document(
      title: reportTitle,
      author: AppConstants.appName,
      creator: AppConstants.appName,
      subject: 'Correctional facility management report',
      theme: pw.ThemeData.withFont(base: regularFont, bold: boldFont),
    );

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(28, 28, 28, 34),
        textDirection: pw.TextDirection.rtl,
        header: (context) => _buildPdfHeader(),
        footer: (context) => _buildPdfFooter(context),
        build: (context) => [
          _buildPdfTitle(reportTitle, result),
          pw.SizedBox(height: 14),
          _buildPdfStatistics(result),
          pw.SizedBox(height: 14),
          _buildPdfDistributionTables(result),
          pw.SizedBox(height: 14),
          _buildPdfDutiesTable(result),
          pw.SizedBox(height: 14),
          _buildPdfPersonnelTable(result),
          pw.SizedBox(height: 14),
          _buildPdfRecommendations(result),
          pw.SizedBox(height: 18),
          _buildPdfSignature(),
        ],
      ),
    );

    return document.save();
  }

  Future<Uint8List> buildExcel({
    required ReportResult result,
    required String reportTitle,
  }) async {
    final workbook = xls.Excel.createExcel();
    workbook.delete('Sheet1');

    _buildExcelSummarySheet(workbook, reportTitle, result);
    _buildExcelDistributionSheet(workbook, result);
    _buildExcelDutiesSheet(workbook, result);
    _buildExcelPersonnelSheet(workbook, result);

    final bytes = workbook.encode() ?? <int>[];
    return Uint8List.fromList(bytes);
  }

  Future<File> savePdf({
    required ReportResult result,
    required String reportTitle,
    required String reportFileKey,
  }) async {
    final bytes = await buildPdf(result: result, reportTitle: reportTitle);
    return _writeFile(bytes, _fileName(reportFileKey, 'pdf'));
  }

  Future<File> saveExcel({
    required ReportResult result,
    required String reportTitle,
    required String reportFileKey,
  }) async {
    final bytes = await buildExcel(result: result, reportTitle: reportTitle);
    return _writeFile(bytes, _fileName(reportFileKey, 'xlsx'));
  }

  Future<void> printPdf({
    required ReportResult result,
    required String reportTitle,
    required String reportFileKey,
  }) async {
    await Printing.layoutPdf(
      name: _fileName(reportFileKey, 'pdf'),
      onLayout: (_) => buildPdf(result: result, reportTitle: reportTitle),
    );
  }

  Future<void> sharePdf({
    required ReportResult result,
    required String reportTitle,
    required String reportFileKey,
  }) async {
    final file = await savePdf(
      result: result,
      reportTitle: reportTitle,
      reportFileKey: reportFileKey,
    );
    await Share.shareXFiles(
      [
        XFile(
          file.path,
          name: _fileName(reportFileKey, 'pdf'),
          mimeType: 'application/pdf',
        ),
      ],
      text: reportTitle,
    );
  }

  Future<void> shareExcel({
    required ReportResult result,
    required String reportTitle,
    required String reportFileKey,
  }) async {
    final file = await saveExcel(
      result: result,
      reportTitle: reportTitle,
      reportFileKey: reportFileKey,
    );
    await Share.shareXFiles(
      [
        XFile(
          file.path,
          name: _fileName(reportFileKey, 'xlsx'),
          mimeType:
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        ),
      ],
      text: reportTitle,
    );
  }

  pw.Widget _buildPdfHeader() {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.blueGrey300, width: 0.7),
        ),
      ),
      child: pw.Row(
        children: [
          pw.Container(
            width: 52,
            height: 52,
            alignment: pw.Alignment.center,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.blueGrey400),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Text(
              'الشعار',
              style: pw.TextStyle(fontSize: 9, color: PdfColors.blueGrey700),
            ),
          ),
          pw.SizedBox(width: 12),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  AppConstants.appName,
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  'إدارة الموارد البشرية - منشأة إصلاحية',
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.blueGrey700,
                  ),
                ),
              ],
            ),
          ),
          pw.Text(
            DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.blueGrey700),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfFooter(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.blueGrey200, width: 0.7),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'وثيقة رسمية مولدة بواسطة ${AppConstants.appName}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.blueGrey600),
          ),
          pw.Text(
            'صفحة ${context.pageNumber} من ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.blueGrey600),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfTitle(String reportTitle, ReportResult result) {
    final formatter = DateFormat('yyyy-MM-dd');

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: PdfColors.blueGrey50,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            reportTitle,
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'الفترة: ${formatter.format(result.filter.fromDate)} - ${formatter.format(result.filter.toDate)}',
            style: const pw.TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfStatistics(ReportResult result) {
    final summary = result.summary;
    final rows = [
      ['إجمالي القوة', summary.totalPersonnel],
      ['الحاضرون', summary.presentPersonnel],
      ['الغائبون', summary.absentPersonnel],
      ['في إجازة', summary.leavePersonnel],
      ['المتاحون', summary.availablePersonnel],
      ['إجمالي المناوبات', summary.totalDuties],
      ['إجمالي المهام', summary.totalMissions],
      ['برامج التدريب', summary.trainingPrograms],
      ['حضور التدريب', summary.trainingAttendance],
      ['ساعات التدريب', summary.trainingHours],
      ['نسبة الجاهزية', '${summary.readinessPercentage.toStringAsFixed(1)}%'],
      ['نقاط الخدمة', summary.totalPosts],
    ];

    return _section(
      title: 'المؤشرات الرئيسية',
      child: pw.Wrap(
        spacing: 8,
        runSpacing: 8,
        children: rows.map((row) {
          return pw.Container(
            width: 166,
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.blueGrey100),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  row.first.toString(),
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.blueGrey700,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  row.last.toString(),
                  style: pw.TextStyle(
                    fontSize: 15,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  pw.Widget _buildPdfDistributionTables(ReportResult result) {
    return _section(
      title: 'التوزيعات',
      child: pw.Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _distributionTable('المهام', result.summary.missionCounts),
          _distributionTable('الورديات', result.summary.shiftCounts),
          _distributionTable('المواقع', result.summary.locationCounts),
          _distributionTable('النقاط', result.summary.postCounts),
          _distributionTable('الأقسام', result.summary.departmentCounts),
          _distributionTable('الرتب', result.summary.rankCounts),
          _distributionTable('حالات المناوبات', result.summary.statusCounts),
          _distributionTable('الإجازات', result.summary.leaveCounts),
        ],
      ),
    );
  }

  pw.Widget _distributionTable(String title, Map<String, int> values) {
    final rows = values.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return pw.Container(
      width: 250,
      child: pw.TableHelper.fromTextArray(
        border: pw.TableBorder.all(color: PdfColors.blueGrey100),
        headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
        cellStyle: const pw.TextStyle(fontSize: 8),
        headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey50),
        cellAlignment: pw.Alignment.centerRight,
        headerAlignment: pw.Alignment.centerRight,
        headers: [title, 'العدد'],
        data: rows.isEmpty
            ? [
                ['لا توجد بيانات', '0'],
              ]
            : rows.take(8).map((entry) => [entry.key, entry.value]).toList(),
      ),
    );
  }

  pw.Widget _buildPdfDutiesTable(ReportResult result) {
    return _section(
      title: 'جدول المناوبات',
      child: pw.TableHelper.fromTextArray(
        border: pw.TableBorder.all(color: PdfColors.blueGrey100),
        headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
        cellStyle: const pw.TextStyle(fontSize: 8),
        headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey50),
        cellAlignment: pw.Alignment.centerRight,
        headerAlignment: pw.Alignment.centerRight,
        headers: ['التاريخ', 'الوردية', 'الموقع', 'النقطة', 'المهمة', 'الحالة'],
        data: result.duties.isEmpty
            ? [
                ['لا توجد بيانات', '', '', '', '', ''],
              ]
            : result.duties.take(20).map((item) {
                return [
                  DateFormat('yyyy-MM-dd').format(item.duty.date),
                  item.shiftName,
                  item.locationName,
                  item.postName,
                  item.taskTypeName,
                  item.status,
                ];
              }).toList(),
      ),
    );
  }

  pw.Widget _buildPdfPersonnelTable(ReportResult result) {
    return _section(
      title: 'جدول الأفراد',
      child: pw.TableHelper.fromTextArray(
        border: pw.TableBorder.all(color: PdfColors.blueGrey100),
        headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
        cellStyle: const pw.TextStyle(fontSize: 8),
        headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey50),
        cellAlignment: pw.Alignment.centerRight,
        headerAlignment: pw.Alignment.centerRight,
        headers: ['الرقم العسكري', 'الاسم', 'الرتبة', 'القسم', 'الحالة'],
        data: result.personnel.isEmpty
            ? [
                ['لا توجد بيانات', '', '', '', ''],
              ]
            : result.personnel.take(25).map((item) {
                return [
                  item.personnel.militaryNumber,
                  item.personnel.fullName,
                  item.rankName,
                  item.departmentName,
                  item.personnel.status,
                ];
              }).toList(),
      ),
    );
  }

  pw.Widget _buildPdfRecommendations(ReportResult result) {
    final recommendations = _recommendations(result);

    return _section(
      title: 'التوصيات الإدارية',
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: recommendations.map((item) {
          return pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 5),
            child: pw.Text('• $item', style: const pw.TextStyle(fontSize: 10)),
          );
        }).toList(),
      ),
    );
  }

  pw.Widget _buildPdfSignature() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('اعتماد مدير الموارد البشرية'),
            pw.SizedBox(height: 26),
            pw.Container(width: 170, height: 0.8, color: PdfColors.blueGrey400),
            pw.SizedBox(height: 4),
            pw.Text('الاسم والتوقيع والختم', style: const pw.TextStyle(fontSize: 9)),
          ],
        ),
        pw.Text(
          'هذا التقرير مخصص للاستخدام الإداري الرسمي.',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.blueGrey700),
        ),
      ],
    );
  }

  pw.Widget _section({required String title, required pw.Widget child}) {
    return pw.Container(
      width: double.infinity,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  void _buildExcelSummarySheet(
    xls.Excel workbook,
    String reportTitle,
    ReportResult result,
  ) {
    final sheet = workbook['Summary'];
    final summary = result.summary;
    final formatter = DateFormat('yyyy-MM-dd');

    sheet.appendRow([xls.TextCellValue(AppConstants.appName)]);
    sheet.appendRow([xls.TextCellValue(reportTitle)]);
    sheet.appendRow([
      xls.TextCellValue('Date Range'),
      xls.TextCellValue(
        '${formatter.format(result.filter.fromDate)} - ${formatter.format(result.filter.toDate)}',
      ),
    ]);
    sheet.appendRow([]);
    sheet.appendRow([xls.TextCellValue('Metric'), xls.TextCellValue('Value')]);
    sheet.appendRow([xls.TextCellValue('Total Personnel'), xls.IntCellValue(summary.totalPersonnel)]);
    sheet.appendRow([xls.TextCellValue('Present Personnel'), xls.IntCellValue(summary.presentPersonnel)]);
    sheet.appendRow([xls.TextCellValue('Absent Personnel'), xls.IntCellValue(summary.absentPersonnel)]);
    sheet.appendRow([xls.TextCellValue('Personnel On Leave'), xls.IntCellValue(summary.leavePersonnel)]);
    sheet.appendRow([xls.TextCellValue('Available Personnel'), xls.IntCellValue(summary.availablePersonnel)]);
    sheet.appendRow([xls.TextCellValue('Total Duties'), xls.IntCellValue(summary.totalDuties)]);
    sheet.appendRow([xls.TextCellValue('Total Missions'), xls.IntCellValue(summary.totalMissions)]);
    sheet.appendRow([xls.TextCellValue('Training Programs'), xls.IntCellValue(summary.trainingPrograms)]);
    sheet.appendRow([xls.TextCellValue('Training Attendance'), xls.IntCellValue(summary.trainingAttendance)]);
    sheet.appendRow([xls.TextCellValue('Training Hours'), xls.IntCellValue(summary.trainingHours)]);
    sheet.appendRow([xls.TextCellValue('Readiness Percentage'), xls.DoubleCellValue(summary.readinessPercentage)]);
    sheet.appendRow([]);
    sheet.appendRow([xls.TextCellValue('Recommendations')]);
    for (final recommendation in _recommendations(result)) {
      sheet.appendRow([xls.TextCellValue(recommendation)]);
    }
    sheet.appendRow([]);
    sheet.appendRow([xls.TextCellValue('Signature')]);
    sheet.appendRow([xls.TextCellValue('HR Manager Name / Signature / Stamp')]);
  }

  void _buildExcelDistributionSheet(xls.Excel workbook, ReportResult result) {
    final sheet = workbook['Distributions'];
    final sections = {
      'Mission Distribution': result.summary.missionCounts,
      'Shift Distribution': result.summary.shiftCounts,
      'Location Distribution': result.summary.locationCounts,
      'Post Distribution': result.summary.postCounts,
      'Department Distribution': result.summary.departmentCounts,
      'Rank Distribution': result.summary.rankCounts,
      'Mission Status Distribution': result.summary.statusCounts,
      'Leave Distribution': result.summary.leaveCounts,
    };

    for (final section in sections.entries) {
      sheet.appendRow([xls.TextCellValue(section.key)]);
      sheet.appendRow([xls.TextCellValue('Item'), xls.TextCellValue('Count')]);
      final rows = section.value.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      for (final row in rows) {
        sheet.appendRow([
          xls.TextCellValue(row.key),
          xls.IntCellValue(row.value),
        ]);
      }
      sheet.appendRow([]);
    }
  }

  void _buildExcelDutiesSheet(xls.Excel workbook, ReportResult result) {
    final sheet = workbook['Duties'];
    sheet.appendRow([
      xls.TextCellValue('Date'),
      xls.TextCellValue('Shift'),
      xls.TextCellValue('Location'),
      xls.TextCellValue('Post'),
      xls.TextCellValue('Mission'),
      xls.TextCellValue('Status'),
      xls.TextCellValue('Notes'),
    ]);

    for (final item in result.duties) {
      sheet.appendRow([
        xls.TextCellValue(DateFormat('yyyy-MM-dd').format(item.duty.date)),
        xls.TextCellValue(item.shiftName),
        xls.TextCellValue(item.locationName),
        xls.TextCellValue(item.postName),
        xls.TextCellValue(item.taskTypeName),
        xls.TextCellValue(item.status),
        xls.TextCellValue(item.duty.notes),
      ]);
    }
  }

  void _buildExcelPersonnelSheet(xls.Excel workbook, ReportResult result) {
    final sheet = workbook['Personnel'];
    sheet.appendRow([
      xls.TextCellValue('Military Number'),
      xls.TextCellValue('Full Name'),
      xls.TextCellValue('Rank'),
      xls.TextCellValue('Department'),
      xls.TextCellValue('Location'),
      xls.TextCellValue('Post'),
      xls.TextCellValue('Status'),
      xls.TextCellValue('Phone'),
    ]);

    for (final item in result.personnel) {
      sheet.appendRow([
        xls.TextCellValue(item.personnel.militaryNumber),
        xls.TextCellValue(item.personnel.fullName),
        xls.TextCellValue(item.rankName),
        xls.TextCellValue(item.departmentName),
        xls.TextCellValue(item.serviceLocationName),
        xls.TextCellValue(item.servicePostName),
        xls.TextCellValue(item.personnel.status),
        xls.TextCellValue(item.personnel.phone),
      ]);
    }
  }

  List<String> _recommendations(ReportResult result) {
    final summary = result.summary;
    final recommendations = <String>[];

    if (summary.readinessPercentage < 70) {
      recommendations.add(
        'رفع الجاهزية التشغيلية عبر مراجعة الغياب والإجازات وتوزيع القوة المتاحة.',
      );
    } else {
      recommendations.add(
        'المحافظة على مستوى الجاهزية الحالي ومتابعة المؤشرات بشكل دوري.',
      );
    }

    if (summary.absentPersonnel > 0) {
      recommendations.add(
        'مراجعة حالات الغياب واتخاذ الإجراءات الإدارية المناسبة حسب اللوائح.',
      );
    }

    if (summary.leavePersonnel > 0) {
      recommendations.add(
        'موازنة الإجازات مع متطلبات التشغيل لضمان تغطية المواقع الحساسة.',
      );
    }

    if (summary.trainingHours == 0) {
      recommendations.add(
        'جدولة برامج تدريبية دورية لتعزيز كفاءة وجاهزية الأفراد.',
      );
    }

    recommendations.add(
      'اعتماد التقرير بعد مراجعته من مسؤول الموارد البشرية وحفظ نسخة في السجلات الرسمية.',
    );

    return recommendations;
  }

  Future<File> _writeFile(Uint8List bytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final reportsDirectory = Directory('${directory.path}/reports');
    if (!reportsDirectory.existsSync()) {
      reportsDirectory.createSync(recursive: true);
    }

    final file = File('${reportsDirectory.path}/$fileName');
    return file.writeAsBytes(bytes, flush: true);
  }

  String _fileName(String reportFileKey, String extension) {
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final normalizedTitle = reportFileKey.replaceAll(
      RegExp(r'[^a-zA-Z0-9_]'),
      '_',
    );
    return 'duty_track_${normalizedTitle}_$timestamp.$extension';
  }
}
