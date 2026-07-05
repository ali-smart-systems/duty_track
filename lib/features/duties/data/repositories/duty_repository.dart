import '../models/duty_model.dart';
import '../models/duty_personnel_model.dart';
import '../services/duty_service.dart';

class DutyRepository {
  DutyRepository({DutyService? service}) : _service = service ?? DutyService();

  final DutyService _service;

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
}
