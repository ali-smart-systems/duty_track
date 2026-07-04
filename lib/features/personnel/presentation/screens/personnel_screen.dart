import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/personnel_model.dart';
import '../../providers/personnel_provider.dart';
import 'add_personnel_screen.dart';
import 'edit_personnel_screen.dart';
import 'personnel_details_screen.dart';

class PersonnelScreen extends ConsumerStatefulWidget {
  const PersonnelScreen({super.key});

  static const double _maxContentWidth = 900;

  @override
  ConsumerState<PersonnelScreen> createState() => _PersonnelScreenState();
}

class _PersonnelScreenState extends ConsumerState<PersonnelScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(personnelQueryProvider).searchText,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final personnelAsync = ref.watch(filteredPersonnelListProvider);
    final query = ref.watch(personnelQueryProvider);
    final filterOptions = ref.watch(personnelFilterOptionsProvider);
    final deleteState = ref.watch(deletePersonnelProvider);

    ref.listen<PersonnelQueryState>(personnelQueryProvider, (previous, next) {
      if (_searchController.text != next.searchText) {
        _searchController.text = next.searchText;
      }
    });

    ref.listen<DeletePersonnelState>(deletePersonnelProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }

      if (next.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حذف بيانات الموظف بنجاح')),
        );
      }
    });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Align(
          alignment: AlignmentDirectional.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: PersonnelScreen._maxContentWidth,
            ),
            child: Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(12),
                  child: ExpansionTile(
                    initiallyExpanded: false,
                    leading: const Icon(Icons.filter_alt),
                    title: const Text('البحث والفلاتر'),
                    childrenPadding: const EdgeInsets.all(8),
                    children: [
                      _PersonnelProductivityPanel(
                        searchController: _searchController,
                        query: query,
                        filterOptions: filterOptions,
                        onSearchChanged: ref
                            .read(personnelQueryProvider.notifier)
                            .setSearchText,
                        onRankChanged: ref
                            .read(personnelQueryProvider.notifier)
                            .setRank,
                        onDepartmentChanged: ref
                            .read(personnelQueryProvider.notifier)
                            .setDepartment,
                        onStatusChanged: ref
                            .read(personnelQueryProvider.notifier)
                            .setStatus,
                        onSortFieldChanged: (value) {
                          if (value == null) return;
                          ref
                              .read(personnelQueryProvider.notifier)
                              .setSortField(value);
                        },
                        onSortAscendingChanged: ref
                            .read(personnelQueryProvider.notifier)
                            .setSortAscending,
                        onClearFilters: ref
                            .read(personnelQueryProvider.notifier)
                            .clearFilters,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: personnelAsync.when(
                    loading: () => const _PersonnelLoadingState(),
                    error: (error, stackTrace) =>
                        _PersonnelErrorState(error: error),
                    data: (personnel) {
                      if (personnel.isEmpty) {
                        return query.hasActiveCriteria
                            ? const _PersonnelEmptySearchState()
                            : const _PersonnelEmptyState();
                      }

                      return _PersonnelList(
                        personnel: personnel,
                        isDeleting: deleteState.loading,
                        onActionSelected: (action, selectedPersonnel) {
                          _handlePersonnelAction(
                            context,
                            ref,
                            action,
                            selectedPersonnel,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const AddPersonnelScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _handlePersonnelAction(
    BuildContext context,
    WidgetRef ref,
    _PersonnelAction action,
    PersonnelModel personnel,
  ) {
    switch (action) {
      case _PersonnelAction.view:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => PersonnelDetailsScreen(personnel: personnel),
          ),
        );
      case _PersonnelAction.edit:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) =>
                EditPersonnelScreen(personnelId: personnel.id),
          ),
        );
      case _PersonnelAction.delete:
        _showDeleteConfirmationDialog(context, ref, personnel);
    }
  }

  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    WidgetRef ref,
    PersonnelModel personnel,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('تأكيد الحذف'),
            content: Text(
              'هل أنت متأكد من حذف بيانات الموظف ${personnel.fullName}؟',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('إلغاء'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('حذف'),
              ),
            ],
          ),
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    await ref
        .read(deletePersonnelProvider.notifier)
        .deletePersonnel(personnel.id);
  }
}

class _PersonnelList extends StatelessWidget {
  const _PersonnelList({
    required this.personnel,
    required this.isDeleting,
    required this.onActionSelected,
  });

  final List<PersonnelModel> personnel;
  final bool isDeleting;
  final void Function(_PersonnelAction action, PersonnelModel personnel)
  onActionSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topCenter,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
        itemCount: personnel.length,
        itemBuilder: (context, index) {
          return _PersonnelCard(
            personnel: personnel[index],
            isDeleting: isDeleting,
            onActionSelected: onActionSelected,
          );
        },
      ),
    );
  }
}

class _PersonnelProductivityPanel extends StatelessWidget {
  const _PersonnelProductivityPanel({
    required this.searchController,
    required this.query,
    required this.filterOptions,
    required this.onSearchChanged,
    required this.onRankChanged,
    required this.onDepartmentChanged,
    required this.onStatusChanged,
    required this.onSortFieldChanged,
    required this.onSortAscendingChanged,
    required this.onClearFilters,
  });

  final TextEditingController searchController;
  final PersonnelQueryState query;
  final AsyncValue<PersonnelFilterOptions> filterOptions;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onRankChanged;
  final ValueChanged<String?> onDepartmentChanged;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<PersonnelSortField?> onSortFieldChanged;
  final ValueChanged<bool> onSortAscendingChanged;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final options = filterOptions.valueOrNull;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 720;
              final spacing = isWide ? 16.0 : 12.0;
              final fieldWidth = isWide
                  ? (constraints.maxWidth - spacing) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: constraints.maxWidth,
                    child: TextField(
                      controller: searchController,
                      onChanged: onSearchChanged,
                      decoration: InputDecoration(
                        labelText: 'بحث',
                        hintText: 'الاسم، الرقم العسكري، الرقم الوطني',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: query.searchText.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'مسح البحث',
                                onPressed: () => onSearchChanged(''),
                                icon: const Icon(Icons.clear),
                              ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  _FilterDropdown(
                    width: fieldWidth,
                    label: 'الرتبة',
                    value: query.rank,
                    items: options?.ranks ?? const [],
                    onChanged: onRankChanged,
                  ),
                  _FilterDropdown(
                    width: fieldWidth,
                    label: 'القسم',
                    value: query.department,
                    items: options?.departments ?? const [],
                    onChanged: onDepartmentChanged,
                  ),
                  _FilterDropdown(
                    width: fieldWidth,
                    label: 'الحالة',
                    value: query.status,
                    items: options?.statuses ?? const [],
                    onChanged: onStatusChanged,
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: DropdownButtonFormField<PersonnelSortField>(
                      initialValue: query.sortField,
                      decoration: const InputDecoration(
                        labelText: 'ترتيب حسب',
                        prefixIcon: Icon(Icons.sort),
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: PersonnelSortField.fullName,
                          child: Text('الاسم'),
                        ),
                        DropdownMenuItem(
                          value: PersonnelSortField.militaryNumber,
                          child: Text('الرقم العسكري'),
                        ),
                        DropdownMenuItem(
                          value: PersonnelSortField.hireDate,
                          child: Text('تاريخ التعيين'),
                        ),
                      ],
                      onChanged: onSortFieldChanged,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(
                          value: true,
                          icon: Icon(Icons.arrow_upward),
                          label: Text('تصاعدي'),
                        ),
                        ButtonSegment(
                          value: false,
                          icon: Icon(Icons.arrow_downward),
                          label: Text('تنازلي'),
                        ),
                      ],
                      selected: {query.sortAscending},
                      onSelectionChanged: (selection) {
                        onSortAscendingChanged(selection.first);
                      },
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: OutlinedButton.icon(
                      onPressed: query.hasActiveCriteria
                          ? onClearFilters
                          : null,
                      icon: const Icon(Icons.filter_alt_off_outlined),
                      label: const Text('مسح البحث والفلاتر'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.width,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final double width;
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.filter_alt_outlined),
          border: const OutlineInputBorder(),
        ),
        items: [
          const DropdownMenuItem<String>(value: '', child: Text('الكل')),
          ...items.map(
            (item) => DropdownMenuItem<String>(value: item, child: Text(item)),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

class _PersonnelCard extends StatelessWidget {
  const _PersonnelCard({
    required this.personnel,
    required this.isDeleting,
    required this.onActionSelected,
  });

  final PersonnelModel personnel;
  final bool isDeleting;
  final void Function(_PersonnelAction action, PersonnelModel personnel)
  onActionSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        title: Text(
          personnel.fullName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                personnel.rank,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                personnel.department,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                personnel.jobTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        trailing: PopupMenuButton<_PersonnelAction>(
          enabled: !isDeleting,
          onSelected: (action) => onActionSelected(action, personnel),
          itemBuilder: (context) => const [
            PopupMenuItem(value: _PersonnelAction.view, child: Text('عرض')),
            PopupMenuItem(value: _PersonnelAction.edit, child: Text('تعديل')),
            PopupMenuItem(value: _PersonnelAction.delete, child: Text('حذف')),
          ],
        ),
      ),
    );
  }
}

class _PersonnelLoadingState extends StatelessWidget {
  const _PersonnelLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _PersonnelEmptyState extends StatelessWidget {
  const _PersonnelEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'لا توجد بيانات للموظفين',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _PersonnelEmptySearchState extends StatelessWidget {
  const _PersonnelEmptySearchState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'لا توجد نتائج مطابقة للبحث أو الفلاتر الحالية',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}

class _PersonnelErrorState extends StatelessWidget {
  const _PersonnelErrorState({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'تعذر تحميل بيانات الموظفين',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }
}

enum _PersonnelAction { view, edit, delete }
