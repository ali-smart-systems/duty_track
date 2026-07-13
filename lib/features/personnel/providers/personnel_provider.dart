import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/personnel_model.dart';
import '../data/repositories/personnel_repository.dart';
import '../data/models/personnel_view_model.dart';

final personnelViewListProvider = FutureProvider<List<PersonnelViewModel>>((
  ref,
) {
  final repository = ref.watch(personnelRepositoryProvider);

  return repository.getPersonnelViewModels();
});

final personnelRepositoryProvider = Provider<PersonnelRepository>((ref) {
  return PersonnelRepository();
});

final personnelListProvider = FutureProvider<List<PersonnelModel>>((ref) {
  final repository = ref.watch(personnelRepositoryProvider);

  return repository.getPersonnel();
});

final personnelQueryProvider =
    StateNotifierProvider<PersonnelQueryNotifier, PersonnelQueryState>((ref) {
      return PersonnelQueryNotifier();
    });

final filteredPersonnelListProvider = FutureProvider<List<PersonnelModel>>((
  ref,
) async {
  final personnel = await ref.watch(personnelListProvider.future);
  final query = ref.watch(personnelQueryProvider);

  final filteredPersonnel = personnel.where((person) {
    final normalizedSearch = query.searchText.trim().toLowerCase();
    final matchesSearch =
        normalizedSearch.isEmpty ||
        person.fullName.toLowerCase().contains(normalizedSearch) ||
        person.militaryNumber.toLowerCase().contains(normalizedSearch) ||
        person.nationalId.toLowerCase().contains(normalizedSearch);

    final matchesRank =
        query.rank == null || query.rank!.isEmpty || person.rank == query.rank;

    final matchesDepartment =
        query.department == null ||
        query.department!.isEmpty ||
        person.department == query.department;
    final matchesStatus =
        query.status == null ||
        query.status!.isEmpty ||
        person.status == query.status;

    return matchesSearch && matchesRank && matchesDepartment && matchesStatus;
  }).toList();

  filteredPersonnel.sort((first, second) {
    final result = switch (query.sortField) {
      PersonnelSortField.fullName => first.fullName.compareTo(second.fullName),
      PersonnelSortField.militaryNumber => first.militaryNumber.compareTo(
        second.militaryNumber,
      ),
      PersonnelSortField.hireDate => _compareNullableDates(
        first.hireDate,
        second.hireDate,
      ),
    };

    return query.sortAscending ? result : -result;
  });

  return filteredPersonnel;
});
final personnelFilterOptionsProvider = FutureProvider<PersonnelFilterOptions>((
  ref,
) async {
  final personnel = await ref.watch(personnelViewListProvider.future);

  return PersonnelFilterOptions(
    ranks: _uniqueSortedValues(personnel.map((person) => person.rankName)),
    departments: _uniqueSortedValues(
      personnel.map((person) => person.departmentName),
    ),
    statuses: _uniqueSortedValues(
      personnel.map((person) => person.personnel.status),
    ),
  );
});

final personnelByIdProvider = FutureProvider.family<PersonnelModel?, String>((
  ref,
  id,
) {
  final repository = ref.watch(personnelRepositoryProvider);

  return repository.getPersonnelById(id);
});

final personnelViewByIdProvider =
    FutureProvider.family<PersonnelViewModel?, String>((ref, id) {
      final repository = ref.watch(personnelRepositoryProvider);

      return repository.getPersonnelViewModelById(id);
    });

enum PersonnelSortField { fullName, militaryNumber, hireDate }

class PersonnelQueryState {
  const PersonnelQueryState({
    this.searchText = '',
    this.rank,
    this.department,
    this.status,
    this.sortField = PersonnelSortField.fullName,
    this.sortAscending = true,
  });

  final String searchText;
  final String? rank;
  final String? department;
  final String? status;
  final PersonnelSortField sortField;
  final bool sortAscending;

  bool get hasActiveCriteria =>
      searchText.trim().isNotEmpty ||
      (rank != null && rank!.isNotEmpty) ||
      (department != null && department!.isNotEmpty) ||
      (status != null && status!.isNotEmpty);

  PersonnelQueryState copyWith({
    String? searchText,
    String? rank,
    String? department,
    String? status,
    PersonnelSortField? sortField,
    bool? sortAscending,
    bool clearRank = false,
    bool clearDepartment = false,
    bool clearStatus = false,
  }) {
    return PersonnelQueryState(
      searchText: searchText ?? this.searchText,
      rank: clearRank ? null : (rank ?? this.rank),
      department: clearDepartment ? null : (department ?? this.department),
      status: clearStatus ? null : (status ?? this.status),
      sortField: sortField ?? this.sortField,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }
}

class PersonnelQueryNotifier extends StateNotifier<PersonnelQueryState> {
  PersonnelQueryNotifier() : super(const PersonnelQueryState());

  void setSearchText(String value) {
    state = state.copyWith(searchText: value);
  }

  void setRank(String? value) {
    state = value == null || value.isEmpty
        ? state.copyWith(clearRank: true)
        : state.copyWith(rank: value);
  }

  void setDepartment(String? value) {
    state = value == null || value.isEmpty
        ? state.copyWith(clearDepartment: true)
        : state.copyWith(department: value);
  }

  void setStatus(String? value) {
    state = value == null || value.isEmpty
        ? state.copyWith(clearStatus: true)
        : state.copyWith(status: value);
  }

  void setSortField(PersonnelSortField value) {
    state = state.copyWith(sortField: value);
  }

  void setSortAscending(bool value) {
    state = state.copyWith(sortAscending: value);
  }

  void clearFilters() {
    state = state.copyWith(
      searchText: '',
      clearRank: true,
      clearDepartment: true,
      clearStatus: true,
    );
  }
}

class PersonnelFilterOptions {
  const PersonnelFilterOptions({
    required this.ranks,
    required this.departments,
    required this.statuses,
  });

  final List<String> ranks;
  final List<String> departments;
  final List<String> statuses;
}

int _compareNullableDates(DateTime? first, DateTime? second) {
  if (first == null && second == null) {
    return 0;
  }

  if (first == null) {
    return 1;
  }

  if (second == null) {
    return -1;
  }

  return first.compareTo(second);
}

List<String> _uniqueSortedValues(Iterable<String> values) {
  final uniqueValues = values
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty)
      .toSet()
      .toList();

  uniqueValues.sort();

  return uniqueValues;
}

final addPersonnelProvider =
    StateNotifierProvider.autoDispose<AddPersonnelNotifier, AddPersonnelState>((
      ref,
    ) {
      return AddPersonnelNotifier(ref);
    });

class AddPersonnelState {
  const AddPersonnelState({
    this.loading = false,
    this.success = false,
    this.error,
  });

  final bool loading;
  final bool success;
  final String? error;

  AddPersonnelState copyWith({
    bool? loading,
    bool? success,
    String? error,
    bool clearError = false,
  }) {
    return AddPersonnelState(
      loading: loading ?? this.loading,
      success: success ?? this.success,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AddPersonnelNotifier extends StateNotifier<AddPersonnelState> {
  AddPersonnelNotifier(this._ref) : super(const AddPersonnelState());

  final Ref _ref;

  Future<void> addPersonnel(PersonnelModel personnel) async {
    try {
      state = const AddPersonnelState(loading: true);

      final repository = _ref.read(personnelRepositoryProvider);
      final militaryNumberExists = await repository.militaryNumberExists(
        personnel.militaryNumber,
      );

      if (militaryNumberExists) {
        state = const AddPersonnelState(error: 'الرقم العسكري مستخدم مسبقاً');
        return;
      }

      final nationalIdExists = await repository.nationalIdExists(
        personnel.nationalId,
      );

      if (nationalIdExists) {
        state = const AddPersonnelState(error: 'الرقم الوطني مستخدم مسبقاً');
        return;
      }

      await repository.addPersonnel(personnel);

      _ref.invalidate(personnelListProvider);

      state = const AddPersonnelState(success: true);
    } catch (e) {
      state = AddPersonnelState(error: e.toString());
    }
  }
}

final editPersonnelProvider =
    StateNotifierProvider.autoDispose<
      EditPersonnelNotifier,
      EditPersonnelState
    >((ref) {
      return EditPersonnelNotifier(ref);
    });

class EditPersonnelState {
  const EditPersonnelState({
    this.loading = false,
    this.success = false,
    this.error,
  });

  final bool loading;
  final bool success;
  final String? error;
}

class EditPersonnelNotifier extends StateNotifier<EditPersonnelState> {
  EditPersonnelNotifier(this._ref) : super(const EditPersonnelState());

  final Ref _ref;

  Future<void> updatePersonnel(PersonnelModel personnel) async {
    try {
      state = const EditPersonnelState(loading: true);

      final repository = _ref.read(personnelRepositoryProvider);
      final militaryNumberExists = await repository.militaryNumberExists(
        personnel.militaryNumber,
        excludePersonnelId: personnel.id,
      );

      if (militaryNumberExists) {
        state = const EditPersonnelState(error: 'الرقم العسكري مستخدم مسبقاً');
        return;
      }

      final nationalIdExists = await repository.nationalIdExists(
        personnel.nationalId,
        excludePersonnelId: personnel.id,
      );

      if (nationalIdExists) {
        state = const EditPersonnelState(error: 'الرقم الوطني مستخدم مسبقاً');
        return;
      }

      await repository.updatePersonnel(personnel);

      _ref
        ..invalidate(personnelListProvider)
        ..invalidate(personnelByIdProvider(personnel.id));

      state = const EditPersonnelState(success: true);
    } catch (e) {
      state = EditPersonnelState(error: e.toString());
    }
  }
}

final deletePersonnelProvider =
    StateNotifierProvider.autoDispose<
      DeletePersonnelNotifier,
      DeletePersonnelState
    >((ref) {
      return DeletePersonnelNotifier(ref);
    });

class DeletePersonnelState {
  const DeletePersonnelState({
    this.loading = false,
    this.success = false,
    this.error,
  });

  final bool loading;
  final bool success;
  final String? error;
}

class DeletePersonnelNotifier extends StateNotifier<DeletePersonnelState> {
  DeletePersonnelNotifier(this._ref) : super(const DeletePersonnelState());

  final Ref _ref;

  Future<void> deletePersonnel(String id) async {
    try {
      state = const DeletePersonnelState(loading: true);

      await _ref.read(personnelRepositoryProvider).deletePersonnel(id);

      _ref
        ..invalidate(personnelListProvider)
        ..invalidate(personnelByIdProvider(id));

      state = const DeletePersonnelState(success: true);
    } catch (e) {
      state = DeletePersonnelState(error: e.toString());
    }
  }
}
