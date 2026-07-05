import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/constants/app_constants.dart';
import '../models/duty_model.dart';
import '../models/duty_personnel_model.dart';

class DutyService {
  DutyService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _duties =>
      _firestore.collection(AppConstants.dutiesCollection);

  CollectionReference<Map<String, dynamic>> get _dutyPersonnel =>
      _firestore.collection(AppConstants.dutyPersonnelCollection);

  // ==========================
  // Duties
  // ==========================

  Future<List<DutyModel>> getDuties() async {
    final snapshot = await _duties.orderBy('date').get();

    return snapshot.docs.map(DutyModel.fromFirestore).toList();
  }

  Future<DutyModel?> getDutyById(String id) async {
    final snapshot = await _duties.doc(id).get();

    if (!snapshot.exists) {
      return null;
    }

    return DutyModel.fromFirestore(snapshot);
  }

  Future<String> addDuty(DutyModel duty) async {
    if (duty.id.isNotEmpty) {
      await _duties.doc(duty.id).set(duty.toFirestore());

      return duty.id;
    }

    final document = await _duties.add(duty.toFirestore());

    return document.id;
  }

  Future<void> updateDuty(DutyModel duty) async {
    await _duties.doc(duty.id).update(duty.toFirestore());
  }

  Future<void> deleteDuty(String id) async {
    await _duties.doc(id).delete();

    final personnel = await _dutyPersonnel.where('dutyId', isEqualTo: id).get();

    final batch = _firestore.batch();

    for (final doc in personnel.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  // ==========================
  // Duty Personnel
  // ==========================

  Future<List<DutyPersonnelModel>> getDutyPersonnel(String dutyId) async {
    final snapshot = await _dutyPersonnel
        .where('dutyId', isEqualTo: dutyId)
        .get();

    return snapshot.docs.map(DutyPersonnelModel.fromFirestore).toList();
  }

  Future<void> addPersonnelToDuty(DutyPersonnelModel model) async {
    if (model.id.isNotEmpty) {
      await _dutyPersonnel.doc(model.id).set(model.toFirestore());
      return;
    }

    await _dutyPersonnel.add(model.toFirestore());
  }

  Future<void> removePersonnelFromDuty(String recordId) async {
    await _dutyPersonnel.doc(recordId).delete();
  }

  Future<void> removeAllPersonnelFromDuty(String dutyId) async {
    final snapshot = await _dutyPersonnel
        .where('dutyId', isEqualTo: dutyId)
        .get();

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}
