import 'package:flutter/material.dart';

class DutyInformationSection extends StatelessWidget {
  const DutyInformationSection({
    super.key,
    required this.selectedDate,
    required this.selectedShift,
    required this.selectedLocation,
    required this.selectedPost,
    required this.selectedStatus,
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

  final VoidCallback onDatePressed;

  final ValueChanged<String?> onShiftChanged;
  final ValueChanged<String?> onLocationChanged;
  final ValueChanged<String?> onPostChanged;
  final ValueChanged<String?> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                          ? "اختر التاريخ"
                          : "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}",
                    ),
                  ),
                ),

                SizedBox(
                  width: 250,
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedShift,
                    decoration: const InputDecoration(
                      labelText: "الوردية",
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "الصباحية",
                        child: Text("الصباحية"),
                      ),
                      DropdownMenuItem(
                        value: "المسائية",
                        child: Text("المسائية"),
                      ),
                      DropdownMenuItem(
                        value: "الليلية",
                        child: Text("الليلية"),
                      ),
                    ],
                    onChanged: onShiftChanged,
                  ),
                ),

                SizedBox(
                  width: 250,
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedLocation,
                    decoration: const InputDecoration(
                      labelText: "موقع الخدمة",
                      border: OutlineInputBorder(),
                    ),
                    items: const [],
                    onChanged: onLocationChanged,
                  ),
                ),

                SizedBox(
                  width: 250,
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedPost,
                    decoration: const InputDecoration(
                      labelText: "نقطة الخدمة",
                      border: OutlineInputBorder(),
                    ),
                    items: const [],
                    onChanged: onPostChanged,
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
                      DropdownMenuItem(value: "مجدولة", child: Text("مجدولة")),
                      DropdownMenuItem(value: "جارية", child: Text("جارية")),
                      DropdownMenuItem(value: "منتهية", child: Text("منتهية")),
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
