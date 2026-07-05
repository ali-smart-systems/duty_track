import 'package:flutter/material.dart';

import '../../../data/models/duty_personnel_view_model.dart';
import '../duty_personnel_card.dart';

class DutyPersonnelSection extends StatelessWidget {
  const DutyPersonnelSection({
    super.key,
    required this.personnel,
    required this.onAddPersonnel,
    required this.onDeletePersonnel,
  });

  final List<DutyPersonnelViewModel> personnel;

  final VoidCallback onAddPersonnel;

  final ValueChanged<int> onDeletePersonnel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "أفراد المناوبة",
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const Spacer(),

                FilledButton.icon(
                  onPressed: onAddPersonnel,
                  icon: const Icon(Icons.person_add),
                  label: const Text("إضافة فرد"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (personnel.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text("لم يتم إضافة أي فرد للمناوبة"),
              ),

            ...List.generate(personnel.length, (index) {
              return DutyPersonnelCard(
                personnel: personnel[index],
                onDelete: () {
                  onDeletePersonnel(index);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
