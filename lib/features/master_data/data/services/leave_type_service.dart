import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/constants/app_constants.dart';
import '../models/leave_type_model.dart';

class LeaveTypeService {
  LeaveTypeService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _leaveTypes =>
      _firestore.collection(AppConstants.leaveTypesCollection);

  Stream<List<LeaveTypeModel>> getLeaveTypes() {
    return _leaveTypes
        .orderBy('displayOrder')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(LeaveTypeModel.fromFirestore).toList(),
        );
  }

  Future<void> addLeaveType(LeaveTypeModel leaveType) async {
    await _leaveTypes.add(leaveType.toFirestore());
  }

  Future<void> updateLeaveType(LeaveTypeModel leaveType) async {
    await _leaveTypes.doc(leaveType.id).update(leaveType.toFirestore());
  }

  Future<void> deleteLeaveType(String id) async {
    await _leaveTypes.doc(id).delete();
  }
}
