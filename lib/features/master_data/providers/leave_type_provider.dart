import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/leave_type_model.dart';
import '../data/repositories/leave_type_repository.dart';

final leaveTypeRepositoryProvider = Provider<LeaveTypeRepository>((ref) {
  return LeaveTypeRepository();
});

final leaveTypesProvider = StreamProvider<List<LeaveTypeModel>>((ref) {
  return ref.read(leaveTypeRepositoryProvider).getLeaveTypes();
});

final addLeaveTypeProvider =
    StateNotifierProvider.autoDispose<AddLeaveTypeNotifier, AddLeaveTypeState>((
      ref,
    ) {
      return AddLeaveTypeNotifier(ref);
    });

class AddLeaveTypeState {
  const AddLeaveTypeState({
    this.loading = false,
    this.success = false,
    this.error,
  });

  final bool loading;
  final bool success;
  final String? error;
}

class AddLeaveTypeNotifier extends StateNotifier<AddLeaveTypeState> {
  AddLeaveTypeNotifier(this._ref) : super(const AddLeaveTypeState());

  final Ref _ref;

  Future<void> addLeaveType(LeaveTypeModel leaveType) async {
    try {
      state = const AddLeaveTypeState(loading: true);

      await _ref.read(leaveTypeRepositoryProvider).addLeaveType(leaveType);

      state = const AddLeaveTypeState(success: true);
    } catch (e) {
      state = AddLeaveTypeState(error: e.toString());
    }
  }
}
