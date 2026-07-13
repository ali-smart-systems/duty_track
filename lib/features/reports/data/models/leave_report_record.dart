import 'package:cloud_firestore/cloud_firestore.dart';

class LeaveReportRecord {
  const LeaveReportRecord({
    required this.id,
    required this.personnelId,
    required this.leaveTypeId,
    required this.status,
    required this.fromDate,
    required this.toDate,
    required this.data,
  });

  final String id;
  final String personnelId;
  final String leaveTypeId;
  final String status;
  final DateTime? fromDate;
  final DateTime? toDate;
  final Map<String, dynamic> data;

  factory LeaveReportRecord.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};

    return LeaveReportRecord(
      id: snapshot.id,
      personnelId: _stringValue(data, [
        'personnelId',
        'employeeId',
        'personId',
      ]),
      leaveTypeId: _stringValue(data, [
        'leaveTypeId',
        'typeId',
        'leaveType',
      ]),
      status: _stringValue(data, ['status', 'dutyStatus']),
      fromDate: _dateValue(data, [
        'fromDate',
        'startDate',
        'leaveStartDate',
        'date',
      ]),
      toDate: _dateValue(data, [
        'toDate',
        'endDate',
        'leaveEndDate',
        'date',
      ]),
      data: data,
    );
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
