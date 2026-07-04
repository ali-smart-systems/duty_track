import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/master_data_provider.dart';
import 'add_rank_screen.dart';

class RanksScreen extends ConsumerWidget {
  const RanksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ranksAsync = ref.watch(ranksProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الرتب العسكرية')),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text('إضافة رتبة'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddRankScreen()),
            );
          },
        ),
        body: ranksAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),

          error: (error, stackTrace) => Center(child: Text(error.toString())),

          data: (ranks) {
            if (ranks.isEmpty) {
              return const Center(
                child: Text('لا توجد رتب', style: TextStyle(fontSize: 18)),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: ranks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final rank = ranks[index];

                return Card(
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),

                    title: Text(rank.name),

                    subtitle: Text(rank.isActive ? 'نشطة' : 'غير نشطة'),

                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        switch (value) {
                          case 'edit':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddRankScreen(rank: rank),
                              ),
                            );
                            break;

                          case 'delete':
                            final result = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('حذف الرتبة'),
                                content: Text('هل تريد حذف "${rank.name}"؟'),
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
                              ),
                            );

                            if (result == true) {
                              await ref
                                  .read(masterDataRepositoryProvider)
                                  .deleteRank(rank.id);
                            }

                            break;
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('تعديل')),
                        PopupMenuItem(value: 'delete', child: Text('حذف')),
                      ],
                    ),
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
