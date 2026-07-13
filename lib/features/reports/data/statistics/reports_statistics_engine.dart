import 'package:duty_track/features/daily_services/data/models/service_assignment_model.dart';
import 'package:duty_track/features/master_data/data/models/department_model.dart';
import 'package:duty_track/features/master_data/data/models/mission_type_model.dart';
import 'package:duty_track/features/master_data/data/models/rank_model.dart';
import 'package:duty_track/features/master_data/data/models/service_location_model.dart';
import 'package:duty_track/features/master_data/data/models/service_post_model.dart';
import 'package:duty_track/features/master_data/data/models/shift_model.dart';
import 'package:duty_track/features/personnel/data/models/personnel_model.dart';
import 'package:duty_track/features/reports/data/models/leave_report_record.dart';
import 'package:duty_track/features/reports/data/models/report_raw_data.dart';
import 'package:duty_track/features/reports/data/models/report_summary.dart';

class ReportsStatisticsEngine {
  const ReportsStatisticsEngine();

  ReportSummary calculate(ReportRawData data) {
    final personnelIds = data.personnel.map((item) => item.id).toSet();
    final leavePersonnelIds = _leavePersonnelIds(data, personnelIds);
    final absentPersonnelIds = _absentPersonnelIds(data.personnel);
    final assignedPersonnelIds = _assignedPersonnelIds(data)
      ..removeWhere((id) => !personnelIds.contains(id));
    final activePersonnelIds = _activePersonnelIds(data.personnel);

    final presentPersonnelIds = <String>{
      ...assignedPersonnelIds,
      ...activePersonnelIds,
    }..removeWhere(
        (id) => leavePersonnelIds.contains(id) || absentPersonnelIds.contains(id),
      );

    final rawAvailablePersonnel = personnelIds.length -
        absentPersonnelIds.length -
        leavePersonnelIds.length;
    final availablePersonnel =
        rawAvailablePersonnel < 0 ? 0 : rawAvailablePersonnel;

    final shiftCounts = _distribution(
      data.duties,
      (duty) => _nameById(data.shifts, duty.shiftId, (item) => item.name),
    );

    return ReportSummary(
      totalPersonnel: personnelIds.length,
      presentPersonnel: presentPersonnelIds.length,
      activePersonnel: presentPersonnelIds.length,
      absentPersonnel: absentPersonnelIds.length,
      leavePersonnel: leavePersonnelIds.length,
      availablePersonnel: availablePersonnel,
      totalDuties: data.duties.length,
      totalMissions: data.duties
          .where((duty) => duty.taskTypeId.trim().isNotEmpty)
          .length,
      totalLocations: data.serviceLocations.length,
      totalPosts: data.servicePosts.length,
      morningShift: _shiftTotal(shiftCounts, const ['morning', 'صباح']),
      eveningShift: _shiftTotal(shiftCounts, const ['evening', 'مساء']),
      nightShift: _shiftTotal(shiftCounts, const ['night', 'ليل']),
      reserveShift: _shiftTotal(shiftCounts, const ['reserve', 'احتياط']),
      missionCounts: _distribution(
        data.duties,
        (duty) => _nameById(
          data.missionTypes,
          duty.taskTypeId,
          (item) => item.name,
        ),
      ),
      shiftCounts: shiftCounts,
      locationCounts: _distribution(
        data.duties,
        (duty) => _nameById(
          data.serviceLocations,
          duty.serviceLocationId,
          (item) => item.name,
        ),
      ),
      postCounts: _distribution(
        data.duties,
        (duty) => _nameById(data.servicePosts, duty.servicePostId, (item) {
          return item.name;
        }),
      ),
      departmentCounts: _distribution(
        data.personnel,
        (item) => _nameById(data.departments, item.department, (item) {
          return item.name;
        }),
      ),
      rankCounts: _distribution(
        data.personnel,
        (item) => _nameById(data.ranks, item.rank, (item) => item.name),
      ),
      statusCounts: _distribution(data.duties, (duty) => duty.status),
      leaveCounts: _distribution(
        data.leaves,
        (leave) => _leaveDistributionKey(leave),
      ),
      trainingPrograms: _trainingProgramCount(data),
      trainingAttendance: data.training.fold<int>(
        0,
        (total, item) => total + item.attendanceCount,
      ),
      trainingHours: data.training.fold<int>(
        0,
        (total, item) => total + item.hours,
      ),
      readinessPercentage: _readinessPercentage(
        availablePersonnel,
        personnelIds.length,
      ),
    );
  }

  Set<String> _leavePersonnelIds(
    ReportRawData data,
    Set<String> reportPersonnelIds,
  ) {
    final leaveIds = data.leaves
        .map((leave) => leave.personnelId)
        .where((id) => id.isNotEmpty)
        .toSet()
      ..removeWhere((id) => !reportPersonnelIds.contains(id));

    leaveIds.addAll(
      data.personnel
          .where((item) => _isLeaveStatus(item.status))
          .map((item) => item.id),
    );

    return leaveIds;
  }

  Set<String> _absentPersonnelIds(List<PersonnelModel> personnel) {
    return personnel
        .where((item) => _containsAny(item.status, const ['absent', 'غائب']))
        .map((item) => item.id)
        .toSet();
  }

  Set<String> _activePersonnelIds(List<PersonnelModel> personnel) {
    return personnel
        .where(
          (item) => _containsAny(item.status, const [
            'active',
            'present',
            'available',
            'حاضر',
            'نشط',
            'متاح',
          ]),
        )
        .map((item) => item.id)
        .toSet();
  }

  Set<String> _assignedPersonnelIds(ReportRawData data) {
    final dailyAssignments = data.dailyServices
        .expand<ServiceAssignmentModel>((service) => service.assignments)
        .map((assignment) => assignment.personnelId);

    final dutyAssignments = data.dutyPersonnel.map((item) => item.personnelId);

    return <String>{...dailyAssignments, ...dutyAssignments}
      ..removeWhere((id) => id.isEmpty);
  }

  int _trainingProgramCount(ReportRawData data) {
    final programKeys = data.training.map((item) {
      if (item.programId.isNotEmpty) {
        return item.programId;
      }
      if (item.programName.isNotEmpty) {
        return item.programName;
      }
      return item.id;
    }).where((key) => key.isNotEmpty).toSet();

    return programKeys.length;
  }

  Map<String, int> _distribution<T>(
    Iterable<T> items,
    String Function(T item) keyFor,
  ) {
    final result = <String, int>{};

    for (final item in items) {
      final key = keyFor(item).trim();
      if (key.isEmpty) {
        continue;
      }
      result[key] = (result[key] ?? 0) + 1;
    }

    return result;
  }

  String _leaveDistributionKey(LeaveReportRecord leave) {
    if (leave.leaveTypeId.isNotEmpty) {
      return leave.leaveTypeId;
    }

    return leave.status;
  }

  String _nameById<T extends Object>(
    Iterable<T> items,
    String id,
    String Function(T item) nameFor,
  ) {
    if (id.isEmpty) {
      return '';
    }

    for (final item in items) {
      if (_idFor(item) == id) {
        final name = nameFor(item);
        return name.isEmpty ? id : name;
      }
    }

    return id;
  }

  String _idFor(Object item) {
    if (item is MissionTypeModel) {
      return item.id;
    }
    if (item is ShiftModel) {
      return item.id;
    }
    if (item is ServiceLocationModel) {
      return item.id;
    }
    if (item is ServicePostModel) {
      return item.id;
    }
    if (item is DepartmentModel) {
      return item.id;
    }
    if (item is RankModel) {
      return item.id;
    }

    return '';
  }

  int _shiftTotal(Map<String, int> shiftCounts, List<String> markers) {
    var total = 0;

    for (final entry in shiftCounts.entries) {
      if (_containsAny(entry.key, markers)) {
        total += entry.value;
      }
    }

    return total;
  }

  bool _isLeaveStatus(String status) {
    return _containsAny(status, const ['leave', 'اجاز', 'إجاز']);
  }

  bool _containsAny(String value, List<String> markers) {
    final normalized = value.trim().toLowerCase();
    return markers.any((marker) => normalized.contains(marker.toLowerCase()));
  }

  double _readinessPercentage(int availablePersonnel, int totalPersonnel) {
    if (totalPersonnel == 0) {
      return 0;
    }

    return (availablePersonnel / totalPersonnel) * 100;
  }
}
