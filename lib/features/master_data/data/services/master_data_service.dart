import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/constants/app_constants.dart';
import '../models/service_location_model.dart';
import '../models/service_post_model.dart';

class MasterDataService {
  MasterDataService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  // ==========================
  // Collections
  // ==========================

  CollectionReference<Map<String, dynamic>> get _locations =>
      _firestore.collection(AppConstants.serviceLocationsCollection);

  CollectionReference<Map<String, dynamic>> get _posts =>
      _firestore.collection(AppConstants.servicePostsCollection);

  // ==========================
  // Service Locations
  // ==========================

  Stream<List<ServiceLocationModel>> getServiceLocations() {
    return _locations
        .orderBy('displayOrder')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(ServiceLocationModel.fromFirestore).toList(),
        );
  }

  Future<void> addServiceLocation(ServiceLocationModel location) async {
    await _locations.add(location.toFirestore());
  }

  Future<void> updateServiceLocation(ServiceLocationModel location) async {
    await _locations.doc(location.id).update(location.toFirestore());
  }

  Future<void> deleteServiceLocation(String id) async {
    await _locations.doc(id).delete();
  }

  // ==========================
  // Service Posts
  // ==========================

  Stream<List<ServicePostModel>> getServicePosts(String locationId) {
    return _posts
        .where('locationId', isEqualTo: locationId)
        .orderBy('displayOrder')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(ServicePostModel.fromFirestore).toList(),
        );
  }

  Future<void> addServicePost(ServicePostModel post) async {
    await _posts.add(post.toFirestore());
  }

  Future<void> updateServicePost(ServicePostModel post) async {
    await _posts.doc(post.id).update(post.toFirestore());
  }

  Future<void> deleteServicePost(String id) async {
    await _posts.doc(id).delete();
  }

  // ==========================
  // Seed Data
  // ==========================

  Future<bool> hasServiceLocations() async {
    final snapshot = await _locations.limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  Future<void> seedServiceLocations(
    List<ServiceLocationModel> locations,
  ) async {
    final exists = await hasServiceLocations();

    if (exists) {
      return;
    }

    final batch = _firestore.batch();

    for (final location in locations) {
      final doc = _locations.doc();

      batch.set(doc, location.copyWith(id: doc.id).toFirestore());
    }

    await batch.commit();
  }
}
