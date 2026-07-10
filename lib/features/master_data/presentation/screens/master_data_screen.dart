import 'package:flutter/material.dart';

import 'service_locations_screen.dart';
import 'service_posts_locations_screen.dart';
import 'shifts_screen.dart';
import 'ranks_screen.dart';
import 'departments_screen.dart';

class MasterDataScreen extends StatelessWidget {
  const MasterDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('البيانات الأساسية'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildItem(
              context,
              icon: Icons.location_on,
              title: 'مواقع الخدمة',
              page: const ServiceLocationsScreen(),
            ),
            _buildItem(
              context,
              icon: Icons.badge,
              title: 'نقاط الخدمة',
              page: const ServicePostsLocationsScreen(),
            ),
            _buildItem(
              context,
              icon: Icons.schedule,
              title: 'الورديات',
              page: const ShiftsScreen(),
            ),
            _buildItem(
              context,
              icon: Icons.workspace_premium,
              title: 'الرتب',
              page: const RanksScreen(),
            ),
            _buildItem(
              context,
              icon: Icons.apartment,
              title: 'الأقسام',
              page: const DepartmentsScreen(),
            ),
            _buildComingSoon(
              icon: Icons.event_available,
              title: 'أنواع الإجازات',
            ),
            _buildComingSoon(icon: Icons.assignment, title: 'أنواع المهام'),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget page,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }

  Widget _buildComingSoon({required IconData icon, required String title}) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Chip(label: Text('قريبًا')),
      ),
    );
  }
}
