import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/personnel_provider.dart';
import '../widgets/personnel_form.dart';

class AddPersonnelScreen extends ConsumerWidget {
  const AddPersonnelScreen({super.key});

  static const double _maxContentWidth = 900;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addState = ref.watch(addPersonnelProvider);

    ref.listen<AddPersonnelState>(addPersonnelProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }

      if (next.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ بيانات الموظف بنجاح')),
        );
        Navigator.of(context).pop();
      }
    });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('إضافة موظف')),
        body: SafeArea(
          child: Align(
            alignment: AlignmentDirectional.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxContentWidth),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: PersonnelForm(
                  isSubmitting: addState.loading,
                  onChanged: (_) {},
                  onSubmit: (personnel) {
                    ref
                        .read(addPersonnelProvider.notifier)
                        .addPersonnel(personnel);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
