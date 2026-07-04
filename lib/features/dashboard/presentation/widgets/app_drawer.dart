import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Center(
              child: Text(
                'DUTY TRACK',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const ListTile(leading: Icon(Icons.home), title: Text('الرئيسية')),

          const ListTile(
            leading: Icon(Icons.groups),
            title: Text('القوة البشرية'),
          ),

          const ListTile(
            leading: Icon(Icons.assignment),
            title: Text('المهام'),
          ),

          const ListTile(leading: Icon(Icons.event), title: Text('الإجازات')),

          const ListTile(
            leading: Icon(Icons.school),
            title: Text('البرامج الثقافية'),
          ),

          const ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('التقارير'),
          ),

          const Divider(),

          ExpansionTile(
            leading: const Icon(Icons.settings),
            title: const Text('الإعدادات'),
            children: [
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('مواقع الخدمة'),
                onTap: () {
                  Navigator.of(context).pop(); // إغلاق الـ Drawer
                  context.push(AppRoutes.serviceLocations);
                },
              ),
              ListTile(leading: Icon(Icons.badge), title: Text('المناصب')),
              ListTile(leading: Icon(Icons.schedule), title: Text('الورديات')),
              ListTile(
                leading: Icon(Icons.workspace_premium),
                title: Text('الرتب'),
              ),
              ListTile(leading: Icon(Icons.apartment), title: Text('الأقسام')),
              ListTile(
                leading: Icon(Icons.event_available),
                title: Text('أنواع الإجازات'),
              ),
              ListTile(
                leading: Icon(Icons.assignment_late),
                title: Text('أنواع المهام'),
              ),
            ],
          ),

          const Divider(),

          const ListTile(
            leading: Icon(Icons.logout),
            title: Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}
