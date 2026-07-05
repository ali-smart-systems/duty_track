import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/duty_personnel_model.dart';
import 'duty_repository_provider.dart';

final dutyPersonnelProvider =
    FutureProvider.family<List<DutyPersonnelModel>, String>((ref, dutyId) {
      return ref.read(dutyRepositoryProvider).getDutyPersonnel(dutyId);
    });
