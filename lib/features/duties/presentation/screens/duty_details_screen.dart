import 'package:flutter/material.dart';

import '../../data/models/duty_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/duty_personnel_provider.dart';

class DutyDetailsScreen extends ConsumerWidget {
  const DutyDetailsScreen({super.key, required this.duty});

  final DutyModel duty;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personnel = ref.watch(dutyPersonnelProvider(duty.id));

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل المناوبة')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('التاريخ'),
              subtitle: Text(duty.date.toString().split(' ').first),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('الوردية'),
              subtitle: Text(duty.shiftId),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('الموقع'),
              subtitle: Text(duty.serviceLocationId),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.security),
              title: const Text('النقطة'),
              subtitle: Text(duty.servicePostId),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'أفراد المناوبة',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),

          const SizedBox(height: 12),

          personnel.when(
            loading: () => const Center(child: CircularProgressIndicator()),

            error: (error, _) => Text(error.toString()),

            data: (items) {
              if (items.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('لا يوجد أفراد لهذه المناوبة'),
                  ),
                );
              }

              return Column(
                children: items.map((person) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(person.personnelId),
                      subtitle: Text(person.role),
                      trailing: person.isLeader
                          ? const Icon(Icons.star, color: Colors.amber)
                          : null,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
