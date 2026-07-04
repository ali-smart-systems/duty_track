import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceLocationModel {
  const ServiceLocationModel({
    required this.id,
    required this.name,
    required this.displayOrder,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final int displayOrder;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceLocationModel copyWith({
    String? id,
    String? name,
    int? displayOrder,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceLocationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      displayOrder: displayOrder ?? this.displayOrder,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ServiceLocationModel.fromMap(Map<String, dynamic> map) {
    return ServiceLocationModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      displayOrder: map['displayOrder'] as int? ?? 0,
      isActive: map['isActive'] as bool? ?? true,
      createdAt: _dateTimeFromValue(map['createdAt']) ?? DateTime.now(),
      updatedAt: _dateTimeFromValue(map['updatedAt']) ?? DateTime.now(),
    );
  }

  factory ServiceLocationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};

    return ServiceLocationModel.fromMap({...data, 'id': snapshot.id});
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'displayOrder': displayOrder,
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

  static DateTime? _dateTimeFromValue(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return null;
  }
}
