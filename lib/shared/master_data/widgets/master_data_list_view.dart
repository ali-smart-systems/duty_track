import 'package:flutter/material.dart';

import 'empty_master_data.dart';
import 'loading_master_data.dart';

class MasterDataListView<T> extends StatelessWidget {
  const MasterDataListView({
    super.key,
    required this.items,
    required this.emptyMessage,
    required this.itemBuilder,
    this.loading = false,
    this.error,
  });

  final List<T>? items;
  final String emptyMessage;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final bool loading;
  final Object? error;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const LoadingMasterData();
    }

    if (error != null) {
      return Center(child: Text(error.toString()));
    }

    if (items == null || items!.isEmpty) {
      return EmptyMasterData(message: emptyMessage);
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items!.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) =>
          itemBuilder(context, items![index], index),
    );
  }
}
