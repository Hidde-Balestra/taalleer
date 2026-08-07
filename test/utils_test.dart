import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:taalleer/data.dart';
import 'package:taalleer/i18n.dart';
import 'package:taalleer/languages/es/es_course.dart';
import 'package:taalleer/models.dart';
import 'package:taalleer/utils.dart';

final _course = SpanishCourse();

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

    test('verduidelijking tussen haakjes hoeft niet meegetypt te worden', () {
      // estar → "zijn (toestand)": alleen "zijn" is ook goed.
      expect(isAcceptable('zijn', 'zijn (toestand)', dyslexia: false), isTrue);
      expect(
        isAcceptable('zijn (toestand)', 'zijn (toestand)', dyslexia: false),
        isTrue,
      );
      expect(isAcceptable('to be', 'to be (state)', dyslexia: false), isTrue);
      expect(isAcceptable('man', 'man (echtgenoot)', dyslexia: false), isTrue);
    });

    test('een fout antwoord blijft fout, ook met haakjes in het origineel', () {
      expect(
        isAcceptable('lopen', 'zijn (toestand)', dyslexia: false),
        isFalse,
      );
    });

    test('haakjes-variant werkt samen met dyslexie-modus', () {
      // "zin" mist één letter t.o.v. "zijn": binnen de tolerantie.
      expect(isAcceptable('zin', 'zijn (toestand)', dyslexia: true), isTrue);
    });
  });

  group('answerVariants', () {
    test('geeft de volledige en de ingekorte vorm', () {
      expect(answerVariants('zijn (toestand)'), ['zijn (toestand)', 'zijn']);
    });

    test('zonder haakjes is er maar één variant', () {
      expect(answerVariants('hablar'), ['hablar']);
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
    final weekWords = wordsForWeek(_course, 1);

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

    test(
      'weektoets crasht niet bij minder dan 10 woorden (bv. een kleine categorie)',
      () {
        final smallPool = weekWords.take(4).toList();
        final qs = buildQuiz(smallPool, Lang.nl, random: Random(1));
        expect(qs, hasLength(4));
      },
    );

    test('weektoets geeft een lege lijst bij een lege woordenlijst', () {
      expect(buildQuiz(const [], Lang.nl, random: Random(1)), isEmpty);
    });
  });

  group('buildListeningPractice', () {
    final weekWords = wordsForWeek(_course, 1);

    test('10 unieke woorden', () {
      final qs = buildListeningPractice(weekWords, Lang.nl, random: Random(1));
      expect(qs, hasLength(10));
      expect(qs.map((q) => q.word.id).toSet(), hasLength(10));
    });

    test('altijd esNl bij brontaal NL', () {
      final qs = buildListeningPractice(weekWords, Lang.nl, random: Random(1));
      for (final q in qs) {
        expect(q.type, QuestionType.esNl);
      }
    });

    test('altijd esEn bij brontaal EN', () {
      final qs = buildListeningPractice(weekWords, Lang.en, random: Random(1));
      for (final q in qs) {
        expect(q.type, QuestionType.esEn);
      }
    });
  });

  group('buildConjugationQuiz', () {
    test('10 werkwoorden, elk met geldige persoon en antwoord', () {
      final qs = buildConjugationQuiz(_course.words, random: Random(7));
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
      final qs = buildConjugationQuiz(_course.words, random: Random(8));
      for (final q in qs) {
        expect(q.word.present, isNotEmpty);
      }
    });
  });

  group('correctAnswerOf / shownWordOf', () {
    const word = Word(
      id: 1,
      target: 'hablar',
      nl: 'spreken',
      en: 'to speak',
      pronunciation: 'ah-BLAR',
      exampleTarget: '',
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

  group('acceptedAnswersOf / isAnswerAcceptable', () {
    const wordWithVariant = Word(
      id: 1,
      target: 'regalo',
      nl: 'cadeau',
      en: 'gift',
      pronunciation: 'reh-GAH-loh',
      nlVariants: ['kado'],
    );

    test('bevat de primaire vertaling plus de nl-varianten (esNl)', () {
      const q = Question(word: wordWithVariant, type: QuestionType.esNl);
      expect(acceptedAnswersOf(q), ['cadeau', 'kado']);
    });

    test('geen varianten bij esEn (die zitten alleen op nl hier)', () {
      const q = Question(word: wordWithVariant, type: QuestionType.esEn);
      expect(acceptedAnswersOf(q), ['gift']);
    });

    test('geen varianten bij nlEs/enEs (target heeft geen varianten)', () {
      const q = Question(word: wordWithVariant, type: QuestionType.nlEs);
      expect(acceptedAnswersOf(q), ['regalo']);
    });

    test(
      'isAnswerAcceptable accepteert zowel de primaire spelling als de variant',
      () {
        const q = Question(word: wordWithVariant, type: QuestionType.esNl);
        expect(isAnswerAcceptable(q, 'cadeau', dyslexia: false), isTrue);
        expect(isAnswerAcceptable(q, 'kado', dyslexia: false), isTrue);
        expect(isAnswerAcceptable(q, 'kadoo', dyslexia: false), isFalse);
      },
    );

    test('regalo (echte woordenboek-data) accepteert cadeau én kado', () {
      final word = _course.words.firstWhere((w) => w.target == 'regalo');
      const type = QuestionType.esNl;
      final q = Question(word: word, type: type);
      expect(isAnswerAcceptable(q, 'cadeau', dyslexia: false), isTrue);
      expect(isAnswerAcceptable(q, 'kado', dyslexia: false), isTrue);
    });
  });

  group('woordenboek', () {
    test('woordenboek bevat minimaal 900 woorden met unieke ids', () {
      expect(_course.words.length, greaterThanOrEqualTo(900));
      expect(
        _course.words.map((w) => w.id).toSet(),
        hasLength(_course.words.length),
      );
    });

    test('geen dubbele Spaanse lemma\'s in het woordenboek', () {
      expect(
        _course.words.map((w) => w.target).toSet(),
        hasLength(_course.words.length),
      );
    });

    test('elk woord heeft vertalingen en een uitspraak', () {
      for (final w in _course.words) {
        expect(w.target, isNotEmpty);
        expect(w.nl, isNotEmpty, reason: 'nl ontbreekt bij ${w.target}');
        expect(w.en, isNotEmpty, reason: 'en ontbreekt bij ${w.target}');
        expect(
          w.pronunciation,
          isNotEmpty,
          reason: 'uitspraak ontbreekt bij ${w.target}',
        );
      }
    });

    test('wordById vindt woorden uit het hele boek', () {
      expect(
        _course.wordById(_course.words.first.id)!.target,
        _course.words.first.target,
      );
      expect(
        _course.wordById(_course.words.last.id)!.target,
        _course.words.last.target,
      );
      expect(_course.wordById(-1), isNull);
    });

    test('elk werkwoord heeft 6 vervoegingen', () {
      final verbs = _course.words.where((w) => w.isVerb).toList();
      expect(verbs.length, greaterThan(200));
      for (final w in verbs) {
        expect(
          w.present,
          hasLength(6),
          reason: 'onvolledige vervoeging bij ${w.target}',
        );
        expect(
          w.article,
          isEmpty,
          reason: '${w.target} is werkwoord, geen lidwoord',
        );
      }
    });

    test('elk werkwoord heeft ook 6 verleden-tijdvormen', () {
      final verbs = _course.words.where((w) => w.isVerb).toList();
      for (final w in verbs) {
        expect(
          w.past,
          hasLength(6),
          reason: 'onvolledige verleden tijd bij ${w.target}',
        );
      }
    });

    test('elk werkwoord heeft ook 6 toekomende-tijdvormen', () {
      final verbs = _course.words.where((w) => w.isVerb).toList();
      for (final w in verbs) {
        expect(
          w.future,
          hasLength(6),
          reason: 'onvolledige toekomende tijd bij ${w.target}',
        );
      }
    });

    test('elk werkwoord heeft een niet-lege gerundio', () {
      final verbs = _course.words.where((w) => w.isVerb).toList();
      for (final w in verbs) {
        expect(
          w.gerundio,
          isNotEmpty,
          reason: 'ontbrekende gerundio bij ${w.target}',
        );
      }
    });

    test('woorden zijn nooit tegelijk werkwoord én zelfstandig naamwoord', () {
      for (final w in _course.words) {
        expect(w.isVerb && w.isNoun, isFalse, reason: w.target);
      }
    });

    test('zelfstandige naamwoorden krijgen el of la', () {
      for (final w in _course.words) {
        if (w.isNoun) {
          expect(['el', 'la'], contains(w.article), reason: w.target);
        }
      }
    });
  });

  group('willekeurige weekselectie', () {
    test('elke week geeft precies 20 unieke woorden', () {
      for (final seed in [0, 1, 7, 26, 52, 999, 10000]) {
        final words = wordsForWeek(_course, seed);
        expect(words, hasLength(kWordsPerWeek));
        expect(
          words.map((w) => w.id).toSet(),
          hasLength(kWordsPerWeek),
          reason: 'dubbele woorden bij seed $seed',
        );
      }
    });

    test('alle gekozen woorden komen uit het woordenboek', () {
      final ids = _course.words.map((w) => w.id).toSet();
      for (final w in wordsForWeek(_course, 42)) {
        expect(ids, contains(w.id));
      }
    });

    test('deterministisch: dezelfde seed geeft dezelfde 20 woorden', () {
      expect(
        wordsForWeek(_course, 29).map((w) => w.id).toList(),
        wordsForWeek(_course, 29).map((w) => w.id).toList(),
      );
    });

    test('de selectie is echt willekeurig, niet de eerste 20 uit het boek', () {
      final firstTwenty = _course.words
          .take(kWordsPerWeek)
          .map((w) => w.id)
          .toSet();
      final picked = wordsForWeek(_course, 3).map((w) => w.id).toSet();
      expect(picked, isNot(equals(firstTwenty)));
    });

    test('verschillende weken geven verschillende trekkingen', () {
      final a = wordsForWeek(_course, 1).map((w) => w.id).toList();
      final b = wordsForWeek(_course, 2).map((w) => w.id).toList();
      final c = wordsForWeek(_course, 3).map((w) => w.id).toList();
      expect(a, isNot(equals(b)));
      expect(b, isNot(equals(c)));
    });

    test('over veel weken komt een groot deel van het boek aan bod', () {
      final seen = <int>{};
      for (var seed = 0; seed < 200; seed++) {
        seen.addAll(wordsForWeek(_course, seed).map((w) => w.id));
      }
      // 200 × 20 trekkingen met teruglegging dekken ruimschoots de helft.
      expect(seen.length, greaterThan(_course.words.length ~/ 2));
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
        _course,
        currentWeekSeed(DateTime(2026, 7, 15)),
      ).map((w) => w.id).toList();
      final nextWeek = wordsForWeek(
        _course,
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

  group('weakWords', () {
    QuizResult resultWith(List<int> wrongWordIds) => QuizResult(
      id: 0,
      weekNumber: 1,
      year: 2026,
      date: 'x',
      grade: 5,
      correct: 5,
      total: 10,
      wrongWordIds: wrongWordIds,
    );

    test('lege historie geeft een lege lijst', () {
      expect(weakWords([], _course), isEmpty);
    });

    test('telt hoe vaak elk woord fout is en sorteert aflopend', () {
      final id1 = _course.words[0].id;
      final id2 = _course.words[1].id;
      final history = [
        resultWith([id1, id2]),
        resultWith([id1]),
        resultWith([id1]),
      ];
      final result = weakWords(history, _course);
      expect(result.first.id, id1); // 3x fout, komt eerst
      expect(result[1].id, id2); // 1x fout
    });

    test('respecteert limit', () {
      final ids = _course.words.take(5).map((w) => w.id).toList();
      final history = [resultWith(ids)];
      expect(weakWords(history, _course, limit: 3), hasLength(3));
    });

    test('negeert onbekende ids veilig', () {
      final history = [
        resultWith([-1, 999999]),
      ];
      expect(weakWords(history, _course), isEmpty);
    });
  });

  group('lastResultForQuiz', () {
    QuizResult resultWith(int id, String quizId) => QuizResult(
      id: id,
      weekNumber: 1,
      year: 2026,
      date: 'x',
      grade: 7,
      correct: 7,
      total: 10,
      wrongWordIds: const [],
      quizId: quizId,
    );

    test('geeft null als die toets nog nooit gemaakt is', () {
      expect(lastResultForQuiz([], 'food'), isNull);
      expect(lastResultForQuiz([resultWith(1, 'family')], 'food'), isNull);
    });

    test('geeft de meest recente match (historie is al nieuwste-eerst)', () {
      final history = [
        resultWith(3, 'food'), // nieuwste
        resultWith(2, 'family'),
        resultWith(1, 'food'),
      ];
      expect(lastResultForQuiz(history, 'food')!.id, 3);
    });
  });

  group('quizLabel', () {
    test('geeft de eigen naam voor de algemene toetsen', () {
      final t = Strings.of(Lang.nl);
      expect(quizLabel(t, _course, kWordQuizId, true), t.homeQuiz);
      expect(quizLabel(t, _course, kConjugationQuizId, true), t.homeConjQuiz);
    });

    test('zoekt de themanaam op voor een categorie-id', () {
      final t = Strings.of(Lang.nl);
      expect(quizLabel(t, _course, 'food', true), isNot(t.historyGeneralQuiz));
    });

    test('valt terug op een generiek label voor onbekende/lege id', () {
      final t = Strings.of(Lang.nl);
      expect(quizLabel(t, _course, '', true), t.historyGeneralQuiz);
      expect(
        quizLabel(t, _course, 'does-not-exist', true),
        t.historyGeneralQuiz,
      );
    });
  });

  group('dailyWords / currentDaySeed', () {
    test('geeft kDailyWordCount unieke woorden', () {
      final words = dailyWords(_course, 1);
      expect(words, hasLength(kDailyWordCount));
      expect(words.map((w) => w.id).toSet(), hasLength(kDailyWordCount));
    });

    test('deterministisch: dezelfde seed geeft dezelfde selectie', () {
      expect(
        dailyWords(_course, 42).map((w) => w.id),
        dailyWords(_course, 42).map((w) => w.id),
      );
    });

    test('andere seed geeft (meestal) een andere selectie', () {
      final a = dailyWords(_course, 1).map((w) => w.id).toList();
      final b = dailyWords(_course, 2).map((w) => w.id).toList();
      expect(a, isNot(equals(b)));
    });

    test('currentDaySeed loopt per dag op', () {
      final d1 = currentDaySeed(DateTime(2026, 7, 15));
      final d2 = currentDaySeed(DateTime(2026, 7, 16));
      expect(d2, d1 + 1);
    });
  });

  group('buildMultipleChoice', () {
    final weekWords = wordsForWeek(_course, 1);

    test('elke vraag heeft 4 unieke opties met het juiste antwoord erbij', () {
      final qs = buildMultipleChoice(
        weekWords,
        _course,
        Lang.nl,
        random: Random(1),
      );
      expect(qs, hasLength(10));
      for (final mcq in qs) {
        expect(mcq.options.toSet(), hasLength(4));
        expect(mcq.options, contains(correctAnswerOf(mcq.question)));
      }
    });

    test(
      'listening: true gebruikt altijd esNl/esEn net als buildListeningPractice',
      () {
        final qs = buildMultipleChoice(
          weekWords,
          _course,
          Lang.nl,
          listening: true,
          random: Random(1),
        );
        for (final mcq in qs) {
          expect(mcq.question.type, QuestionType.esNl);
        }
      },
    );
  });

  group('buildMemoryGame / tilesMatch', () {
    final weekWords = wordsForWeek(_course, 1);

    test('geeft 2*pairs tegels, exact 2 per woord-id', () {
      final tiles = buildMemoryGame(
        weekWords,
        Lang.nl,
        pairs: 6,
        random: Random(1),
      );
      expect(tiles, hasLength(12));
      final counts = <int, int>{};
      for (final tile in tiles) {
        counts[tile.word.id] = (counts[tile.word.id] ?? 0) + 1;
      }
      expect(counts.values, everyElement(2));
    });

    test('tilesMatch klopt voor een echt paar', () {
      final tiles = buildMemoryGame(
        weekWords,
        Lang.nl,
        pairs: 6,
        random: Random(1),
      );
      final word = tiles.first.word;
      final pair = tiles.where((t) => t.word.id == word.id).toList();
      expect(tilesMatch(pair[0], pair[1]), isTrue);
    });

    test('tilesMatch geeft false bij twee tegels van dezelfde kant', () {
      final a = MemoryTile(
        id: 1,
        word: weekWords.first,
        text: weekWords.first.target,
        isTarget: true,
      );
      final b = MemoryTile(
        id: 1,
        word: weekWords.first,
        text: weekWords.first.target,
        isTarget: true,
      );
      expect(tilesMatch(a, b), isFalse);
    });

    test('tilesMatch geeft false voor verschillende woorden', () {
      final tiles = buildMemoryGame(
        weekWords,
        Lang.nl,
        pairs: 6,
        random: Random(1),
      );
      final a = tiles.firstWhere((t) => t.isTarget);
      final b = tiles.firstWhere((t) => !t.isTarget && t.word.id != a.word.id);
      expect(tilesMatch(a, b), isFalse);
    });
  });

  group(
    'sentenceWordPool / buildSentenceBuilder / buildSentenceTranslation',
    () {
      test('sentenceWordPool geeft alleen woorden met een voorbeeldzin', () {
        final pool = sentenceWordPool(_course);
        expect(pool, isNotEmpty);
        for (final w in pool) {
          expect(w.exampleTarget, isNotEmpty);
        }
      });

      test('buildSentenceBuilder reconstrueert de originele zin', () {
        final qs = buildSentenceBuilder(_course, count: 5, random: Random(1));
        expect(qs, hasLength(5));
        for (final q in qs) {
          expect(q.correctTokens, q.word.exampleTarget.split(' '));
          expect(
            q.shuffledTokens.toList()..sort(),
            q.correctTokens.toList()..sort(),
          );
        }
      });

      test(
        'buildSentenceTranslation geeft unieke woorden met een voorbeeld',
        () {
          final words = buildSentenceTranslation(
            _course,
            count: 5,
            random: Random(1),
          );
          expect(words, hasLength(5));
          expect(words.map((w) => w.id).toSet(), hasLength(5));
          for (final w in words) {
            expect(w.exampleTarget, isNotEmpty);
          }
        },
      );
    },
  );

  group('buildClozeExercise', () {
    test(
      'geeft alleen werkwoorden met een cloze-zin, gekoppeld aan hun entry',
      () {
        final items = buildClozeExercise(
          _course.words,
          _course,
          count: 5,
          random: Random(1),
        );
        expect(items, hasLength(5));
        for (final (word, entry) in items) {
          expect(_course.clozeFor(word.target), isNotNull);
          expect(word.present, hasLength(6));
          expect(entry.person, inInclusiveRange(0, 5));
          expect(entry.sentenceTemplate, contains('___'));
        }
      },
    );
  });
}
