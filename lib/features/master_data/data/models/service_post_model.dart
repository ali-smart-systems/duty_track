import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/enums/gender.dart';

class ServicePostModel {
  const ServicePostModel({
    required this.id,
    required this.locationId,
    required this.name,
    required this.displayOrder,
    required this.requiredPersonnelCount,
    required this.gender,
    required this.isRequired,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;

  /// موقع الخدمة الذي يتبع له هذا المنصب
  final String locationId;

  /// اسم المنصب
  final String name;

  /// ترتيب العرض داخل الموقع
  final int displayOrder;

  /// عدد الأفراد المطلوبين لهذا المنصب
  final int requiredPersonnelCount;

  /// الجنس المطلوب
  final Gender gender;

  /// هل المنصب إلزامي؟
  final bool isRequired;

  /// هل المنصب مفعل؟
  final bool isActive;

  final DateTime createdAt;
  final DateTime updatedAt;

  ServicePostModel copyWith({
    String? id,
    String? locationId,
    String? name,
    int? displayOrder,
    int? requiredPersonnelCount,
    Gender? gender,
    bool? isRequired,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServicePostModel(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      name: name ?? this.name,
      displayOrder: displayOrder ?? this.displayOrder,
      requiredPersonnelCount:
          requiredPersonnelCount ?? this.requiredPersonnelCount,
      gender: gender ?? this.gender,
      isRequired: isRequired ?? this.isRequired,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ServicePostModel.fromMap(Map<String, dynamic> map) {
    return ServicePostModel(
      id: map['id'] ?? '',
      locationId: map['locationId'] ?? '',
      name: map['name'] ?? '',
      displayOrder: map['displayOrder'] ?? 0,
      requiredPersonnelCount: map['requiredPersonnelCount'] ?? 1,
      gender: Gender.values.firstWhere(
        (e) => e.name == (map['gender'] ?? 'both'),
        orElse: () => Gender.both,
      ),
      isRequired: map['isRequired'] ?? true,
      isActive: map['isActive'] ?? true,
      createdAt: _toDateTime(map['createdAt']) ?? DateTime.now(),
      updatedAt: _toDateTime(map['updatedAt']) ?? DateTime.now(),
    );
  }

  factory ServicePostModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? {};

    return ServicePostModel.fromMap({...data, 'id': snapshot.id});
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'locationId': locationId,
      'name': name,
      'displayOrder': displayOrder,
      'requiredPersonnelCount': requiredPersonnelCount,
      'gender': gender.name,
      'isRequired': isRequired,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Map<String, dynamic> toFirestore() {
    final data = toMap();
    data.remove('id');
    return data;
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return null;
  }
}
