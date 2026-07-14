import 'package:flutter_test/flutter_test.dart';
import 'package:taalleer/app_state.dart';
import 'package:taalleer/data.dart';
import 'package:taalleer/models.dart';

void main() {
  group('AppState', () {
    test('start met de voorbeeldhistorie en bijbehorende streak', () {
      final state = AppState();
      expect(state.history, hasLength(kMockHistory.length));
      expect(state.streak, kMockHistory.length);
    });

    test('addResult zet nieuw resultaat vooraan en meldt luisteraars', () {
      final state = AppState();
      var notified = false;
      state.addListener(() => notified = true);

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
      state.addResult(result);

      expect(state.history.first.id, 99);
      expect(state.streak, kMockHistory.length + 1);
      expect(notified, isTrue);
    });

    test('updateSettings vervangt instellingen en meldt luisteraars', () {
      final state = AppState();
      var notified = false;
      state.addListener(() => notified = true);

      state.updateSettings(
        state.settings.copyWith(language: Lang.en, dyslexiaMode: true),
      );

      expect(state.settings.language, Lang.en);
      expect(state.settings.dyslexiaMode, isTrue);
      // Overige velden blijven onaangetast.
      expect(state.settings.sourceLang, Lang.nl);
      expect(notified, isTrue);
    });

    test('history is niet van buitenaf aan te passen', () {
      final state = AppState();
      expect(
        () => state.history.add(kMockHistory.first),
        throwsUnsupportedError,
      );
    });
  });
}
