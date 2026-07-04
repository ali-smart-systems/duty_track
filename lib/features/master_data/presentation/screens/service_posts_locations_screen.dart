import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/master_data_provider.dart';
import 'service_posts_screen.dart';

class ServicePostsLocationsScreen extends ConsumerWidget {
  const ServicePostsLocationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsAsync = ref.watch(serviceLocationsProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('اختيار موقع الخدمة')),
        body: locationsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),

          error: (error, _) => Center(child: Text(error.toString())),

          data: (locations) {
            if (locations.isEmpty) {
              return const Center(child: Text('لا توجد مواقع خدمة'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: locations.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final location = locations[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(location.name),
                    subtitle: Text(location.isActive ? 'نشط' : 'غير نشط'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ServicePostsScreen(
                            locationId: location.id,
                            locationName: location.name,
                          ),
                        ),
                      );
                    },
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
