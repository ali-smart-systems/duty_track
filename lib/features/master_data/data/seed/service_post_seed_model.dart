import '../../../../../core/enums/gender.dart';

class ServicePostSeedModel {
  const ServicePostSeedModel({
    required this.name,
    required this.requiredPersonnelCount,
    required this.gender,
    this.isRequired = true,
    this.isActive = true,
  });

  final String name;

  final int requiredPersonnelCount;

  final Gender gender;

  final bool isRequired;

  final bool isActive;
}

class ServiceLocationSeedModel {
  const ServiceLocationSeedModel({
    required this.locationCode,
    required this.locationName,
    required this.posts,
  });

  final String locationCode;

  final String locationName;

  final List<ServicePostSeedModel> posts;
}
