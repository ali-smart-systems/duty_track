import 'duty_model.dart';

class DutyViewModel {
  const DutyViewModel({
    required this.duty,
    required this.shiftName,
    required this.locationName,
    required this.postName,
    required this.taskTypeName,
    required this.status,
  });

  final DutyModel duty;

  final String shiftName;

  final String locationName;

  final String postName;

  /// اسم نوع المهمة
  final String taskTypeName;

  /// حالة المناوبة
  final String status;
}
