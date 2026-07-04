import '../models/service_location_model.dart';
import '../models/service_post_model.dart';
import '../seed/service_locations_seed.dart';
import '../services/master_data_service.dart';
import '../models/shift_model.dart';
import '../models/rank_model.dart';
import '../services/rank_service.dart';
import '../models/department_model.dart';
import '../services/department_service.dart';

class MasterDataRepository {
  MasterDataRepository({
    MasterDataService? service,
    RankService? rankService,
    DepartmentService? departmentService,
  }) : _service = service ?? MasterDataService(),
       _rankService = rankService ?? RankService(),
       _departmentService = departmentService ?? DepartmentService();

  final MasterDataService _service;
  final RankService _rankService;
  final DepartmentService _departmentService;
  // ==========================
  // Service Locations
  // ==========================

  Stream<List<ServiceLocationModel>> getServiceLocations() {
    return _service.getServiceLocations();
  }

  Future<void> addServiceLocation(ServiceLocationModel location) {
    return _service.addServiceLocation(location);
  }

  Future<void> updateServiceLocation(ServiceLocationModel location) {
    return _service.updateServiceLocation(location);
  }

  Future<void> deleteServiceLocation(String id) {
    return _service.deleteServiceLocation(id);
  }

  Future<bool> serviceLocationExists(String name, {String? excludeId}) async {
    final locations = await getServiceLocations().first;

    return locations.any(
      (location) =>
          location.name.trim().toLowerCase() == name.trim().toLowerCase() &&
          location.id != excludeId,
    );
  }

  Future<void> seedServiceLocations() async {
    await _service.seedServiceLocations(ServiceLocationsSeed.data);
  }

  // ==========================
  // Service Posts
  // ==========================

  Stream<List<ServicePostModel>> getServicePosts(String locationId) {
    return _service.getServicePosts(locationId);
  }

  Future<void> addServicePost(ServicePostModel post) {
    return _service.addServicePost(post);
  }

  Future<void> updateServicePost(ServicePostModel post) {
    return _service.updateServicePost(post);
  }

  Future<void> deleteServicePost(String id) {
    return _service.deleteServicePost(id);
  }
  // ==========================
  // Shifts
  // ==========================

  Stream<List<ShiftModel>> getShifts() {
    return _service.getShifts();
  }

  Future<void> addShift(ShiftModel shift) {
    return _service.addShift(shift);
  }

  Future<void> updateShift(ShiftModel shift) {
    return _service.updateShift(shift);
  }

  Future<void> deleteShift(String id) {
    return _service.deleteShift(id);
  }

  // ==========================
  // Ranks
  // ==========================

  Stream<List<RankModel>> getRanks() {
    return _rankService.getRanks();
  }

  Future<void> addRank(RankModel rank) {
    return _rankService.addRank(rank);
  }

  Future<void> updateRank(RankModel rank) {
    return _rankService.updateRank(rank);
  }

  Future<void> deleteRank(String id) {
    return _rankService.deleteRank(id);
  }
  // ==========================
  // Departments
  // ==========================

  Stream<List<DepartmentModel>> getDepartments() {
    return _departmentService.getDepartments();
  }

  Future<void> addDepartment(DepartmentModel department) {
    return _departmentService.addDepartment(department);
  }

  Future<void> updateDepartment(DepartmentModel department) {
    return _departmentService.updateDepartment(department);
  }

  Future<void> deleteDepartment(String id) {
    return _departmentService.deleteDepartment(id);
  }
}
