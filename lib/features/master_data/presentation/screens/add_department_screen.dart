import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/department_model.dart';
import '../../providers/master_data_provider.dart';

class AddDepartmentScreen extends ConsumerStatefulWidget {
  const AddDepartmentScreen({super.key, this.department});

  final DepartmentModel? department;

  @override
  ConsumerState<AddDepartmentScreen> createState() =>
      _AddDepartmentScreenState();
}

class _AddDepartmentScreenState extends ConsumerState<AddDepartmentScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  bool _isActive = true;

  @override
  void initState() {
    super.initState();

    if (widget.department != null) {
      _nameController.text = widget.department!.name;
      _isActive = widget.department!.isActive;
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

    final repository = ref.read(masterDataRepositoryProvider);

    final department = DepartmentModel(
      id: widget.department?.id ?? '',
      name: _nameController.text.trim(),
      displayOrder: widget.department?.displayOrder ?? 1,
      isActive: _isActive,
      createdAt: widget.department?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      if (widget.department == null) {
        await repository.addDepartment(department);
      } else {
        await repository.updateDepartment(department);
      }

      if (!mounted) return;

      Navigator.pop(context);
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
          title: Text(widget.department == null ? 'إضافة قسم' : 'تعديل قسم'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم القسم',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'أدخل اسم القسم';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              SwitchListTile(
                value: _isActive,
                title: const Text('القسم نشط'),
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
                label: Text(widget.department == null ? 'إضافة' : 'تحديث'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
