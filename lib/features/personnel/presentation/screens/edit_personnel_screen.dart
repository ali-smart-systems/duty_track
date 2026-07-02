import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/personnel_model.dart';
import '../../providers/personnel_provider.dart';
import '../widgets/personnel_form.dart';

class EditPersonnelScreen extends ConsumerWidget {
  const EditPersonnelScreen({super.key, required this.personnelId});

  static const double _maxContentWidth = 900;

  final String personnelId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personnelAsync = ref.watch(personnelByIdProvider(personnelId));
    final editState = ref.watch(editPersonnelProvider);

    ref.listen<EditPersonnelState>(editPersonnelProvider, (previous, next) {
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
          const SnackBar(content: Text('تم تحديث بيانات الموظف بنجاح')),
        );
        Navigator.of(context).pop();
      }
    });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('تعديل بيانات موظف')),
        body: SafeArea(
          child: personnelAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => const _EditPersonnelErrorState(),
            data: (personnel) {
              if (personnel == null) {
                return const _PersonnelNotFoundState();
              }

              return _EditPersonnelContent(
                personnel: personnel,
                isSubmitting: editState.loading,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EditPersonnelContent extends ConsumerWidget {
  const _EditPersonnelContent({
    required this.personnel,
    required this.isSubmitting,
  });

  final PersonnelModel personnel;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: AlignmentDirectional.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: EditPersonnelScreen._maxContentWidth,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: PersonnelForm(
            initialPersonnel: personnel,
            isSubmitting: isSubmitting,
            onChanged: (_) {},
            onSubmit: (updatedPersonnel) {
              ref
                  .read(editPersonnelProvider.notifier)
                  .updatePersonnel(updatedPersonnel);
            },
          ),
        ),
      ),
    );
  }
}

class _EditPersonnelErrorState extends StatelessWidget {
  const _EditPersonnelErrorState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'تعذر تحميل بيانات الموظف',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }
}

class _PersonnelNotFoundState extends StatelessWidget {
  const _PersonnelNotFoundState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'لم يتم العثور على بيانات الموظف',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
