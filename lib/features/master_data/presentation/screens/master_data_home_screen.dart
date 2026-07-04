import 'package:flutter/material.dart';

import 'service_locations_screen.dart';

class MasterDataHomeScreen extends StatelessWidget {
  const MasterDataHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الإعدادات')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _MenuCard(
              title: 'مواقع الخدمة',
              icon: Icons.location_on,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ServiceLocationsScreen(),
                  ),
                );
              },
            ),

            _MenuCard(title: 'المناصب', icon: Icons.badge, onTap: () {}),

            _MenuCard(title: 'الورديات', icon: Icons.schedule, onTap: () {}),

            _MenuCard(
              title: 'أنواع الإجازات',
              icon: Icons.event_available,
              onTap: () {},
            ),

            _MenuCard(
              title: 'أنواع المهام',
              icon: Icons.assignment,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
