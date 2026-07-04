import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/service_location_model.dart';
import '../data/models/service_post_model.dart';
import '../data/models/shift_model.dart';
import '../data/repositories/master_data_repository.dart';
import '../data/models/rank_model.dart';
import '../data/models/department_model.dart';

final masterDataRepositoryProvider = Provider<MasterDataRepository>((ref) {
  return MasterDataRepository();
});
final departmentsProvider = StreamProvider<List<DepartmentModel>>((ref) {
  return ref.watch(masterDataRepositoryProvider).getDepartments();
});
// ==========================
// Service Locations
// ==========================

final serviceLocationsProvider = StreamProvider<List<ServiceLocationModel>>((
  ref,
) {
  return ref.watch(masterDataRepositoryProvider).getServiceLocations();
});
final ranksProvider = StreamProvider<List<RankModel>>((ref) {
  return ref.watch(masterDataRepositoryProvider).getRanks();
});
// ==========================
// Service Posts
// ==========================

final servicePostsProvider =
    StreamProvider.family<List<ServicePostModel>, String>((ref, locationId) {
      return ref
          .watch(masterDataRepositoryProvider)
          .getServicePosts(locationId);
    });

// ==========================
// Shifts
// ==========================

final shiftsProvider = StreamProvider<List<ShiftModel>>((ref) {
  return ref.watch(masterDataRepositoryProvider).getShifts();
});

// ==========================
// Controller
// ==========================

final masterDataControllerProvider = Provider<MasterDataRepository>((ref) {
  return ref.read(masterDataRepositoryProvider);
});
