import 'package:flutter/material.dart';

import '../../data/models/leave_type_model.dart';
import 'add_leave_type_screen.dart';

class EditLeaveTypeScreen extends StatelessWidget {
  const EditLeaveTypeScreen({super.key, required this.leaveType});

  final LeaveTypeModel leaveType;

  @override
  Widget build(BuildContext context) {
    return AddLeaveTypeScreen(leaveType: leaveType);
  }
}
