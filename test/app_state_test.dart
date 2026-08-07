import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taalleer/app_state.dart';
import 'package:taalleer/models.dart';

void main() {
  const result = QuizResult(
    id: 99,
    weekNumber: 29,
    year: 2026,
    date: '18 jul 2026',
    grade: 7.0,
    correct: 7,
    total: 10,
    wrongWordIds: [1, 2, 3],
    quizId: kWordQuizId,
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AppState', () {
    test('start zonder dummydata: lege historie en streak 0', () async {
      final state = await AppState.load();
      expect(state.history, isEmpty);
      expect(state.streak, 0);
      expect(state.settings.language, Lang.en);
    });

    test(
      'addResult zet nieuw resultaat vooraan en meldt luisteraars',
      () async {
        final state = await AppState.load();
        var notified = false;
        state.addListener(() => notified = true);

        state.addResult(result);

        expect(state.history.first.id, 99);
        expect(state.streak, 1);
        expect(notified, isTrue);
      },
    );

    test(
      'toetsresultaat blijft bewaard na herstart (nieuwe AppState)',
      () async {
        final state = await AppState.load();
        state.addResult(result);

        // Wacht tot de asynchrone opslag klaar is.
        await Future<void>.delayed(Duration.zero);

        final reloaded = await AppState.load();
        expect(reloaded.history, hasLength(1));
        expect(reloaded.history.first.id, 99);
        expect(reloaded.history.first.grade, 7.0);
        expect(reloaded.streak, 1);
      },
    );

    test(
      'instellingen blijven bewaard na herstart (nieuwe AppState)',
      () async {
        final state = await AppState.load();
        state.updateSettings(
          state.settings.copyWith(
            language: Lang.en,
            darkMode: DarkModeSetting.dark,
            dyslexiaMode: true,
          ),
        );

        await Future<void>.delayed(Duration.zero);

        final reloaded = await AppState.load();
        expect(reloaded.settings.language, Lang.en);
        expect(reloaded.settings.darkMode, DarkModeSetting.dark);
        expect(reloaded.settings.dyslexiaMode, isTrue);
        // Niet gewijzigde velden behouden hun standaardwaarde.
        expect(reloaded.settings.sourceLang, Lang.nl);
      },
    );

    test(
      'meerdere resultaten worden in volgorde (nieuwste eerst) bewaard',
      () async {
        // Eén toets per week, dus de tweede toets valt een week later.
        var week = 400;
        final state = await AppState.load(nowWeek: () => week);
        state.addResult(result);
        week = 401;
        state.addResult(
          const QuizResult(
            id: 100,
            weekNumber: 30,
            year: 2026,
            date: '25 jul 2026',
            grade: 9.0,
            correct: 9,
            total: 10,
            wrongWordIds: [5],
          ),
        );

        await Future<void>.delayed(Duration.zero);

        final reloaded = await AppState.load(nowWeek: () => week);
        expect(reloaded.history, hasLength(2));
        expect(reloaded.history.first.id, 100);
        expect(reloaded.history.last.id, 99);
      },
    );

    test('history is niet van buitenaf aan te passen', () async {
      final state = await AppState.load();
      expect(() => state.history.add(result), throwsUnsupportedError);
    });
  });

  group('Wekelijkse streak', () {
    // Een instelbare weekteller voor deterministische tests.
    var week = 100;
    int nowWeek() => week;

    setUp(() => week = 100);

    QuizResult resultFor(int id) => QuizResult(
      id: id,
      weekNumber: 1,
      year: 2026,
      date: 'x',
      grade: 8,
      correct: 8,
      total: 10,
      wrongWordIds: const [],
      quizId: kWordQuizId,
    );

    test('eerste toets zet streak op 1', () async {
      final state = await AppState.load(nowWeek: nowWeek);
      state.addResult(resultFor(1));
      expect(state.streak, 1);
      expect(state.quizDoneThisWeek(kWordQuizId), isTrue);
    });

    test('opvolgende weken laten de streak oplopen', () async {
      final state = await AppState.load(nowWeek: nowWeek);
      state.addResult(resultFor(1));
      week = 101;
      state.addResult(resultFor(2));
      week = 102;
      state.addResult(resultFor(3));
      expect(state.streak, 3);
    });

    test('per week is maar één toets toegestaan', () async {
      final state = await AppState.load(nowWeek: nowWeek);
      expect(state.quizAllowed(kWordQuizId), isTrue);

      state.addResult(resultFor(1));
      expect(state.quizAllowed(kWordQuizId), isFalse); // op slot tot de reset
      expect(state.quizDoneThisWeek(kWordQuizId), isTrue);

      state.addResult(resultFor(2)); // wordt genegeerd
      expect(state.history, hasLength(1));
      expect(state.streak, 1);
    });

    test(
      'na de wekelijkse reset mag er weer een toets gemaakt worden',
      () async {
        final state = await AppState.load(nowWeek: nowWeek);
        state.addResult(resultFor(1));
        expect(state.quizAllowed(kWordQuizId), isFalse);

        week = 101; // nieuwe week
        expect(state.quizAllowed(kWordQuizId), isTrue);
        expect(state.quizDoneThisWeek(kWordQuizId), isFalse);

        state.addResult(resultFor(2));
        expect(state.history, hasLength(2));
        expect(state.streak, 2);
      },
    );

    test('een gemiste week verlaagt de streak naar 0', () async {
      final state = await AppState.load(nowWeek: nowWeek);
      state.addResult(resultFor(1));
      expect(state.streak, 1);
      week = 103; // twee weken later, niets gedaan
      expect(state.streak, 0);
    });

    test('na een gemiste week begint de streak weer bij 1', () async {
      final state = await AppState.load(nowWeek: nowWeek);
      state.addResult(resultFor(1));
      week = 104;
      state.addResult(resultFor(2));
      expect(state.streak, 1);
    });

    test('streak overleeft een herstart van de app', () async {
      final state = await AppState.load(nowWeek: nowWeek);
      state.addResult(resultFor(1));
      week = 101;
      state.addResult(resultFor(2));
      await Future<void>.delayed(Duration.zero);

      final reloaded = await AppState.load(nowWeek: nowWeek);
      expect(reloaded.streak, 2);
    });
  });

  group('Eerdere weken', () {
    var week = 300;
    int nowWeek() => week;
    setUp(() => week = 300);

    test('een nieuwe gebruiker heeft nog geen eerdere weken', () async {
      final state = await AppState.load(nowWeek: nowWeek);
      expect(state.pastWeekSeeds, isEmpty);
    });

    test('na een paar weken zijn de vorige weken beschikbaar', () async {
      // Eerste gebruik legt de startweek vast.
      await AppState.load(nowWeek: nowWeek);
      await Future<void>.delayed(Duration.zero);

      week = 303; // drie weken later
      final state = await AppState.load(nowWeek: nowWeek);
      // Weken 300, 301, 302 zijn geweest; 303 is de huidige week.
      expect(state.pastWeekSeeds, [302, 301, 300]);
    });

    test('de startweek blijft bewaard na een herstart', () async {
      await AppState.load(nowWeek: nowWeek);
      await Future<void>.delayed(Duration.zero);

      week = 305;
      final reloaded = await AppState.load(nowWeek: nowWeek);
      expect(reloaded.pastWeekSeeds.last, 300);
      expect(reloaded.pastWeekSeeds, hasLength(5));
    });
  });

  group('Pauze', () {
    var week = 200;
    int nowWeek() => week;
    setUp(() => week = 200);

    QuizResult resultFor(int id) => QuizResult(
      id: id,
      weekNumber: 1,
      year: 2026,
      date: 'x',
      grade: 8,
      correct: 8,
      total: 10,
      wrongWordIds: const [],
      quizId: kWordQuizId,
    );

    test('tijdens pauze zijn toetsen geblokkeerd', () async {
      final state = await AppState.load(nowWeek: nowWeek);
      state.addResult(resultFor(1));
      state.setPaused(true);
      expect(state.quizAllowed(kWordQuizId), isFalse);

      state.addResult(resultFor(2)); // moet genegeerd worden
      expect(state.history, hasLength(1));
    });

    test(
      'pauze bevriest de streak: geen verval bij verstrijken van weken',
      () async {
        final state = await AppState.load(nowWeek: nowWeek);
        state.addResult(resultFor(1));
        expect(state.streak, 1);
        state.setPaused(true);

        week = 210; // tien weken verder, maar gepauzeerd
        expect(state.streak, 1); // niet gereset
      },
    );

    test(
      'na de pauze hervat de streak zonder de pauzeweken te tellen',
      () async {
        final state = await AppState.load(nowWeek: nowWeek);
        state.addResult(resultFor(1)); // effectieve week 200, streak 1
        state.setPaused(true);
        week = 210;
        state.setPaused(false); // 10 weken pauze worden weggerekend

        // Nog steeds dezelfde effectieve week als de laatste toets.
        expect(state.streak, 1);

        week = 211; // één échte week verder → één effectieve week verder
        state.addResult(resultFor(2));
        expect(state.streak, 2);
      },
    );
  });

  group('Categorietoetsen', () {
    var week = 500;
    int nowWeek() => week;
    setUp(() => week = 500);

    QuizResult resultFor(int id, {String quizId = kWordQuizId}) => QuizResult(
      id: id,
      weekNumber: 1,
      year: 2026,
      date: 'x',
      grade: 8,
      correct: 8,
      total: 10,
      wrongWordIds: const [],
      quizId: quizId,
    );

    test('elke categorie is onafhankelijk vergrendeld', () async {
      final state = await AppState.load(nowWeek: nowWeek);
      expect(state.quizAllowed('food'), isTrue);
      expect(state.quizAllowed('family'), isTrue);

      state.addResult(resultFor(1, quizId: 'food'));
      expect(state.quizAllowed('food'), isFalse);
      expect(state.quizDoneThisWeek('food'), isTrue);
      // Een andere categorie is nog gewoon beschikbaar.
      expect(state.quizAllowed('family'), isTrue);

      state.addResult(resultFor(2, quizId: 'family'));
      expect(state.quizDoneThisWeek('family'), isTrue);
      expect(state.history, hasLength(2));
    });

    test(
      'een categorietoets blokkeert de algemene toets niet, en andersom',
      () async {
        final state = await AppState.load(nowWeek: nowWeek);
        state.addResult(resultFor(1, quizId: 'food'));
        expect(
          state.quizAllowed(kWordQuizId),
          isTrue,
        ); // algemene toets nog beschikbaar

        state.addResult(resultFor(2)); // algemene toets
        expect(state.quizDoneThisWeek(kWordQuizId), isTrue);
        // De categorietoets blijft onaangeroerd vergrendeld/beschikbaar
        // zoals hij al was — een 3e categorie is nog gewoon vrij.
        expect(state.quizAllowed('travel'), isTrue);
        expect(state.history, hasLength(2));
      },
    );

    test(
      'een herhaalde poging voor dezelfde categorie wordt genegeerd',
      () async {
        final state = await AppState.load(nowWeek: nowWeek);
        state.addResult(resultFor(1, quizId: 'food'));
        state.addResult(resultFor(2, quizId: 'food')); // genegeerd
        expect(state.history, hasLength(1));
      },
    );

    test(
      'elke toets (algemeen of categorie) houdt de streak in stand',
      () async {
        final state = await AppState.load(nowWeek: nowWeek);
        state.addResult(resultFor(1, quizId: 'food'));
        expect(state.streak, 1);

        week = 501;
        state.addResult(resultFor(2, quizId: 'family')); // andere categorie
        expect(state.streak, 2);

        week = 502;
        state.addResult(resultFor(3)); // algemene toets
        expect(state.streak, 3);
      },
    );

    test('tijdens pauze zijn categorietoetsen ook geblokkeerd', () async {
      final state = await AppState.load(nowWeek: nowWeek);
      state.setPaused(true);
      expect(state.quizAllowed('food'), isFalse);
      state.addResult(resultFor(1, quizId: 'food'));
      expect(state.history, isEmpty);
    });
  });

  group('StreakState-migratie', () {
    test(
      'lastActivityWeek valt terug op de oude lastQuizWeek zonder dataverlies',
      () {
        // Simuleert een vóór deze feature opgeslagen StreakState-JSON,
        // zonder lastActivityWeek/categoryLastQuizWeek (van vóór zowel de
        // streak- als de per-toets-vergrendeling-opsplitsing).
        final migrated = StreakState.fromJson({
          'streak': 5,
          'lastQuizWeek': 42,
          'paused': false,
          'pauseOffset': 0,
          'firstWeek': 10,
        });
        expect(migrated.lastActivityWeek, 42);
        // De oude gedeelde vergrendeling wordt eenmalig overgedragen naar
        // de twee algemene toetsen, zodat iemand die deze week al de
        // gedeelde toets deed niet ineens allebei opnieuw mag maken.
        expect(migrated.quizLastWeek, {
          kWordQuizId: 42,
          kConjugationQuizId: 42,
        });
      },
    );

    test('een nieuwere StreakState-JSON gebruikt lastActivityWeek direct', () {
      final state = StreakState.fromJson({
        'streak': 5,
        'lastQuizWeek': 40,
        'lastActivityWeek': 42,
        'categoryLastQuizWeek': {'food': 42},
      });
      expect(state.lastActivityWeek, 42);
      // De al opgeslagen categorie blijft leidend; de oude lastQuizWeek
      // vult alleen de nog ontbrekende algemene-toets-entries aan.
      expect(state.quizLastWeek, {
        'food': 42,
        kWordQuizId: 40,
        kConjugationQuizId: 40,
      });
    });

    test(
      'geen migratie nodig als de algemene toetsen al eigen entries hebben',
      () {
        final state = StreakState.fromJson({
          'streak': 5,
          'lastQuizWeek': 40,
          'categoryLastQuizWeek': {kWordQuizId: 45, kConjugationQuizId: 46},
        });
        // De al bestaande, specifiekere waarden worden niet overschreven
        // door de oudere, gedeelde lastQuizWeek.
        expect(state.quizLastWeek, {kWordQuizId: 45, kConjugationQuizId: 46});
      },
    );
  });
}
