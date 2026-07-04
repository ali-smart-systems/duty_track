import '../models/daily_service_model.dart';
import '../services/daily_service_service.dart';

class DailyServiceRepository {
  DailyServiceRepository({DailyServiceService? service})
    : _service = service ?? DailyServiceService();

  final DailyServiceService _service;

  Stream<List<DailyServiceModel>> getDailyServices() {
    return _service.getDailyServices();
  }

  Future<DailyServiceModel?> getById(String id) {
    return _service.getById(id);
  }

  Future<void> add(DailyServiceModel model) {
    return _service.add(model);
  }

  Future<void> update(DailyServiceModel model) {
    return _service.update(model);
  }

  Future<void> delete(String id) {
    return _service.delete(id);
  }
}
