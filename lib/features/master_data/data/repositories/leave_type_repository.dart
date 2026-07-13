import '../models/leave_type_model.dart';
import '../services/leave_type_service.dart';

class LeaveTypeRepository {
  LeaveTypeRepository({LeaveTypeService? service})
    : _service = service ?? LeaveTypeService();

  final LeaveTypeService _service;

  Stream<List<LeaveTypeModel>> getLeaveTypes() {
    return _service.getLeaveTypes();
  }

  Future<void> addLeaveType(LeaveTypeModel leaveType) {
    return _service.addLeaveType(leaveType);
  }

  Future<void> updateLeaveType(LeaveTypeModel leaveType) {
    return _service.updateLeaveType(leaveType);
  }

  Future<void> deleteLeaveType(String id) {
    return _service.deleteLeaveType(id);
  }
}
