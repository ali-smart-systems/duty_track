import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/gender.dart';
import '../../data/models/service_post_model.dart';
import '../../providers/master_data_provider.dart';

class AddServicePostScreen extends ConsumerStatefulWidget {
  const AddServicePostScreen({
    super.key,
    required this.locationId,
    required this.locationName,
    this.post,
  });

  final String locationId;
  final String locationName;
  final ServicePostModel? post;

  @override
  ConsumerState<AddServicePostScreen> createState() =>
      _AddServicePostScreenState();
}

class _AddServicePostScreenState extends ConsumerState<AddServicePostScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _countController = TextEditingController(text: '1');

  Gender _gender = Gender.male;

  bool _isRequired = true;

  bool _isActive = true;

  @override
  void initState() {
    super.initState();

    final post = widget.post;

    if (post != null) {
      _nameController.text = post.name;
      _countController.text = post.requiredPersonnelCount.toString();

      _gender = post.gender;
      _isRequired = post.isRequired;
      _isActive = post.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final posts = await ref
        .read(masterDataRepositoryProvider)
        .getServicePosts(widget.locationId)
        .first;

    final exists = posts.any(
      (item) =>
          item.name.trim().toLowerCase() ==
              _nameController.text.trim().toLowerCase() &&
          item.id != widget.post?.id,
    );

    if (exists) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يوجد نقطة الخدمة بنفس الاسم داخل هذا الموقع'),
        ),
      );

      return;
    }
    try {
      final model = ServicePostModel(
        id: widget.post?.id ?? '',
        locationId: widget.locationId,
        name: _nameController.text.trim(),
        displayOrder: widget.post?.displayOrder ?? 1,
        requiredPersonnelCount: int.tryParse(_countController.text) ?? 1,
        gender: _gender,
        isRequired: _isRequired,
        isActive: _isActive,
        createdAt: widget.post?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.post == null) {
        await ref.read(masterDataRepositoryProvider).addServicePost(model);
      } else {
        await ref.read(masterDataRepositoryProvider).updateServicePost(model);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.post == null
                ? 'تمت إضافة نقطة الخدمة بنجاح'
                : 'تم تحديث نقطة الخدمة بنجاح',
          ),
        ),
      );

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
          title: Text(
            widget.post == null ? 'إضافة نقطة الخدمة' : 'تعديل نقطة الخدمة',
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
                  labelText: 'اسم نقطة الخدمة',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'أدخل اسم نقطة الخدمة';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _countController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'عدد الأفراد المطلوب',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<Gender>(
                initialValue: _gender,
                decoration: const InputDecoration(
                  labelText: 'الجنس',
                  border: OutlineInputBorder(),
                ),
                items: Gender.values.map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender.label),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    _gender = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              SwitchListTile(
                value: _isRequired,
                title: const Text('نقطة الخدمة إلزامي'),
                onChanged: (value) {
                  setState(() {
                    _isRequired = value;
                  });
                },
              ),

              SwitchListTile(
                value: _isActive,
                title: const Text('نشط'),
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
                label: Text(widget.post == null ? 'إضافة' : 'تحديث'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
