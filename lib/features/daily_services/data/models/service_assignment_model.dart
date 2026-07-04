class ServiceAssignmentModel {
  const ServiceAssignmentModel({
    required this.id,
    required this.locationId,
    required this.locationName,
    required this.postId,
    required this.postName,
    required this.personnelId,
    required this.personnelName,
    required this.rank,
    required this.notes,
  });

  final String id;

  /// معرف موقع الخدمة
  final String locationId;

  /// اسم موقع الخدمة (Snapshot)
  final String locationName;

  /// معرف المنصب
  final String postId;

  /// اسم المنصب (Snapshot)
  final String postName;

  /// معرف الفرد
  final String personnelId;

  /// اسم الفرد (Snapshot)
  final String personnelName;

  /// الرتبة وقت التكليف (Snapshot)
  final String rank;

  /// ملاحظات إضافية
  final String notes;

  ServiceAssignmentModel copyWith({
    String? id,
    String? locationId,
    String? locationName,
    String? postId,
    String? postName,
    String? personnelId,
    String? personnelName,
    String? rank,
    String? notes,
  }) {
    return ServiceAssignmentModel(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      locationName: locationName ?? this.locationName,
      postId: postId ?? this.postId,
      postName: postName ?? this.postName,
      personnelId: personnelId ?? this.personnelId,
      personnelName: personnelName ?? this.personnelName,
      rank: rank ?? this.rank,
      notes: notes ?? this.notes,
    );
  }

  factory ServiceAssignmentModel.fromMap(Map<String, dynamic> map) {
    return ServiceAssignmentModel(
      id: map['id'] as String? ?? '',
      locationId: map['locationId'] as String? ?? '',
      locationName: map['locationName'] as String? ?? '',
      postId: map['postId'] as String? ?? '',
      postName: map['postName'] as String? ?? '',
      personnelId: map['personnelId'] as String? ?? '',
      personnelName: map['personnelName'] as String? ?? '',
      rank: map['rank'] as String? ?? '',
      notes: map['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'locationId': locationId,
      'locationName': locationName,
      'postId': postId,
      'postName': postName,
      'personnelId': personnelId,
      'personnelName': personnelName,
      'rank': rank,
      'notes': notes,
    };
  }
}
