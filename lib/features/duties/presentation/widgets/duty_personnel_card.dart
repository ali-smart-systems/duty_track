import 'package:flutter/material.dart';

import '../../data/models/duty_personnel_view_model.dart';

class DutyPersonnelCard extends StatelessWidget {
  const DutyPersonnelCard({
    super.key,
    required this.personnel,
    required this.onDelete,
  });

  final DutyPersonnelViewModel personnel;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(personnel.fullName.isEmpty ? '?' : personnel.fullName[0]),
        ),

        title: Text(
          personnel.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("الرتبة : ${personnel.rank}"),
            Text("الدور : ${personnel.role}"),

            if (personnel.isLeader)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Chip(label: Text("قائد المناوبة")),
              ),
          ],
        ),

        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline, color: Colors.red),
        ),
      ),
    );
  }
}
