import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/master_data_provider.dart';
import 'add_rank_screen.dart';
import '../../../../shared/master_data/dialogs/delete_dialog.dart';
import '../../../../shared/master_data/widgets/empty_master_data.dart';
import '../../../../shared/master_data/widgets/loading_master_data.dart';
import '../../../../shared/master_data/widgets/master_data_card.dart';

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
          loading: () => const LoadingMasterData(),

          error: (error, stackTrace) => Center(child: Text(error.toString())),

          data: (ranks) {
            if (ranks.isEmpty) {
              return const EmptyMasterData(message: 'لا توجد رتب');
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: ranks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final rank = ranks[index];

                return MasterDataCard(
                  title: rank.name,
                  subtitle: rank.isActive ? 'نشطة' : 'غير نشطة',

                  leading: CircleAvatar(child: Text('${index + 1}')),

                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddRankScreen(rank: rank),
                      ),
                    );
                  },

                  onDelete: () async {
                    final result = await DeleteDialog.show(
                      context,
                      title: 'حذف الرتبة',
                      message: 'هل تريد حذف "${rank.name}"؟',
                    );

                    if (result) {
                      await ref
                          .read(masterDataRepositoryProvider)
                          .deleteRank(rank.id);
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
