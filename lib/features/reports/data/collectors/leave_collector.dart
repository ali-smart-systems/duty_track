import 'package:duty_track/features/reports/data/collectors/report_filter_matcher.dart';
import 'package:duty_track/features/reports/data/models/leave_report_record.dart';
import 'package:duty_track/features/reports/data/models/report_filter.dart';
import 'package:duty_track/features/reports/data/repositories/reports_repository.dart';

class LeaveCollector {
  LeaveCollector({ReportsRepository? repository})
    : _repository = repository ?? ReportsRepository();

  final ReportsRepository _repository;

  Future<List<LeaveReportRecord>> collect(ReportFilter filter) async {
    final leaves = await _repository.getLeaves();

    return leaves.where((leave) {
      return ReportFilterMatcher.matchesDateRange(
            filter,
            fromDate: leave.fromDate,
            toDate: leave.toDate,
          ) &&
          ReportFilterMatcher.matchesNullable(
            filter.personnelId,
            leave.personnelId,
          ) &&
          ReportFilterMatcher.matchesNullable(filter.dutyStatus, leave.status);
    }).toList();
  }
}
