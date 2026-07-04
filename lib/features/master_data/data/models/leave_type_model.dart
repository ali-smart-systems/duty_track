import 'package:cloud_firestore/cloud_firestore.dart';

class LeaveTypeModel {
  const LeaveTypeModel({
    required this.id,
    required this.name,
    required this.maxDays,
    required this.displayOrder,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final int maxDays;
  final int displayOrder;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  LeaveTypeModel copyWith({
    String? id,
    String? name,
    int? maxDays,
    int? displayOrder,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LeaveTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      maxDays: maxDays ?? this.maxDays,
      displayOrder: displayOrder ?? this.displayOrder,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory LeaveTypeModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? {};

    return LeaveTypeModel(
      id: snapshot.id,
      name: data['name'] ?? '',
      maxDays: data['maxDays'] ?? 0,
      displayOrder: data['displayOrder'] ?? 0,
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'maxDays': maxDays,
      'displayOrder': displayOrder,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
