import 'package:duty_track/features/master_data/data/models/department_model.dart';
import 'package:duty_track/features/master_data/data/models/rank_model.dart';
import 'package:duty_track/features/master_data/data/models/service_location_model.dart';
import 'package:duty_track/features/master_data/data/models/service_post_model.dart';
import 'package:duty_track/features/master_data/data/models/shift_model.dart';
import 'package:duty_track/features/reports/data/builders/report_builder.dart';
import 'package:duty_track/features/reports/data/collectors/daily_service_collector.dart';
import 'package:duty_track/features/reports/data/collectors/duty_collector.dart';
import 'package:duty_track/features/reports/data/collectors/leave_collector.dart';
import 'package:duty_track/features/reports/data/collectors/mission_collector.dart';
import 'package:duty_track/features/reports/data/collectors/personnel_collector.dart';
import 'package:duty_track/features/reports/data/collectors/report_filter_matcher.dart';
import 'package:duty_track/features/reports/data/collectors/training_collector.dart';
import 'package:duty_track/features/reports/data/models/report_filter.dart';
import 'package:duty_track/features/reports/data/models/report_raw_data.dart';
import 'package:duty_track/features/reports/data/models/report_result.dart';
import 'package:duty_track/features/reports/data/repositories/reports_repository.dart';
import 'package:duty_track/features/reports/data/statistics/reports_statistics_engine.dart';

class ReportsService {
  ReportsService({
    ReportsRepository? repository,
    PersonnelCollector? personnelCollector,
    DutyCollector? dutyCollector,
    LeaveCollector? leaveCollector,
    TrainingCollector? trainingCollector,
    MissionCollector? missionCollector,
    DailyServiceCollector? dailyServiceCollector,
    ReportsStatisticsEngine? statisticsEngine,
    ReportBuilder? reportBuilder,
  }) : _repository = repository ?? ReportsRepository(),
       _personnelCollector = personnelCollector,
       _dutyCollector = dutyCollector,
       _leaveCollector = leaveCollector,
       _trainingCollector = trainingCollector,
       _missionCollector = missionCollector,
       _dailyServiceCollector = dailyServiceCollector,
       _statisticsEngine = statisticsEngine ?? const ReportsStatisticsEngine(),
       _reportBuilder = reportBuilder ?? const ReportBuilder();

  final ReportsRepository _repository;
  final PersonnelCollector? _personnelCollector;
  final DutyCollector? _dutyCollector;
  final LeaveCollector? _leaveCollector;
  final TrainingCollector? _trainingCollector;
  final MissionCollector? _missionCollector;
  final DailyServiceCollector? _dailyServiceCollector;
  final ReportsStatisticsEngine _statisticsEngine;
  final ReportBuilder _reportBuilder;

  Future<ReportResult> generateReport(ReportFilter filter) async {
    final personnelCollector =
        _personnelCollector ?? PersonnelCollector(repository: _repository);
    final dutyCollector =
        _dutyCollector ?? DutyCollector(repository: _repository);
    final leaveCollector =
        _leaveCollector ?? LeaveCollector(repository: _repository);
    final trainingCollector =
        _trainingCollector ?? TrainingCollector(repository: _repository);
    final missionCollector =
        _missionCollector ?? MissionCollector(repository: _repository);
    final dailyServiceCollector =
        _dailyServiceCollector ?? DailyServiceCollector(repository: _repository);

    final personnel = await personnelCollector.collect(filter);
    final duties = await dutyCollector.collect(filter);
    final dutyPersonnel = await dutyCollector.collectDutyPersonnel(
      filter,
      duties: duties,
    );
    final leaves = await leaveCollector.collect(filter);
    final training = await trainingCollector.collect(filter);
    final dailyServices = await dailyServiceCollector.collect(filter);
    final missionTypes = await missionCollector.collect(filter);
    final serviceLocations = await _collectServiceLocations(filter);
    final servicePosts = await _collectServicePosts(filter, serviceLocations);
    final departments = await _collectDepartments(filter);
    final ranks = await _collectRanks(filter);
    final shifts = await _collectShifts(filter);

    final rawData = ReportRawData(
      personnel: personnel,
      duties: duties,
      dutyPersonnel: dutyPersonnel,
      leaves: leaves,
      training: training,
      dailyServices: dailyServices,
      missionTypes: missionTypes,
      serviceLocations: serviceLocations,
      servicePosts: servicePosts,
      departments: departments,
      ranks: ranks,
      shifts: shifts,
    );

    final summary = _statisticsEngine.calculate(rawData);

    return _reportBuilder.build(
      filter: filter,
      summary: summary,
      data: rawData,
    );
  }

  Future<List<ServiceLocationModel>> _collectServiceLocations(
    ReportFilter filter,
  ) async {
    final locations = await _repository.getServiceLocations();

    return locations.where((location) {
      return ReportFilterMatcher.matchesNullable(filter.locationId, location.id);
    }).toList();
  }

  Future<List<ServicePostModel>> _collectServicePosts(
    ReportFilter filter,
    List<ServiceLocationModel> locations,
  ) async {
    final posts = await _repository.getServicePosts(locations);

    return posts.where((post) {
      return ReportFilterMatcher.matchesNullable(
            filter.locationId,
            post.locationId,
          ) &&
          ReportFilterMatcher.matchesNullable(filter.postId, post.id);
    }).toList();
  }

  Future<List<DepartmentModel>> _collectDepartments(ReportFilter filter) async {
    final departments = await _repository.getDepartments();

    return departments.where((department) {
      return ReportFilterMatcher.matchesNullable(
        filter.departmentId,
        department.id,
      );
    }).toList();
  }

  Future<List<RankModel>> _collectRanks(ReportFilter filter) async {
    final ranks = await _repository.getRanks();

    return ranks.where((rank) {
      return ReportFilterMatcher.matchesNullable(filter.rankId, rank.id);
    }).toList();
  }

  Future<List<ShiftModel>> _collectShifts(ReportFilter filter) async {
    final shifts = await _repository.getShifts();

    return shifts.where((shift) {
      return ReportFilterMatcher.matchesNullable(filter.shiftId, shift.id);
    }).toList();
  }
}
