import '../../../../../core/enums/gender.dart';
import 'service_post_seed_model.dart';

class ServicePostsSeed {
  ServicePostsSeed._();

  static const List<ServiceLocationSeedModel> data = [
    ServiceLocationSeedModel(
      locationCode: 'gate_outer',
      locationName: 'البوابة الخارجية',
      posts: [
        ServicePostSeedModel(
          name: 'مستلم البوابة الرئيسية',
          requiredPersonnelCount: 1,
          gender: Gender.male,
        ),

        ServicePostSeedModel(
          name: 'مساعد البوابة',
          requiredPersonnelCount: 1,
          gender: Gender.male,
        ),

        ServicePostSeedModel(
          name: 'مفتش الأكل',
          requiredPersonnelCount: 1,
          gender: Gender.male,
        ),

        ServicePostSeedModel(
          name: 'مفتش',
          requiredPersonnelCount: 6,
          gender: Gender.male,
        ),

        ServicePostSeedModel(
          name: 'كاتب سجل الرجال',
          requiredPersonnelCount: 1,
          gender: Gender.male,
        ),

        ServicePostSeedModel(
          name: 'مستلم ختم الزيارة',
          requiredPersonnelCount: 1,
          gender: Gender.male,
        ),

        ServicePostSeedModel(
          name: 'كاتبة سجل النساء',
          requiredPersonnelCount: 1,
          gender: Gender.female,
        ),

        ServicePostSeedModel(
          name: 'مفتشة',
          requiredPersonnelCount: 5,
          gender: Gender.female,
        ),
      ],
    ),

    ServiceLocationSeedModel(
      locationCode: 'gate_inner',
      locationName: 'البوابة الداخلية',
      posts: [
        ServicePostSeedModel(
          name: 'مستلم البوابة',
          requiredPersonnelCount: 1,
          gender: Gender.male,
        ),
        ServicePostSeedModel(
          name: 'مساعد البوابة',
          requiredPersonnelCount: 1,
          gender: Gender.male,
        ),
        ServicePostSeedModel(
          name: 'مستلم ختم الزيارة',
          requiredPersonnelCount: 1,
          gender: Gender.male,
        ),
        ServicePostSeedModel(
          name: 'مستلم غرفة الشرعية',
          requiredPersonnelCount: 1,
          gender: Gender.male,
        ),
      ],
    ),
    ServiceLocationSeedModel(
      locationCode: 'office',
      locationName: 'المكتب',
      posts: [
        ServicePostSeedModel(
          name: 'مستلم المكتب',
          requiredPersonnelCount: 1,
          gender: Gender.male,
        ),
      ],
    ),

    ServiceLocationSeedModel(
      locationCode: 'cultural_center',
      locationName: 'المركز الثقافي',
      posts: [
        ServicePostSeedModel(
          name: 'مسؤول المركز',
          requiredPersonnelCount: 1,
          gender: Gender.male,
        ),
        ServicePostSeedModel(
          name: 'الحارس',
          requiredPersonnelCount: 1,
          gender: Gender.male,
        ),
      ],
    ),

    ServiceLocationSeedModel(
      locationCode: 'medical_center',
      locationName: 'المركز الصحي',
      posts: [
        ServicePostSeedModel(
          name: 'طبيب',
          requiredPersonnelCount: 7,
          gender: Gender.both,
        ),
      ],
    ),

    ServiceLocationSeedModel(
      locationCode: 'main_kitchen',
      locationName: 'المطبخ العام',
      posts: [
        ServicePostSeedModel(
          name: 'مسؤول المطبخ',
          requiredPersonnelCount: 1,
          gender: Gender.male,
        ),
        ServicePostSeedModel(
          name: 'عامل',
          requiredPersonnelCount: 4,
          gender: Gender.male,
        ),
      ],
    ),

    ServiceLocationSeedModel(
      locationCode: 'staff_kitchen',
      locationName: 'مطبخ العاملين',
      posts: [
        ServicePostSeedModel(
          name: 'مسؤول المطبخ',
          requiredPersonnelCount: 1,
          gender: Gender.male,
        ),
      ],
    ),

    ServiceLocationSeedModel(
      locationCode: 'bakery',
      locationName: 'الفرن',
      posts: [
        ServicePostSeedModel(
          name: 'مستلم الفرن',
          requiredPersonnelCount: 1,
          gender: Gender.male,
        ),
        ServicePostSeedModel(
          name: 'عامل',
          requiredPersonnelCount: 5,
          gender: Gender.male,
        ),
      ],
    ),

    ServiceLocationSeedModel(
      locationCode: 'juvenile_prison',
      locationName: 'سجن الأحداث',
      posts: [
        ServicePostSeedModel(
          name: 'المساعد',
          requiredPersonnelCount: 1,
          gender: Gender.male,
        ),
        ServicePostSeedModel(
          name: 'الحارس',
          requiredPersonnelCount: 1,
          gender: Gender.male,
        ),
      ],
    ),
    ServiceLocationSeedModel(
      locationCode: 'gate_middle',
      locationName: 'البوابة الوسطى',
      posts: [
        ServicePostSeedModel(
          name: 'فرد',
          requiredPersonnelCount: 4,
          gender: Gender.male,
        ),
      ],
    ),

    ServiceLocationSeedModel(
      locationCode: 'reception',
      locationName: 'قسم الاستقبال',
      posts: [
        ServicePostSeedModel(
          name: 'مستلم الشبك',
          requiredPersonnelCount: 1,
          gender: Gender.male,
        ),
        ServicePostSeedModel(
          name: 'مستلم ختم الزيارة',
          requiredPersonnelCount: 1,
          gender: Gender.male,
        ),
        ServicePostSeedModel(
          name: 'مستلم التفتيش',
          requiredPersonnelCount: 2,
          gender: Gender.male,
        ),
      ],
    ),

    ServiceLocationSeedModel(
      locationCode: 'roof',
      locationName: 'السطح',
      posts: [
        ServicePostSeedModel(
          name: 'حارس السطح',
          requiredPersonnelCount: 1,
          gender: Gender.male,
        ),
      ],
    ),

    ServiceLocationSeedModel(
      locationCode: 'operations',
      locationName: 'العمليات',
      posts: [
        ServicePostSeedModel(
          name: 'العمليات',
          requiredPersonnelCount: 3,
          gender: Gender.male,
        ),
      ],
    ),
  ];
}
