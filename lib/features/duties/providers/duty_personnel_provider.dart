import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/duty_personnel_view_model.dart';
import 'duty_repository_provider.dart';

final dutyPersonnelProvider =
    FutureProvider.family<List<DutyPersonnelViewModel>, String>((ref, dutyId) {
      return ref
          .read(dutyRepositoryProvider)
          .getDutyPersonnelViewModels(dutyId);
    });
