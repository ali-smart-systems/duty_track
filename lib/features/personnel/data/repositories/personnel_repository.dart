import '../models/personnel_model.dart';
import '../services/personnel_service.dart';
import '../../../master_data/data/repositories/master_data_repository.dart';
import '../models/personnel_view_model.dart';

class PersonnelRepository {
  PersonnelRepository({PersonnelService? service})
    : _service = service ?? PersonnelService();

  final PersonnelService _service;
  final MasterDataRepository _masterDataRepository = MasterDataRepository();
  Future<List<PersonnelModel>> getPersonnel() {
    return _service.getPersonnel();
  }

  Future<PersonnelModel?> getPersonnelById(String id) {
    return _service.getPersonnelById(id);
  }

  Future<String> addPersonnel(PersonnelModel personnel) {
    return _service.addPersonnel(personnel);
  }

  Future<void> updatePersonnel(PersonnelModel personnel) {
    return _service.updatePersonnel(personnel);
  }

  Future<void> deletePersonnel(String id) {
    return _service.deletePersonnel(id);
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

  Future<List<PersonnelViewModel>> getPersonnelViewModels() async {
    final personnel = await getPersonnel();

    final ranks = await _masterDataRepository.getRanks().first;
    final departments = await _masterDataRepository.getDepartments().first;
    final locations = await _masterDataRepository.getServiceLocations().first;

    final posts = <dynamic>[];

    for (final location in locations) {
      posts.addAll(
        await _masterDataRepository.getServicePosts(location.id).first,
      );
    }

    return personnel.map((person) {
      final rank = ranks.where((e) => e.id == person.rank).firstOrNull;

      final department = departments
          .where((e) => e.id == person.department)
          .firstOrNull;
      final location = locations
          .where((e) => e.id == person.serviceLocationId)
          .firstOrNull;

      final post = posts.where((e) => e.id == person.servicePostId).firstOrNull;

      return PersonnelViewModel(
        personnel: person,
        rankName: rank?.name ?? '',
        departmentName: department?.name ?? '',
        serviceLocationName: location?.name ?? '',
        servicePostName: post?.name ?? '',
      );
    }).toList();
  }

  Future<PersonnelViewModel?> getPersonnelViewModelById(String id) async {
    final items = await getPersonnelViewModels();

    return items.where((e) => e.personnel.id == id).firstOrNull;
  }
}
