import 'package:cloud_firestore/cloud_firestore.dart';

class DutyPersonnelModel {
  const DutyPersonnelModel({
    required this.id,
    required this.dutyId,
    required this.personnelId,
    required this.role,
    required this.isLeader,
    required this.createdAt,
  });

  final String id;

  /// المناوبة
  final String dutyId;

  /// الفرد
  final String personnelId;

  /// الدور داخل المناوبة
  final String role;

  /// هل هو قائد المناوبة
  final bool isLeader;

  final DateTime createdAt;

  DutyPersonnelModel copyWith({
    String? id,
    String? dutyId,
    String? personnelId,
    String? role,
    bool? isLeader,
    DateTime? createdAt,
  }) {
    return DutyPersonnelModel(
      id: id ?? this.id,
      dutyId: dutyId ?? this.dutyId,
      personnelId: personnelId ?? this.personnelId,
      role: role ?? this.role,
      isLeader: isLeader ?? this.isLeader,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory DutyPersonnelModel.fromMap(Map<String, dynamic> map) {
    return DutyPersonnelModel(
      id: map['id'] ?? '',
      dutyId: map['dutyId'] ?? '',
      personnelId: map['personnelId'] ?? '',
      role: map['role'] ?? 'فرد',
      isLeader: map['isLeader'] ?? false,
      createdAt: _dateTimeFromValue(map['createdAt']) ?? DateTime.now(),
    );
  }

  factory DutyPersonnelModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? {};

    return DutyPersonnelModel.fromMap({...data, 'id': snapshot.id});
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dutyId': dutyId,
      'personnelId': personnelId,
      'role': role,
      'isLeader': isLeader,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Map<String, dynamic> toFirestore() {
    final map = toMap();
    map.remove('id');
    return map;
  }

  static DateTime? _dateTimeFromValue(dynamic value) {
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
