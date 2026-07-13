import '../models/task_type_model.dart';
import '../services/task_type_service.dart';

class TaskTypeRepository {
  TaskTypeRepository({TaskTypeService? service})
    : _service = service ?? TaskTypeService();

  final TaskTypeService _service;

  Stream<List<TaskTypeModel>> getTaskTypes() {
    return _service.getTaskTypes();
  }

  Future<void> addTaskType(TaskTypeModel taskType) {
    return _service.addTaskType(taskType);
  }

  Future<void> updateTaskType(TaskTypeModel taskType) {
    return _service.updateTaskType(taskType);
  }

  Future<void> deleteTaskType(String id) {
    return _service.deleteTaskType(id);
  }
}
