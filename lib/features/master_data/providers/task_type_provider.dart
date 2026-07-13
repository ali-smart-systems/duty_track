import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/task_type_model.dart';
import '../data/repositories/task_type_repository.dart';

final taskTypeRepositoryProvider = Provider<TaskTypeRepository>((ref) {
  return TaskTypeRepository();
});

final taskTypesProvider = StreamProvider<List<TaskTypeModel>>((ref) {
  return ref.read(taskTypeRepositoryProvider).getTaskTypes();
});
