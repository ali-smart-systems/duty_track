import 'package:flutter/material.dart';

class DashboardHomeScreen extends StatelessWidget {
  const DashboardHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),

      children: const [
        Card(
          child: ListTile(
            leading: Icon(Icons.people),
            title: Text('إجمالي القوة البشرية'),
            trailing: Text('0'),
          ),
        ),

        SizedBox(height: 12),

        Card(
          child: ListTile(
            leading: Icon(Icons.task_alt),
            title: Text('المهام النشطة'),
            trailing: Text('0'),
          ),
        ),

        SizedBox(height: 12),

        Card(
          child: ListTile(
            leading: Icon(Icons.event_available),
            title: Text('الإجازات الحالية'),
            trailing: Text('0'),
          ),
        ),

        SizedBox(height: 12),

        Card(
          child: ListTile(
            leading: Icon(Icons.school),
            title: Text('البرامج التدريبية'),
            trailing: Text('0'),
          ),
        ),
      ],
    );
  }
}
