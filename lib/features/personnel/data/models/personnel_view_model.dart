import 'personnel_model.dart';

class PersonnelViewModel {
  const PersonnelViewModel({
    required this.personnel,
    required this.rankName,
    required this.departmentName,
    required this.serviceLocationName,
    required this.servicePostName,
  });

  final PersonnelModel personnel;

  final String rankName;
  final String departmentName;
  final String serviceLocationName;
  final String servicePostName;
}
