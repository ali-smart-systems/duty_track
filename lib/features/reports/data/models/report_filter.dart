class ReportFilter {
  const ReportFilter({
    required this.fromDate,
    required this.toDate,
    this.locationId,
    this.postId,
    this.shiftId,
    this.missionTypeId,
    this.dutyStatus,
    this.departmentId,
    this.rankId,
    this.personnelId,
  });

  final DateTime fromDate;
  final DateTime toDate;

  final String? locationId;
  final String? postId;
  final String? shiftId;
  final String? missionTypeId;
  final String? dutyStatus;
  final String? departmentId;
  final String? rankId;
  final String? personnelId;

  ReportFilter copyWith({
    DateTime? fromDate,
    DateTime? toDate,
    String? locationId,
    String? postId,
    String? shiftId,
    String? missionTypeId,
    String? dutyStatus,
    String? departmentId,
    String? rankId,
    String? personnelId,
  }) {
    return ReportFilter(
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      locationId: locationId ?? this.locationId,
      postId: postId ?? this.postId,
      shiftId: shiftId ?? this.shiftId,
      missionTypeId: missionTypeId ?? this.missionTypeId,
      dutyStatus: dutyStatus ?? this.dutyStatus,
      departmentId: departmentId ?? this.departmentId,
      rankId: rankId ?? this.rankId,
      personnelId: personnelId ?? this.personnelId,
    );
  }
}