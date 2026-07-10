import 'package:flutter/material.dart';

class PersonnelDropdownField extends StatelessWidget {
  const PersonnelDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.icon,
    this.validator,
  });

  final String label;
  final String? value;

  final List<DropdownMenuItem<String>> items;

  final ValueChanged<String?> onChanged;
  final IconData? icon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value == null || value!.isEmpty ? null : value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon == null ? null : Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
