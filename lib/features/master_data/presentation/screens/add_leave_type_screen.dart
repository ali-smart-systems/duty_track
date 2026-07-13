import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/leave_type_model.dart';
import '../../providers/leave_type_provider.dart';

class AddLeaveTypeScreen extends ConsumerStatefulWidget {
  const AddLeaveTypeScreen({super.key, this.leaveType});

  final LeaveTypeModel? leaveType;

  @override
  ConsumerState<AddLeaveTypeScreen> createState() => _AddLeaveTypeScreenState();
}

class _AddLeaveTypeScreenState extends ConsumerState<AddLeaveTypeScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _maxDaysController = TextEditingController();

  bool _isActive = true;

  @override
  void initState() {
    super.initState();

    if (widget.leaveType != null) {
      _nameController.text = widget.leaveType!.name;
      _maxDaysController.text = widget.leaveType!.maxDays.toString();
      _isActive = widget.leaveType!.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _maxDaysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.leaveType == null ? 'إضافة نوع إجازة' : 'تعديل نوع إجازة',
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم نوع الإجازة',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'أدخل اسم الإجازة';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _maxDaysController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'الحد الأقصى بالأيام',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'أدخل عدد الأيام';
                    }

                    if (int.tryParse(value) == null) {
                      return 'رقم غير صحيح';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                SwitchListTile(
                  title: const Text('نشط'),
                  value: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                ),

                const SizedBox(height: 24),

                FilledButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    final leaveType = LeaveTypeModel(
                      id: widget.leaveType?.id ?? '',
                      name: _nameController.text.trim(),
                      maxDays: int.parse(_maxDaysController.text),
                      displayOrder: widget.leaveType?.displayOrder ?? 0,
                      isActive: _isActive,
                      createdAt: widget.leaveType?.createdAt ?? DateTime.now(),
                      updatedAt: DateTime.now(),
                    );

                    await ref
                        .read(addLeaveTypeProvider.notifier)
                        .addLeaveType(leaveType);

                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('حفظ'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
