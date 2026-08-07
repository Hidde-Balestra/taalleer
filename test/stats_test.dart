import 'package:flutter_test/flutter_test.dart';
import 'package:taalleer/languages/es/es_course.dart';
import 'package:taalleer/models.dart';
import 'package:taalleer/stats.dart';

final _course = SpanishCourse();

QuizResult _result({
  required double grade,
  required int correct,
  required int total,
  List<int> wrong = const [],
  String category = '',
}) => QuizResult(
  id: 0,
  weekNumber: 1,
  year: 2026,
  date: 'x',
  grade: grade,
  correct: correct,
  total: total,
  wrongWordIds: wrong,
  category: category,
);

void main() {
  group('computeStats', () {
    test('lege historie geeft veilige nulwaarden', () {
      final stats = computeStats([], _course);
      expect(stats.totalQuizzes, 0);
      expect(stats.totalCorrect, 0);
      expect(stats.totalAnswered, 0);
      expect(stats.averageGrade, 0);
      expect(stats.bestGrade, 0);
      expect(stats.weakWords, isEmpty);
    });

    test('telt toetsen, correcte/totale antwoorden', () {
      final history = [
        _result(grade: 8, correct: 8, total: 10),
        _result(grade: 6, correct: 6, total: 10),
      ];
      final stats = computeStats(history, _course);
      expect(stats.totalQuizzes, 2);
      expect(stats.totalCorrect, 14);
      expect(stats.totalAnswered, 20);
    });

    test('gemiddeld en beste cijfer kloppen', () {
      final history = [
        _result(grade: 6, correct: 6, total: 10),
        _result(grade: 10, correct: 10, total: 10),
        _result(grade: 8, correct: 8, total: 10),
      ];
      final stats = computeStats(history, _course);
      expect(stats.averageGrade, 8.0);
      expect(stats.bestGrade, 10.0);
    });

    test('weakWords-integratie: gebruikt wrongWordIds van de historie', () {
      final id1 = _course.words[0].id;
      final history = [
        _result(grade: 5, correct: 5, total: 10, wrong: [id1]),
        _result(grade: 5, correct: 5, total: 10, wrong: [id1]),
      ];
      final stats = computeStats(history, _course);
      expect(stats.weakWords, isNotEmpty);
      expect(stats.weakWords.first.id, id1);
    });

    test('categoryGrades is leeg zonder categorietoetsen', () {
      final history = [_result(grade: 8, correct: 8, total: 10)];
      expect(computeStats(history, _course).categoryGrades, isEmpty);
    });

    test('categoryGrades groepeert en middelt per categorie', () {
      final history = [
        _result(grade: 6, correct: 6, total: 10, category: 'food'),
        _result(grade: 8, correct: 8, total: 10, category: 'food'),
        _result(grade: 10, correct: 10, total: 10, category: 'family'),
        _result(grade: 5, correct: 5, total: 10), // algemeen, telt niet mee
      ];
      final grades = computeStats(history, _course).categoryGrades;
      expect(grades, hasLength(2));

      final food = grades.firstWhere((g) => g.categoryId == 'food');
      expect(food.averageGrade, 7.0);
      expect(food.count, 2);

      final family = grades.firstWhere((g) => g.categoryId == 'family');
      expect(family.averageGrade, 10.0);
      expect(family.count, 1);
    });

    test('categoryGrades sorteert op aantal toetsen aflopend', () {
      final history = [
        _result(grade: 8, correct: 8, total: 10, category: 'family'),
        _result(grade: 8, correct: 8, total: 10, category: 'food'),
        _result(grade: 8, correct: 8, total: 10, category: 'food'),
      ];
      final grades = computeStats(history, _course).categoryGrades;
      expect(grades.first.categoryId, 'food'); // 2 toetsen
      expect(grades.last.categoryId, 'family'); // 1 toets
    });
  });
}
