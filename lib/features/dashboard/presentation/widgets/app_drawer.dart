import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
          DrawerHeader(
            child: Center(
              child: Text(
                'DUTY TRACK',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          ListTile(leading: Icon(Icons.home), title: Text('الرئيسية')),

          ListTile(leading: Icon(Icons.groups), title: Text('القوة البشرية')),

          ListTile(leading: Icon(Icons.assignment), title: Text('المهام')),

          ListTile(leading: Icon(Icons.event), title: Text('الإجازات')),

          ListTile(leading: Icon(Icons.school), title: Text('التدريب')),

          ListTile(leading: Icon(Icons.bar_chart), title: Text('التقارير')),

          Divider(),

          ListTile(leading: Icon(Icons.settings), title: Text('الإعدادات')),

          ListTile(leading: Icon(Icons.logout), title: Text('تسجيل الخروج')),
        ],
      ),
    );
  }
}
