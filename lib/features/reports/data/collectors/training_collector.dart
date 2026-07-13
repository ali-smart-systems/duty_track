import 'package:duty_track/features/reports/data/collectors/report_filter_matcher.dart';
import 'package:duty_track/features/reports/data/models/report_filter.dart';
import 'package:duty_track/features/reports/data/models/training_report_record.dart';
import 'package:duty_track/features/reports/data/repositories/reports_repository.dart';

class TrainingCollector {
  TrainingCollector({ReportsRepository? repository})
    : _repository = repository ?? ReportsRepository();

  final ReportsRepository _repository;

  Future<List<TrainingReportRecord>> collect(ReportFilter filter) async {
    final training = await _repository.getTraining();

    return training.where((item) {
      return ReportFilterMatcher.matchesDateRange(
            filter,
            date: item.date,
            fromDate: item.fromDate,
            toDate: item.toDate,
          ) &&
          ReportFilterMatcher.matchesNullable(
            filter.personnelId,
            item.personnelId,
          ) &&
          ReportFilterMatcher.matchesNullable(
            filter.departmentId,
            item.departmentId,
          ) &&
          ReportFilterMatcher.matchesNullable(filter.rankId, item.rankId);
    }).toList();
  }
}
