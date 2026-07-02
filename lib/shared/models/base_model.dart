import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseModel {
  final String id;

  final DateTime createdAt;

  final DateTime updatedAt;

  final bool isActive;

  final bool isDeleted;

  const BaseModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.isDeleted = false,
  });

  Map<String, dynamic> toMap();

  static DateTime? dateTimeFromTimestamp(dynamic value) {
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
