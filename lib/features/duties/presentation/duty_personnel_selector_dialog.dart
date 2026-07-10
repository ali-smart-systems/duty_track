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

  final String _role = 'فرد';

  final bool _isLeader = false;

  String? _selectedPersonnelId;

  @override
  Widget build(BuildContext context) {
    final personnelAsync = ref.watch(personnelViewListProvider);

    return AlertDialog(
      title: const Text("إضافة فرد للمناوبة"),

      content: SizedBox(
        width: 600,
        height: 500,

        child: personnelAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),

          error: (error, stackTrace) => const Center(child: Text("حدث خطأ")),

          data: (personnel) {
            final search = _searchController.text.trim().toLowerCase();

            final availablePersonnel = personnel.where((person) {
              if (widget.selectedPersonnelIds.contains(person.personnel.id)) {
                return false;
              }

              if (search.isEmpty) {
                return true;
              }

              return person.personnel.fullName.toLowerCase().contains(search) ||
                  person.personnel.militaryNumber.toLowerCase().contains(
                    search,
                  );
            }).toList();

            return Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) {
                    setState(() {});
                  },
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
                        value: person.personnel.id,

                        groupValue: _selectedPersonnelId,

                        onChanged: (value) {
                          setState(() {
                            _selectedPersonnelId = value;
                          });
                        },

                        title: Text(person.personnel.fullName),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${person.rankName} • ${person.departmentName}",
                            ),
                            Text(
                              "${person.serviceLocationName} • ${person.servicePostName}",
                            ),
                          ],
                        ),
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

            final personnelState = ref.read(personnelViewListProvider);

            personnelState.whenData((personnel) {
              final person = personnel.firstWhere(
                (e) => e.personnel.id == _selectedPersonnelId,
              );

              Navigator.pop(
                context,
                DutyPersonnelViewModel(
                  personnelId: person.personnel.id,
                  fullName: person.personnel.fullName,
                  rank: person.rankName,
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
