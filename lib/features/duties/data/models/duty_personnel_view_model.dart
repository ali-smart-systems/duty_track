class DutyPersonnelViewModel {
  const DutyPersonnelViewModel({
    required this.personnelId,
    required this.fullName,
    required this.rank,
    required this.role,
    required this.isLeader,
  });

  final String personnelId;

  final String fullName;

  final String rank;

  final String role;

  final bool isLeader;

  DutyPersonnelViewModel copyWith({
    String? personnelId,
    String? fullName,
    String? rank,
    String? role,
    bool? isLeader,
  }) {
    return DutyPersonnelViewModel(
      personnelId: personnelId ?? this.personnelId,
      fullName: fullName ?? this.fullName,
      rank: rank ?? this.rank,
      role: role ?? this.role,
      isLeader: isLeader ?? this.isLeader,
    );
  }
}
