import 'package:cloud_firestore/cloud_firestore.dart';

class MissionTypeModel {
  const MissionTypeModel({
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

  MissionTypeModel copyWith({
    String? id,
    String? name,
    int? displayOrder,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MissionTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      displayOrder: displayOrder ?? this.displayOrder,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory MissionTypeModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? {};

    return MissionTypeModel(
      id: snapshot.id,
      name: data['name'] ?? '',
      displayOrder: data['displayOrder'] ?? 0,
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'displayOrder': displayOrder,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
