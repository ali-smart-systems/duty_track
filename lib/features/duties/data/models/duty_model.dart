import 'package:cloud_firestore/cloud_firestore.dart';

class DutyModel {
  const DutyModel({
    required this.id,
    required this.date,
    required this.dateKey,
    required this.shiftId,
    required this.serviceLocationId,
    required this.servicePostId,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;

  /// تاريخ المناوبة
  final DateTime date;

  final String dateKey;

  /// الوردية
  final String shiftId;

  /// موقع الخدمة
  final String serviceLocationId;

  /// نقطة الخدمة
  final String servicePostId;

  /// ملاحظات
  final String notes;

  final DateTime createdAt;
  final DateTime updatedAt;

  DutyModel copyWith({
    String? id,
    DateTime? date,
    String? dateKey,
    String? shiftId,
    String? serviceLocationId,
    String? servicePostId,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DutyModel(
      id: id ?? this.id,
      date: date ?? this.date,
      dateKey: dateKey ?? this.dateKey,
      shiftId: shiftId ?? this.shiftId,
      serviceLocationId: serviceLocationId ?? this.serviceLocationId,
      servicePostId: servicePostId ?? this.servicePostId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory DutyModel.fromMap(Map<String, dynamic> map) {
    return DutyModel(
      id: map['id'] ?? '',
      date: _dateTimeFromValue(map['date']) ?? DateTime.now(),
      dateKey: map['dateKey'] ?? '',
      shiftId: map['shiftId'] ?? '',
      serviceLocationId: map['serviceLocationId'] ?? '',
      servicePostId: map['servicePostId'] ?? '',
      notes: map['notes'] ?? '',
      createdAt: _dateTimeFromValue(map['createdAt']) ?? DateTime.now(),
      updatedAt: _dateTimeFromValue(map['updatedAt']) ?? DateTime.now(),
    );
  }

  factory DutyModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? {};

    return DutyModel.fromMap({...data, 'id': snapshot.id});
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': Timestamp.fromDate(date),
      'dateKey': dateKey,
      'shiftId': shiftId,
      'serviceLocationId': serviceLocationId,
      'servicePostId': servicePostId,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
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
