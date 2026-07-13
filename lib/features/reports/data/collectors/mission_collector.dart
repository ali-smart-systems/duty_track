import 'package:duty_track/features/master_data/data/models/mission_type_model.dart';
import 'package:duty_track/features/reports/data/collectors/report_filter_matcher.dart';
import 'package:duty_track/features/reports/data/models/report_filter.dart';
import 'package:duty_track/features/reports/data/repositories/reports_repository.dart';

class MissionCollector {
  MissionCollector({ReportsRepository? repository})
    : _repository = repository ?? ReportsRepository();

  final ReportsRepository _repository;

  Future<List<MissionTypeModel>> collect(ReportFilter filter) async {
    final missionTypes = await _repository.getMissionTypes();

    return missionTypes.where((missionType) {
      return ReportFilterMatcher.matchesNullable(
        filter.missionTypeId,
        missionType.id,
      );
    }).toList();
  }
}
