import 'package:flutter/material.dart';

import '../../../data/models/duty_personnel_view_model.dart';

class DutySummarySection extends StatelessWidget {
  const DutySummarySection({super.key, required this.personnel});

  final List<DutyPersonnelViewModel> personnel;

  @override
  Widget build(BuildContext context) {
    final total = personnel.length;

    final leaders = personnel.where((e) => e.isLeader).length;

    final drivers = personnel.where((e) => e.role == 'سائق').length;

    final reserve = personnel.where((e) => e.role == 'احتياط').length;

    final observers = personnel.where((e) => e.role == 'مراقب').length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ملخص المناوبة",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _SummaryCard(
                  title: "إجمالي الأفراد",
                  value: total.toString(),
                  icon: Icons.groups,
                ),

                _SummaryCard(
                  title: "القادة",
                  value: leaders.toString(),
                  icon: Icons.star,
                ),

                _SummaryCard(
                  title: "السائقون",
                  value: drivers.toString(),
                  icon: Icons.drive_eta,
                ),

                _SummaryCard(
                  title: "الاحتياط",
                  value: reserve.toString(),
                  icon: Icons.shield,
                ),

                _SummaryCard(
                  title: "المراقبون",
                  value: observers.toString(),
                  icon: Icons.visibility,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 30),

              const SizedBox(height: 10),

              Text(value, style: Theme.of(context).textTheme.headlineMedium),

              const SizedBox(height: 6),

              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
