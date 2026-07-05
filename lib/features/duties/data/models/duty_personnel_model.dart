import 'package:cloud_firestore/cloud_firestore.dart';

class DutyPersonnelModel {
  const DutyPersonnelModel({
    required this.id,
    required this.dutyId,
    required this.personnelId,
    required this.createdAt,
  });

  final String id;

  /// المناوبة
  final String dutyId;

  /// الموظف
  final String personnelId;

  final DateTime createdAt;

  DutyPersonnelModel copyWith({
    String? id,
    String? dutyId,
    String? personnelId,
    DateTime? createdAt,
  }) {
    return DutyPersonnelModel(
      id: id ?? this.id,
      dutyId: dutyId ?? this.dutyId,
      personnelId: personnelId ?? this.personnelId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory DutyPersonnelModel.fromMap(Map<String, dynamic> map) {
    return DutyPersonnelModel(
      id: map['id'] ?? '',
      dutyId: map['dutyId'] ?? '',
      personnelId: map['personnelId'] ?? '',
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
