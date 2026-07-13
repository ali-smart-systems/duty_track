import 'package:duty_track/features/duties/data/models/duty_view_model.dart';
import 'package:duty_track/features/personnel/data/models/personnel_view_model.dart';
import 'package:duty_track/features/reports/data/models/report_filter.dart';
import 'package:duty_track/features/reports/data/models/report_summary.dart';

class ReportResult {
  const ReportResult({
    required this.filter,
    required this.summary,
    required this.duties,
    required this.personnel,
  });

  final ReportFilter filter;
  final ReportSummary summary;
  final List<DutyViewModel> duties;
  final List<PersonnelViewModel> personnel;

  ReportResult copyWith({
    ReportFilter? filter,
    ReportSummary? summary,
    List<DutyViewModel>? duties,
    List<PersonnelViewModel>? personnel,
  }) {
    return ReportResult(
      filter: filter ?? this.filter,
      summary: summary ?? this.summary,
      duties: duties ?? this.duties,
      personnel: personnel ?? this.personnel,
    );
  }
}
