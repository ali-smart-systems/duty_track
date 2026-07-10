import 'package:flutter/material.dart';

import '../../../data/models/duty_personnel_view_model.dart';
import 'duty_actions_section.dart';
import 'duty_information_section.dart';
import 'duty_notes_section.dart';
import 'duty_personnel_section.dart';
import 'duty_summary_section.dart';
import '../../duty_personnel_selector_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/add_duty_provider.dart';
import '../../../data/models/duty_model.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/duty_personnel_model.dart';
import '../../../providers/edit_duty_provider.dart';

class DutyForm extends ConsumerStatefulWidget {
  const DutyForm({super.key, this.duty});

  final DutyModel? duty;

  @override
  @override
  ConsumerState<DutyForm> createState() => _DutyFormState();
}

class _DutyFormState extends ConsumerState<DutyForm> {
  DateTime? _date;

  String? _shift;
  String? _location;
  String? _post;
  String? _status;
  @override
  void initState() {
    super.initState();

    if (widget.duty != null) {
      _date = widget.duty!.date;
      _shift = widget.duty!.shiftId;
      _location = widget.duty!.serviceLocationId;
      _post = widget.duty!.servicePostId;
      _notesController.text = widget.duty!.notes;
    }
  }

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
            locationId: _location,

            onDatePressed: _pickDate,

            onShiftChanged: (value) {
              setState(() => _shift = value);
            },

            onLocationChanged: (value) {
              setState(() {
                _location = value;
                _post = null;
              });
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

  Future<void> _save() async {
    if (_date == null) {
      _showMessage("يرجى اختيار تاريخ المناوبة");
      return;
    }

    if (_shift == null) {
      _showMessage("يرجى اختيار الوردية");
      return;
    }

    if (_location == null) {
      _showMessage("يرجى اختيار الموقع");
      return;
    }

    if (_post == null) {
      _showMessage("يرجى اختيار النقطة");
      return;
    }

    if (_status == null) {
      _showMessage("يرجى اختيار الحالة");
      return;
    }

    if (_personnel.isEmpty) {
      _showMessage("يجب إضافة فرد واحد على الأقل");
      return;
    }

    final now = DateTime.now();

    final duty = DutyModel(
      id: widget.duty?.id ?? const Uuid().v4(),
      date: _date!,
      shiftId: _shift!,
      serviceLocationId: _location!,
      servicePostId: _post!,
      notes: _notesController.text.trim(),
      createdAt: widget.duty?.createdAt ?? now,
      updatedAt: now,
    );
    final dutyPersonnel = _personnel.map((person) {
      return DutyPersonnelModel(
        id: const Uuid().v4(),
        dutyId: '',
        personnelId: person.personnelId,
        role: person.role,
        isLeader: person.isLeader,
        createdAt: DateTime.now(),
      );
    }).toList();
    if (widget.duty == null) {
      await ref.read(addDutyProvider.notifier).addDuty(duty, dutyPersonnel);
    } else {
      await ref.read(editDutyProvider.notifier).updateDuty(duty, dutyPersonnel);
    }

    final state = ref.read(addDutyProvider);

    if (state.success) {
      if (mounted) {
        Navigator.pop(context);
      }
    } else if (state.error != null) {
      _showMessage(state.error!);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
