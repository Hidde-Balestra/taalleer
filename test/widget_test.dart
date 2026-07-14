import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taalleer/app_state.dart';
import 'package:taalleer/data.dart';
import 'package:taalleer/main.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester, {AppState? state}) async {
    await tester.pumpWidget(TaalLeerApp(appState: state ?? AppState()));
    await tester.pumpAndSettle();
  }

  group('Navigatie', () {
    testWidgets('home-scherm toont begroeting en actieknoppen', (tester) async {
      await pumpApp(tester);
      expect(find.text('Welkom terug! 👋'), findsOneWidget);
      expect(find.text('Oefenen'), findsOneWidget);
      expect(find.text('Toets starten'), findsOneWidget);
      expect(find.text('Laatste cijfer'), findsOneWidget);
    });

    testWidgets('tabbladen wisselen tussen de vier schermen', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text('Woorden'));
      await tester.pumpAndSettle();
      expect(find.text('Woordenlijst'), findsOneWidget);

      await tester.tap(find.text('Resultaten'));
      await tester.pumpAndSettle();
      expect(find.text('Week 28'), findsOneWidget);

      await tester.tap(find.text('Instellingen'));
      await tester.pumpAndSettle();
      expect(find.text('App-taal'), findsOneWidget);

      await tester.tap(find.text('Huis'));
      await tester.pumpAndSettle();
      expect(find.text('Welkom terug! 👋'), findsOneWidget);
    });
  });

  group('Woordenlijst', () {
    testWidgets('zoeken filtert de lijst', (tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('Woorden'));
      await tester.pumpAndSettle();

      expect(find.text('biblioteca'), findsOneWidget);
      expect(find.text('hablar'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'biblio');
      await tester.pumpAndSettle();

      expect(find.text('biblioteca'), findsOneWidget);
      expect(find.text('hablar'), findsNothing);
    });

    testWidgets('woord uitklappen toont uitspraak en voorbeeld', (
      tester,
    ) async {
      await pumpApp(tester);
      await tester.tap(find.text('Woorden'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('biblioteca'));
      await tester.pumpAndSettle();

      expect(find.text('bee-blee-oh-TEH-kah'), findsOneWidget);
      expect(find.text('Voy a la biblioteca todos los días.'), findsOneWidget);
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
      'volledige toets met alle antwoorden fout geeft cijfer 0 en historie-item',
      (tester) async {
        final state = AppState();
        await pumpApp(tester, state: state);

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
        expect(state.history, hasLength(kMockHistory.length + 1));
        expect(state.history.first.grade, 0.0);
        expect(state.history.first.wrongWordIds, hasLength(10));

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
