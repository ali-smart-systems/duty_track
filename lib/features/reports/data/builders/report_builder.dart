import 'package:duty_track/features/duties/data/models/duty_view_model.dart';
import 'package:duty_track/features/master_data/data/models/department_model.dart';
import 'package:duty_track/features/master_data/data/models/mission_type_model.dart';
import 'package:duty_track/features/master_data/data/models/rank_model.dart';
import 'package:duty_track/features/master_data/data/models/service_location_model.dart';
import 'package:duty_track/features/master_data/data/models/service_post_model.dart';
import 'package:duty_track/features/master_data/data/models/shift_model.dart';
import 'package:duty_track/features/personnel/data/models/personnel_view_model.dart';
import 'package:duty_track/features/reports/data/models/report_filter.dart';
import 'package:duty_track/features/reports/data/models/report_raw_data.dart';
import 'package:duty_track/features/reports/data/models/report_result.dart';
import 'package:duty_track/features/reports/data/models/report_summary.dart';

class ReportBuilder {
  const ReportBuilder();

  ReportResult build({
    required ReportFilter filter,
    required ReportSummary summary,
    required ReportRawData data,
  }) {
    return ReportResult(
      filter: filter,
      summary: summary,
      duties: _buildDuties(data),
      personnel: _buildPersonnel(data),
    );
  }

  List<DutyViewModel> _buildDuties(ReportRawData data) {
    return data.duties.map((duty) {
      return DutyViewModel(
        duty: duty,
        shiftName: _nameById(data.shifts, duty.shiftId),
        locationName: _nameById(
          data.serviceLocations,
          duty.serviceLocationId,
        ),
        postName: _nameById(data.servicePosts, duty.servicePostId),
        taskTypeName: _nameById(data.missionTypes, duty.taskTypeId),
        status: duty.status,
      );
    }).toList();
  }

  List<PersonnelViewModel> _buildPersonnel(ReportRawData data) {
    return data.personnel.map((person) {
      return PersonnelViewModel(
        personnel: person,
        rankName: _nameById(data.ranks, person.rank),
        departmentName: _nameById(data.departments, person.department),
        serviceLocationName: _nameById(
          data.serviceLocations,
          person.serviceLocationId,
        ),
        servicePostName: _nameById(data.servicePosts, person.servicePostId),
      );
    }).toList();
  }

  String _nameById(Iterable<Object> items, String id) {
    if (id.isEmpty) {
      return '';
    }

    for (final item in items) {
      final itemId = _idFor(item);
      if (itemId == id) {
        final name = _nameFor(item);
        return name.isEmpty ? id : name;
      }
    }

    return id;
  }

  String _idFor(Object item) {
    if (item is ShiftModel) return item.id;
    if (item is ServiceLocationModel) return item.id;
    if (item is ServicePostModel) return item.id;
    if (item is MissionTypeModel) return item.id;
    if (item is RankModel) return item.id;
    if (item is DepartmentModel) return item.id;

    return '';
  }

  String _nameFor(Object item) {
    if (item is ShiftModel) return item.name;
    if (item is ServiceLocationModel) return item.name;
    if (item is ServicePostModel) return item.name;
    if (item is MissionTypeModel) return item.name;
    if (item is RankModel) return item.name;
    if (item is DepartmentModel) return item.name;

    return '';
  }
}
