import 'package:flutter/material.dart';

class DutyNotesSection extends StatelessWidget {
  const DutyNotesSection({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("الملاحظات", style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 16),

            TextField(
              controller: controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "اكتب أي ملاحظات خاصة بالمناوبة...",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
