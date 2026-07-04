import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/master_data_provider.dart';

class ServiceLocationList extends ConsumerWidget {
  const ServiceLocationList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locations = ref.watch(serviceLocationsProvider);

    return locations.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text(error.toString())),
      data: (items) {
        if (items.isEmpty) {
          return const Center(child: Text('لا توجد مواقع خدمة'));
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: ListTile(
                leading: CircleAvatar(child: Text('${item.displayOrder}')),
                title: Text(item.name),
                subtitle: Text(item.isActive ? 'نشط' : 'غير نشط'),
              ),
            );
          },
        );
      },
    );
  }
}
