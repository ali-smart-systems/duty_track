import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/app_routes.dart';
import '../../../auth/providers/auth_provider.dart';

import '../../../../features/master_data/presentation/screens/master_data_screen.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

          ListTile(leading: Icon(Icons.home), title: Text('الرئيسية')),

          ListTile(
            leading: Icon(Icons.groups),
            title: const Text('القوة البشرية'),
            onTap: () { Navigator.pop(context); context.go(AppRoutes.personnel); },
          ),

          ListTile(
            leading: Icon(Icons.assignment),
            title: const Text('المهام'),
            onTap: () { Navigator.pop(context); context.go(AppRoutes.tasks); },
          ),

          ListTile(leading: Icon(Icons.event), title: Text('الإجازات')),

          const ListTile(
            leading: Icon(Icons.school),
            title: const Text('البرامج الثقافية'),
            onTap: () { Navigator.pop(context); context.go(AppRoutes.culturalPrograms); },
          ),

          const ListTile(
            leading: Icon(Icons.bar_chart),
            title: const Text('التقارير'),
            onTap: () { Navigator.pop(context); context.go(AppRoutes.reports); },
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
            onTap: () async {
              Navigator.pop(context);
              await ref.read(authProvider.notifier).logout();
      if (context.mounted) context.go(AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }
}
