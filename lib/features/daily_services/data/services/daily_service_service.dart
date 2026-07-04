import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/constants/app_constants.dart';
import '../models/daily_service_model.dart';

class DailyServiceService {
  DailyServiceService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(AppConstants.dailyServicesCollection);

  /// جميع كشوفات الخدمات اليومية
  Stream<List<DailyServiceModel>> getDailyServices() {
    return _collection
        .orderBy('serviceDate', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(DailyServiceModel.fromFirestore).toList(),
        );
  }

  /// كشف واحد حسب المعرف
  Future<DailyServiceModel?> getById(String id) async {
    final doc = await _collection.doc(id).get();

    if (!doc.exists) {
      return null;
    }

    return DailyServiceModel.fromFirestore(doc);
  }

  /// إضافة كشف جديد
  Future<void> add(DailyServiceModel model) async {
    await _collection.add(model.toFirestore());
  }

  /// تعديل كشف
  Future<void> update(DailyServiceModel model) async {
    await _collection.doc(model.id).update(model.toFirestore());
  }

  /// حذف كشف
  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}
