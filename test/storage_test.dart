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
    });

    test('AppSettings overleeft een toJson/fromJson-rondje', () {
      const settings = AppSettings(
        language: Lang.en,
        darkMode: DarkModeSetting.dark,
        dyslexiaMode: true,
        sourceLang: Lang.en,
      );
      final copy = AppSettings.fromJson(settings.toJson());
      expect(copy.language, Lang.en);
      expect(copy.darkMode, DarkModeSetting.dark);
      expect(copy.dyslexiaMode, isTrue);
      expect(copy.sourceLang, Lang.en);
    });

    test('AppSettings valt terug op standaardwaarden bij onbekende JSON', () {
      final copy = AppSettings.fromJson({'language': 'xx', 'darkMode': 99});
      expect(copy.language, Lang.nl);
      expect(copy.darkMode, DarkModeSetting.system);
      expect(copy.dyslexiaMode, isFalse);
      expect(copy.sourceLang, Lang.nl);
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

        expect(settings.language, Lang.nl);
        expect(settings.darkMode, DarkModeSetting.system);
        expect(settings.dyslexiaMode, isFalse);
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

      expect(settings.language, Lang.nl);
      expect(history, isEmpty);
    });
  });
}
