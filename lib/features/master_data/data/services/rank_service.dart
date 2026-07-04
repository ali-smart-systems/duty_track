import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/constants/app_constants.dart';
import '../models/rank_model.dart';

class RankService {
  RankService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _ranks =>
      _firestore.collection(AppConstants.ranksCollection);

  Stream<List<RankModel>> getRanks() {
    return _ranks
        .orderBy('displayOrder')
        .snapshots()
        .map((snapshot) => snapshot.docs.map(RankModel.fromFirestore).toList());
  }

  Future<void> addRank(RankModel rank) async {
    await _ranks.add(rank.toFirestore());
  }

  Future<void> updateRank(RankModel rank) async {
    await _ranks.doc(rank.id).update(rank.toFirestore());
  }

  Future<void> deleteRank(String id) async {
    await _ranks.doc(id).delete();
  }
}
