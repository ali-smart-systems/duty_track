import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/master_data_provider.dart';
import 'add_shift_screen.dart';
import '../widgets/master_data_list_tile.dart';

class ShiftsScreen extends ConsumerWidget {
  const ShiftsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shiftsAsync = ref.watch(shiftsProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الورديات')),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text('إضافة وردية'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddShiftScreen()),
            );
          },
        ),
        body: shiftsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),

          error: (error, stackTrace) => Center(child: Text(error.toString())),

          data: (shifts) {
            if (shifts.isEmpty) {
              return const Center(
                child: Text('لا توجد ورديات', style: TextStyle(fontSize: 18)),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: shifts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final shift = shifts[index];

                return MasterDataListTile(
                  title: shift.name,
                  subtitle: '${shift.startTime}  ←→  ${shift.endTime}',
                  icon: Icons.schedule,

                  onEdit: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddShiftScreen(shift: shift),
                      ),
                    );
                  },

                  onDelete: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('حذف الوردية'),
                        content: Text('هل تريد حذف "${shift.name}"؟'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('إلغاء'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('حذف'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      try {
                        await ref
                            .read(masterDataRepositoryProvider)
                            .deleteShift(shift.id);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم حذف الوردية')),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      }
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
