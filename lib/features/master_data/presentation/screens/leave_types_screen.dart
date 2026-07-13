import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/leave_type_provider.dart';
import 'add_leave_type_screen.dart';

class LeaveTypesScreen extends ConsumerWidget {
  const LeaveTypesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaveTypes = ref.watch(leaveTypesProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('أنواع الإجازات')),
        body: leaveTypes.when(
          loading: () => const Center(child: CircularProgressIndicator()),

          error: (error, _) => Center(child: Text(error.toString())),

          data: (items) {
            if (items.isEmpty) {
              return const Center(child: Text('لا توجد أنواع إجازات'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = items[index];

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(item.name),
                    subtitle: Text('الحد الأقصى ${item.maxDays} يوم'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.isActive ? Icons.check_circle : Icons.cancel,
                          color: item.isActive ? Colors.green : Colors.red,
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            switch (value) {
                              case 'edit':
                                break;

                              case 'delete':
                                break;
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'edit', child: Text('تعديل')),
                            PopupMenuItem(value: 'delete', child: Text('حذف')),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddLeaveTypeScreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
