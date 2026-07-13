import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../master_data/providers/master_data_provider.dart';
import '../../../../master_data/providers/task_type_provider.dart';

class DutyInformationSection extends ConsumerWidget {
  const DutyInformationSection({
    super.key,
    required this.selectedDate,
    required this.selectedShift,
    required this.selectedLocation,
    required this.selectedPost,
    required this.selectedStatus,
    required this.selectedTaskType,
    required this.onTaskTypeChanged,
    required this.locationId,
    required this.onDatePressed,
    required this.onShiftChanged,
    required this.onLocationChanged,
    required this.onPostChanged,
    required this.onStatusChanged,
  });

  final DateTime? selectedDate;

  final String? selectedShift;
  final String? selectedLocation;
  final String? selectedPost;
  final String? selectedStatus;
  final String? selectedTaskType;

  // أضف هذا السطر
  final String? locationId;

  final VoidCallback onDatePressed;

  final ValueChanged<String?> onShiftChanged;
  final ValueChanged<String?> onLocationChanged;
  final ValueChanged<String?> onPostChanged;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onTaskTypeChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint(
      'shift=$selectedShift, location=$selectedLocation, post=$selectedPost, status=$selectedStatus',
    );
    final shiftsAsync = ref.watch(shiftsProvider);

    final locationsAsync = ref.watch(serviceLocationsProvider);

    final taskTypesAsync = ref.watch(taskTypesProvider);

    final postsAsync = selectedLocation == null
        ? const AsyncValue<List>.loading()
        : ref.watch(servicePostsProvider(selectedLocation!));
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "بيانات المناوبة",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: 250,
                  child: OutlinedButton.icon(
                    onPressed: onDatePressed,
                    icon: const Icon(Icons.calendar_month),
                    label: Text(
                      selectedDate == null
                          ? "اختر تاريخ المناوبة"
                          : "${selectedDate!.day.toString().padLeft(2, '0')}/"
                                "${selectedDate!.month.toString().padLeft(2, '0')}/"
                                "${selectedDate!.year}",
                    ),
                  ),
                ),

                SizedBox(
                  width: 250,
                  child: shiftsAsync.when(
                    loading: () => const CircularProgressIndicator(),

                    error: (_, _) => const Text('خطأ في تحميل الورديات'),

                    data: (shifts) {
                      return DropdownButtonFormField<String>(
                        initialValue: selectedShift,
                        decoration: const InputDecoration(
                          labelText: "الوردية",
                          border: OutlineInputBorder(),
                        ),
                        items: shifts
                            .map<DropdownMenuItem<String>>(
                              (shift) => DropdownMenuItem<String>(
                                value: shift.id,
                                child: Text(shift.name),
                              ),
                            )
                            .toList(),
                        onChanged: onShiftChanged,
                      );
                    },
                  ),
                ),

                SizedBox(
                  width: 250,
                  child: locationsAsync.when(
                    loading: () => const CircularProgressIndicator(),

                    error: (_, _) => const Text('خطأ في تحميل المواقع'),

                    data: (locations) {
                      return DropdownButtonFormField<String>(
                        initialValue: selectedLocation,
                        decoration: const InputDecoration(
                          labelText: "الموقع",
                          border: OutlineInputBorder(),
                        ),
                        items: locations
                            .map<DropdownMenuItem<String>>(
                              (location) => DropdownMenuItem<String>(
                                value: location.id,
                                child: Text(location.name),
                              ),
                            )
                            .toList(),
                        onChanged: onLocationChanged,
                      );
                    },
                  ),
                ),

                SizedBox(
                  width: 250,
                  child: postsAsync.when(
                    loading: () => const CircularProgressIndicator(),

                    error: (_, _) => const Text('خطأ في تحميل النقاط'),

                    data: (posts) {
                      return DropdownButtonFormField<String>(
                        initialValue: selectedPost,
                        decoration: const InputDecoration(
                          labelText: "النقطة",
                          border: OutlineInputBorder(),
                        ),
                        items: posts
                            .map<DropdownMenuItem<String>>(
                              (post) => DropdownMenuItem<String>(
                                value: post.id,
                                child: Text(post.name),
                              ),
                            )
                            .toList(),
                        onChanged: onPostChanged,
                      );
                    },
                  ),
                ),

                SizedBox(
                  width: 250,
                  child: taskTypesAsync.when(
                    loading: () => const CircularProgressIndicator(),

                    error: (_, _) => const Text('خطأ في تحميل أنواع المهام'),

                    data: (taskTypes) {
                      return DropdownButtonFormField<String>(
                        initialValue: selectedTaskType,
                        decoration: const InputDecoration(
                          labelText: "نوع المهمة",
                          border: OutlineInputBorder(),
                        ),
                        items: taskTypes
                            .map(
                              (task) => DropdownMenuItem<String>(
                                value: task.id,
                                child: Text(task.name),
                              ),
                            )
                            .toList(),
                        onChanged: onTaskTypeChanged,
                      );
                    },
                  ),
                ),

                SizedBox(
                  width: 250,
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedStatus,
                    decoration: const InputDecoration(
                      labelText: "الحالة",
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: "نشطة", child: Text("نشطة")),
                      DropdownMenuItem(value: "احتياط", child: Text("احتياط")),
                      DropdownMenuItem(value: "ملغاة", child: Text("ملغاة")),
                    ],
                    onChanged: onStatusChanged,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
