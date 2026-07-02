import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/personnel_model.dart';

class PersonnelService {
  PersonnelService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(AppConstants.personnelCollection);

  Future<List<PersonnelModel>> getPersonnel() async {
    final snapshot = await _collection.orderBy('fullName').get();

    return snapshot.docs.map(PersonnelModel.fromFirestore).toList();
  }

  Future<PersonnelModel?> getPersonnelById(String id) async {
    final snapshot = await _collection.doc(id).get();

    if (!snapshot.exists) {
      return null;
    }

    return PersonnelModel.fromFirestore(snapshot);
  }

  Future<String> addPersonnel(PersonnelModel personnel) async {
    if (personnel.id.isNotEmpty) {
      await _collection.doc(personnel.id).set(personnel.toFirestore());
      return personnel.id;
    }

    final document = await _collection.add(personnel.toFirestore());
    return document.id;
  }

  Future<bool> militaryNumberExists(
    String militaryNumber, {
    String? excludePersonnelId,
  }) async {
    final snapshot = await _collection
        .where('militaryNumber', isEqualTo: militaryNumber)
        .limit(1)
        .get();

    return snapshot.docs.any((doc) => doc.id != excludePersonnelId);
  }

  Future<bool> nationalIdExists(
    String nationalId, {
    String? excludePersonnelId,
  }) async {
    final snapshot = await _collection
        .where('nationalId', isEqualTo: nationalId)
        .limit(1)
        .get();

    return snapshot.docs.any((doc) => doc.id != excludePersonnelId);
  }

  Future<void> updatePersonnel(PersonnelModel personnel) async {
    await _collection.doc(personnel.id).update(personnel.toFirestore());
  }

  Future<void> deletePersonnel(String id) async {
    await _collection.doc(id).delete();
  }
}
