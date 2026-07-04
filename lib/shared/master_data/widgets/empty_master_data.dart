import 'package:flutter/material.dart';

class EmptyMasterData extends StatelessWidget {
  const EmptyMasterData({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message, style: const TextStyle(fontSize: 18)));
  }
}
