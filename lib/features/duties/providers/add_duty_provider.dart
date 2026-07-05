import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/duty_model.dart';
import 'duty_list_provider.dart';
import 'duty_repository_provider.dart';

final addDutyProvider =
    StateNotifierProvider.autoDispose<AddDutyNotifier, AddDutyState>((ref) {
      return AddDutyNotifier(ref);
    });

class AddDutyState {
  const AddDutyState({this.loading = false, this.success = false, this.error});

  final bool loading;
  final bool success;
  final String? error;
}

class AddDutyNotifier extends StateNotifier<AddDutyState> {
  AddDutyNotifier(this._ref) : super(const AddDutyState());

  final Ref _ref;

  Future<void> addDuty(DutyModel duty) async {
    try {
      state = const AddDutyState(loading: true);

      await _ref.read(dutyRepositoryProvider).addDuty(duty);

      _ref.invalidate(dutyListProvider);

      state = const AddDutyState(success: true);
    } catch (e) {
      state = AddDutyState(error: e.toString());
    }
  }
}
