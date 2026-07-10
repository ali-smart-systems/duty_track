import 'package:flutter/material.dart';

class MasterDataListTile extends StatelessWidget {
  const MasterDataListTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.onEdit,
    required this.onDelete,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title),
        subtitle: subtitle == null ? null : Text(subtitle!),
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
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('تعديل')),
            PopupMenuItem(value: 'delete', child: Text('حذف')),
          ],
        ),
      ),
    );
  }
}
