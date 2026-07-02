import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../data/models/personnel_model.dart';

class PersonnelDetailsScreen extends StatelessWidget {
  PersonnelDetailsScreen({super.key, required this.personnel})
    : _dateFormatter = intl.DateFormat('yyyy-MM-dd'),
      _dateTimeFormatter = intl.DateFormat('yyyy-MM-dd HH:mm');

  static const double _maxContentWidth = 900;

  final PersonnelModel personnel;
  final intl.DateFormat _dateFormatter;
  final intl.DateFormat _dateTimeFormatter;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('تفاصيل الموظف')),
        body: SafeArea(
          child: Align(
            alignment: AlignmentDirectional.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxContentWidth),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _DetailsSection(
                    title: 'البيانات الأساسية',
                    children: [
                      _DetailTile(label: 'المعرف', value: personnel.id),
                      _DetailTile(
                        label: 'الرقم العسكري',
                        value: personnel.militaryNumber,
                      ),
                      _DetailTile(
                        label: 'الاسم الكامل',
                        value: personnel.fullName,
                      ),
                      _DetailTile(label: 'الرتبة', value: personnel.rank),
                      _DetailTile(label: 'القسم', value: personnel.department),
                      _DetailTile(
                        label: 'المسمى الوظيفي',
                        value: personnel.jobTitle,
                      ),
                      _DetailTile(label: 'الحالة', value: personnel.status),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _DetailsSection(
                    title: 'بيانات التواصل والهوية',
                    children: [
                      _DetailTile(label: 'رقم الهاتف', value: personnel.phone),
                      _DetailTile(
                        label: 'البريد الإلكتروني',
                        value: personnel.email,
                      ),
                      _DetailTile(
                        label: 'الرقم الوطني',
                        value: personnel.nationalId,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _DetailsSection(
                    title: 'التواريخ',
                    children: [
                      _DetailTile(
                        label: 'تاريخ الميلاد',
                        value: _formatDate(personnel.birthDate),
                      ),
                      _DetailTile(
                        label: 'تاريخ التعيين',
                        value: _formatDate(personnel.hireDate),
                      ),
                      _DetailTile(
                        label: 'تاريخ الإنشاء',
                        value: _dateTimeFormatter.format(personnel.createdAt),
                      ),
                      _DetailTile(
                        label: 'آخر تحديث',
                        value: _dateTimeFormatter.format(personnel.updatedAt),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _DetailsSection(
                    title: 'ملاحظات',
                    children: [
                      _DetailTile(label: 'ملاحظات', value: personnel.notes),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? value) {
    return value == null ? 'غير محدد' : _dateFormatter.format(value);
  }
}

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final displayValue = value.trim().isEmpty ? 'غير محدد' : value;

    return ListTile(title: Text(label), subtitle: Text(displayValue));
  }
}
