import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/duty_model.dart';
import 'duty_list_provider.dart';
import 'duty_repository_provider.dart';

final editDutyProvider =
    StateNotifierProvider.autoDispose<EditDutyNotifier, EditDutyState>((ref) {
      return EditDutyNotifier(ref);
    });

class EditDutyState {
  const EditDutyState({this.loading = false, this.success = false, this.error});

  final bool loading;
  final bool success;
  final String? error;
}

class EditDutyNotifier extends StateNotifier<EditDutyState> {
  EditDutyNotifier(this._ref) : super(const EditDutyState());

  final Ref _ref;

  Future<void> updateDuty(DutyModel duty) async {
    try {
      state = const EditDutyState(loading: true);

      await _ref.read(dutyRepositoryProvider).updateDuty(duty);

      _ref
        ..invalidate(dutyListProvider)
        ..invalidate(dutyByIdProvider(duty.id));

      state = const EditDutyState(success: true);
    } catch (e) {
      state = EditDutyState(error: e.toString());
    }
  }
}
