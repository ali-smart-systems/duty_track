import 'package:duty_track/features/duties/data/models/duty_model.dart';
import 'package:duty_track/features/duties/data/models/duty_personnel_model.dart';
import 'package:duty_track/features/reports/data/collectors/report_filter_matcher.dart';
import 'package:duty_track/features/reports/data/models/report_filter.dart';
import 'package:duty_track/features/reports/data/repositories/reports_repository.dart';

class DutyCollector {
  DutyCollector({ReportsRepository? repository})
    : _repository = repository ?? ReportsRepository();

  final ReportsRepository _repository;

  Future<List<DutyModel>> collect(ReportFilter filter) async {
    final duties = await _repository.getDuties();

    return duties.where((duty) {
      return ReportFilterMatcher.matchesDateRange(filter, date: duty.date) &&
          ReportFilterMatcher.matchesNullable(
            filter.locationId,
            duty.serviceLocationId,
          ) &&
          ReportFilterMatcher.matchesNullable(
            filter.postId,
            duty.servicePostId,
          ) &&
          ReportFilterMatcher.matchesNullable(filter.shiftId, duty.shiftId) &&
          ReportFilterMatcher.matchesNullable(
            filter.missionTypeId,
            duty.taskTypeId,
          ) &&
          ReportFilterMatcher.matchesNullable(
            filter.dutyStatus,
            duty.status,
          );
    }).toList();
  }

  Future<List<DutyPersonnelModel>> collectDutyPersonnel(
    ReportFilter filter, {
    List<DutyModel>? duties,
  }) async {
    final reportDuties = duties ?? await collect(filter);
    final dutyPersonnel = <DutyPersonnelModel>[];

    for (final duty in reportDuties) {
      final items = await _repository.getDutyPersonnel(duty.id);
      dutyPersonnel.addAll(
        items.where(
          (item) => ReportFilterMatcher.matchesNullable(
            filter.personnelId,
            item.personnelId,
          ),
        ),
      );
    }

    return dutyPersonnel;
  }
}
