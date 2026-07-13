import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingReportRecord {
  const TrainingReportRecord({
    required this.id,
    required this.programId,
    required this.programName,
    required this.personnelId,
    required this.date,
    required this.fromDate,
    required this.toDate,
    required this.attendanceCount,
    required this.hours,
    required this.departmentId,
    required this.rankId,
    required this.data,
  });

  final String id;
  final String programId;
  final String programName;
  final String personnelId;
  final DateTime? date;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int attendanceCount;
  final int hours;
  final String departmentId;
  final String rankId;
  final Map<String, dynamic> data;

  factory TrainingReportRecord.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};

    return TrainingReportRecord(
      id: snapshot.id,
      programId: _stringValue(data, [
        'programId',
        'trainingProgramId',
        'courseId',
      ]),
      programName: _stringValue(data, [
        'programName',
        'trainingProgramName',
        'courseName',
        'name',
        'title',
      ]),
      personnelId: _stringValue(data, [
        'personnelId',
        'employeeId',
        'personId',
      ]),
      date: _dateValue(data, ['date', 'trainingDate']),
      fromDate: _dateValue(data, ['fromDate', 'startDate', 'date']),
      toDate: _dateValue(data, ['toDate', 'endDate', 'date']),
      attendanceCount: _attendanceCount(data),
      hours: _intValue(data, ['hours', 'trainingHours', 'durationHours']),
      departmentId: _stringValue(data, ['departmentId', 'department']),
      rankId: _stringValue(data, ['rankId', 'rank']),
      data: data,
    );
  }

  static int _attendanceCount(Map<String, dynamic> data) {
    final explicitCount = _intValue(data, [
      'attendanceCount',
      'attendeesCount',
      'participantsCount',
    ]);

    if (explicitCount > 0) {
      return explicitCount;
    }

    final attendees = data['attendees'] ?? data['participants'];
    if (attendees is List) {
      return attendees.length;
    }

    return data['personnelId'] is String ? 1 : 0;
  }

  static int _intValue(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is int) {
        return value;
      }
      if (value is num) {
        return value.toInt();
      }
    }

    return 0;
  }

  static String _stringValue(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is String) {
        return value;
      }
    }

    return '';
  }

  static DateTime? _dateValue(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is DateTime) {
        return value;
      }
    }

    return null;
  }
}
