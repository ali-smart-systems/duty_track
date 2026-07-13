import 'package:duty_track/features/daily_services/data/models/daily_service_model.dart';
import 'package:duty_track/features/reports/data/collectors/report_filter_matcher.dart';
import 'package:duty_track/features/reports/data/models/report_filter.dart';
import 'package:duty_track/features/reports/data/repositories/reports_repository.dart';

class DailyServiceCollector {
  DailyServiceCollector({ReportsRepository? repository})
    : _repository = repository ?? ReportsRepository();

  final ReportsRepository _repository;

  Future<List<DailyServiceModel>> collect(ReportFilter filter) async {
    final services = await _repository.getDailyServices();

    return services.where((service) {
      return ReportFilterMatcher.matchesDateRange(
            filter,
            date: service.serviceDate,
          ) &&
          ReportFilterMatcher.matchesNullable(filter.shiftId, service.shiftId) &&
          _matchesAssignments(filter, service);
    }).toList();
  }

  bool _matchesAssignments(ReportFilter filter, DailyServiceModel service) {
    final hasAssignmentFilters =
        filter.locationId != null ||
        filter.postId != null ||
        filter.personnelId != null;

    if (!hasAssignmentFilters) {
      return true;
    }

    return service.assignments.any((assignment) {
      return ReportFilterMatcher.matchesNullable(
            filter.locationId,
            assignment.locationId,
          ) &&
          ReportFilterMatcher.matchesNullable(
            filter.postId,
            assignment.postId,
          ) &&
          ReportFilterMatcher.matchesNullable(
            filter.personnelId,
            assignment.personnelId,
          );
    });
  }
}
