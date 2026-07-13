import 'package:flutter/material.dart';

import '../../data/models/duty_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/duty_personnel_provider.dart';
import '../../providers/duty_list_provider.dart';

class DutyDetailsScreen extends ConsumerWidget {
  const DutyDetailsScreen({super.key, required this.duty});

  final DutyModel duty;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personnel = ref.watch(dutyPersonnelProvider(duty.id));
    final dutyView = ref.watch(dutyByIdProvider(duty.id));

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل المناوبة')),
      body: dutyView.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, _) => Center(child: Text(error.toString())),

        data: (view) {
          if (view == null) {
            return const Center(child: Text('المناوبة غير موجودة'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: const Text('التاريخ'),
                  subtitle: Text(view.duty.date.toString().split(' ').first),
                ),
              ),

              const SizedBox(height: 12),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.schedule),
                  title: const Text('الوردية'),
                  subtitle: Text(view.shiftName),
                ),
              ),

              const SizedBox(height: 12),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text('الموقع'),
                  subtitle: Text(view.locationName),
                ),
              ),

              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text('النقطة'),
                  subtitle: Text(view.postName),
                ),
              ),

              const SizedBox(height: 12),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.assignment),
                  title: const Text('نوع المهمة'),
                  subtitle: Text(view.taskTypeName),
                ),
              ),

              const SizedBox(height: 12),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('الحالة'),
                  subtitle: Text(view.status),
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
                          title: Text(
                            person.fullName.isEmpty
                                ? 'غير معروف'
                                : person.fullName,
                          ),
                          subtitle: Text("${person.rank} • ${person.role}"),
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
          );
        },
      ),
    );
  }
}
