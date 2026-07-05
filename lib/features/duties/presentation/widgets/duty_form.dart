import 'package:flutter/material.dart';

class DutyForm extends StatefulWidget {
  const DutyForm({super.key});

  @override
  State<DutyForm> createState() => _DutyFormState();
}

class _DutyFormState extends State<DutyForm> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: const [
          _DutyInformationCard(),
          SizedBox(height: 16),
          _DutyPersonnelCardSection(),
          SizedBox(height: 16),
          _DutyNotesCard(),
          SizedBox(height: 16),
          _DutySummaryCard(),
          SizedBox(height: 16),
          _DutySaveButtons(),
        ],
      ),
    );
  }
}

class _DutyInformationCard extends StatelessWidget {
  const _DutyInformationCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "بيانات المناوبة",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

class _DutyPersonnelCardSection extends StatelessWidget {
  const _DutyPersonnelCardSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "أفراد المناوبة",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

class _DutyNotesCard extends StatelessWidget {
  const _DutyNotesCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text("الملاحظات", style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}

class _DutySummaryCard extends StatelessWidget {
  const _DutySummaryCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "ملخص المناوبة",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

class _DutySaveButtons extends StatelessWidget {
  const _DutySaveButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton(onPressed: () {}, child: const Text("حفظ")),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(onPressed: () {}, child: const Text("إلغاء")),
        ),
      ],
    );
  }
}
