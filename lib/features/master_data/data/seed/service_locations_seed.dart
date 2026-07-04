import '../models/service_location_model.dart';

class ServiceLocationsSeed {
  ServiceLocationsSeed._();

  static List<ServiceLocationModel> get data {
    final now = DateTime.now();

    return [
      ServiceLocationModel(
        id: '',
        name: 'البوابة الخارجية',
        displayOrder: 1,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      ServiceLocationModel(
        id: '',
        name: 'البوابة الداخلية',
        displayOrder: 2,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      ServiceLocationModel(
        id: '',
        name: 'البوابة الوسطى',
        displayOrder: 3,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      ServiceLocationModel(
        id: '',
        name: 'قسم الاستقبال',
        displayOrder: 4,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      ServiceLocationModel(
        id: '',
        name: 'السطح',
        displayOrder: 5,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      ServiceLocationModel(
        id: '',
        name: 'العمليات',
        displayOrder: 6,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      ServiceLocationModel(
        id: '',
        name: 'المكتب',
        displayOrder: 7,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      ServiceLocationModel(
        id: '',
        name: 'المركز الثقافي',
        displayOrder: 8,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      ServiceLocationModel(
        id: '',
        name: 'المركز الصحي',
        displayOrder: 9,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      ServiceLocationModel(
        id: '',
        name: 'المطبخ العام',
        displayOrder: 10,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      ServiceLocationModel(
        id: '',
        name: 'الفرن',
        displayOrder: 11,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      ServiceLocationModel(
        id: '',
        name: 'مطبخ العاملين',
        displayOrder: 12,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      ServiceLocationModel(
        id: '',
        name: 'سجن الأحداث',
        displayOrder: 13,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
