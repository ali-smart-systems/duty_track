class AppConstants {
  AppConstants._();

  // =========================
  // Application
  // =========================

  static const String taskTypesCollection = 'task_types';

  static const String appName = 'DUTY TRACK';

  static const String appVersion = '1.0.0';
  static const dutiesCollection = 'duties';

  static const dutyPersonnelCollection = 'duty_personnel';
  // =========================
  // Firestore Collections
  // =========================
  static const ranksCollection = 'ranks';
  static const String usersCollection = 'users';
  static const departmentsCollection = 'departments';
  static const String personnelCollection = 'personnel';

  static const String tasksCollection = 'tasks';

  static const String leavesCollection = 'leaves';

  static const String trainingCollection = 'training';

  static const String reportsCollection = 'reports';

  static const String activityLogsCollection = 'activity_logs';

  static const String settingsCollection = 'settings';

  // =========================
  // Date Formats
  // =========================

  static const String dateFormat = 'yyyy-MM-dd';

  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';

  // =========================
  // Cache
  // =========================
  static const String serviceLocationsCollection = 'service_locations';

  static const String servicePostsCollection = 'service_posts';
  static const String shiftsCollection = 'shifts';

  static const String dailyServicesCollection = 'daily_services';

  static const String missionTypesCollection = 'mission_types';

  static const String leaveTypesCollection = 'leave_types';

  static const String culturalProgramsCollection = 'cultural_programs';
  static const Duration splashDuration = Duration(seconds: 2);

  static const Duration requestTimeout = Duration(seconds: 30);
}
