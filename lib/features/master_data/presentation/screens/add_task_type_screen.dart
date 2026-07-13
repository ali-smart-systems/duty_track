import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/task_type_model.dart';
import '../../providers/task_type_provider.dart';

class AddTaskTypeScreen extends ConsumerStatefulWidget {
  const AddTaskTypeScreen({super.key, this.taskType});

  final TaskTypeModel? taskType;

  @override
  ConsumerState<AddTaskTypeScreen> createState() => _AddTaskTypeScreenState();
}

class _AddTaskTypeScreenState extends ConsumerState<AddTaskTypeScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  bool _isActive = true;

  @override
  void initState() {
    super.initState();

    if (widget.taskType != null) {
      _nameController.text = widget.taskType!.name;
      _isActive = widget.taskType!.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final repository = ref.read(taskTypeRepositoryProvider);

    final taskType = TaskTypeModel(
      id: widget.taskType?.id ?? '',
      name: _nameController.text.trim(),
      displayOrder: widget.taskType?.displayOrder ?? 1,
      isActive: _isActive,
      createdAt: widget.taskType?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      if (widget.taskType == null) {
        await repository.addTaskType(taskType);
      } else {
        await repository.updateTaskType(taskType);
      }

      if (!mounted) return;

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.taskType == null ? 'إضافة نوع مهمة' : 'تعديل نوع مهمة',
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم نوع المهمة',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'أدخل اسم نوع المهمة';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              SwitchListTile(
                title: const Text('نوع المهمة نشط'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
              ),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: Text(widget.taskType == null ? 'إضافة' : 'تحديث'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
