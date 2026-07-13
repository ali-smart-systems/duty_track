import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/constants/app_constants.dart';
import '../models/task_type_model.dart';

class TaskTypeService {
  TaskTypeService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _taskTypes =>
      _firestore.collection(AppConstants.taskTypesCollection);

  Stream<List<TaskTypeModel>> getTaskTypes() {
    return _taskTypes
        .orderBy('displayOrder')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(TaskTypeModel.fromFirestore).toList(),
        );
  }

  Future<void> addTaskType(TaskTypeModel taskType) async {
    await _taskTypes.add(taskType.toFirestore());
  }

  Future<void> updateTaskType(TaskTypeModel taskType) async {
    await _taskTypes.doc(taskType.id).update(taskType.toFirestore());
  }

  Future<void> deleteTaskType(String id) async {
    await _taskTypes.doc(id).delete();
  }
}
