import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:taalleer/data.dart';
import 'package:taalleer/models.dart';
import 'package:taalleer/utils.dart';

void main() {
  group('levenshtein', () {
    test('identieke strings hebben afstand 0', () {
      expect(levenshtein('hablar', 'hablar'), 0);
    });

    test('één vervanging is afstand 1', () {
      expect(levenshtein('hablar', 'hablor'), 1);
    });

    test('invoegen en verwijderen tellen mee', () {
      expect(levenshtein('kat', 'kaart'), 2);
      expect(levenshtein('', 'abc'), 3);
      expect(levenshtein('abc', ''), 3);
    });
  });

  group('isAcceptable', () {
    test('exacte match is altijd goed', () {
      expect(isAcceptable('biblioteca', 'biblioteca', dyslexia: false), isTrue);
    });

    test('negeert hoofdletters en spaties', () {
      expect(
        isAcceptable('  Biblioteca ', 'biblioteca', dyslexia: false),
        isTrue,
      );
    });

    test('typefout zonder dyslexie-modus is fout', () {
      expect(
        isAcceptable('biblioteka', 'biblioteca', dyslexia: false),
        isFalse,
      );
    });

    test('kleine typefout met dyslexie-modus is goed', () {
      // "biblioteca" heeft 10 tekens → 2 fouten toegestaan.
      expect(isAcceptable('bibliotecca', 'biblioteca', dyslexia: true), isTrue);
      expect(isAcceptable('bibloteca', 'biblioteca', dyslexia: true), isTrue);
    });

    test('te veel fouten met dyslexie-modus blijft fout', () {
      expect(isAcceptable('bblotea', 'biblioteca', dyslexia: true), isFalse);
    });

    test('kort woord staat maximaal 1 fout toe in dyslexie-modus', () {
      expect(isAcceptable('etn', 'eten', dyslexia: true), isTrue);
      expect(isAcceptable('en', 'eten', dyslexia: true), isFalse);
    });
  });

  group('calcGrade', () {
    test('alles goed is een 10', () {
      expect(calcGrade(10, 10), 10.0);
    });

    test('alles fout is een 0', () {
      expect(calcGrade(0, 10), 0.0);
    });

    test('8 van 10 goed is een 8.0', () {
      expect(calcGrade(8, 10), 8.0);
    });

    test('rondt af op één decimaal', () {
      expect(calcGrade(2, 3), 6.7);
    });
  });

  group('gradeColor', () {
    test('groen vanaf 8, oranje vanaf 6, anders rood', () {
      expect(gradeColor(8.0).toARGB32(), 0xFF10B981);
      expect(gradeColor(10.0).toARGB32(), 0xFF10B981);
      expect(gradeColor(6.0).toARGB32(), 0xFFF59E0B);
      expect(gradeColor(7.9).toARGB32(), 0xFFF59E0B);
      expect(gradeColor(5.9).toARGB32(), 0xFFEF4444);
      expect(gradeColor(0.0).toARGB32(), 0xFFEF4444);
    });
  });

  group('weekNumberOf', () {
    test('1 januari valt in week 1', () {
      expect(weekNumberOf(DateTime(2026, 1, 1)), 1);
    });

    test('weeknummer stijgt door het jaar heen', () {
      final early = weekNumberOf(DateTime(2026, 2, 1));
      final late = weekNumberOf(DateTime(2026, 11, 1));
      expect(late, greaterThan(early));
      expect(late, lessThanOrEqualTo(53));
    });
  });

  group('isWeekend', () {
    test('zaterdag en zondag zijn weekend', () {
      expect(isWeekend(DateTime(2026, 7, 11)), isTrue); // zaterdag
      expect(isWeekend(DateTime(2026, 7, 12)), isTrue); // zondag
      expect(isWeekend(DateTime(2026, 7, 13)), isFalse); // maandag
    });
  });

  group('buildPractice / buildQuiz', () {
    test('oefensessie heeft 10 unieke woorden', () {
      final qs = buildPractice(Lang.nl, random: Random(1));
      expect(qs, hasLength(10));
      expect(qs.map((q) => q.word.id).toSet(), hasLength(10));
    });

    test('oefensessie met brontaal NL gebruikt alleen NL-vraagtypen', () {
      final qs = buildPractice(Lang.nl, random: Random(2));
      for (final q in qs) {
        expect(q.type, isIn([QuestionType.nlEs, QuestionType.esNl]));
      }
    });

    test('oefensessie met brontaal EN gebruikt alleen EN-vraagtypen', () {
      final qs = buildPractice(Lang.en, random: Random(3));
      for (final q in qs) {
        expect(q.type, isIn([QuestionType.enEs, QuestionType.esEn]));
      }
    });

    test('weektoets wisselt vraagrichting af', () {
      final qs = buildQuiz(Lang.nl, random: Random(4));
      expect(qs, hasLength(10));
      for (var i = 0; i < qs.length; i++) {
        expect(qs[i].type, i.isEven ? QuestionType.nlEs : QuestionType.esNl);
      }
    });
  });

  group('correctAnswerOf / shownWordOf', () {
    const word = Word(
      id: 1,
      es: 'hablar',
      nl: 'spreken',
      en: 'to speak',
      pronunciation: 'ah-BLAR',
      exampleEs: '',
      exampleNl: '',
    );

    test('NL→ES toont NL en verwacht ES', () {
      const q = Question(word: word, type: QuestionType.nlEs);
      expect(shownWordOf(q), 'spreken');
      expect(correctAnswerOf(q), 'hablar');
    });

    test('ES→NL toont ES en verwacht NL', () {
      const q = Question(word: word, type: QuestionType.esNl);
      expect(shownWordOf(q), 'hablar');
      expect(correctAnswerOf(q), 'spreken');
    });

    test('EN→ES toont EN en verwacht ES', () {
      const q = Question(word: word, type: QuestionType.enEs);
      expect(shownWordOf(q), 'to speak');
      expect(correctAnswerOf(q), 'hablar');
    });

    test('ES→EN toont ES en verwacht EN', () {
      const q = Question(word: word, type: QuestionType.esEn);
      expect(shownWordOf(q), 'hablar');
      expect(correctAnswerOf(q), 'to speak');
    });
  });

  test('woordenlijst bevat 20 woorden met unieke ids', () {
    expect(kWords, hasLength(20));
    expect(kWords.map((w) => w.id).toSet(), hasLength(20));
  });
}
