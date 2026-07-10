import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/master_data_provider.dart';
import '../../../../core/enums/gender.dart';
import 'add_service_post_screen.dart';

class ServicePostsScreen extends ConsumerWidget {
  const ServicePostsScreen({
    super.key,
    required this.locationId,
    required this.locationName,
  });

  final String locationId;
  final String locationName;
  Future<void> _deletePost(
    BuildContext context,
    WidgetRef ref,
    String postId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('حذف نقطة الخدمة'),
          content: const Text('هل أنت متأكد من حذف نقطة الخدمة'),
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
        );
      },
    );

    if (confirmed != true) return;

    try {
      await ref.read(masterDataRepositoryProvider).deleteServicePost(postId);

      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم حذف نقطة الخدمة بنجاح')));
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(servicePostsProvider(locationId));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(locationName)),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AddServicePostScreen(
                  locationId: locationId,
                  locationName: locationName,
                ),
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('إضافة نقطة الخدمة'),
        ),
        body: postsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text(error.toString())),
          data: (posts) {
            if (posts.isEmpty) {
              return const Center(
                child: Text(
                  'لا توجد نقطة خدمة',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              child: Text('${post.requiredPersonnelCount}'),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Text(
                                post.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => AddServicePostScreen(
                                      locationId: locationId,
                                      locationName: locationName,
                                      post: post,
                                    ),
                                  ),
                                );
                              },
                            ),

                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deletePost(context, ref, post.id);
                              },
                            ),
                          ],
                        ),

                        const Divider(),

                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            Chip(
                              avatar: const Icon(Icons.people, size: 18),
                              label: Text(
                                'العدد: ${post.requiredPersonnelCount}',
                              ),
                            ),

                            Chip(
                              avatar: const Icon(Icons.person, size: 18),
                              label: Text(post.gender.label),
                            ),

                            Chip(
                              avatar: Icon(
                                post.isActive
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                size: 18,
                              ),
                              label: Text(post.isActive ? 'نشط' : 'غير نشط'),
                            ),

                            Chip(
                              avatar: const Icon(Icons.priority_high, size: 18),
                              label: Text(
                                post.isRequired ? 'إلزامي' : 'اختياري',
                              ),
                            ),
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
      ),
    );
  }
}
