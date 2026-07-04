import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/constants/app_constants.dart';
import '../models/mission_type_model.dart';

class MissionTypeService {
  MissionTypeService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _missionTypes =>
      _firestore.collection(AppConstants.missionTypesCollection);

  Stream<List<MissionTypeModel>> getMissionTypes() {
    return _missionTypes
        .orderBy('displayOrder')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(MissionTypeModel.fromFirestore).toList(),
        );
  }

  Future<void> addMissionType(MissionTypeModel missionType) async {
    await _missionTypes.add(missionType.toFirestore());
  }

  Future<void> updateMissionType(MissionTypeModel missionType) async {
    await _missionTypes.doc(missionType.id).update(missionType.toFirestore());
  }

  Future<void> deleteMissionType(String id) async {
    await _missionTypes.doc(id).delete();
  }
}
