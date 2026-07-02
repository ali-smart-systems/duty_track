import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PersonnelDateField extends StatelessWidget {
  PersonnelDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.validator,
  }) : _formatter = DateFormat('yyyy-MM-dd');

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? Function(DateTime?)? validator;
  final DateFormat _formatter;

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime?>(
      initialValue: value,
      validator: validator,
      builder: (field) {
        final selectedDate = field.value;

        return InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () => _pickDate(context, field),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: const Icon(Icons.calendar_today_outlined),
              border: const OutlineInputBorder(),
              errorText: field.errorText,
            ),
            child: Text(
              selectedDate == null ? '' : _formatter.format(selectedDate),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    FormFieldState<DateTime?> field,
  ) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: field.value ?? now,
      firstDate: firstDate ?? DateTime(1950),
      lastDate: lastDate ?? DateTime(now.year + 10),
    );

    if (pickedDate == null) {
      return;
    }

    field.didChange(pickedDate);
    onChanged(pickedDate);
  }
}
