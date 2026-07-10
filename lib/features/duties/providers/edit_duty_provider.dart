import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/duty_model.dart';
import 'duty_list_provider.dart';
import 'duty_repository_provider.dart';
import '../data/models/duty_personnel_model.dart';

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

  Future<void> updateDuty(
    DutyModel duty,
    List<DutyPersonnelModel> personnel,
  ) async {
    try {
      state = const EditDutyState(loading: true);

      final repository = _ref.read(dutyRepositoryProvider);

      await repository.updateDuty(duty);

      await repository.removeAllPersonnelFromDuty(duty.id);

      for (final item in personnel) {
        await repository.addPersonnelToDuty(item.copyWith(dutyId: duty.id));
      }

      _ref
        ..invalidate(dutyListProvider)
        ..invalidate(dutyByIdProvider(duty.id));

      state = const EditDutyState(success: true);
    } catch (e) {
      state = EditDutyState(error: e.toString());
    }
  }
}
