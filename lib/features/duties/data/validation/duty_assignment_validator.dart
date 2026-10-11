/// Pure validation of personnel assignments before a Firestore batch.
/// This is a UI-side integrity check, not a concurrency or security control.
class DutyAssignmentValidator {
  const DutyAssignmentValidator._();

  static void validate({
    required List<String> personnelIds,
    required int leaderCount,
  }) {
    if (personnelIds.isEmpty) {
      throw ArgumentError('يجب إسناد فرد واحد على الأقل');
    }
    if (personnelIds.any((id) => id.trim().isEmpty)) {
      throw ArgumentError('معرف الفرد مطلوب لكل إسناد');
    }
    if (personnelIds.toSet().length != personnelIds.length) {
      throw ArgumentError('لا يجوز تكرار الفرد في نفس المناوبة');
    }
    if (leaderCount > 1 || leaderCount < 0) {
      throw ArgumentError('لا يجوز إسناد أكثر من قائد للمناوبة');
    }
  }
}
