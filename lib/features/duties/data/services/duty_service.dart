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

  Future<bool> dutyExists({
    required DateTime date,
    required String shiftId,
    required String serviceLocationId,
    required String servicePostId,
    String? excludeDutyId,
  }) async {
    final dateKey =
        "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";

    final snapshot = await _duties
        .where('dateKey', isEqualTo: dateKey)
        .where('shiftId', isEqualTo: shiftId)
        .where('serviceLocationId', isEqualTo: serviceLocationId)
        .where('servicePostId', isEqualTo: servicePostId)
        .get();

    for (final doc in snapshot.docs) {
      if (doc.id != excludeDutyId) {
        return true;
      }
    }

    return false;
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
    final personnel = await _dutyPersonnel.where('dutyId', isEqualTo: id).get();
    if (personnel.docs.length >= 499) {
      throw StateError('عدد سجلات المناوبة يتجاوز الحد الآمن للحذف الدفعي');
    }

    final batch = _firestore.batch();

    for (final doc in personnel.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_duties.doc(id));
    await batch.commit();
  }

  Future<String> createDutyWithPersonnel(
    DutyModel duty,
    List<DutyPersonnelModel> personnel,
  ) async {
    _validateAssignments(personnel);
    if (personnel.length + 1 > 499) {
      throw StateError('عدد عمليات الإضافة يتجاوز الحد الآمن للدفعة');
    }
    final dutyRef = duty.id.isEmpty ? _duties.doc() : _duties.doc(duty.id);
    final batch = _firestore.batch();
    batch.set(dutyRef, duty.toFirestore());
    for (final item in personnel) {
      final ref = item.id.isEmpty ? _dutyPersonnel.doc() : _dutyPersonnel.doc(item.id);
      batch.set(ref, item.copyWith(dutyId: dutyRef.id).toFirestore());
    }
    await batch.commit();
    return dutyRef.id;
  }

  void _validateAssignments(List<DutyPersonnelModel> personnel) {
    if (personnel.isEmpty) {
      throw ArgumentError('يجب إسناد فرد واحد على الأقل');
    }
    final ids = personnel.map((item) => item.personnelId).toList();
    if (ids.toSet().length != ids.length) {
      throw ArgumentError('لا يجوز تكرار الفرد في نفس المناوبة');
    }
    if (personnel.where((item) => item.isLeader).length > 1) {
      throw ArgumentError('لا يجوز إسناد أكثر من قائد للمناوبة');
    }
  }

  Future<void> replaceDutyWithPersonnel(
    DutyModel duty,
    List<DutyPersonnelModel> personnel,
  ) async {
    _validateAssignments(personnel);
    final existing = await _dutyPersonnel.where('dutyId', isEqualTo: duty.id).get();
    if (existing.docs.length + personnel.length + 1 > 499) {
      throw StateError('عدد عمليات التحديث يتجاوز الحد الآمن للدفعة');
    }
    final batch = _firestore.batch();
    batch.update(_duties.doc(duty.id), duty.toFirestore());
    for (final doc in existing.docs) {
      batch.delete(doc.reference);
    }
    for (final item in personnel) {
      final ref = item.id.isEmpty ? _dutyPersonnel.doc() : _dutyPersonnel.doc(item.id);
      batch.set(ref, item.copyWith(dutyId: duty.id).toFirestore());
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
