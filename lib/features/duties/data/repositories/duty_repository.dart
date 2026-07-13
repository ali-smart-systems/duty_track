import '../models/duty_model.dart';
import '../models/duty_personnel_model.dart';
import '../services/duty_service.dart';
import '../../../master_data/data/repositories/master_data_repository.dart';
import '../models/duty_view_model.dart';
import '../../../personnel/data/repositories/personnel_repository.dart';
import '../models/duty_personnel_view_model.dart';
import '../../../master_data/data/repositories/task_type_repository.dart';

class DutyRepository {
  DutyRepository({DutyService? service}) : _service = service ?? DutyService();

  final DutyService _service;

  final MasterDataRepository _masterDataRepository = MasterDataRepository();

  final TaskTypeRepository _taskTypeRepository = TaskTypeRepository();

  // ==========================
  // Duties
  // ==========================

  Future<List<DutyModel>> getDuties() {
    return _service.getDuties();
  }

  Future<DutyModel?> getDutyById(String id) {
    return _service.getDutyById(id);
  }

  Future<bool> dutyExists({
    required DateTime date,
    required String shiftId,
    required String serviceLocationId,
    required String servicePostId,
    String? excludeDutyId,
  }) {
    return _service.dutyExists(
      date: date,
      shiftId: shiftId,
      serviceLocationId: serviceLocationId,
      servicePostId: servicePostId,
      excludeDutyId: excludeDutyId,
    );
  }

  Future<String> addDuty(DutyModel duty) {
    return _service.addDuty(duty);
  }

  Future<void> updateDuty(DutyModel duty) {
    return _service.updateDuty(duty);
  }

  Future<void> deleteDuty(String id) {
    return _service.deleteDuty(id);
  }

  // ==========================
  // Duty Personnel
  // ==========================

  Future<List<DutyPersonnelModel>> getDutyPersonnel(String dutyId) {
    return _service.getDutyPersonnel(dutyId);
  }

  Future<void> addPersonnelToDuty(DutyPersonnelModel model) {
    return _service.addPersonnelToDuty(model);
  }

  Future<void> removePersonnelFromDuty(String recordId) {
    return _service.removePersonnelFromDuty(recordId);
  }

  Future<void> removeAllPersonnelFromDuty(String dutyId) {
    return _service.removeAllPersonnelFromDuty(dutyId);
  }

  Future<List<DutyViewModel>> getDutyViewModels() async {
    final duties = await getDuties();

    final shifts = await _masterDataRepository.getShifts().first;
    final locations = await _masterDataRepository.getServiceLocations().first;
    final taskTypes = await _taskTypeRepository.getTaskTypes().first;
    final posts = <dynamic>[];

    for (final location in locations) {
      posts.addAll(
        await _masterDataRepository.getServicePosts(location.id).first,
      );
    }

    return duties.map((duty) {
      final shift = shifts.where((e) => e.id == duty.shiftId).firstOrNull;

      final location = locations
          .where((e) => e.id == duty.serviceLocationId)
          .firstOrNull;

      final post = posts.where((e) => e.id == duty.servicePostId).firstOrNull;
      final taskType = taskTypes
          .where((e) => e.id == duty.taskTypeId)
          .firstOrNull;
      return DutyViewModel(
        duty: duty,
        shiftName: shift?.name ?? '',
        locationName: location?.name ?? '',
        postName: post?.name ?? '',
        taskTypeName: taskType?.name ?? '',
        status: duty.status,
      );
    }).toList();
  }

  Future<List<DutyPersonnelViewModel>> getDutyPersonnelViewModels(
    String dutyId,
  ) async {
    final dutyPersonnel = await getDutyPersonnel(dutyId);

    final personnelRepository = PersonnelRepository();
    final personnel = await personnelRepository.getPersonnelViewModels();

    return dutyPersonnel.map((item) {
      final person = personnel
          .where((e) => e.personnel.id == item.personnelId)
          .firstOrNull;

      return DutyPersonnelViewModel(
        personnelId: item.personnelId,
        fullName: person?.personnel.fullName ?? '',
        rank: person?.rankName ?? '',
        role: item.role,
        isLeader: item.isLeader,
      );
    }).toList();
  }

  Future<DutyViewModel?> getDutyViewModelById(String id) async {
    final duty = await getDutyById(id);

    if (duty == null) {
      return null;
    }

    final shifts = await _masterDataRepository.getShifts().first;
    final locations = await _masterDataRepository.getServiceLocations().first;
    final taskTypes = await _taskTypeRepository.getTaskTypes().first;
    final posts = <dynamic>[];

    for (final location in locations) {
      posts.addAll(
        await _masterDataRepository.getServicePosts(location.id).first,
      );
    }

    final shift = shifts.where((e) => e.id == duty.shiftId).firstOrNull;

    final location = locations
        .where((e) => e.id == duty.serviceLocationId)
        .firstOrNull;

    final post = posts.where((e) => e.id == duty.servicePostId).firstOrNull;
    final taskType = taskTypes
        .where((e) => e.id == duty.taskTypeId)
        .firstOrNull;
    return DutyViewModel(
      duty: duty,
      shiftName: shift?.name ?? '',
      locationName: location?.name ?? '',
      postName: post?.name ?? '',
      taskTypeName: taskType?.name ?? '',
      status: duty.status,
    );
  }
}
