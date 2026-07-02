import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../shared/models/base_model.dart';

class UserModel extends BaseModel {
  final String username;
  final String email;
  final String fullName;
  final String role;
  final String phone;
  final DateTime? lastLoginAt;

  const UserModel({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.username,
    required this.email,
    required this.fullName,
    required this.role,
    required this.phone,
    required this.lastLoginAt,
    super.isActive,
    super.isDeleted,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      role: map['role'] ?? '',
      phone: map['phone'] ?? '',
      lastLoginAt: map['lastLoginAt'] != null
          ? BaseModel.fromTimestamp(map['lastLoginAt'])
          : null,
      createdAt: BaseModel.fromTimestamp(map['createdAt']),
      updatedAt: BaseModel.fromTimestamp(map['updatedAt']),
      isActive: map['isActive'] ?? true,
      isDeleted: map['isDeleted'] ?? false,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'fullName': fullName,
      'role': role,
      'phone': phone,
      'lastLoginAt': lastLoginAt == null
          ? null
          : Timestamp.fromDate(lastLoginAt!),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
      'isDeleted': isDeleted,
    };
  }
}
