import 'package:duty_track/features/reports/data/models/report_filter.dart';
import 'package:duty_track/features/reports/providers/reports_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ReportFilterScreen extends ConsumerStatefulWidget {
  const ReportFilterScreen({super.key});

  @override
  ConsumerState<ReportFilterScreen> createState() => _ReportFilterScreenState();
}

class _ReportFilterScreenState extends ConsumerState<ReportFilterScreen> {
  late ReportFilter _filter;

  @override
  void initState() {
    super.initState();
    _filter = ref.read(reportsControllerProvider).filter;
  }

  @override
  Widget build(BuildContext context) {
    final options = ref.watch(reportFilterOptionsProvider);

    return Directionality(
     textDirection: Directionality.of(context),
      child: Scaffold(
        appBar: AppBar(title: const Text('فلاتر التقرير')),
        body: options.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'تعذر تحميل خيارات الفلاتر',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ),
          data: (data) => Align(
            alignment: AlignmentDirectional.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                children: [
                  _DateRangeTile(
                    filter: _filter,
                    onTap: _pickDateRange,
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth >= 720;
                          final spacing = isWide ? 16.0 : 12.0;
                          final fieldWidth = isWide
                              ? (constraints.maxWidth - spacing) / 2
                              : constraints.maxWidth;

                          return Wrap(
                            spacing: spacing,
                            runSpacing: spacing,
                            children: [
                              _DropdownField(
                                width: fieldWidth,
                                label: 'الموقع',
                                icon: Icons.location_on_outlined,
                                value: _filter.locationId,
                                items: data.locations
                                    .map(
                                      (item) => _DropdownOption(
                                        value: item.id,
                                        label: item.name,
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  _setFilter(locationId: value, postId: '');
                                },
                              ),
                              _DropdownField(
                                width: fieldWidth,
                                label: 'نقطة الخدمة',
                                icon: Icons.place_outlined,
                                value: _filter.postId,
                                items: data.posts
                                    .where(
                                      (post) =>
                                          _filter.locationId == null ||
                                          post.locationId ==
                                              _filter.locationId,
                                    )
                                    .map(
                                      (item) => _DropdownOption(
                                        value: item.id,
                                        label: item.name,
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  _setFilter(postId: value);
                                },
                              ),
                              _DropdownField(
                                width: fieldWidth,
                                label: 'الوردية',
                                icon: Icons.schedule_outlined,
                                value: _filter.shiftId,
                                items: data.shifts
                                    .map(
                                      (item) => _DropdownOption(
                                        value: item.id,
                                        label: item.name,
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  _setFilter(shiftId: value);
                                },
                              ),
                              _DropdownField(
                                width: fieldWidth,
                                label: 'نوع المهمة',
                                icon: Icons.assignment_outlined,
                                value: _filter.missionTypeId,
                                items: data.missionTypes
                                    .map(
                                      (item) => _DropdownOption(
                                        value: item.id,
                                        label: item.name,
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  _setFilter(missionTypeId: value);
                                },
                              ),
                              _DropdownField(
                                width: fieldWidth,
                                label: 'حالة المناوبة',
                                icon: Icons.fact_check_outlined,
                                value: _filter.dutyStatus,
                                items: data.dutyStatuses
                                    .map(
                                      (item) => _DropdownOption(
                                        value: item,
                                        label: item,
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  _setFilter(dutyStatus: value);
                                },
                              ),
                              _DropdownField(
                                width: fieldWidth,
                                label: 'القسم',
                                icon: Icons.apartment_outlined,
                                value: _filter.departmentId,
                                items: data.departments
                                    .map(
                                      (item) => _DropdownOption(
                                        value: item.id,
                                        label: item.name,
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  _setFilter(departmentId: value);
                                },
                              ),
                              _DropdownField(
                                width: fieldWidth,
                                label: 'الرتبة',
                                icon: Icons.military_tech_outlined,
                                value: _filter.rankId,
                                items: data.ranks
                                    .map(
                                      (item) => _DropdownOption(
                                        value: item.id,
                                        label: item.name,
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  _setFilter(rankId: value);
                                },
                              ),
                              _DropdownField(
                                width: fieldWidth,
                                label: 'الفرد',
                                icon: Icons.person_outline,
                                value: _filter.personnelId,
                                items: data.personnel
                                    .map(
                                      (item) => _DropdownOption(
                                        value: item.id,
                                        label: item.fullName,
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  _setFilter(personnelId: value);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clearFilters,
                    icon: const Icon(Icons.filter_alt_off_outlined),
                    label: const Text('مسح الفلاتر'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _applyFilters,
                    icon: const Icon(Icons.check),
                    label: const Text('تطبيق'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: _filter.fromDate,
        end: _filter.toDate,
      ),
    );

    if (range == null) {
      return;
    }

    setState(() {
      _filter = _copyFilter(fromDate: range.start, toDate: range.end);
    });
  }

  void _setFilter({
    String? locationId,
    String? postId,
    String? shiftId,
    String? missionTypeId,
    String? dutyStatus,
    String? departmentId,
    String? rankId,
    String? personnelId,
  }) {
    setState(() {
      _filter = _copyFilter(
        locationId: locationId ?? _filter.locationId,
        postId: postId ?? _filter.postId,
        shiftId: shiftId ?? _filter.shiftId,
        missionTypeId: missionTypeId ?? _filter.missionTypeId,
        dutyStatus: dutyStatus ?? _filter.dutyStatus,
        departmentId: departmentId ?? _filter.departmentId,
        rankId: rankId ?? _filter.rankId,
        personnelId: personnelId ?? _filter.personnelId,
      );
    });
  }

  void _clearFilters() {
    setState(() {
      _filter = ReportFilter(
        fromDate: _filter.fromDate,
        toDate: _filter.toDate,
      );
    });
  }

  void _applyFilters() {
    ref.read(reportsControllerProvider.notifier).setFilter(_filter);
    Navigator.of(context).pop();
  }

  ReportFilter _copyFilter({
    DateTime? fromDate,
    DateTime? toDate,
    String? locationId,
    String? postId,
    String? shiftId,
    String? missionTypeId,
    String? dutyStatus,
    String? departmentId,
    String? rankId,
    String? personnelId,
  }) {
    return ReportFilter(
      fromDate: fromDate ?? _filter.fromDate,
      toDate: toDate ?? _filter.toDate,
      locationId: _clean(locationId),
      postId: _clean(postId),
      shiftId: _clean(shiftId),
      missionTypeId: _clean(missionTypeId),
      dutyStatus: _clean(dutyStatus),
      departmentId: _clean(departmentId),
      rankId: _clean(rankId),
      personnelId: _clean(personnelId),
    );
  }

  String? _clean(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    return value;
  }
}

class _DateRangeTile extends StatelessWidget {
  const _DateRangeTile({required this.filter, required this.onTap});

  final ReportFilter filter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy-MM-dd');

    return Card(
      child: ListTile(
        leading: const Icon(Icons.date_range),
        title: const Text('نطاق التاريخ'),
        subtitle: Text(
          '${formatter.format(filter.fromDate)} - ${formatter.format(filter.toDate)}',
        ),
        trailing: const Icon(Icons.chevron_left),
        onTap: onTap,
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.width,
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final double width;
  final String label;
  final IconData icon;
  final String? value;
  final List<_DropdownOption> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final values = items.map((item) => item.value).toSet();
    final effectiveValue = values.contains(value) ? value : null;

    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        initialValue: effectiveValue,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        items: [
          const DropdownMenuItem<String>(value: '', child: Text('الكل')),
          ...items.map(
            (item) => DropdownMenuItem<String>(
              value: item.value,
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

class _DropdownOption {
  const _DropdownOption({required this.value, required this.label});

  final String value;
  final String label;
}
