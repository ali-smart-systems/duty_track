import 'package:duty_track/features/personnel/data/models/personnel_model.dart';
import 'package:duty_track/features/reports/data/collectors/report_filter_matcher.dart';
import 'package:duty_track/features/reports/data/models/report_filter.dart';
import 'package:duty_track/features/reports/data/repositories/reports_repository.dart';

class PersonnelCollector {
  PersonnelCollector({ReportsRepository? repository})
    : _repository = repository ?? ReportsRepository();

  final ReportsRepository _repository;

  Future<List<PersonnelModel>> collect(ReportFilter filter) async {
    final personnel = await _repository.getPersonnel();

    return personnel.where((item) {
      return ReportFilterMatcher.matchesNullable(
            filter.locationId,
            item.serviceLocationId,
          ) &&
          ReportFilterMatcher.matchesNullable(
            filter.postId,
            item.servicePostId,
          ) &&
          ReportFilterMatcher.matchesNullable(
            filter.departmentId,
            item.department,
          ) &&
          ReportFilterMatcher.matchesNullable(filter.rankId, item.rank) &&
          ReportFilterMatcher.matchesNullable(filter.personnelId, item.id);
    }).toList();
  }
}
