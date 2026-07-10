import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/duty_list_provider.dart';
import '../widgets/duty_form/duty_form.dart';
import '../../providers/delete_duty_provider.dart';
import 'duty_details_screen.dart';

class DutiesScreen extends ConsumerWidget {
  const DutiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duties = ref.watch(dutyListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('إدارة المناوبات')),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => Dialog(
              insetPadding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 900,
                  maxHeight: 700,
                ),
                child: const DutyForm(),
              ),
            ),
          );

          ref.invalidate(dutyListProvider);
        },
        child: const Icon(Icons.add),
      ),

      body: duties.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),

        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('لا توجد مناورات مسجلة'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final dutyView = items[index];
              final duty = dutyView.duty;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.event_note)),

                  title: Text(
                    duty.date.toString().split(' ').first,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.schedule, size: 18),
                            const SizedBox(width: 6),
                            Expanded(child: Text(dutyView.shiftName)),
                          ],
                        ),

                        const SizedBox(height: 4),

                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 18),
                            const SizedBox(width: 6),
                            Expanded(child: Text(dutyView.locationName)),
                          ],
                        ),

                        const SizedBox(height: 4),

                        Row(
                          children: [
                            const Icon(Icons.security, size: 18),
                            const SizedBox(width: 6),
                            Expanded(child: Text(dutyView.postName)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        tooltip: 'عرض',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DutyDetailsScreen(duty: duty),
                            ),
                          );
                        },
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) async {
                          switch (value) {
                            case 'edit':
                              await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) {
                                  return Dialog(
                                    insetPadding: const EdgeInsets.all(16),
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 900,
                                        maxHeight: 700,
                                      ),
                                      child: DutyForm(duty: duty),
                                    ),
                                  );
                                },
                              );

                              ref.invalidate(dutyListProvider);
                              break;

                            case 'delete':
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: const Text('حذف المناوبة'),
                                    content: const Text(
                                      'هل أنت متأكد من حذف هذه المناوبة؟',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: const Text('إلغاء'),
                                      ),
                                      FilledButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: const Text('حذف'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirm == true) {
                                await ref
                                    .read(deleteDutyProvider.notifier)
                                    .deleteDuty(duty.id);

                                ref.invalidate(dutyListProvider);

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('تم حذف المناوبة'),
                                    ),
                                  );
                                }
                              }

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
    );
  }
}
