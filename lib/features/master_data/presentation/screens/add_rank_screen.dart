import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/rank_model.dart';
import '../../providers/master_data_provider.dart';

class AddRankScreen extends ConsumerStatefulWidget {
  const AddRankScreen({super.key, this.rank});

  final RankModel? rank;

  @override
  ConsumerState<AddRankScreen> createState() => _AddRankScreenState();
}

class _AddRankScreenState extends ConsumerState<AddRankScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  bool _isActive = true;

  @override
  void initState() {
    super.initState();

    if (widget.rank != null) {
      _nameController.text = widget.rank!.name;
      _isActive = widget.rank!.isActive;
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

    final repo = ref.read(masterDataRepositoryProvider);

    final rank = RankModel(
      id: widget.rank?.id ?? '',
      name: _nameController.text.trim(),
      displayOrder: widget.rank?.displayOrder ?? 1,
      isActive: _isActive,
      createdAt: widget.rank?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      if (widget.rank == null) {
        await repo.addRank(rank);
      } else {
        await repo.updateRank(rank);
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
          title: Text(widget.rank == null ? 'إضافة رتبة' : 'تعديل رتبة'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم الرتبة',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'أدخل اسم الرتبة';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              SwitchListTile(
                value: _isActive,
                title: const Text('الرتبة نشطة'),
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
                label: Text(widget.rank == null ? 'إضافة' : 'تحديث'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
