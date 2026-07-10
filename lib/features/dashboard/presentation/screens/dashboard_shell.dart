import 'package:flutter/material.dart';

import '../../../duties/presentation/screens/duties_screen.dart';
import '../../../personnel/presentation/screens/personnel_screen.dart';
import '../widgets/app_drawer.dart';
import 'dashboard_home_screen.dart';

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    DashboardHomeScreen(),
    PersonnelScreen(),
    DutiesScreen(),
    Center(child: Text('التقارير')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DUTY TRACK'), centerTitle: true),

      drawer: const AppDrawer(),

      body: pages[currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'القوة',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'المناوبات',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'التقارير',
          ),
        ],
      ),
    );
  }
}
