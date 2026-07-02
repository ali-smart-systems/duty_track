import 'package:flutter/material.dart';

import '../../data/models/personnel_model.dart';
import 'personnel_date_field.dart';
import 'personnel_dropdown_field.dart';
import 'personnel_text_field.dart';

class PersonnelForm extends StatefulWidget {
  const PersonnelForm({
    super.key,
    required this.onSubmit,
    required this.onChanged,
    this.initialPersonnel,
    this.isSubmitting = false,
  });

  final PersonnelModel? initialPersonnel;
  final ValueChanged<PersonnelModel> onSubmit;
  final ValueChanged<PersonnelModel> onChanged;
  final bool isSubmitting;

  @override
  State<PersonnelForm> createState() => _PersonnelFormState();
}

class _PersonnelFormState extends State<PersonnelForm> {
  static const List<String> _rankOptions = [
    'جندي',
    'عريف',
    'رقيب',
    'مساعد',
    'ملازم',
    'نقيب',
    'رائد',
    'مقدم',
    'عقيد',
  ];

  static const List<String> _departmentOptions = [
    'الإدارة',
    'الموارد البشرية',
    'الأمن',
    'العمليات',
    'التدريب',
    'الشؤون المالية',
  ];

  static const List<String> _statusOptions = [
    'نشط',
    'إجازة',
    'موقوف',
    'منقول',
    'متقاعد',
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _militaryNumberController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _jobTitleController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _nationalIdController;
  late final TextEditingController _notesController;

  String? _rank;
  String? _department;
  String? _status;
  DateTime? _birthDate;
  DateTime? _hireDate;

  @override
  void initState() {
    super.initState();

    final personnel = widget.initialPersonnel;
    _militaryNumberController = TextEditingController(
      text: personnel?.militaryNumber ?? '',
    );
    _fullNameController = TextEditingController(
      text: personnel?.fullName ?? '',
    );
    _jobTitleController = TextEditingController(
      text: personnel?.jobTitle ?? '',
    );
    _phoneController = TextEditingController(text: personnel?.phone ?? '');
    _emailController = TextEditingController(text: personnel?.email ?? '');
    _nationalIdController = TextEditingController(
      text: personnel?.nationalId ?? '',
    );
    _notesController = TextEditingController(text: personnel?.notes ?? '');
    _rank = personnel?.rank;
    _department = personnel?.department;
    _status = personnel?.status;
    _birthDate = personnel?.birthDate;
    _hireDate = personnel?.hireDate;
  }

  @override
  void dispose() {
    _militaryNumberController.dispose();
    _fullNameController.dispose();
    _jobTitleController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _nationalIdController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Form(
        key: _formKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 720;
            final spacing = isWide ? 16.0 : 12.0;
            final fieldWidth = isWide
                ? (constraints.maxWidth - spacing) / 2
                : constraints.maxWidth;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                _fieldBox(
                  width: fieldWidth,
                  child: PersonnelTextField(
                    controller: _militaryNumberController,
                    label: 'الرقم العسكري',
                    icon: Icons.badge_outlined,
                    textInputAction: TextInputAction.next,
                    validator: _requiredValidator,
                    onChanged: (_) => _emitChanged(),
                  ),
                ),
                _fieldBox(
                  width: fieldWidth,
                  child: PersonnelTextField(
                    controller: _fullNameController,
                    label: 'الاسم الكامل',
                    icon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                    validator: _requiredValidator,
                    onChanged: (_) => _emitChanged(),
                  ),
                ),
                _fieldBox(
                  width: fieldWidth,
                  child: PersonnelDropdownField(
                    label: 'الرتبة',
                    value: _rank,
                    items: _rankOptions,
                    icon: Icons.military_tech_outlined,
                    validator: _requiredValidator,
                    onChanged: (value) {
                      setState(() => _rank = value);
                      _emitChanged();
                    },
                  ),
                ),
                _fieldBox(
                  width: fieldWidth,
                  child: PersonnelDropdownField(
                    label: 'القسم',
                    value: _department,
                    items: _departmentOptions,
                    icon: Icons.apartment_outlined,
                    validator: _requiredValidator,
                    onChanged: (value) {
                      setState(() => _department = value);
                      _emitChanged();
                    },
                  ),
                ),
                _fieldBox(
                  width: fieldWidth,
                  child: PersonnelTextField(
                    controller: _jobTitleController,
                    label: 'المسمى الوظيفي',
                    icon: Icons.work_outline,
                    textInputAction: TextInputAction.next,
                    validator: _requiredValidator,
                    onChanged: (_) => _emitChanged(),
                  ),
                ),
                _fieldBox(
                  width: fieldWidth,
                  child: PersonnelTextField(
                    controller: _phoneController,
                    label: 'رقم الهاتف',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    validator: _phoneValidator,
                    onChanged: (_) => _emitChanged(),
                  ),
                ),
                _fieldBox(
                  width: fieldWidth,
                  child: PersonnelTextField(
                    controller: _emailController,
                    label: 'البريد الإلكتروني',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: _emailValidator,
                    onChanged: (_) => _emitChanged(),
                  ),
                ),
                _fieldBox(
                  width: fieldWidth,
                  child: PersonnelTextField(
                    controller: _nationalIdController,
                    label: 'الرقم الوطني',
                    icon: Icons.credit_card_outlined,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: _requiredValidator,
                    onChanged: (_) => _emitChanged(),
                  ),
                ),
                _fieldBox(
                  width: fieldWidth,
                  child: PersonnelDateField(
                    label: 'تاريخ الميلاد',
                    value: _birthDate,
                    lastDate: DateTime.now(),
                    validator: _dateRequiredValidator,
                    onChanged: (value) {
                      setState(() => _birthDate = value);
                      _emitChanged();
                    },
                  ),
                ),
                _fieldBox(
                  width: fieldWidth,
                  child: PersonnelDateField(
                    label: 'تاريخ التعيين',
                    value: _hireDate,
                    lastDate: DateTime.now(),
                    validator: _dateRequiredValidator,
                    onChanged: (value) {
                      setState(() => _hireDate = value);
                      _emitChanged();
                    },
                  ),
                ),
                _fieldBox(
                  width: fieldWidth,
                  child: PersonnelDropdownField(
                    label: 'الحالة',
                    value: _status,
                    items: _statusOptions,
                    icon: Icons.verified_outlined,
                    validator: _requiredValidator,
                    onChanged: (value) {
                      setState(() => _status = value);
                      _emitChanged();
                    },
                  ),
                ),
                _fieldBox(
                  width: constraints.maxWidth,
                  child: PersonnelTextField(
                    controller: _notesController,
                    label: 'ملاحظات',
                    icon: Icons.notes_outlined,
                    maxLines: 4,
                    textInputAction: TextInputAction.newline,
                    onChanged: (_) => _emitChanged(),
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth,
                  child: FilledButton.icon(
                    onPressed: widget.isSubmitting ? null : _submit,
                    icon: widget.isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(widget.isSubmitting ? 'جاري الحفظ' : 'حفظ'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _fieldBox({required double width, required Widget child}) {
    return SizedBox(width: width, child: child);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    widget.onSubmit(_buildPersonnel());
  }

  void _emitChanged() {
    widget.onChanged(_buildPersonnel());
  }

  PersonnelModel _buildPersonnel() {
    final now = DateTime.now();
    final initialPersonnel = widget.initialPersonnel;

    return PersonnelModel(
      id: initialPersonnel?.id ?? '',
      militaryNumber: _militaryNumberController.text.trim(),
      fullName: _fullNameController.text.trim(),
      rank: _rank ?? '',
      department: _department ?? '',
      jobTitle: _jobTitleController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      nationalId: _nationalIdController.text.trim(),
      birthDate: _birthDate,
      hireDate: _hireDate,
      status: _status ?? '',
      notes: _notesController.text.trim(),
      createdAt: initialPersonnel?.createdAt ?? now,
      updatedAt: now,
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'هذا الحقل مطلوب';
    }

    return null;
  }

  String? _dateRequiredValidator(DateTime? value) {
    if (value == null) {
      return 'هذا الحقل مطلوب';
    }

    return null;
  }

  String? _phoneValidator(String? value) {
    final requiredError = _requiredValidator(value);
    if (requiredError != null) {
      return requiredError;
    }

    final normalizedValue = value!.trim();
    if (normalizedValue.length < 6) {
      return 'أدخل رقم هاتف صحيح';
    }

    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final normalizedValue = value.trim();
    if (!normalizedValue.contains('@') || !normalizedValue.contains('.')) {
      return 'أدخل بريد إلكتروني صحيح';
    }

    return null;
  }
}
