import 'package:flutter_test/flutter_test.dart';
import 'package:duty_track/features/duties/data/validation/duty_assignment_validator.dart';

void main() {
  group('DutyAssignmentValidator', () {
    test('accepts distinct assigned personnel and one leader', () {
      expect(
        () => DutyAssignmentValidator.validate(
          personnelIds: ['person-a', 'person-b'],
          leaderCount: 1,
        ),
        returnsNormally,
      );
    });

    test('rejects an empty duty', () {
      expect(
        () => DutyAssignmentValidator.validate(
          personnelIds: [],
          leaderCount: 0,
        ),
        throwsArgumentError,
      );
    });

    test('rejects duplicate personnel', () {
      expect(
        () => DutyAssignmentValidator.validate(
          personnelIds: ['person-a', 'person-a'],
          leaderCount: 1,
        ),
        throwsArgumentError,
      );
    });

    test('rejects missing personnel identifiers', () {
      expect(
        () => DutyAssignmentValidator.validate(
          personnelIds: ['  '],
          leaderCount: 0,
        ),
        throwsArgumentError,
      );
    });

    test('rejects multiple leaders', () {
      expect(
        () => DutyAssignmentValidator.validate(
          personnelIds: ['person-a', 'person-b'],
          leaderCount: 2,
        ),
        throwsArgumentError,
      );
    });
  });
}
