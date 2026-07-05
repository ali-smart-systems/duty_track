import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../personnel/providers/personnel_provider.dart';
import '../data/models/duty_personnel_view_model.dart';

class DutyPersonnelSelectorDialog extends ConsumerStatefulWidget {
  const DutyPersonnelSelectorDialog({
    super.key,
    required this.selectedPersonnelIds,
  });

  final List<String> selectedPersonnelIds;

  @override
  ConsumerState<DutyPersonnelSelectorDialog> createState() =>
      _DutyPersonnelSelectorDialogState();
}

class _DutyPersonnelSelectorDialogState
    extends ConsumerState<DutyPersonnelSelectorDialog> {
  final TextEditingController _searchController = TextEditingController();

  String _role = 'فرد';

  bool _isLeader = false;

  String? _selectedPersonnelId;

  @override
  Widget build(BuildContext context) {
    final personnelAsync = ref.watch(personnelListProvider);

    return AlertDialog(
      title: const Text("إضافة فرد للمناوبة"),

      content: SizedBox(
        width: 600,
        height: 500,

        child: personnelAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),

          error: (error, stackTrace) => const Center(child: Text("حدث خطأ")),

          data: (personnel) {
            final availablePersonnel = personnel.where((person) {
              return !widget.selectedPersonnelIds.contains(person.id);
            }).toList();

            return Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: "بحث...",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: ListView.builder(
                    itemCount: availablePersonnel.length,

                    itemBuilder: (context, index) {
                      final person = availablePersonnel[index];

                      return RadioListTile<String>(
                        value: person.id,

                        groupValue: _selectedPersonnelId,

                        onChanged: (value) {
                          setState(() {
                            _selectedPersonnelId = value;
                          });
                        },

                        title: Text(person.fullName),

                        subtitle: Text("${person.rank} • ${person.department}"),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("إلغاء"),
        ),

        FilledButton(
          onPressed: () {
            if (_selectedPersonnelId == null) {
              return;
            }

            final personnelState = ref.read(personnelListProvider);

            personnelState.whenData((personnel) {
              final person = personnel.firstWhere(
                (e) => e.id == _selectedPersonnelId,
              );

              Navigator.pop(
                context,
                DutyPersonnelViewModel(
                  personnelId: person.id,
                  fullName: person.fullName,
                  rank: person.rank,
                  role: _role,
                  isLeader: _isLeader,
                ),
              );
            });
          },
          child: const Text("إضافة"),
        ),
      ],
    );
  }
}
