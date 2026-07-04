import 'package:cloud_firestore/cloud_firestore.dart';

import 'service_assignment_model.dart';

class DailyServiceModel {
  const DailyServiceModel({
    required this.id,
    required this.serviceDate,
    required this.shiftId,
    required this.shiftName,
    required this.assignments,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;

  /// تاريخ الخدمة
  final DateTime serviceDate;

  /// معرف الوردية
  final String shiftId;

  /// اسم الوردية
  final String shiftName;

  /// جميع التكليفات الخاصة بهذه الخدمة
  final List<ServiceAssignmentModel> assignments;

  /// المستخدم الذي أنشأ السجل
  final String createdBy;

  final DateTime createdAt;
  final DateTime updatedAt;

  DailyServiceModel copyWith({
    String? id,
    DateTime? serviceDate,
    String? shiftId,
    String? shiftName,
    List<ServiceAssignmentModel>? assignments,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DailyServiceModel(
      id: id ?? this.id,
      serviceDate: serviceDate ?? this.serviceDate,
      shiftId: shiftId ?? this.shiftId,
      shiftName: shiftName ?? this.shiftName,
      assignments: assignments ?? this.assignments,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory DailyServiceModel.fromMap(Map<String, dynamic> map) {
    return DailyServiceModel(
      id: map['id'] as String? ?? '',
      serviceDate: _dateTimeFromValue(map['serviceDate']) ?? DateTime.now(),
      shiftId: map['shiftId'] as String? ?? '',
      shiftName: map['shiftName'] as String? ?? '',
      assignments: (map['assignments'] as List<dynamic>? ?? [])
          .map(
            (e) => ServiceAssignmentModel.fromMap(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList(),
      createdBy: map['createdBy'] as String? ?? '',
      createdAt: _dateTimeFromValue(map['createdAt']) ?? DateTime.now(),
      updatedAt: _dateTimeFromValue(map['updatedAt']) ?? DateTime.now(),
    );
  }

  factory DailyServiceModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};

    return DailyServiceModel.fromMap({...data, 'id': snapshot.id});
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceDate': Timestamp.fromDate(serviceDate),
      'shiftId': shiftId,
      'shiftName': shiftName,
      'assignments': assignments.map((e) => e.toMap()).toList(),
      'createdBy': createdBy,
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
