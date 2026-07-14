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
}
