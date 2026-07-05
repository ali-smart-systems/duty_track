import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'duty_list_provider.dart';
import 'duty_repository_provider.dart';

final deleteDutyProvider =
    StateNotifierProvider.autoDispose<DeleteDutyNotifier, DeleteDutyState>((
      ref,
    ) {
      return DeleteDutyNotifier(ref);
    });

class DeleteDutyState {
  const DeleteDutyState({
    this.loading = false,
    this.success = false,
    this.error,
  });

  final bool loading;
  final bool success;
  final String? error;
}

class DeleteDutyNotifier extends StateNotifier<DeleteDutyState> {
  DeleteDutyNotifier(this._ref) : super(const DeleteDutyState());

  final Ref _ref;

  Future<void> deleteDuty(String id) async {
    try {
      state = const DeleteDutyState(loading: true);

      await _ref.read(dutyRepositoryProvider).deleteDuty(id);

      _ref
        ..invalidate(dutyListProvider)
        ..invalidate(dutyByIdProvider(id));

      state = const DeleteDutyState(success: true);
    } catch (e) {
      state = DeleteDutyState(error: e.toString());
    }
  }
}
