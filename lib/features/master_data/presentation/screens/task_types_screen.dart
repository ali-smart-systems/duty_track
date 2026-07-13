import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/task_type_provider.dart';
import 'add_task_type_screen.dart';

import '../../../../shared/master_data/dialogs/delete_dialog.dart';
import '../../../../shared/master_data/widgets/empty_master_data.dart';
import '../../../../shared/master_data/widgets/loading_master_data.dart';
import '../../../../shared/master_data/widgets/master_data_card.dart';

class TaskTypesScreen extends ConsumerWidget {
  const TaskTypesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskTypesAsync = ref.watch(taskTypesProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('أنواع المهام')),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text('إضافة نوع مهمة'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddTaskTypeScreen()),
            );
          },
        ),
        body: taskTypesAsync.when(
          loading: () => const LoadingMasterData(),

          error: (error, _) => Center(child: Text(error.toString())),

          data: (taskTypes) {
            if (taskTypes.isEmpty) {
              return const EmptyMasterData(message: 'لا توجد أنواع مهام');
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: taskTypes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final taskType = taskTypes[index];

                return MasterDataCard(
                  title: taskType.name,
                  subtitle: taskType.isActive ? 'نشطة' : 'غير نشطة',
                  leading: CircleAvatar(child: Text('${index + 1}')),

                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddTaskTypeScreen(taskType: taskType),
                      ),
                    );
                  },

                  onDelete: () async {
                    final result = await DeleteDialog.show(
                      context,
                      title: 'حذف نوع المهمة',
                      message: 'هل تريد حذف "${taskType.name}"؟',
                    );

                    if (result) {
                      await ref
                          .read(taskTypeRepositoryProvider)
                          .deleteTaskType(taskType.id);
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
