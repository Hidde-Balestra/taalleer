import 'package:flutter_test/flutter_test.dart';
import 'package:taalleer/achievements.dart';
import 'package:taalleer/models.dart';

QuizResult _result({
  double grade = 5,
  int total = 10,
  List<int> wrong = const [],
}) => QuizResult(
  id: 0,
  weekNumber: 1,
  year: 2026,
  date: 'x',
  grade: grade,
  correct: total - wrong.length,
  total: total,
  wrongWordIds: wrong,
);

Achievement _find(String id) => kAchievements.firstWhere((a) => a.id == id);

void main() {
  group('kAchievements', () {
    test(
      'elke prestatie heeft een niet-lege titel en beschrijving in beide talen',
      () {
        for (final a in kAchievements) {
          expect(a.titleNl, isNotEmpty, reason: a.id);
          expect(a.titleEn, isNotEmpty, reason: a.id);
          expect(a.descNl, isNotEmpty, reason: a.id);
          expect(a.descEn, isNotEmpty, reason: a.id);
        }
      },
    );

    test('ids zijn uniek', () {
      final ids = kAchievements.map((a) => a.id).toSet();
      expect(ids, hasLength(kAchievements.length));
    });
  });

  group('first_steps', () {
    test('leeg zonder historie, behaald met één resultaat', () {
      final a = _find('first_steps');
      expect(a.isUnlocked([], 0), isFalse);
      expect(a.isUnlocked([_result()], 0), isTrue);
    });
  });

  group('streaks', () {
    test('month_streak bij streak >= 4', () {
      final a = _find('month_streak');
      expect(a.isUnlocked([], 3), isFalse);
      expect(a.isUnlocked([], 4), isTrue);
    });

    test('half_year_streak bij streak >= 26', () {
      final a = _find('half_year_streak');
      expect(a.isUnlocked([], 25), isFalse);
      expect(a.isUnlocked([], 26), isTrue);
    });

    test('year_streak bij streak >= 52', () {
      final a = _find('year_streak');
      expect(a.isUnlocked([], 51), isFalse);
      expect(a.isUnlocked([], 52), isTrue);
    });
  });

  group('perfect_score', () {
    test('alleen behaald met een 10.0 in de historie', () {
      final a = _find('perfect_score');
      expect(a.isUnlocked([_result(grade: 9.5)], 0), isFalse);
      expect(a.isUnlocked([_result(grade: 10.0)], 0), isTrue);
    });
  });

  group('quiz-aantallen', () {
    test('ten_quizzes bij 10 of meer resultaten', () {
      final a = _find('ten_quizzes');
      expect(a.isUnlocked(List.generate(9, (_) => _result()), 0), isFalse);
      expect(a.isUnlocked(List.generate(10, (_) => _result()), 0), isTrue);
    });

    test('fifty_quizzes bij 50 of meer resultaten', () {
      final a = _find('fifty_quizzes');
      expect(a.isUnlocked(List.generate(49, (_) => _result()), 0), isFalse);
      expect(a.isUnlocked(List.generate(50, (_) => _result()), 0), isTrue);
    });
  });

  group('no_mistakes', () {
    test('alleen behaald bij een resultaat zonder foute woorden', () {
      final a = _find('no_mistakes');
      expect(
        a.isUnlocked([
          _result(wrong: [1]),
        ], 0),
        isFalse,
      );
      expect(a.isUnlocked([_result(wrong: const [])], 0), isTrue);
    });

    test('een resultaat met total 0 telt niet mee', () {
      final a = _find('no_mistakes');
      expect(a.isUnlocked([_result(total: 0, wrong: const [])], 0), isFalse);
    });
  });
}
