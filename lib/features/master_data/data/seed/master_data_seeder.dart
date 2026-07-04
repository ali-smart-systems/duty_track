import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/constants/app_constants.dart';
import '../models/service_location_model.dart';
import '../models/service_post_model.dart';
import 'service_locations_seed.dart';
import 'service_posts_seed.dart';

class MasterDataSeeder {
  MasterDataSeeder._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> seedServiceLocations() async {
    final collection = _firestore.collection(
      AppConstants.serviceLocationsCollection,
    );

    for (var i = 0; i < ServiceLocationsSeed.data.length; i++) {
      final location = ServiceLocationsSeed.data[i];

      final exists = await collection
          .where('name', isEqualTo: location.name)
          .limit(1)
          .get();

      if (exists.docs.isNotEmpty) {
        continue;
      }

      await collection.add(
        ServiceLocationModel(
          id: '',
          name: location.name,
          displayOrder: i + 1,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ).toFirestore(),
      );
    }
  }

  static Future<void> seedServicePosts() async {
    final locationsCollection = _firestore.collection(
      AppConstants.serviceLocationsCollection,
    );

    final postsCollection = _firestore.collection(
      AppConstants.servicePostsCollection,
    );

    final locationsSnapshot = await locationsCollection.get();

    final Map<String, String> locationIds = {};

    for (final doc in locationsSnapshot.docs) {
      locationIds[doc['name']] = doc.id;
    }

    for (final location in ServicePostsSeed.data) {
      final locationId = locationIds[location.locationName];

      if (locationId == null) continue;

      int order = 1;

      for (final post in location.posts) {
        final exists = await postsCollection
            .where('locationId', isEqualTo: locationId)
            .where('name', isEqualTo: post.name)
            .limit(1)
            .get();

        if (exists.docs.isNotEmpty) {
          continue;
        }

        await postsCollection.add(
          ServicePostModel(
            id: '',
            locationId: locationId,
            name: post.name,
            displayOrder: order++,
            requiredPersonnelCount: post.requiredPersonnelCount,
            gender: post.gender,
            isRequired: post.isRequired,
            isActive: post.isActive,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ).toFirestore(),
        );
      }
    }
  }

  static Future<void> seedAll() async {
    await seedServiceLocations();

    await seedServicePosts();
  }
}
