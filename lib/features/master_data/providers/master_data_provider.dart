import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/department_model.dart';
import '../data/models/leave_type_model.dart';
import '../data/models/rank_model.dart';
import '../data/models/service_location_model.dart';
import '../data/models/service_post_model.dart';
import '../data/models/shift_model.dart';
import '../data/repositories/master_data_repository.dart';
import '../data/models/mission_type_model.dart';

final masterDataRepositoryProvider = Provider<MasterDataRepository>((ref) {
  return MasterDataRepository();
});

final missionTypesProvider = StreamProvider<List<MissionTypeModel>>((ref) {
  return ref.watch(masterDataRepositoryProvider).getMissionTypes();
});

// ==========================
// Service Locations
// ==========================

final serviceLocationsProvider = StreamProvider<List<ServiceLocationModel>>((
  ref,
) {
  return ref.watch(masterDataRepositoryProvider).getServiceLocations();
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
// Ranks
// ==========================

final ranksProvider = StreamProvider<List<RankModel>>((ref) {
  return ref.watch(masterDataRepositoryProvider).getRanks();
});

// ==========================
// Departments
// ==========================

final departmentsProvider = StreamProvider<List<DepartmentModel>>((ref) {
  return ref.watch(masterDataRepositoryProvider).getDepartments();
});

// ==========================
// Leave Types
// ==========================

final leaveTypesProvider = StreamProvider<List<LeaveTypeModel>>((ref) {
  return ref.watch(masterDataRepositoryProvider).getLeaveTypes();
});

// ==========================
// Controller
// ==========================

final masterDataControllerProvider = Provider<MasterDataRepository>((ref) {
  return ref.read(masterDataRepositoryProvider);
});
