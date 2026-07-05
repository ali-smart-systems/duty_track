import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/duty_repository.dart';

final dutyRepositoryProvider = Provider<DutyRepository>((ref) {
  return DutyRepository();
});
