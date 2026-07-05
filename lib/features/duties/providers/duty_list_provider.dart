import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/duty_model.dart';
import 'duty_repository_provider.dart';

final dutyListProvider = FutureProvider<List<DutyModel>>((ref) {
  return ref.read(dutyRepositoryProvider).getDuties();
});

final dutyByIdProvider = FutureProvider.family<DutyModel?, String>((ref, id) {
  return ref.read(dutyRepositoryProvider).getDutyById(id);
});
