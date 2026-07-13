import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duty_track/core/constants/app_constants.dart';
import 'package:duty_track/features/daily_services/data/models/daily_service_model.dart';
import 'package:duty_track/features/daily_services/data/repositories/daily_service_repository.dart';
import 'package:duty_track/features/duties/data/models/duty_model.dart';
import 'package:duty_track/features/duties/data/models/duty_personnel_model.dart';
import 'package:duty_track/features/duties/data/repositories/duty_repository.dart';
import 'package:duty_track/features/master_data/data/models/department_model.dart';
import 'package:duty_track/features/master_data/data/models/mission_type_model.dart';
import 'package:duty_track/features/master_data/data/models/rank_model.dart';
import 'package:duty_track/features/master_data/data/models/service_location_model.dart';
import 'package:duty_track/features/master_data/data/models/service_post_model.dart';
import 'package:duty_track/features/master_data/data/models/shift_model.dart';
import 'package:duty_track/features/master_data/data/repositories/master_data_repository.dart';
import 'package:duty_track/features/personnel/data/models/personnel_model.dart';
import 'package:duty_track/features/personnel/data/repositories/personnel_repository.dart';
import 'package:duty_track/features/reports/data/models/leave_report_record.dart';
import 'package:duty_track/features/reports/data/models/training_report_record.dart';

class ReportsRepository {
  ReportsRepository({
    PersonnelRepository? personnelRepository,
    DutyRepository? dutyRepository,
    DailyServiceRepository? dailyServiceRepository,
    MasterDataRepository? masterDataRepository,
    FirebaseFirestore? firestore,
  }) : _personnelRepository = personnelRepository ?? PersonnelRepository(),
       _dutyRepository = dutyRepository ?? DutyRepository(),
       _dailyServiceRepository =
           dailyServiceRepository ?? DailyServiceRepository(),
       _masterDataRepository = masterDataRepository ?? MasterDataRepository(),
       _firestore = firestore ?? FirebaseFirestore.instance;

  final PersonnelRepository _personnelRepository;
  final DutyRepository _dutyRepository;
  final DailyServiceRepository _dailyServiceRepository;
  final MasterDataRepository _masterDataRepository;
  final FirebaseFirestore _firestore;

  Future<List<PersonnelModel>> getPersonnel() {
    return _personnelRepository.getPersonnel();
  }

  Future<List<DutyModel>> getDuties() {
    return _dutyRepository.getDuties();
  }

  Future<List<DutyPersonnelModel>> getDutyPersonnel(String dutyId) {
    return _dutyRepository.getDutyPersonnel(dutyId);
  }

  Future<List<DailyServiceModel>> getDailyServices() {
    return _dailyServiceRepository.getDailyServices().first;
  }

  Future<List<LeaveReportRecord>> getLeaves() async {
    final snapshot = await _firestore
        .collection(AppConstants.leavesCollection)
        .get();

    return snapshot.docs.map(LeaveReportRecord.fromFirestore).toList();
  }

  Future<List<TrainingReportRecord>> getTraining() async {
    final snapshot = await _firestore
        .collection(AppConstants.trainingCollection)
        .get();

    return snapshot.docs.map(TrainingReportRecord.fromFirestore).toList();
  }

  Future<List<MissionTypeModel>> getMissionTypes() {
    return _masterDataRepository.getMissionTypes().first;
  }

  Future<List<ServiceLocationModel>> getServiceLocations() {
    return _masterDataRepository.getServiceLocations().first;
  }

  Future<List<ServicePostModel>> getServicePosts(
    List<ServiceLocationModel> locations,
  ) async {
    final posts = <ServicePostModel>[];

    for (final location in locations) {
      posts.addAll(
        await _masterDataRepository.getServicePosts(location.id).first,
      );
    }

    return posts;
  }

  Future<List<DepartmentModel>> getDepartments() {
    return _masterDataRepository.getDepartments().first;
  }

  Future<List<RankModel>> getRanks() {
    return _masterDataRepository.getRanks().first;
  }

  Future<List<ShiftModel>> getShifts() {
    return _masterDataRepository.getShifts().first;
  }
}
