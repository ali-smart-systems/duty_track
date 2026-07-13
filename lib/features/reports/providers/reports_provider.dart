import 'package:duty_track/features/master_data/data/models/department_model.dart';
import 'package:duty_track/features/master_data/data/models/mission_type_model.dart';
import 'package:duty_track/features/master_data/data/models/rank_model.dart';
import 'package:duty_track/features/master_data/data/models/service_location_model.dart';
import 'package:duty_track/features/master_data/data/models/service_post_model.dart';
import 'package:duty_track/features/master_data/data/models/shift_model.dart';
import 'package:duty_track/features/personnel/data/models/personnel_model.dart';
import 'package:duty_track/features/reports/data/export/reports_export_service.dart';
import 'package:duty_track/features/reports/data/models/report_filter.dart';
import 'package:duty_track/features/reports/data/models/report_result.dart';
import 'package:duty_track/features/reports/data/repositories/reports_repository.dart';
import 'package:duty_track/features/reports/data/services/reports_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ReportType {
  humanResources,
  duty,
  mission,
  leave,
  training,
  executive,
}

extension ReportTypeLabel on ReportType {
  String get title {
    return switch (this) {
      ReportType.humanResources => 'تقرير الموارد البشرية',
      ReportType.duty => 'تقرير المناوبات',
      ReportType.mission => 'تقرير المهام',
      ReportType.leave => 'تقرير الإجازات',
      ReportType.training => 'تقرير التدريب',
      ReportType.executive => 'التقرير التنفيذي',
    };
  }

  String get description {
    return switch (this) {
      ReportType.humanResources => 'ملخص القوة حسب الحالة والرتب والأقسام',
      ReportType.duty => 'تحليل المناوبات والتوزيع حسب المواقع والورديات',
      ReportType.mission => 'توزيع المهام وحالات التنفيذ',
      ReportType.leave => 'مؤشرات الإجازات وتأثيرها على الجاهزية',
      ReportType.training => 'برامج التدريب والحضور والساعات',
      ReportType.executive => 'ملخص شامل للإدارة العليا',
    };
  }
}

class ReportsState {
  const ReportsState({
    required this.reportType,
    required this.filter,
    required this.result,
  });

  final ReportType reportType;
  final ReportFilter filter;
  final AsyncValue<ReportResult?> result;

  ReportsState copyWith({
    ReportType? reportType,
    ReportFilter? filter,
    AsyncValue<ReportResult?>? result,
  }) {
    return ReportsState(
      reportType: reportType ?? this.reportType,
      filter: filter ?? this.filter,
      result: result ?? this.result,
    );
  }
}

class ReportFilterOptions {
  const ReportFilterOptions({
    required this.locations,
    required this.posts,
    required this.shifts,
    required this.missionTypes,
    required this.departments,
    required this.ranks,
    required this.personnel,
    required this.dutyStatuses,
  });

  final List<ServiceLocationModel> locations;
  final List<ServicePostModel> posts;
  final List<ShiftModel> shifts;
  final List<MissionTypeModel> missionTypes;
  final List<DepartmentModel> departments;
  final List<RankModel> ranks;
  final List<PersonnelModel> personnel;
  final List<String> dutyStatuses;
}

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return ReportsRepository();
});

final reportsServiceProvider = Provider<ReportsService>((ref) {
  return ReportsService(repository: ref.watch(reportsRepositoryProvider));
});

final reportsExportServiceProvider = Provider<ReportsExportService>((ref) {
  return const ReportsExportService();
});

final reportFilterOptionsProvider = FutureProvider<ReportFilterOptions>((
  ref,
) async {
  final repository = ref.watch(reportsRepositoryProvider);

  final locations = await repository.getServiceLocations();
  final posts = await repository.getServicePosts(locations);
  final duties = await repository.getDuties();

  final statuses = duties
      .map((duty) => duty.status.trim())
      .where((status) => status.isNotEmpty)
      .toSet()
      .toList()
    ..sort();

  return ReportFilterOptions(
    locations: locations,
    posts: posts,
    shifts: await repository.getShifts(),
    missionTypes: await repository.getMissionTypes(),
    departments: await repository.getDepartments(),
    ranks: await repository.getRanks(),
    personnel: await repository.getPersonnel(),
    dutyStatuses: statuses,
  );
});

final reportsControllerProvider =
    StateNotifierProvider<ReportsController, ReportsState>((ref) {
      return ReportsController(ref.watch(reportsServiceProvider));
    });

class ReportsController extends StateNotifier<ReportsState> {
  ReportsController(this._service)
    : super(
        ReportsState(
          reportType: ReportType.executive,
          filter: ReportFilter(
            fromDate: _today(),
            toDate: _today(),
          ),
          result: const AsyncData(null),
        ),
      );

  final ReportsService _service;

  void setReportType(ReportType reportType) {
    state = state.copyWith(reportType: reportType);
  }

  void setFilter(ReportFilter filter) {
    state = state.copyWith(filter: filter);
  }

  void setDateRange(DateTime fromDate, DateTime toDate) {
    state = state.copyWith(
      filter: state.filter.copyWith(fromDate: fromDate, toDate: toDate),
    );
  }

  void clearFilters() {
    state = state.copyWith(
      filter: ReportFilter(
        fromDate: state.filter.fromDate,
        toDate: state.filter.toDate,
      ),
    );
  }

  Future<void> generateReport() async {
    state = state.copyWith(result: const AsyncLoading());

    try {
      final result = await _service.generateReport(state.filter);
      state = state.copyWith(result: AsyncData(result));
    } catch (error, stackTrace) {
      state = state.copyWith(result: AsyncError(error, stackTrace));
    }
  }

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
