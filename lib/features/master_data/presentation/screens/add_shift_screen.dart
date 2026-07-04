import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/shift_model.dart';
import '../../providers/master_data_provider.dart';

class AddShiftScreen extends ConsumerStatefulWidget {
  const AddShiftScreen({super.key, this.shift});

  final ShiftModel? shift;

  @override
  ConsumerState<AddShiftScreen> createState() => _AddShiftScreenState();
}

class _AddShiftScreenState extends ConsumerState<AddShiftScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _startController = TextEditingController();

  final _endController = TextEditingController();

  bool _isActive = true;

  @override
  void initState() {
    super.initState();

    if (widget.shift != null) {
      _nameController.text = widget.shift!.name;
      _startController.text = widget.shift!.startTime;
      _endController.text = widget.shift!.endTime;
      _isActive = widget.shift!.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final repo = ref.read(masterDataRepositoryProvider);

    final model = ShiftModel(
      id: widget.shift?.id ?? '',
      name: _nameController.text.trim(),
      startTime: _startController.text.trim(),
      endTime: _endController.text.trim(),
      displayOrder: widget.shift?.displayOrder ?? 1,
      isActive: _isActive,
      createdAt: widget.shift?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      if (widget.shift == null) {
        await repo.addShift(model);
      } else {
        await repo.updateShift(model);
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
          title: Text(widget.shift == null ? 'إضافة وردية' : 'تعديل وردية'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم الوردية',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'أدخل اسم الوردية' : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _startController,
                decoration: const InputDecoration(
                  labelText: 'وقت البداية',
                  hintText: '08:00',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _endController,
                decoration: const InputDecoration(
                  labelText: 'وقت النهاية',
                  hintText: '16:00',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              SwitchListTile(
                value: _isActive,
                title: const Text('نشطة'),
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
                label: Text(widget.shift == null ? 'إضافة' : 'تحديث'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
