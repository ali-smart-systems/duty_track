enum Gender { male, female, both }

extension GenderExtension on Gender {
  String get label {
    switch (this) {
      case Gender.male:
        return 'ذكر';

      case Gender.female:
        return 'أنثى';

      case Gender.both:
        return 'الاثنان';
    }
  }

  static Gender fromString(String value) {
    switch (value) {
      case 'ذكر':
        return Gender.male;

      case 'أنثى':
        return Gender.female;

      default:
        return Gender.both;
    }
  }
}
