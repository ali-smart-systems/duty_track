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
    void navigate(String route) {
      Navigator.of(context).pop();
      context.go(route);
    }

    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Center(
              child: Text('DUTY TRACK',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('الرئيسية'),
            onTap: () => navigate(AppRoutes.dashboard),
          ),
          ListTile(
            leading: const Icon(Icons.groups),
            title: const Text('القوة البشرية'),
            onTap: () => navigate(AppRoutes.personnel),
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('المناوبات'),
            onTap: () => navigate(AppRoutes.tasks),
          ),
          const ListTile(
            leading: Icon(Icons.event),
            title: Text('الإجازات (قيد التطوير)'),
            enabled: false,
          ),
          const ListTile(
            leading: Icon(Icons.school),
            title: Text('البرامج الثقافية (قيد التطوير)'),
            enabled: false,
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('التقارير'),
            onTap: () => navigate(AppRoutes.reports),
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
                  await Future<void>.delayed(Duration.zero);
                  if (!context.mounted) return;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const MasterDataScreen()));
                },
              ),
            ],
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('تسجيل الخروج'),
            onTap: () async {
              Navigator.of(context).pop();
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go(AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }
}
