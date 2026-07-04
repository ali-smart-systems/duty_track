import 'package:flutter/material.dart';

import '../widgets/service_location_list.dart';

class MasterDataScreen extends StatelessWidget {
  const MasterDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('البيانات المرجعية'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.location_on_outlined), text: 'مواقع الخدمة'),
              Tab(icon: Icon(Icons.badge_outlined), text: 'المناصب'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ServiceLocationList(),
            Center(child: Text('سيتم بناء شاشة المناصب قريبًا')),
          ],
        ),
      ),
    );
  }
}
