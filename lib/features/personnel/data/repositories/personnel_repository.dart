import '../models/personnel_model.dart';
import '../services/personnel_service.dart';

class PersonnelRepository {
  PersonnelRepository({PersonnelService? service})
    : _service = service ?? PersonnelService();

  final PersonnelService _service;

  Future<List<PersonnelModel>> getPersonnel() {
    return _service.getPersonnel();
  }

  Future<PersonnelModel?> getPersonnelById(String id) {
    return _service.getPersonnelById(id);
  }

  Future<String> addPersonnel(PersonnelModel personnel) {
    return _service.addPersonnel(personnel);
  }

  Future<bool> militaryNumberExists(
    String militaryNumber, {
    String? excludePersonnelId,
  }) {
    return _service.militaryNumberExists(
      militaryNumber,
      excludePersonnelId: excludePersonnelId,
    );
  }

  Future<bool> nationalIdExists(
    String nationalId, {
    String? excludePersonnelId,
  }) {
    return _service.nationalIdExists(
      nationalId,
      excludePersonnelId: excludePersonnelId,
    );
  }

  Future<void> updatePersonnel(PersonnelModel personnel) {
    return _service.updatePersonnel(personnel);
  }

  Future<void> deletePersonnel(String id) {
    return _service.deletePersonnel(id);
  }
}
