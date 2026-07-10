import '../models/duty_model.dart';
import '../models/duty_personnel_model.dart';
import '../services/duty_service.dart';
import '../../../master_data/data/repositories/master_data_repository.dart';
import '../models/duty_view_model.dart';

class DutyRepository {
  DutyRepository({DutyService? service}) : _service = service ?? DutyService();

  final DutyService _service;

  final MasterDataRepository _masterDataRepository = MasterDataRepository();

  // ==========================
  // Duties
  // ==========================

  Future<List<DutyModel>> getDuties() {
    return _service.getDuties();
  }

  Future<DutyModel?> getDutyById(String id) {
    return _service.getDutyById(id);
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

    return duties.map((duty) {
      final shift = shifts.where((e) => e.id == duty.shiftId).firstOrNull;

      final location = locations
          .where((e) => e.id == duty.serviceLocationId)
          .firstOrNull;

      return DutyViewModel(
        duty: duty,
        shiftName: shift?.name ?? '',
        locationName: location?.name ?? '',
        postName: '',
      );
    }).toList();
  }
}
