import 'package:duty_track/features/daily_services/data/models/daily_service_model.dart';
import 'package:duty_track/features/duties/data/models/duty_model.dart';
import 'package:duty_track/features/duties/data/models/duty_personnel_model.dart';
import 'package:duty_track/features/master_data/data/models/department_model.dart';
import 'package:duty_track/features/master_data/data/models/mission_type_model.dart';
import 'package:duty_track/features/master_data/data/models/rank_model.dart';
import 'package:duty_track/features/master_data/data/models/service_location_model.dart';
import 'package:duty_track/features/master_data/data/models/service_post_model.dart';
import 'package:duty_track/features/master_data/data/models/shift_model.dart';
import 'package:duty_track/features/personnel/data/models/personnel_model.dart';
import 'package:duty_track/features/reports/data/models/leave_report_record.dart';
import 'package:duty_track/features/reports/data/models/training_report_record.dart';

class ReportRawData {
  const ReportRawData({
    required this.personnel,
    required this.duties,
    required this.dutyPersonnel,
    required this.leaves,
    required this.training,
    required this.dailyServices,
    required this.missionTypes,
    required this.serviceLocations,
    required this.servicePosts,
    required this.departments,
    required this.ranks,
    required this.shifts,
  });

  final List<PersonnelModel> personnel;
  final List<DutyModel> duties;
  final List<DutyPersonnelModel> dutyPersonnel;
  final List<LeaveReportRecord> leaves;
  final List<TrainingReportRecord> training;
  final List<DailyServiceModel> dailyServices;
  final List<MissionTypeModel> missionTypes;
  final List<ServiceLocationModel> serviceLocations;
  final List<ServicePostModel> servicePosts;
  final List<DepartmentModel> departments;
  final List<RankModel> ranks;
  final List<ShiftModel> shifts;
}
