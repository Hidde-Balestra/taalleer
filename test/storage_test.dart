import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taalleer/models.dart';
import 'package:taalleer/storage.dart';

void main() {
  const result = QuizResult(
    id: 42,
    weekNumber: 29,
    year: 2026,
    date: '18 jul 2026',
    grade: 7.5,
    correct: 7,
    total: 10,
    wrongWordIds: [3, 14, 20],
    quizId: 'food',
  );

  group('JSON-serialisatie', () {
    test('QuizResult overleeft een toJson/fromJson-rondje', () {
      final copy = QuizResult.fromJson(result.toJson());
      expect(copy.id, result.id);
      expect(copy.weekNumber, result.weekNumber);
      expect(copy.year, result.year);
      expect(copy.date, result.date);
      expect(copy.grade, result.grade);
      expect(copy.correct, result.correct);
      expect(copy.total, result.total);
      expect(copy.wrongWordIds, result.wrongWordIds);
      expect(copy.quizId, 'food');
    });

    test('QuizResult zonder category in de JSON valt terug op leeg', () {
      final copy = QuizResult.fromJson({
        'id': 1,
        'weekNumber': 1,
        'year': 2026,
        'date': 'x',
        'grade': 5.0,
        'correct': 5,
        'total': 10,
        'wrongWordIds': <int>[],
      });
      expect(copy.quizId, '');
    });

    test('StreakState overleeft een toJson/fromJson-rondje', () {
      // quizLastWeek bevat hier al eigen entries voor de algemene toetsen,
      // zodat deze test puur de serialisatie test — de migratie vanuit de
      // oude lastQuizWeek heeft een eigen test in app_state_test.dart.
      const state = StreakState(
        streak: 4,
        lastQuizWeek: 100,
        lastActivityWeek: 101,
        quizLastWeek: {
          'food': 101,
          'family': 99,
          kWordQuizId: 100,
          kConjugationQuizId: 100,
        },
        paused: false,
        pauseOffset: 2,
        firstWeek: 90,
      );
      final copy = StreakState.fromJson(state.toJson());
      expect(copy.streak, 4);
      expect(copy.lastQuizWeek, 100);
      expect(copy.lastActivityWeek, 101);
      expect(copy.quizLastWeek, {
        'food': 101,
        'family': 99,
        kWordQuizId: 100,
        kConjugationQuizId: 100,
      });
      expect(copy.pauseOffset, 2);
      expect(copy.firstWeek, 90);
    });

    test('AppSettings overleeft een toJson/fromJson-rondje', () {
      const settings = AppSettings(
        language: Lang.en,
        darkMode: DarkModeSetting.dark,
        dyslexiaMode: true,
        sourceLang: Lang.en,
        onboardingComplete: true,
        dailyReminder: true,
        reminderHour: 21,
      );
      final copy = AppSettings.fromJson(settings.toJson());
      expect(copy.language, Lang.en);
      expect(copy.darkMode, DarkModeSetting.dark);
      expect(copy.dyslexiaMode, isTrue);
      expect(copy.sourceLang, Lang.en);
      expect(copy.onboardingComplete, isTrue);
      expect(copy.dailyReminder, isTrue);
      expect(copy.reminderHour, 21);
    });

    test('AppSettings valt terug op standaardwaarden bij onbekende JSON', () {
      final copy = AppSettings.fromJson({'language': 'xx', 'darkMode': 99});
      expect(copy.language, Lang.en);
      expect(copy.darkMode, DarkModeSetting.system);
      expect(copy.dyslexiaMode, isFalse);
      expect(copy.sourceLang, Lang.nl);
      expect(copy.onboardingComplete, isFalse);
    });
  });

  group('AppStorage', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test(
      'zonder opgeslagen data: standaardinstellingen en lege historie',
      () async {
        final storage = AppStorage();
        final settings = await storage.loadSettings();
        final history = await storage.loadHistory();

        expect(settings.language, Lang.en);
        expect(settings.darkMode, DarkModeSetting.system);
        expect(settings.dyslexiaMode, isFalse);
        expect(settings.onboardingComplete, isFalse);
        expect(history, isEmpty);
      },
    );

    test(
      'instellingen worden op het apparaat bewaard en teruggelezen',
      () async {
        final storage = AppStorage();
        await storage.saveSettings(
          const AppSettings(
            language: Lang.en,
            darkMode: DarkModeSetting.light,
            dyslexiaMode: true,
            sourceLang: Lang.en,
          ),
        );

        // Nieuwe instantie leest dezelfde lokale opslag.
        final reloaded = await AppStorage().loadSettings();
        expect(reloaded.language, Lang.en);
        expect(reloaded.darkMode, DarkModeSetting.light);
        expect(reloaded.dyslexiaMode, isTrue);
        expect(reloaded.sourceLang, Lang.en);
      },
    );

    test('historie wordt op het apparaat bewaard en teruggelezen', () async {
      final storage = AppStorage();
      await storage.saveHistory([result]);

      final reloaded = await AppStorage().loadHistory();
      expect(reloaded, hasLength(1));
      expect(reloaded.first.id, 42);
      expect(reloaded.first.grade, 7.5);
      expect(reloaded.first.wrongWordIds, [3, 14, 20]);
    });

    test('corrupte opgeslagen data geeft veilige standaardwaarden', () async {
      SharedPreferences.setMockInitialValues({
        AppStorage.settingsKey: 'dit is geen json',
        AppStorage.historyKey: 'kapot{{{',
      });
      final storage = AppStorage();
      final settings = await storage.loadSettings();
      final history = await storage.loadHistory();

      expect(settings.language, Lang.en);
      expect(history, isEmpty);
    });
  });
}
