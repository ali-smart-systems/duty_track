import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/daily_service_provider.dart';

class DailyServicesScreen extends ConsumerWidget {
  const DailyServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyServices = ref.watch(dailyServicesProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الخدمات اليومية')),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // سيتم إنشاء كشف جديد في المرحلة القادمة
          },
          icon: const Icon(Icons.add),
          label: const Text('كشف جديد'),
        ),
        body: dailyServices.when(
          loading: () => const Center(child: CircularProgressIndicator()),

          error: (error, stackTrace) => Center(
            child: Text('حدث خطأ\n$error', textAlign: TextAlign.center),
          ),

          data: (items) {
            if (items.isEmpty) {
              return const Center(
                child: Text(
                  'لا توجد كشوفات خدمات يومية',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = items[index];

                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.assignment)),
                    title: Text(item.shiftName),
                    subtitle: Text(
                      item.serviceDate.toString().split(' ').first,
                    ),
                    trailing: Text('${item.assignments.length} تكليف'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
