import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/duty_view_model.dart';
import 'duty_repository_provider.dart';

final dutyListProvider = FutureProvider<List<DutyViewModel>>((ref) {
  return ref.read(dutyRepositoryProvider).getDutyViewModels();
});
final dutyByIdProvider = FutureProvider.family<DutyViewModel?, String>((
  ref,
  id,
) {
  return ref.read(dutyRepositoryProvider).getDutyViewModelById(id);
});
