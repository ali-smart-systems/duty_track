import 'package:flutter/material.dart';

class MasterDataCard extends StatelessWidget {
  const MasterDataCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.onEdit,
    required this.onDelete,
  });

  final String title;
  final String subtitle;
  final Widget leading;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: leading,
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                onEdit();
                break;

              case 'delete':
                onDelete();
                break;
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'edit', child: Text('تعديل')),
            PopupMenuItem(value: 'delete', child: Text('حذف')),
          ],
        ),
      ),
    );
  }
}
