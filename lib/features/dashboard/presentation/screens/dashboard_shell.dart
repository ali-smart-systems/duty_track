import 'package:flutter/material.dart';

import '../../../duties/presentation/screens/duties_screen.dart';
import '../../../personnel/presentation/screens/personnel_screen.dart';
import '../../../reports/presentation/screens/reports_home_screen.dart';
import '../widgets/app_drawer.dart';
import 'dashboard_home_screen.dart';

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(covariant DashboardShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      currentIndex = widget.initialIndex;
    }
  }

  final List<Widget> pages = const [
    DashboardHomeScreen(),
    PersonnelScreen(),
    DutiesScreen(),
    ReportsHomeScreen(),
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
