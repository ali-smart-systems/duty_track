class ReportSummary {
  const ReportSummary({
    required this.totalPersonnel,
    required this.presentPersonnel,
    required this.activePersonnel,
    required this.absentPersonnel,
    required this.leavePersonnel,
    required this.availablePersonnel,
    required this.totalDuties,
    required this.totalMissions,
    required this.totalLocations,
    required this.totalPosts,
    required this.morningShift,
    required this.eveningShift,
    required this.nightShift,
    required this.reserveShift,
    required this.missionCounts,
    required this.shiftCounts,
    required this.locationCounts,
    required this.postCounts,
    required this.departmentCounts,
    required this.rankCounts,
    required this.statusCounts,
    required this.leaveCounts,
    required this.trainingPrograms,
    required this.trainingAttendance,
    required this.trainingHours,
    required this.readinessPercentage,
  });

  final int totalPersonnel;
  final int presentPersonnel;
  final int activePersonnel;
  final int absentPersonnel;
  final int leavePersonnel;
  final int availablePersonnel;
  final int totalDuties;
  final int totalMissions;
  final int totalLocations;
  final int totalPosts;
  final int morningShift;
  final int eveningShift;
  final int nightShift;
  final int reserveShift;
  final Map<String, int> missionCounts;
  final Map<String, int> shiftCounts;
  final Map<String, int> locationCounts;
  final Map<String, int> postCounts;
  final Map<String, int> departmentCounts;
  final Map<String, int> rankCounts;
  final Map<String, int> statusCounts;
  final Map<String, int> leaveCounts;
  final int trainingPrograms;
  final int trainingAttendance;
  final int trainingHours;
  final double readinessPercentage;

  ReportSummary copyWith({
    int? totalPersonnel,
    int? presentPersonnel,
    int? activePersonnel,
    int? absentPersonnel,
    int? leavePersonnel,
    int? availablePersonnel,
    int? totalDuties,
    int? totalMissions,
    int? totalLocations,
    int? totalPosts,
    int? morningShift,
    int? eveningShift,
    int? nightShift,
    int? reserveShift,
    Map<String, int>? missionCounts,
    Map<String, int>? shiftCounts,
    Map<String, int>? locationCounts,
    Map<String, int>? postCounts,
    Map<String, int>? departmentCounts,
    Map<String, int>? rankCounts,
    Map<String, int>? statusCounts,
    Map<String, int>? leaveCounts,
    int? trainingPrograms,
    int? trainingAttendance,
    int? trainingHours,
    double? readinessPercentage,
  }) {
    return ReportSummary(
      totalPersonnel: totalPersonnel ?? this.totalPersonnel,
      presentPersonnel: presentPersonnel ?? this.presentPersonnel,
      activePersonnel: activePersonnel ?? this.activePersonnel,
      absentPersonnel: absentPersonnel ?? this.absentPersonnel,
      leavePersonnel: leavePersonnel ?? this.leavePersonnel,
      availablePersonnel: availablePersonnel ?? this.availablePersonnel,
      totalDuties: totalDuties ?? this.totalDuties,
      totalMissions: totalMissions ?? this.totalMissions,
      totalLocations: totalLocations ?? this.totalLocations,
      totalPosts: totalPosts ?? this.totalPosts,
      morningShift: morningShift ?? this.morningShift,
      eveningShift: eveningShift ?? this.eveningShift,
      nightShift: nightShift ?? this.nightShift,
      reserveShift: reserveShift ?? this.reserveShift,
      missionCounts: missionCounts ?? this.missionCounts,
      shiftCounts: shiftCounts ?? this.shiftCounts,
      locationCounts: locationCounts ?? this.locationCounts,
      postCounts: postCounts ?? this.postCounts,
      departmentCounts: departmentCounts ?? this.departmentCounts,
      rankCounts: rankCounts ?? this.rankCounts,
      statusCounts: statusCounts ?? this.statusCounts,
      leaveCounts: leaveCounts ?? this.leaveCounts,
      trainingPrograms: trainingPrograms ?? this.trainingPrograms,
      trainingAttendance: trainingAttendance ?? this.trainingAttendance,
      trainingHours: trainingHours ?? this.trainingHours,
      readinessPercentage:
          readinessPercentage ?? this.readinessPercentage,
    );
  }
}
