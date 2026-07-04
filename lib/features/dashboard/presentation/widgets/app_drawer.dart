import 'package:flutter/material.dart';

import '../../../../features/master_data/presentation/screens/master_data_screen.dart';

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
                leading: const Icon(Icons.dataset),
                title: const Text('البيانات الأساسية'),
                onTap: () async {
                  Navigator.of(context).pop();

                  await Future.delayed(Duration.zero);

                  if (!context.mounted) return;

                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MasterDataScreen()),
                  );
                },
              ),
            ],
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('تسجيل الخروج'),
            onTap: () {
              Navigator.pop(context);
              // TODO: تنفيذ تسجيل الخروج
            },
          ),
        ],
      ),
    );
  }
}
