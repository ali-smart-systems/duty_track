import 'duty_model.dart';

class DutyViewModel {
  const DutyViewModel({
    required this.duty,
    required this.shiftName,
    required this.locationName,
    required this.postName,
  });

  final DutyModel duty;

  final String shiftName;

  final String locationName;

  final String postName;
}
