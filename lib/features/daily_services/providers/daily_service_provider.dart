import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/daily_service_model.dart';
import '../data/repositories/daily_service_repository.dart';

final dailyServiceRepositoryProvider = Provider<DailyServiceRepository>((ref) {
  return DailyServiceRepository();
});

final dailyServicesProvider = StreamProvider<List<DailyServiceModel>>((ref) {
  return ref.watch(dailyServiceRepositoryProvider).getDailyServices();
});

final dailyServiceByIdProvider =
    FutureProvider.family<DailyServiceModel?, String>((ref, id) {
      return ref.watch(dailyServiceRepositoryProvider).getById(id);
    });
