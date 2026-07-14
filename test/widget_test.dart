import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taalleer/app_state.dart';
import 'package:taalleer/data.dart';
import 'package:taalleer/main.dart';
import 'package:taalleer/models.dart';
import 'package:taalleer/utils.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<AppState> pumpApp(WidgetTester tester, {AppState? state}) async {
    final appState = state ?? await AppState.load();
    await tester.pumpWidget(TaalLeerApp(appState: appState));
    await tester.pumpAndSettle();
    return appState;
  }

  group('Navigatie', () {
    testWidgets('home-scherm toont begroeting en actieknoppen', (tester) async {
      await pumpApp(tester);
      expect(find.text('Welkom terug! 👋'), findsOneWidget);
      expect(find.text('Oefenen'), findsOneWidget);
      expect(find.text('Toets starten'), findsOneWidget);
      expect(find.text('Laatste cijfer'), findsOneWidget);
    });

    testWidgets('zonder opgeslagen data is er geen dummyhistorie', (
      tester,
    ) async {
      await pumpApp(tester);
      expect(find.text('Nog geen toets gemaakt'), findsOneWidget);

      await tester.tap(find.text('Resultaten'));
      await tester.pumpAndSettle();
      expect(find.text('Nog geen resultaten beschikbaar.'), findsOneWidget);
      expect(find.text('0 weken'), findsOneWidget);
    });

    testWidgets('tabbladen wisselen tussen de vier schermen', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text('Woorden'));
      await tester.pumpAndSettle();
      expect(find.text('Woordenlijst'), findsOneWidget);

      await tester.tap(find.text('Instellingen'));
      await tester.pumpAndSettle();
      expect(find.text('App-taal'), findsOneWidget);

      await tester.tap(find.text('Huis'));
      await tester.pumpAndSettle();
      expect(find.text('Welkom terug! 👋'), findsOneWidget);
    });
  });

  group('Woordenlijst', () {
    final weekWords = wordsForWeek(currentWeekNumber());

    testWidgets('toont de woorden van deze week', (tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('Woorden'));
      await tester.pumpAndSettle();

      // De eerste woorden van deze week staan bovenaan de lijst.
      expect(find.text(weekWords[0].es), findsWidgets);
      expect(find.text(weekWords[1].es), findsWidgets);
    });

    testWidgets('zoeken filtert de lijst', (tester) async {
      final target = weekWords.first;
      // Een ander woord (zichtbaar bovenaan) dat niet op de zoekterm matcht.
      final other = weekWords
          .skip(1)
          .take(4)
          .firstWhere(
            (w) =>
                !w.es.contains(target.es) &&
                !w.nl.contains(target.es) &&
                !w.en.contains(target.es),
          );

      await pumpApp(tester);
      await tester.tap(find.text('Woorden'));
      await tester.pumpAndSettle();

      expect(find.text(other.es), findsWidgets);

      await tester.enterText(find.byType(TextField), target.es);
      await tester.pumpAndSettle();

      expect(find.text(target.es), findsWidgets);
      expect(find.text(other.es), findsNothing);
    });

    testWidgets('woord uitklappen toont de uitspraak', (tester) async {
      // Kies een woord waarvan de uitspraak afwijkt van het woord zelf
      // (bij éénlettergrepige woorden zijn die gelijk).
      final target = weekWords
          .take(5)
          .firstWhere((w) => w.pronunciation != w.es);

      await pumpApp(tester);
      await tester.tap(find.text('Woorden'));
      await tester.pumpAndSettle();

      await tester.tap(find.text(target.es));
      await tester.pumpAndSettle();

      expect(find.text(target.pronunciation), findsOneWidget);
    });
  });

  group('Instellingen', () {
    testWidgets('taal wisselen naar Engels vertaalt de UI', (tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('Instellingen'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('🇬🇧 Engels'));
      await tester.pumpAndSettle();

      expect(find.text('App Language'), findsOneWidget);
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Welcome back! 👋'), findsOneWidget);
    });

    testWidgets('gewijzigde instellingen worden op het apparaat opgeslagen', (
      tester,
    ) async {
      await pumpApp(tester);
      await tester.tap(find.text('Instellingen'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Donker'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Een verse AppState leest dezelfde lokale opslag: de keuzes zijn er nog.
      final reloaded = await AppState.load();
      expect(reloaded.settings.darkMode, DarkModeSetting.dark);
      expect(reloaded.settings.dyslexiaMode, isTrue);
    });

    testWidgets('dyslexie-schakelaar toont uitlegtekst', (tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('Instellingen'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Actief: kleine spelfouten worden geaccepteerd op basis van woordlengte.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('donkere modus kiezen past het thema aan', (tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('Instellingen'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Donker'));
      await tester.pumpAndSettle();

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.dark);
    });
  });

  group('Oefenen', () {
    testWidgets(
      'fout antwoord toont het juiste antwoord, daarna volgende vraag',
      (tester) async {
        await pumpApp(tester);
        await tester.tap(find.text('Oefenen'));
        await tester.pumpAndSettle();

        expect(find.text('1/10'), findsOneWidget);

        await tester.enterText(find.byType(TextField), 'zeker-fout-antwoord');
        await tester.pumpAndSettle();
        await tester.tap(find.text('Controleren'));
        await tester.pumpAndSettle();

        expect(find.text('Helaas!'), findsOneWidget);
        expect(find.textContaining('Correct antwoord'), findsOneWidget);

        await tester.tap(find.text('Volgende →'));
        await tester.pumpAndSettle();
        expect(find.text('2/10'), findsOneWidget);
      },
    );
  });

  group('Weektoets', () {
    testWidgets(
      'volledige toets met alle antwoorden fout geeft cijfer 0 en wordt lokaal opgeslagen',
      (tester) async {
        final state = await pumpApp(tester);

        await tester.tap(find.text('Toets starten'));
        await tester.pumpAndSettle();
        expect(find.text('Weektoets'), findsOneWidget);
        expect(find.text('Geen hints beschikbaar'), findsOneWidget);

        for (var i = 0; i < 10; i++) {
          await tester.enterText(find.byType(TextField), 'zeker-fout-antwoord');
          await tester.pumpAndSettle();
          await tester.tap(find.text('Bevestigen →'));
          await tester.pumpAndSettle();
        }

        // Resultaatscherm
        expect(find.text('0.0'), findsOneWidget);
        expect(find.text('Onvoldoende'), findsOneWidget);
        expect(find.text('Foute woorden'), findsOneWidget);
        expect(state.history, hasLength(1));
        expect(state.history.first.grade, 0.0);
        expect(state.history.first.wrongWordIds, hasLength(10));

        // Alleen woorden van deze week zaten in de toets.
        final weekIds = wordsForWeek(
          currentWeekNumber(),
        ).map((w) => w.id).toSet();
        for (final id in state.history.first.wrongWordIds) {
          expect(weekIds, contains(id));
        }

        // Het resultaat staat op het apparaat: een verse AppState ziet het ook.
        final reloaded = await AppState.load();
        expect(reloaded.history, hasLength(1));
        expect(reloaded.history.first.grade, 0.0);

        // Terug naar huis (knop staat onderaan de scrollbare lijst)
        await tester.dragUntilVisible(
          find.text('Terug naar huis'),
          find.byType(ListView),
          const Offset(0, -200),
        );
        await tester.tap(find.text('Terug naar huis'));
        await tester.pumpAndSettle();
        expect(find.text('Welkom terug! 👋'), findsOneWidget);
      },
    );
  });
}
