import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/constants/app_constants.dart';
import '../models/department_model.dart';

class DepartmentService {
  DepartmentService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _departments =>
      _firestore.collection(AppConstants.departmentsCollection);

  Stream<List<DepartmentModel>> getDepartments() {
    return _departments
        .orderBy('displayOrder')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(DepartmentModel.fromFirestore).toList(),
        );
  }

  Future<void> addDepartment(DepartmentModel department) async {
    await _departments.add(department.toFirestore());
  }

  Future<void> updateDepartment(DepartmentModel department) async {
    await _departments.doc(department.id).update(department.toFirestore());
  }

  Future<void> deleteDepartment(String id) async {
    await _departments.doc(id).delete();
  }
}
