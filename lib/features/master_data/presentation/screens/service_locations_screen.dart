import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/master_data_provider.dart';
import 'add_service_location_screen.dart';

import '../widgets/master_data_list_tile.dart';

class ServiceLocationsScreen extends ConsumerWidget {
  const ServiceLocationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsAsync = ref.watch(serviceLocationsProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('مواقع الخدمة')),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text('إضافة موقع'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const AddServiceLocationScreen(),
              ),
            );
          },
        ),
        body: locationsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),

          error: (error, stackTrace) => Center(
            child: Text('حدث خطأ\n$error', textAlign: TextAlign.center),
          ),

          data: (locations) {
            if (locations.isEmpty) {
              return const Center(
                child: Text(
                  'لا توجد مواقع خدمة',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: locations.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final location = locations[index];

                return MasterDataListTile(
                  title: location.name,
                  subtitle: 'ترتيب: ${location.displayOrder}',
                  icon: Icons.location_on,

                  onEdit: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AddServiceLocationScreen(location: location),
                      ),
                    );
                  },

                  onDelete: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('حذف موقع الخدمة'),
                        content: Text('هل تريد حذف "${location.name}"؟'),
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
                            .deleteServiceLocation(location.id);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم حذف الموقع')),
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
