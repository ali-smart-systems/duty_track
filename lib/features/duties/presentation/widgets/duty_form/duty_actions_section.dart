import 'package:flutter/material.dart';

class DutyActionsSection extends StatelessWidget {
  const DutyActionsSection({
    super.key,
    required this.isLoading,
    required this.onSave,
    required this.onCancel,
  });

  final bool isLoading;

  final VoidCallback onSave;

  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: isLoading ? null : onSave,
            icon: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),

            label: Text(isLoading ? "جاري الحفظ..." : "حفظ المناوبة"),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: OutlinedButton.icon(
            onPressed: isLoading ? null : onCancel,
            icon: const Icon(Icons.close),
            label: const Text("إلغاء"),
          ),
        ),
      ],
    );
  }
}
