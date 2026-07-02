class AppConstants {
  AppConstants._();

  // =========================
  // Application
  // =========================

  static const String appName = 'DUTY TRACK';

  static const String appVersion = '1.0.0';

  // =========================
  // Firestore Collections
  // =========================

  static const String usersCollection = 'users';

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

  static const Duration splashDuration = Duration(seconds: 2);

  static const Duration requestTimeout = Duration(seconds: 30);
}
