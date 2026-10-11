import '../models/report_summary.dart';

/// Checks report totals before issuing an official management report.
///
/// These checks do not assert that overlapping categories add up to the
/// workforce: a person may appear in more than one operational category.
class ReportSummaryValidator {
  const ReportSummaryValidator._();

  static List<String> validate(ReportSummary summary) {
    final errors = <String>[];
    final counts = <String, int>{
      'إجمالي القوة': summary.totalPersonnel,
      'الحاضرون': summary.presentPersonnel,
      'على رأس العمل': summary.activePersonnel,
      'الغائبون': summary.absentPersonnel,
      'المجازون': summary.leavePersonnel,
      'المتاحون': summary.availablePersonnel,
      'المناوبات': summary.totalDuties,
      'المهام': summary.totalMissions,
      'المواقع': summary.totalLocations,
      'نقاط الخدمة': summary.totalPosts,
      'الوردية الصباحية': summary.morningShift,
      'الوردية المسائية': summary.eveningShift,
      'الوردية الليلية': summary.nightShift,
      'الاحتياط': summary.reserveShift,
      'البرامج التدريبية': summary.trainingPrograms,
      'حضور التدريب': summary.trainingAttendance,
      'ساعات التدريب': summary.trainingHours,
    };
    for (final entry in counts.entries) {
      if (entry.value < 0) errors.add('${entry.key}: قيمة سالبة غير مقبولة');
    }
    for (final entry in {
      'الحاضرون': summary.presentPersonnel,
      'على رأس العمل': summary.activePersonnel,
      'الغائبون': summary.absentPersonnel,
      'المجازون': summary.leavePersonnel,
      'المتاحون': summary.availablePersonnel,
    }.entries) {
      if (entry.value > summary.totalPersonnel) {
        errors.add('${entry.key}: يتجاوز إجمالي القوة');
      }
    }
    if (!summary.readinessPercentage.isFinite ||
        summary.readinessPercentage < 0 ||
        summary.readinessPercentage > 100) {
      errors.add('نسبة الجاهزية يجب أن تكون بين 0 و100');
    }
    final distributions = <String, Map<String, int>>{
      'المهام': summary.missionCounts,
      'الورديات': summary.shiftCounts,
      'المواقع': summary.locationCounts,
      'النقاط': summary.postCounts,
      'الأقسام': summary.departmentCounts,
      'الرتب': summary.rankCounts,
      'الحالات': summary.statusCounts,
      'الإجازات': summary.leaveCounts,
    };
    for (final distribution in distributions.entries) {
      for (final entry in distribution.value.entries) {
        if (entry.value < 0) {
          errors.add('${distribution.key} / ${entry.key}: قيمة سالبة');
        }
      }
    }
    return errors;
  }
}
