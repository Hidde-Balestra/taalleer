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
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AppState', () {
    test('start zonder dummydata: lege historie en streak 0', () async {
      final state = await AppState.load();
      expect(state.history, isEmpty);
      expect(state.streak, 0);
      expect(state.settings.language, Lang.nl);
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
        final state = await AppState.load();
        state.addResult(result);
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

        final reloaded = await AppState.load();
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
    );

    test('eerste toets zet streak op 1', () async {
      final state = await AppState.load(nowWeek: nowWeek);
      state.addResult(resultFor(1));
      expect(state.streak, 1);
      expect(state.quizDoneThisWeek, isTrue);
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

    test(
      'één toets per week is genoeg (tweede toets telt niet extra)',
      () async {
        final state = await AppState.load(nowWeek: nowWeek);
        state.addResult(resultFor(1));
        state.addResult(resultFor(2)); // zelfde week
        expect(state.streak, 1);
        expect(state.history, hasLength(2));
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
    );

    test('tijdens pauze zijn toetsen geblokkeerd', () async {
      final state = await AppState.load(nowWeek: nowWeek);
      state.addResult(resultFor(1));
      state.setPaused(true);
      expect(state.quizAllowed, isFalse);

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
}
