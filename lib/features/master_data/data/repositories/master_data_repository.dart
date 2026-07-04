import '../models/service_location_model.dart';
import '../models/service_post_model.dart';
import '../seed/service_locations_seed.dart';
import '../services/master_data_service.dart';

class MasterDataRepository {
  MasterDataRepository({MasterDataService? service})
    : _service = service ?? MasterDataService();

  final MasterDataService _service;

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
}
