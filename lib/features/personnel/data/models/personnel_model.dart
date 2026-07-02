import 'package:cloud_firestore/cloud_firestore.dart';

class PersonnelModel {
  const PersonnelModel({
    required this.id,
    required this.militaryNumber,
    required this.fullName,
    required this.rank,
    required this.department,
    required this.jobTitle,
    required this.phone,
    required this.email,
    required this.nationalId,
    required this.birthDate,
    required this.hireDate,
    required this.status,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String militaryNumber;
  final String fullName;
  final String rank;
  final String department;
  final String jobTitle;
  final String phone;
  final String email;
  final String nationalId;
  final DateTime? birthDate;
  final DateTime? hireDate;
  final String status;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  PersonnelModel copyWith({
    String? id,
    String? militaryNumber,
    String? fullName,
    String? rank,
    String? department,
    String? jobTitle,
    String? phone,
    String? email,
    String? nationalId,
    DateTime? birthDate,
    DateTime? hireDate,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PersonnelModel(
      id: id ?? this.id,
      militaryNumber: militaryNumber ?? this.militaryNumber,
      fullName: fullName ?? this.fullName,
      rank: rank ?? this.rank,
      department: department ?? this.department,
      jobTitle: jobTitle ?? this.jobTitle,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      nationalId: nationalId ?? this.nationalId,
      birthDate: birthDate ?? this.birthDate,
      hireDate: hireDate ?? this.hireDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory PersonnelModel.fromMap(Map<String, dynamic> map) {
    return PersonnelModel(
      id: map['id'] as String? ?? '',
      militaryNumber: map['militaryNumber'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      rank: map['rank'] as String? ?? '',
      department: map['department'] as String? ?? '',
      jobTitle: map['jobTitle'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      email: map['email'] as String? ?? '',
      nationalId: map['nationalId'] as String? ?? '',
      birthDate: _dateTimeFromValue(map['birthDate']),
      hireDate: _dateTimeFromValue(map['hireDate']),
      status: map['status'] as String? ?? '',
      notes: map['notes'] as String? ?? '',
      createdAt: _dateTimeFromValue(map['createdAt']) ?? DateTime.now(),
      updatedAt: _dateTimeFromValue(map['updatedAt']) ?? DateTime.now(),
    );
  }

  factory PersonnelModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};

    return PersonnelModel.fromMap({...data, 'id': snapshot.id});
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'militaryNumber': militaryNumber,
      'fullName': fullName,
      'rank': rank,
      'department': department,
      'jobTitle': jobTitle,
      'phone': phone,
      'email': email,
      'nationalId': nationalId,
      'birthDate': _timestampFromDateTime(birthDate),
      'hireDate': _timestampFromDateTime(hireDate),
      'status': status,
      'notes': notes,
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

  static Timestamp? _timestampFromDateTime(DateTime? value) {
    return value == null ? null : Timestamp.fromDate(value);
  }
}
