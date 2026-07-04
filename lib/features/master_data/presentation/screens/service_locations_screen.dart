import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/master_data_provider.dart';
import 'add_service_location_screen.dart';
import 'service_posts_screen.dart';

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

                return Card(
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${location.displayOrder}'),
                    ),

                    title: Text(location.name),

                    subtitle: Text(location.isActive ? 'نشط' : 'غير نشط'),

                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ServicePostsScreen(
                            locationId: location.id,
                            locationName: location.name,
                          ),
                        ),
                      );
                    },

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'تعديل',
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AddServiceLocationScreen(
                                  location: location,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          tooltip: 'حذف',
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            // كود الحذف الموجود لديك
                          },
                        ),
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
