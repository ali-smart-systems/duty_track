import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/service_location_model.dart';
import '../data/models/service_post_model.dart';
import '../data/repositories/master_data_repository.dart';

final masterDataRepositoryProvider = Provider<MasterDataRepository>((ref) {
  return MasterDataRepository();
});

final serviceLocationsProvider = StreamProvider<List<ServiceLocationModel>>((
  ref,
) {
  return ref.watch(masterDataRepositoryProvider).getServiceLocations();
});

final servicePostsProvider =
    StreamProvider.family<List<ServicePostModel>, String>((ref, locationId) {
      return ref
          .watch(masterDataRepositoryProvider)
          .getServicePosts(locationId);
    });

final masterDataControllerProvider = Provider<MasterDataRepository>((ref) {
  return ref.read(masterDataRepositoryProvider);
});
