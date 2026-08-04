import 'package:flutter_test/flutter_test.dart';
import 'package:taalleer/i18n.dart';
import 'package:taalleer/models.dart';
import 'package:taalleer/share.dart';

const _result = QuizResult(
  id: 1,
  weekNumber: 5,
  year: 2026,
  date: '3 aug 2026',
  grade: 8.0,
  correct: 8,
  total: 10,
  wrongWordIds: [1, 2],
);

void main() {
  group('buildShareText', () {
    test('bevat cijfer en score (nl)', () {
      final text = buildShareText(Strings.nl, _result);
      expect(text, contains('8.0'));
      expect(text, contains('8/10'));
    });

    test('bevat cijfer en score (en)', () {
      final text = buildShareText(Strings.en, _result);
      expect(text, contains('8.0'));
      expect(text, contains('8/10'));
    });

    test('werkt voor een ander resultaat', () {
      const other = QuizResult(
        id: 2,
        weekNumber: 1,
        year: 2026,
        date: 'x',
        grade: 4.5,
        correct: 4,
        total: 10,
        wrongWordIds: [],
      );
      final text = buildShareText(Strings.nl, other);
      expect(text, contains('4.5'));
      expect(text, contains('4/10'));
    });
  });
}
