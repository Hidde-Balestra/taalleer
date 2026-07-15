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
    final weekWords = wordsForWeek(1);

    test('oefensessie heeft 10 unieke woorden', () {
      final qs = buildPractice(weekWords, Lang.nl, random: Random(1));
      expect(qs, hasLength(10));
      expect(qs.map((q) => q.word.id).toSet(), hasLength(10));
    });

    test('oefensessie gebruikt alleen woorden van de opgegeven week', () {
      final qs = buildPractice(weekWords, Lang.nl, random: Random(1));
      final weekIds = weekWords.map((w) => w.id).toSet();
      for (final q in qs) {
        expect(weekIds, contains(q.word.id));
      }
    });

    test('oefensessie met brontaal NL gebruikt alleen NL-vraagtypen', () {
      final qs = buildPractice(weekWords, Lang.nl, random: Random(2));
      for (final q in qs) {
        expect(q.type, isIn([QuestionType.nlEs, QuestionType.esNl]));
      }
    });

    test('oefensessie met brontaal EN gebruikt alleen EN-vraagtypen', () {
      final qs = buildPractice(weekWords, Lang.en, random: Random(3));
      for (final q in qs) {
        expect(q.type, isIn([QuestionType.enEs, QuestionType.esEn]));
      }
    });

    test('weektoets wisselt vraagrichting af', () {
      final qs = buildQuiz(weekWords, Lang.nl, random: Random(4));
      expect(qs, hasLength(10));
      for (var i = 0; i < qs.length; i++) {
        expect(qs[i].type, i.isEven ? QuestionType.nlEs : QuestionType.esNl);
      }
    });

    test('weektoets gebruikt alleen woorden van de opgegeven week', () {
      final qs = buildQuiz(weekWords, Lang.nl, random: Random(5));
      final weekIds = weekWords.map((w) => w.id).toSet();
      for (final q in qs) {
        expect(weekIds, contains(q.word.id));
      }
    });
  });

  group('buildConjugationQuiz', () {
    test('10 werkwoorden, elk met geldige persoon en antwoord', () {
      final qs = buildConjugationQuiz(kWordBook, random: Random(7));
      expect(qs, hasLength(10));
      for (final q in qs) {
        expect(q.word.isVerb, isTrue);
        expect(q.person, inInclusiveRange(0, 5));
        expect(q.answer, q.word.present[q.person]);
        // Wederkerende vormen (met spatie) worden uitgesloten.
        expect(q.answer.contains(' '), isFalse);
      }
    });

    test('kiest geen niet-werkwoorden', () {
      final qs = buildConjugationQuiz(kWordBook, random: Random(8));
      for (final q in qs) {
        expect(q.word.present, isNotEmpty);
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

  group('woordenboek', () {
    test('woordenboek bevat minimaal 900 woorden met unieke ids', () {
      expect(kWordBook.length, greaterThanOrEqualTo(900));
      expect(kWordBook.map((w) => w.id).toSet(), hasLength(kWordBook.length));
    });

    test('geen dubbele Spaanse lemma\'s in het woordenboek', () {
      expect(kWordBook.map((w) => w.es).toSet(), hasLength(kWordBook.length));
    });

    test('elk woord heeft vertalingen en een uitspraak', () {
      for (final w in kWordBook) {
        expect(w.es, isNotEmpty);
        expect(w.nl, isNotEmpty, reason: 'nl ontbreekt bij ${w.es}');
        expect(w.en, isNotEmpty, reason: 'en ontbreekt bij ${w.es}');
        expect(
          w.pronunciation,
          isNotEmpty,
          reason: 'uitspraak ontbreekt bij ${w.es}',
        );
      }
    });

    test('wordById vindt woorden uit het hele boek', () {
      expect(wordById(kWordBook.first.id)!.es, kWordBook.first.es);
      expect(wordById(kWordBook.last.id)!.es, kWordBook.last.es);
      expect(wordById(-1), isNull);
    });

    test('elk werkwoord heeft 6 vervoegingen', () {
      final verbs = kWordBook.where((w) => w.isVerb).toList();
      expect(verbs.length, greaterThan(200));
      for (final w in verbs) {
        expect(
          w.present,
          hasLength(6),
          reason: 'onvolledige vervoeging bij ${w.es}',
        );
        expect(
          w.article,
          isEmpty,
          reason: '${w.es} is werkwoord, geen lidwoord',
        );
      }
    });

    test('woorden zijn nooit tegelijk werkwoord én zelfstandig naamwoord', () {
      for (final w in kWordBook) {
        expect(w.isVerb && w.isNoun, isFalse, reason: w.es);
      }
    });

    test('zelfstandige naamwoorden krijgen el of la', () {
      for (final w in kWordBook) {
        if (w.isNoun) {
          expect(['el', 'la'], contains(w.article), reason: w.es);
        }
      }
    });
  });

  group('willekeurige weekselectie', () {
    test('elke week geeft precies 20 unieke woorden', () {
      for (final seed in [0, 1, 7, 26, 52, 999, 10000]) {
        final words = wordsForWeek(seed);
        expect(words, hasLength(kWordsPerWeek));
        expect(
          words.map((w) => w.id).toSet(),
          hasLength(kWordsPerWeek),
          reason: 'dubbele woorden bij seed $seed',
        );
      }
    });

    test('alle gekozen woorden komen uit het woordenboek', () {
      final ids = kWordBook.map((w) => w.id).toSet();
      for (final w in wordsForWeek(42)) {
        expect(ids, contains(w.id));
      }
    });

    test('deterministisch: dezelfde seed geeft dezelfde 20 woorden', () {
      expect(
        wordsForWeek(29).map((w) => w.id).toList(),
        wordsForWeek(29).map((w) => w.id).toList(),
      );
    });

    test('de selectie is echt willekeurig, niet de eerste 20 uit het boek', () {
      final firstTwenty = kWordBook
          .take(kWordsPerWeek)
          .map((w) => w.id)
          .toSet();
      final picked = wordsForWeek(3).map((w) => w.id).toSet();
      expect(picked, isNot(equals(firstTwenty)));
    });

    test('verschillende weken geven verschillende trekkingen', () {
      final a = wordsForWeek(1).map((w) => w.id).toList();
      final b = wordsForWeek(2).map((w) => w.id).toList();
      final c = wordsForWeek(3).map((w) => w.id).toList();
      expect(a, isNot(equals(b)));
      expect(b, isNot(equals(c)));
    });

    test('over veel weken komt een groot deel van het boek aan bod', () {
      final seen = <int>{};
      for (var seed = 0; seed < 200; seed++) {
        seen.addAll(wordsForWeek(seed).map((w) => w.id));
      }
      // 200 × 20 trekkingen met teruglegging dekken ruimschoots de helft.
      expect(seen.length, greaterThan(kWordBook.length ~/ 2));
    });

    test('weekStartDate geeft de maandag van die week', () {
      final start = weekStartDate(currentWeekSeed(DateTime(2026, 7, 15)));
      expect(start.weekday, DateTime.monday);
      // 15 juli 2026 is een woensdag → die week begon maandag 13 juli.
      expect(start, DateTime(2026, 7, 13));
    });

    test('nextWordReset is de eerstvolgende maandag', () {
      final reset = nextWordReset(DateTime(2026, 7, 15)); // woensdag
      expect(reset.weekday, DateTime.monday);
      expect(reset, DateTime(2026, 7, 20));
    });

    test('daysUntilWordReset telt de dagen tot die maandag (1..7)', () {
      expect(daysUntilWordReset(DateTime(2026, 7, 15)), 5); // wo → ma
      expect(daysUntilWordReset(DateTime(2026, 7, 19)), 1); // zo → ma
      expect(daysUntilWordReset(DateTime(2026, 7, 13)), 7); // ma → ma
    });

    test('bij de reset horen nieuwe woorden', () {
      final thisWeek = wordsForWeek(
        currentWeekSeed(DateTime(2026, 7, 15)),
      ).map((w) => w.id).toList();
      final nextWeek = wordsForWeek(
        currentWeekSeed(DateTime(2026, 7, 20)),
      ).map((w) => w.id).toList();
      expect(thisWeek, isNot(equals(nextWeek)));
    });

    test('currentWeekSeed loopt per week op en herhaalt niet per jaar', () {
      final w1 = currentWeekSeed(DateTime(2026, 7, 15));
      final w2 = currentWeekSeed(DateTime(2026, 7, 22)); // 7 dagen later
      final sameWeek = currentWeekSeed(DateTime(2026, 7, 16)); // zelfde week
      final nextYear = currentWeekSeed(DateTime(2027, 7, 15));
      expect(w2, w1 + 1);
      expect(sameWeek, w1);
      expect(nextYear, isNot(w1));
    });
  });
}
