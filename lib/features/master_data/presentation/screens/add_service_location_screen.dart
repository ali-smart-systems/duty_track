import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/service_location_model.dart';
import '../../providers/master_data_provider.dart';

class AddServiceLocationScreen extends ConsumerStatefulWidget {
  const AddServiceLocationScreen({super.key, this.location});

  final ServiceLocationModel? location;

  @override
  ConsumerState<AddServiceLocationScreen> createState() =>
      _AddServiceLocationScreenState();
}

class _AddServiceLocationScreenState
    extends ConsumerState<AddServiceLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    if (widget.location != null) {
      _nameController.text = widget.location!.name;
      _orderController.text = widget.location!.displayOrder.toString();
      _isActive = widget.location!.isActive;
    }
  }

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _orderController = TextEditingController(
    text: '1',
  );

  bool _isActive = true;

  @override
  void dispose() {
    _nameController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final exists = await ref
        .read(masterDataControllerProvider)
        .serviceLocationExists(
          _nameController.text,
          excludeId: widget.location?.id,
        );

    if (exists) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يوجد موقع خدمة بنفس الاسم')),
      );

      return;
    }
    final now = DateTime.now();

    final model = ServiceLocationModel(
      id: widget.location?.id ?? '',
      name: _nameController.text.trim(),
      displayOrder: int.parse(_orderController.text),
      isActive: _isActive,
      createdAt: widget.location?.createdAt ?? now,
      updatedAt: now,
    );

    try {
      if (widget.location == null) {
        await ref.read(masterDataControllerProvider).addServiceLocation(model);
      } else {
        await ref
            .read(masterDataControllerProvider)
            .updateServiceLocation(model);
      }
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.location == null
                ? 'تمت إضافة الموقع بنجاح'
                : 'تم تحديث الموقع بنجاح',
          ),
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ:\n$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.location == null ? 'إضافة موقع خدمة' : 'تعديل موقع خدمة',
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
                  labelText: 'اسم الموقع',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال اسم الموقع';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _orderController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ترتيب العرض',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final number = int.tryParse(value ?? '');

                  if (number == null) {
                    return 'أدخل رقمًا صحيحًا';
                  }

                  if (number <= 0) {
                    return 'يجب أن يكون أكبر من صفر';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              Card(
                child: SwitchListTile(
                  value: _isActive,
                  title: const Text('نشط'),
                  subtitle: const Text('سيظهر الموقع في شاشة الخدمات اليومية'),
                  onChanged: (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 50,
                child: FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: Text(
                    widget.location == null ? 'إضافة' : 'حفظ التعديل',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
