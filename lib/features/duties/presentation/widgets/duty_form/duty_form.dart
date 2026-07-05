import 'package:flutter/material.dart';

import '../../../data/models/duty_personnel_view_model.dart';
import 'duty_actions_section.dart';
import 'duty_information_section.dart';
import 'duty_notes_section.dart';
import 'duty_personnel_section.dart';
import 'duty_summary_section.dart';
import '../../duty_personnel_selector_dialog.dart';

class DutyForm extends StatefulWidget {
  const DutyForm({super.key});

  @override
  State<DutyForm> createState() => _DutyFormState();
}

class _DutyFormState extends State<DutyForm> {
  DateTime? _date;

  String? _shift;
  String? _location;
  String? _post;
  String? _status;

  final TextEditingController _notesController = TextEditingController();

  final List<DutyPersonnelViewModel> _personnel = [];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DutyInformationSection(
            selectedDate: _date,
            selectedShift: _shift,
            selectedLocation: _location,
            selectedPost: _post,
            selectedStatus: _status,

            onDatePressed: _pickDate,

            onShiftChanged: (value) {
              setState(() => _shift = value);
            },

            onLocationChanged: (value) {
              setState(() => _location = value);
            },

            onPostChanged: (value) {
              setState(() => _post = value);
            },

            onStatusChanged: (value) {
              setState(() => _status = value);
            },
          ),

          const SizedBox(height: 16),

          DutyPersonnelSection(
            personnel: _personnel,

            onAddPersonnel: _addPersonnel,

            onDeletePersonnel: (index) {
              setState(() {
                _personnel.removeAt(index);
              });
            },
          ),

          const SizedBox(height: 16),

          DutyNotesSection(controller: _notesController),

          const SizedBox(height: 16),

          DutySummarySection(personnel: _personnel),

          const SizedBox(height: 16),

          DutyActionsSection(
            isLoading: false,

            onSave: _save,

            onCancel: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2050),
      initialDate: _date ?? DateTime.now(),
    );

    if (selected != null) {
      setState(() {
        _date = selected;
      });
    }
  }

  Future<void> _addPersonnel() async {
    final result = await showDialog<DutyPersonnelViewModel>(
      context: context,
      builder: (context) {
        return DutyPersonnelSelectorDialog(
          selectedPersonnelIds: _personnel.map((e) => e.personnelId).toList(),
        );
      },
    );

    if (result == null) {
      return;
    }

    setState(() {
      _personnel.add(result);
    });
  }

  void _save() {
    // سيتم ربطه بالـ Provider لاحقاً
  }
}
